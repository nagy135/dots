/* 	Credits to jumpei@google.com of the extension "Shortcut Manager" for this code. */

// namespace
var keyutil = {};

/**
 * @type {Object.<string, Number>} A map from a upper case key name to a key
 *     code. These keys are invisible keys which a 'keypress' event cannot
 *     capture.
 */
keyutil.INVISIBLE_KEY_MAP = {
  BACKSPACE: 8,
  TAB: 9,
  SHIFT: 16,
  CTRL: 17,
  ALT: 18,
  PAUSEBREAK: 19,
  ESC: 27,
  PAGEUP: 33,
  PAGEDOWN: 34,
  END: 35,
  HOME: 36,
  LEFT: 37,
  UP: 38,
  RIGHT: 39,
  DOWN: 40,
  SELECT: 41,
  PRINTSCREEN: 42,
  EXECUTE: 43,
  SNAPSHOT: 44,
  INSERT: 45,
  DELETE: 46,
  HELP: 47,
  META: 91,
  F1: 112,
  F2: 113,
  F3: 114,
  F4: 115,
  F5: 116,
  F6: 117,
  F7: 118,
  F8: 119,
  F9: 120,
  F10: 121,
  F11: 122,
  F12: 123,
  F13: 124,
  F14: 125,
  F15: 126,
  F16: 127,
  NUMLOCK: 144,
  SCROLLLOCK: 145,
  CAPSLOCK: 240
};

/**
 * @type {Object.<string, Number>} The following keys does change a text value.
 */
keyutil.INVISIBLE_TEXT_KEY_MAP = {
  DELETE: 1
};

/**
 * @type {Object.<string, Number>} A map from an upper case key name to a key
 *     code. These keys are visible to a user when s/he types it in an text box.
 */
keyutil.VISIBLE_KEY_MAP = {
  ENTER: 13,
  SPACE: 32,
  NUM0: 96,
  NUM1: 97,
  NUM2: 98,
  NUM3: 99,
  NUM4: 100,
  NUM5: 101,
  NUM6: 102,
  NUM7: 103,
  NUM8: 104,
  NUM9: 105,
  'NUM*': 106,
  'NUMPLUS': 107,
  'NUM-': 109,
  'NUM.': 110,
  'NUM/': 111,
  ';': 186,
  '=': 187,
  ',': 188,
  '-': 189,
  '.': 190,
  '/': 191,
  '`': 192,
  '[': 219,
  '\\': 220,
  ']': 221,
  '\'': 222
};

/**
 * @type {Object.<string, string>} A map from a shorcut command to its meaning.
 *     These commands are always executed and nobody cannot overwrite them even
 *     with e.preventDefault().
 */
keyutil.strongBindingObj = {
  'ALT+F4': 'Close the current window',
  'ALT+SHIFT+T': 'Focus on the toolbar',
  'CTRL+N': 'Open a new window',
  'CTRL+T': 'Open a new tab',
  'CTRL+W': 'Close the current tab',
  'CTRL+F4': 'Close the current tab',
  'CTRL+TAB': 'Select the right tab',
  'CTRL+SHIFT+TAB': 'Select the left tab',
  'CTRL+SHIFT+T': 'Undo close tab',
  'CTRL+SHIFT+N': 'Open the secret window',
  'SHIFT+ESCAPE': 'Open TaskManager'
};

/**
 * @type {Object.<string, string>} A map from a shorcut command to its meaning.
 *     These commands can be overwritten or canceled with e.preventDefault().
 */
