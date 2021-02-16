/*
TODO
====
-bug fix: flash videos stay hidden
-bug when focus couldn't change
-test
	mail.yahoo.com
	google docs keys working?
	flash groove, vancouver2010
	french keyboard
	remove console.logs
	augment version number
-thumbnails of websites?
-add animations when going through tabs (refer to quicktabs)
- /Mac OS/.test(navigator.userAgent)
-i18n
*/

var DEBUG = false;
var subsequentLoad;
var recentTabs;

if (!subsequentLoad) {
	document.addEventListener('keydown', keyDown, true);
	document.addEventListener('keyup', keyUp, true);
}

if (window.$) {
	$(document).ready(function() {
		$("frame,iframe").each( function(index) {
			// fixed google drive/docs keys not being inputted by changed .bind to .on
			$(this.contentDocument).on('keydown', keyDown);
			$(this.contentDocument).on('keyup', keyUp);
		});
		
		$(window).blur( function() {
			if ($('#RT_tabs').is(':visible')) {
				hideCycler();
			}
		});
	});
}

var selectedTab = 0;
var lastCommand = "hide";
var ls;
var metaStartPressed = false;

function getCurrentDocFromEvent(e) {
	if ($(document).find("frameset").length) {
		return $(e.target).parents("html");
	} else {
		return $(document);
	}
}

function tabImage(tab) {
	if(tab.favIconUrl && tab.favIconUrl.length > 0) {
		return tab.favIconUrl;
	} else if(/^chrome:\/\/extensions\/.*/.exec(tab.url)) {
		return "http://img168.imageshack.us/img168/3407/chromeextensionsicon.png";
	} else {
		return "http://img29.imageshack.us/img29/5347/documentblankicon.png"
	}
}

function showCycler() {
	if (lastCommand == "show") {
		recentTabs.show();
	}
}

function hideCycler(callback) {
	lastCommand = "hide";
	if (recentTabs) {
		recentTabs.fadeOut(85, function() {
			$("iframe[RT_hidden=true],embed[RT_hidden=true],object[RT_hidden=true]").css("visibility", "visible");
			selectedTab = 0;
			if (callback) {
				setTimeout(callback, 1);
			}
		});
	}
}

function keyUp(e) {
	if (DEBUG) {
		console.log("up: " + e.which + " __ " + e.ctrlKey + "__" + e.metaKey);
	}
	if (e.which == 91) {
		metaStartPressed = false;
	}
	if (lastCommand == "show") {
		chrome.runtime.sendMessage({call: "getLocalStorage"},
			function(response) {
				ls = response.ls;
				var keys = ls["keys"];
				if (keys) {
					keys = JSON.parse(keys);
				}
				if (e.which == 17 || e.which == 18 || e.which == 91 || (e.which == 16 && keys && isPartOfCombination(keys, 'shift'))) {
					var currentDoc = getCurrentDocFromEvent(e);
					var tabIndex = currentDoc.find("#RT_tabIndex"+selectedTab).attr("tabId");
					hideCycler(function() {chrome.runtime.sendMessage({call: "switchTabs", id:tabIndex})} );
				}
			}
		);
	}
}

function keyDown(e) {
	if (DEBUG) {
		console.log("down: " + e.which + " __ " + e.ctrlKey + "__" + e.metaKey);
	}
	if (e.which == 91) {
		metaStartPressed = true;
	}
	processKey(e);
}

function isPartOfCombination(keys, key) {
	if (keys) {
		return toBool(keys['array'][0][key])
	} else {
		return false;
	}
}

