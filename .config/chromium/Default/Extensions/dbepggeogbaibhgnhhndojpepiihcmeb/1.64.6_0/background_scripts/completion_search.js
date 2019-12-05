// Generated by CoffeeScript 1.12.7
(function() {
  var CompletionSearch, EnginePrefixWrapper, root,
    slice = [].slice;

  EnginePrefixWrapper = (function() {
    function EnginePrefixWrapper(searchUrl1, engine1) {
      this.searchUrl = searchUrl1;
      this.engine = engine1;
    }

    EnginePrefixWrapper.prototype.getUrl = function(queryTerms) {
      var prefix, terms;
      if (/\=.+\+%s/.test(this.searchUrl)) {
        terms = this.searchUrl.replace(/\+%s.*/, "");
        terms = terms.replace(/.*=/, "");
        terms = terms.replace(/\+/g, " ");
        queryTerms = slice.call(terms.split(" ")).concat(slice.call(queryTerms));
        prefix = terms + " ";
        this.postprocessSuggestions = function(suggestions) {
          var i, len, results, suggestion;
          results = [];
          for (i = 0, len = suggestions.length; i < len; i++) {
            suggestion = suggestions[i];
            if (!suggestion.startsWith(prefix)) {
              continue;
            }
            results.push(suggestion.slice(prefix.length));
          }
          return results;
        };
      }
      return this.engine.getUrl(queryTerms);
    };

    EnginePrefixWrapper.prototype.parse = function(xhr) {
      return this.postprocessSuggestions(this.engine.parse(xhr));
    };

    EnginePrefixWrapper.prototype.postprocessSuggestions = function(suggestions) {
      return suggestions;
    };

    return EnginePrefixWrapper;

  })();

  CompletionSearch = {
    debug: false,
    inTransit: {},
    completionCache: new SimpleCache(2 * 60 * 60 * 1000, 5000),
    engineCache: new SimpleCache(1000 * 60 * 60 * 1000),
    delay: 100,
    get: function(searchUrl, url, callback) {
      var xhr;
      xhr = new XMLHttpRequest();
      xhr.open("GET", url, true);
      xhr.timeout = 2500;
      xhr.ontimeout = xhr.onerror = function() {
        return callback(null);
      };
      xhr.send();
      return xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
          return callback(xhr.status === 200 ? xhr : null);
        }
      };
    },
    lookupEngine: function(searchUrl) {
      var engine, i, len;
      if (this.engineCache.has(searchUrl)) {
        return this.engineCache.get(searchUrl);
      } else {
        for (i = 0, len = CompletionEngines.length; i < len; i++) {
          engine = CompletionEngines[i];
          engine = new engine();
          if (engine.match(searchUrl)) {
            return this.engineCache.set(searchUrl, engine);
          }
        }
      }
    },
    haveCompletionEngine: function(searchUrl) {
      return !this.lookupEngine(searchUrl).dummy;
    },
    complete: function(searchUrl, queryTerms, callback) {
      var completionCacheKey, handler, query, returnResultsOnlyFromCache, reusePreviousSuggestions;
      if (callback == null) {
        callback = null;
      }
      query = queryTerms.join(" ").toLowerCase();
      returnResultsOnlyFromCache = callback == null;
      if (callback == null) {
        callback = function(suggestions) {
          return suggestions;
        };
      }
      if (!(3 < query.length)) {
        return callback([]);
      }
      if (1 === queryTerms.length && Utils.isUrl(query)) {
        return callback([]);
      }
      if (Utils.hasJavascriptPrefix(query)) {
        return callback([]);
      }
      completionCacheKey = JSON.stringify([searchUrl, queryTerms]);
      if (this.completionCache.has(completionCacheKey)) {
        if (this.debug) {
          console.log("hit", completionCacheKey);
        }
        return callback(this.completionCache.get(completionCacheKey));
      }
      if ((this.mostRecentQuery != null) && (this.mostRecentSuggestions != null) && (this.mostRecentSearchUrl != null)) {
        if (searchUrl === this.mostRecentSearchUrl) {
          reusePreviousSuggestions = (function(_this) {
            return function() {
              var i, len, ref, suggestion;
              if (0 !== query.indexOf(_this.mostRecentQuery.toLowerCase())) {
                return false;
              }
              ref = _this.mostRecentSuggestions;
              for (i = 0, len = ref.length; i < len; i++) {
                suggestion = ref[i];
                if (!(0 <= suggestion.indexOf(query))) {
                  return false;
                }
              }
              return true;
            };
          })(this)();
          if (reusePreviousSuggestions) {
            if (this.debug) {
              console.log("reuse previous query:", this.mostRecentQuery, this.mostRecentSuggestions.length);
            }
            return callback(this.completionCache.set(completionCacheKey, this.mostRecentSuggestions));
          }
        }
      }
      if (returnResultsOnlyFromCache) {
        return callback(null);
      }
      return Utils.setTimeout(this.delay, handler = this.mostRecentHandler = (function(_this) {
        return function() {
          var base;
          if (handler === _this.mostRecentHandler) {
            _this.mostRecentHandler = null;
            if ((base = _this.inTransit)[completionCacheKey] == null) {
              base[completionCacheKey] = new AsyncDataFetcher(function(callback) {
                var engine, url;
                engine = new EnginePrefixWrapper(searchUrl, _this.lookupEngine(searchUrl));
                url = engine.getUrl(queryTerms);
                return _this.get(searchUrl, url, function(xhr) {
                  var suggestion, suggestions;
                  if (xhr == null) {
                    xhr = null;
                  }
                  try {
                    suggestions = engine.parse(xhr);
                    suggestions = (function() {
                      var i, len, results;
                      results = [];
                      for (i = 0, len = suggestions.length; i < len; i++) {
                        suggestion = suggestions[i];
                        results.push(suggestion.toLowerCase());
                      }
                      return results;
                    })();
                    suggestions = (function() {
                      var i, len, results;
                      results = [];
                      for (i = 0, len = suggestions.length; i < len; i++) {
                        suggestion = suggestions[i];
                        if (suggestion !== query) {
                          results.push(suggestion);
                        }
                      }
                      return results;
                    })();
                    if (_this.debug) {
                      console.log("GET", url);
                    }
                  } catch (error) {
                    suggestions = [];
                    Utils.setTimeout(30 * 1000, function() {
                      return _this.completionCache.set(completionCacheKey, null);
                    });
                    if (_this.debug) {
                      console.log("fail", url);
                    }
                  }
                  callback(suggestions);
                  return delete _this.inTransit[completionCacheKey];
                });
              });
            }
            return _this.inTransit[completionCacheKey].use(function(suggestions) {
              _this.mostRecentSearchUrl = searchUrl;
              _this.mostRecentQuery = query;
              _this.mostRecentSuggestions = suggestions;
              return callback(_this.completionCache.set(completionCacheKey, suggestions));
            });
          }
        };
      })(this));
    },
    cancel: function() {
      if (this.mostRecentHandler != null) {
        this.mostRecentHandler = null;
        if (this.debug) {
          return console.log("cancel (user is typing)");
        }
      }
    }
  };

  root = typeof exports !== "undefined" && exports !== null ? exports : window;

  root.CompletionSearch = CompletionSearch;

}).call(this);