keyutil.weakBindingObj = {
  'BACKSPACE': 'Back',
  'DELETE': 'Delete',
  'ESCAPE': 'Stop',
  'PAGEUP': 'Page up',
  'PAGEDOWN': 'Page down',
  'SPACE': 'Scroll down',
  'UP': 'Scroll up',
  'DOWN': 'Scroll down',
  'LEFT': 'Scroll left',
  'RIGHT': 'Scroll right',
  'TAB': 'Focus on the next element',
  'F1': 'Open the Chrome support page',
  'F3': 'Search next',
  'F5': 'Reload',
  'F6': 'Select the address bar',
  'F11': 'Full screen',
  'HOME': 'Scroll to the top',
  'END': 'Scroll to the bottom',
  'CTRL+A': 'Select all',
  'CTRL+B': 'Show the bookmark bar',
  'CTRL+C': 'Copy',
  'CTRL+D': 'Bookmark this page',
  'CTRL+E': 'Jump to the search box',
  'CTRL+F': 'Find',
  'CTRL+G': 'Search next',
  'CTRL+H': 'Open History',
  'CTRL+J': 'Open Downloads',
  'CTRL+K': 'Jump to the search box',
  'CTRL+L': 'Select the address bar',
  'CTRL+O': 'Open',
  'CTRL+P': 'Print',
  'CTRL+R': 'Reload',
  'CTRL+S': 'Save',
  'CTRL+U': 'View source',
  'CTRL+V': 'Paste',
  'CTRL+X': 'Cut',
  'CTRL+Z': 'Undo',
  'CTRL+=': 'Zoom up',
  'CTRL+-': 'Zoom out',
  'CTRL+0': 'Default font size',
  'CTRL+1': 'Select the 1st tab',
  'CTRL+2': 'Select the 2nd tab',
  'CTRL+3': 'Select the 3rd tab',
  'CTRL+4': 'Select the 4th tab',
  'CTRL+5': 'Select the 5th tab',
  'CTRL+6': 'Select the 6th tab',
  'CTRL+7': 'Select the 7th tab',
  'CTRL+8': 'Select the 8th tab',
  'CTRL+9': 'Select the last tab',
  'CTRL+F5': 'Reload (Cacheless)',
  'ALT+LEFT': 'Back',
  'ALT+RIGHT': 'Forward',
  'ALT+HOME': 'Open a new tab',
  'ALT+D': 'Select the address bar',
  'SHIFT+BACKSPACE': 'Forward',
  'SHIFT+F3': 'Search previous',
  'SHIFT+F5': 'Reload (Cacheless)',
  'SHIFT+INSERT': 'Paste',
  'SHIFT+DELETE': 'Cut',
  'SHIFT+TAB' : 'Focus on the previous element',
  'CTRL+SHIFT+G': 'Search previous',
  'CTRL+SHIFT+J': 'Javascript console',
  'CTRL+SHIFT+V': 'Paste content as a plain text',
  'CTRL+SHIFT+DELETE': '"Clear History" dialog'
};

// '0' - '9'
for (var code = 48; code <= 57; ++code) {
  keyutil.VISIBLE_KEY_MAP[String.fromCharCode(code)] = code;
}
// 'A' - 'Z'
for (code = 65; code <= 90; ++code) {
  keyutil.VISIBLE_KEY_MAP[String.fromCharCode(code)] = code;
}

/**
 * @type {Object.<Number, string>} A map from a key code to a key name.
 */
keyutil.CODE_KEY_MAP = {};

for (var str in keyutil.INVISIBLE_KEY_MAP) {
  keyutil.CODE_KEY_MAP[keyutil.INVISIBLE_KEY_MAP[str]] = str;
}
for (str in keyutil.VISIBLE_KEY_MAP) {
  keyutil.CODE_KEY_MAP[keyutil.VISIBLE_KEY_MAP[str]] = str;
}

/**
 * @param {string} keystroke The key stroke string like "Ctrl+k ALT+m".
 * @return {Object} with the following key.
 *    - array : KeyMatcher array.
 *    - isVisible : A key is visible if a character is shown in a text box.
 *                  For example, "A", "0", "-", "SHIFT+/" are visible,
 *                  while "F4", "ESC", "Ctrl+A", "Ctrl+SHIFT+K" are not visible.
 *    - note : Not error, but notable fact.
 *    - error : Error string.
 */