function processKey(e) {
	chrome.runtime.sendMessage({call: "getLocalStorage"},
		function(response) {
			ls = response.ls;
			var maxRecentTabs = pref(ls["maxRecentTabs"], 10);
			var keys = ls["keys"];
			if (keys) {
				keys = JSON.parse(keys);
			}
			var correctCombination = false;
			if (keys) {
				var idx = 0;
				if (metaStartPressed) {
					idx = 1;
				}
				// Patch for Google Docs when focus on google document: e.metaKey always is true when Ctrl is pressed? so setting it to false
				if (document.location.host == "docs.google.com" && e.metaKey) {
					e.metaKey = false;
				}
				if ((keys['array'][idx] && e.ctrlKey == toBool(keys['array'][idx]['ctrl'])) && e.altKey == toBool(keys['array'][idx]['alt']) && e.metaKey == toBool(keys['array'][idx]['meta']) && e.which == keys['array'][idx]['code']) {
					if (toBool(keys['array'][idx]['shift'])) {
						if (e.shiftKey) {
							correctCombination = true;
						}
					} else {
						correctCombination = true;
					}
				}
			} else {
				if (e.ctrlKey && (e.which == "Q".charCodeAt(0) || e.which == 192)) {
					correctCombination = true;
				}
			}
			if (correctCombination) {
				var tabs;
				lastCommand = "show";
				chrome.runtime.sendMessage({call: "getTabs"}, function(response) {
					tabs = response.tabs;
					tabs.splice(maxRecentTabs);
					if (tabs.length == 1) {
						return;
					} else if (pref(ls["displayTabCylcer"], true) == false || tabs.length == 2 || (keys && (!isPartOfCombination(keys, 'ctrl') && !isPartOfCombination(keys, 'alt') && !isPartOfCombination(keys, 'meta') && !isPartOfCombination(keys, 'shift')))) {
						chrome.runtime.sendMessage({call: "switchTabs", id:tabs[1].id});
						return;
					}
					if (e.shiftKey && !isPartOfCombination(keys, 'shift')) {
						if (selectedTab == 0) {
							selectedTab = tabs.length - 1;
						} else {
							selectedTab--;
						}
					} else {
						if (selectedTab == tabs.length - 1) {
							selectedTab = 0;
						} else {
							selectedTab++;
						}
					}

					var currentDoc = getCurrentDocFromEvent(e);
					recentTabs = $(currentDoc).find("#RT_tabs");

					if (recentTabs.length) {
						recentTabs.html("");
					} else {
						var nodeToAttachCSS = currentDoc.find("head");
						if (!nodeToAttachCSS.length) {
							nodeToAttachCSS = currentDoc;
						}
						var cssURL = chrome.extension.getURL('main.css');
						var css = "<style>";
						css += " #RT_tabs, #RT_tabs * {-webkit-box-sizing:content-box} ";
						css += " #RT_tabs {box-shadow:5px 5px 5px #aaa;position:fixed;background:#aaa;border:2px solid #aaa;z-index:2147483647;top:30px;padding:15px;font-size:14px;-webkit-border-radius: 15px} ";
						css += " #RT_tabs img {padding:0;margin:0} ";
						
						css += " #closeRecentTabs {position:absolute;right:4px;top:4px;font-size:11px;color:blue;cursor:pointer} ";

						css += " #extensionTitle {text-shadow:1px 1px 1px white;color:black;text-align:center;padding-bottom:5px} ";
						css += " #extensionTitle, .RT_title {font:normal 15px Calibri,Verdana,Arial,sans-serif} ";
						css += " .RT_outerTab {padding:1px;-webkit-border-radius:5px} ";
						css += " .RT_selected {background:#1478E3} ";
						css += " .RT_tab {cursor:pointer;background:white;height:16px;margin:5px;padding:5px;-webkit-border-radius:5px} ";
						css += " #RT_tabs .RT_favicon {padding-right:5px;margin:0} ";
						css += " .RT_title {float:left;color:black} ";

						css += " #RT_donateButton {color:blue} ";
						css += " #tryMyApps {text-decoration:underline} ";
						css += " #RT_tabs #RT_donateButton {cursor:pointer;padding-top:7px;text-align:center} ";
						css += " #RT_tabs #RT_donateButton img {margin:0 auto} ";
						css += "</style>";

						nodeToAttachCSS.append( css );

						recentTabs = $("<div id='RT_tabs'></div>");
						currentDoc.find("body").append( recentTabs );
					}

					var $closeDiv = $("<div id='closeRecentTabs'>[Close]</div>")
					$closeDiv.click( function() {
						hideCycler(function () {});
					});
					
					recentTabs.append($closeDiv);
					
					recentTabs.append($("<div id='extensionTitle'>Recent Tabs Extension</div>"));
					$.each(tabs, function(i, tab) {
						var outerTab = "RT_outerTab";
						if (i == selectedTab) {
							outerTab += " RT_selected";
						}
						var title;
						if (tab.title) {
							title = tab.title;
						} else {
							title = tab.url;
						}
						var MAX_TITLE_LEN = 30;
						if (title.length > MAX_TITLE_LEN) {
							title = title.substring(0, MAX_TITLE_LEN) + " ...";
						}
						recentTabs.append($("<div></div>").attr({class:outerTab, id:"RT_tabIndex"+i, tabId:tab.id})
							.click( function() {
								hideCycler(function () { chrome.runtime.sendMessage({call: "switchTabs", id:tab.id}) });
							})
							.append($("<div class='RT_tab'></div>")
							.append($("<div style='float:left'></div>").append($("<img></img>").attr({src:tabImage(tab), class:"RT_favicon", align:"absmiddle", width:"16", height:"16", border:"0"})))
							.append($("<div class='RT_title'></div>").attr({title:title}).text(title)))
						);
					});
					recentTabs.append($("<div id='RT_donateButton'></div>").append($("<span><img align='absmiddle' src='data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAABa1BMVEX////39/fT3NVRt0lXmULcIyny8fHe3t8RYaGnz6XitwnYrBHcIyne3t/cIyl7p5VRt0lTp07cIykMXp3e3t/X3dvT3NW1z7jssgvcrhFYqlXcIynitwlRt0lgsVxdr1iSYjTcIynuwQztvg/nuBDvxAkdd8fnuBDcIymSpIbfMTbs2ZdRt0n////9zgb6yg7cIyn4xRLkQTv6zAfZIShBlN7lSUXfLC7enaTymZFPr0r4w7763dvgNi388fL84XP01dj920TOISrEICxYoeBeoNj04+Xy9vRonozjdHnUdH/w9PL17Ovl8ObZxG/fbmhXmULmiBTtvg/dZm3WZm6cc2vlWV2SYjTSSVaGZDPraV+HWjPdPUPXPUTgNyM1jt17sdfqVkviWRwff9PkUFMfe83srK/oq7DxqKZ/xoDLS0X610e44Lf2yMlwreHMlqNmqODgMTHQNibuhH5Rt0ntjhXrgobogYvRHCJH0vSeAAAALXRSTlMAEREREREiIiIzMzMzVVVmZmZmd4iIiIiIiIiImZmZmZmZu7u7u7vMzN3d7u6bOr4uAAAA00lEQVR4XlXKZVMDMRSF4Vsv7u71AjfJet3dcHd3159Pdtlhhvfjcw7wbL2z/Q74q21q8X2LyaGJThOGm/c3ezLbfPicn+s2oI6YulzLHVT3ZXY4CjBURvzajqSu1vOvH8QPMMgBM5ES/xFKPBwa12/ROOpRQvlj5PZFVE92EzpQ6gHL+A7TkqKoJkxwTi9/156Wktq5AV5wzcQ2Cs+PrZXT+C9Y+2KVI0U5lqQ0UoEDgL0ncHFWJCSLgiD4wMg9EJbIHYdgB5hB++QCro7Bv7r0+Qc1pirs9Ik4zAAAAABJRU5ErkJggg=='/> <span id='tryMyApps'>Try my other cool apps!</span></span>")
						.click( function() {
							hideCycler(function () { chrome.runtime.sendMessage({call: "openDonatePage"}) });
						})
					));

					$("iframe[src^='http://ad.']:visible,iframe[src^='https://ad.']:visible,embed:visible,object:visible").css("visibility", "hidden").attr("RT_hidden", "true");
					//$("embed,object").attr("wmode", "transparent");
					//$("param[name=wmode]").attr("value", "transparent");
					//$("embed,object").hide();
					//$("embed").append("<param name='wmode' value='transparent'>");

					var wnd = $(window);
					pLeft = (wnd.width() - recentTabs.outerWidth()) / 2;

					recentTabs.css({top: 80, left: pLeft});
					showCycler();
				});
			}
		}
	);
}

subsequentLoad = true;