keyutil.parseKey = function(keystroke) {
  var isVisible = false;
  keystroke = keystroke.toUpperCase().replace(/^\s+|\s+$/g, '');
  var chars = keystroke.split(/\s+/g);
  if (chars.length == 1 && chars[0] == '') {
    return {
      'array': []
    };
  }
  var matchObjArray = [];
  var notes = [];
  for (var i = 0; i < chars.length; ++i) {
    // 'ch' consists of the main key + some optional modifiers.
    // e.g. "L", "SHIFT+A", "Ctrl+ALT+SHIFT+K".
    var ch = chars[i];
    if (keyutil.strongBindingObj[ch]) {
      return {
        'error': 'Key conflict: [' + ch + '] always triggers "' + keyutil.strongBindingObj[ch] + '" before your action.'
      };
    } else if (keyutil.weakBindingObj[ch]) {
      if (i != chars.length - 1) {
        return {
          'error': 'Key conflict: [' + ch + '] triggers "' + keyutil.weakBindingObj[ch] + '" before you finish typing.'
		  };
      } else {
        notes.push('[' + ch + '] hides the default browser action "' + keyutil.weakBindingObj[ch] + '"');
      }
    }
    var choptions = ch.split(/\+/g);
    var charObj = {};
    var isCharVisible = false;
    for (var j = 0; j < choptions.length; ++j) {
      var modifier = choptions[j].toUpperCase();
      var keyCode = (keyutil.INVISIBLE_KEY_MAP[modifier] ||
                     keyutil.VISIBLE_KEY_MAP[modifier]);
      if (keyCode) {
        if (keyutil.VISIBLE_KEY_MAP[modifier] ||
            keyutil.INVISIBLE_TEXT_KEY_MAP[modifier]) {
          isCharVisible = true;
        }
        if (keyCode == 16) {
          if (!charObj['shift']) {
            charObj['shift'] = true;
          } else {
            // duplicate shift
            return {
              'error': '"' + ch + '" in "' + keystroke + '"'
            };
          }
        } else if (keyCode == 17) {
          if (!charObj['ctrl']) {
            charObj['ctrl'] = true;
          } else {
            // duplicate ctrl
            return {
              'error': '"' + ch + '" in "' + keystroke + '"'
            };
          }
        } else if (keyCode == 18) {
          if (!charObj['alt']) {
            charObj['alt'] = true;
          } else {
            // duplicate alt
            return {
              'error': '"' + ch + '" in "' + keystroke + '"'
            };
          }
        } else {
          if (!charObj['code']) {
            charObj['code'] = keyCode;
          } else {
            return {
              'error': '"' + ch + '" in "' + keystroke + '"'
            };
          }
        }
      }
      if (modifier.length == 1 && modifier.charCodeAt(0) <= 255) {
        charObj['key'] = modifier;
      } else if (!keyCode) {
        return {
          'error': '"' + ch + '" in "' + keystroke + '"'
        };
      }
    }
    if (isCharVisible && (charObj['ctrl'] || charObj['alt'])) {
      isCharVisible = false;
    }
    if (isCharVisible) {
      isVisible = true;
    }
    if (charObj['key']) {
      if (typeof charObj['key'] == 'string') {
        if (charObj['shift']) {
          charObj['key'] = charObj['key'].toUpperCase();
        } else {
          charObj['key'] = charObj['key'].toLowerCase();
        }
      }
    } else if (!charObj['code']) {
      return {
        'error': '"' + ch + '" in "' + keystroke + '"'
      };
    }
    matchObjArray.push(charObj);
  }
  return {
    'array': matchObjArray,
    'isVisible': isVisible,
    'note': notes.join('\n')
  };
};

/**
 * @param {Number} code The code value.
 * @return {boolean} Returns true if the key code is invisible character.
 */
keyutil.isInvisibleKeyCode = function(code) {
  // Lazy evaluation.
  for (var k in keyutil.INVISIBLE_KEY_MAP) {
    if (keyutil.INVISIBLE_KEY_MAP[k] == code) {
      return true;
    }
  }
  return false;
};

/**
 * @param {string} onekey One combination of key such as "A", "CTRL+A", or
 *     "CTRL+SHIFT+ALT+ENTER".
 * @return {string} The key for display, such as "a", "Ctrl+a", or
 *     "Ctrl+Shift+Alt+Enter".
 */
keyutil.normalizeForDisplay = function(onekey) {
  var chars = onekey.split('+');
  for (var i = 0; i < chars.length; ++i) {
    if (chars[i].length == 1) {
      chars[i] = chars[i].toLowerCase();
    } else {
      chars[i] = chars[i][0].toUpperCase() + chars[i].slice(1).toLowerCase();
    }
  }
  return chars.join('+');
};

/**
 * @param {Object} charObj The object obtained from keyutil.parseKey().
 * @param {Number} keydown The keyCode of a keydown event.
 * @param {Number} keypress The keyCode of a keydown event.
 * @param {boolean} shiftKey Is shiftKey pressed.
 * @param {boolean} ctrlKey Is ctrlKey pressed.
 * @param {boolean} altKey is altKey pressed.
 * @param {boolean} metaKey is metaKey pressed.
 * @return {boolean} True if the charObj matches the current key a user typed.
 */
keyutil.matchOneKey = function(charObj, keydown, keypress,
                               shiftKey, ctrlKey, altKey, metaKey) {
  var skipShift = false;
  var failed = false;
  if (charObj['key'] == String.fromCharCode(keypress)) {
    if (!(keypress >= 65 && keypress <= 122)) {
      skipShift = true;
    }
  } else if (charObj['code'] == keydown) {
    // do nothing.
  } else {
    return false;
  }
  if (!skipShift && (charObj['shift'] ^ shiftKey)) {
    return false;
  }
  if (charObj['alt'] ^ altKey) {
    return false;
  }
  if (charObj['ctrl'] ^ ctrlKey) {
    return false;
  }
  return true;
};

/**
 * Listen keydown event in the given input box so that users can register
 * keyboard shortcuts easily.
 * @param {HTMLInputElement} input The input element.
 * @param {function():string} opt_getValue If specified, call
 *     this function to get the input value.
 * @param {function(string): void?} opt_setValue If
 *     specified, call this function to set the input value.
 * @constructor
 */
keyutil.InputBoxListener = function(input, opt_getValue, opt_setValue) {
  /**
   * @type {Object} timer object.
   * @private
   */
  this.timer_ = null;

  /**
   * @type {HTMLInputElement}
   * @private
   */
  this.input_ = input;

  /**
   * @type {function():string}
   * @private
   */
  this.getValue_ = (opt_getValue ? opt_getValue :
                    util.bind(this.getValueDefault_, this));

  /**
   * @type {function(string): void?}
   * @private
   */
  this.setValue_ = (opt_setValue ? opt_setValue :
                    util.bind(this.setValueDefault_, this));

  input.addEventListener('keydown', util.bind(this.onKeydown, this), false);
};

/**
 * @return {string} Get the value of the input box.
 * @private
 */
keyutil.InputBoxListener.prototype.getValueDefault_ = function() {
  return this.input_.value;
};

/**
 * @param {string} value Set the value of the input box.
 * @private
 */
keyutil.InputBoxListener.prototype.setValueDefault_ = function(value) {
  this.input_.value = value;
};


/**
 * @param {Event} e Keydown event object.
 */
keyutil.InputBoxListener.prototype.onKeydown = function(e) {
  // Show the current
  if (e.keyCode == 16 || e.keyCode == 17 || e.keyCode == 18) {
    // A user just typed 'ctrl', 'alt', or 'shift' key. Ignore it.
    return;
  }
  var keystr = '';
  if (e.ctrlKey) {
    keystr += 'Ctrl+';
  }
  if (e.altKey) {
    keystr += 'Alt+';
  }
  if (e.metaKey) {
    keystr += 'Meta+';
  }
  if (e.shiftKey) {
    keystr += 'Shift+';
  }
  if (keyutil.CODE_KEY_MAP[e.keyCode]) {
    var onekey = keyutil.normalizeForDisplay(
        keyutil.CODE_KEY_MAP[e.keyCode]);
    keystr += onekey;
  } else {
    throw new Error('Unregistered keyCode: ' + e.keyCode);
  }

  if (this.timer_ == null) {
    // The key strokes have been already finished. Start a new stroke.
    this.setValue_(keystr);
  } else {
    var value = this.getValue_();
    if (value) {
      this.setValue_(value + ' ' + keystr);
    } else {
      this.setValue_(keystr);
    }
    window.clearTimeout(this.timer_);
  }
  // After 1 sec, this.timer_ is cleared.
  this.timer_ = window.setTimeout(
    util.bind(function() {
      this.timer_ = null;
    }, this), 1000);

  e.preventDefault();
  e.stopPropagation();
};
