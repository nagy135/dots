# Autogenerated config.py
#
# NOTE: config.py is intended for advanced users who are comfortable
# with manually migrating the config file on qutebrowser upgrades. If
# you prefer, you can also configure qutebrowser using the
# :set/:bind/:config-* commands without having to write a config.py
# file.
#
# Documentation:
#   qute://help/configuring.html
#   qute://help/settings.html

# Change the argument to True to still load settings configured via autoconfig.yml
config.load_autoconfig(False)

# Aliases for commands. The keys of the given dictionary are the
# aliases, while the values are the commands they map to.
# Type: Dict
c.aliases = {'w': 'session-save', 'q': 'quit', 'wq': 'quit --save', 'pypa': 'spawn pypass print -d --clip --masterpass ', 'wall': 'spawn --userscript wallpaper_create '}

# Which cookies to accept. With QtWebEngine, this setting also controls
# other features with tracking capabilities similar to those of cookies;
# including IndexedDB, DOM storage, filesystem API, service workers, and
# AppCache. Note that with QtWebKit, only `all` and `never` are
# supported as per-domain values. Setting `no-3rdparty` or `no-
# unknown-3rdparty` per-domain on QtWebKit will have the same effect as
# `all`. If this setting is used with URL patterns, the pattern gets
# applied to the origin/first party URL of the page making the request,
# not the request URL.
# Type: String
# Valid values:
#   - all: Accept all cookies.
#   - no-3rdparty: Accept cookies from the same origin only. This is known to break some sites, such as GMail.
#   - no-unknown-3rdparty: Accept cookies from the same origin only, unless a cookie is already set for the domain. On QtWebEngine, this is the same as no-3rdparty.
#   - never: Don't accept cookies at all.
config.set('content.cookies.accept', 'all', 'chrome-devtools://*')

# Which cookies to accept. With QtWebEngine, this setting also controls
# other features with tracking capabilities similar to those of cookies;
# including IndexedDB, DOM storage, filesystem API, service workers, and
# AppCache. Note that with QtWebKit, only `all` and `never` are
# supported as per-domain values. Setting `no-3rdparty` or `no-
# unknown-3rdparty` per-domain on QtWebKit will have the same effect as
# `all`. If this setting is used with URL patterns, the pattern gets
# applied to the origin/first party URL of the page making the request,
# not the request URL.
# Type: String
# Valid values:
#   - all: Accept all cookies.
#   - no-3rdparty: Accept cookies from the same origin only. This is known to break some sites, such as GMail.
#   - no-unknown-3rdparty: Accept cookies from the same origin only, unless a cookie is already set for the domain. On QtWebEngine, this is the same as no-3rdparty.
#   - never: Don't accept cookies at all.
config.set('content.cookies.accept', 'all', 'devtools://*')

# User agent to send.  The following placeholders are defined:  *
# `{os_info}`: Something like "X11; Linux x86_64". * `{webkit_version}`:
# The underlying WebKit version (set to a fixed value   with
# QtWebEngine). * `{qt_key}`: "Qt" for QtWebKit, "QtWebEngine" for
# QtWebEngine. * `{qt_version}`: The underlying Qt version. *
# `{upstream_browser_key}`: "Version" for QtWebKit, "Chrome" for
# QtWebEngine. * `{upstream_browser_version}`: The corresponding
# Safari/Chrome version. * `{qutebrowser_version}`: The currently
# running qutebrowser version.  The default value is equal to the
# unchanged user agent of QtWebKit/QtWebEngine.  Note that the value
# read from JavaScript is always the global value. With QtWebEngine
# between 5.12 and 5.14 (inclusive), changing the value exposed to
# JavaScript requires a restart.
# Type: FormatString
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}; rv:71.0) Gecko/20100101 Firefox/71.0', 'https://docs.google.com/*')

# User agent to send.  The following placeholders are defined:  *
# `{os_info}`: Something like "X11; Linux x86_64". * `{webkit_version}`:
# The underlying WebKit version (set to a fixed value   with
# QtWebEngine). * `{qt_key}`: "Qt" for QtWebKit, "QtWebEngine" for
# QtWebEngine. * `{qt_version}`: The underlying Qt version. *
# `{upstream_browser_key}`: "Version" for QtWebKit, "Chrome" for
# QtWebEngine. * `{upstream_browser_version}`: The corresponding
# Safari/Chrome version. * `{qutebrowser_version}`: The currently
# running qutebrowser version.  The default value is equal to the
# unchanged user agent of QtWebKit/QtWebEngine.  Note that the value
# read from JavaScript is always the global value. With QtWebEngine
# between 5.12 and 5.14 (inclusive), changing the value exposed to
# JavaScript requires a restart.
# Type: FormatString
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}; rv:71.0) Gecko/20100101 Firefox/71.0', 'https://drive.google.com/*')

# User agent to send.  The following placeholders are defined:  *
# `{os_info}`: Something like "X11; Linux x86_64". * `{webkit_version}`:
# The underlying WebKit version (set to a fixed value   with
# QtWebEngine). * `{qt_key}`: "Qt" for QtWebKit, "QtWebEngine" for
# QtWebEngine. * `{qt_version}`: The underlying Qt version. *
# `{upstream_browser_key}`: "Version" for QtWebKit, "Chrome" for
# QtWebEngine. * `{upstream_browser_version}`: The corresponding
# Safari/Chrome version. * `{qutebrowser_version}`: The currently
# running qutebrowser version.  The default value is equal to the
# unchanged user agent of QtWebKit/QtWebEngine.  Note that the value
# read from JavaScript is always the global value. With QtWebEngine
# between 5.12 and 5.14 (inclusive), changing the value exposed to
# JavaScript requires a restart.
# Type: FormatString
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version}', 'https://web.whatsapp.com/')

# User agent to send.  The following placeholders are defined:  *
# `{os_info}`: Something like "X11; Linux x86_64". * `{webkit_version}`:
# The underlying WebKit version (set to a fixed value   with
# QtWebEngine). * `{qt_key}`: "Qt" for QtWebKit, "QtWebEngine" for
# QtWebEngine. * `{qt_version}`: The underlying Qt version. *
# `{upstream_browser_key}`: "Version" for QtWebKit, "Chrome" for
# QtWebEngine. * `{upstream_browser_version}`: The corresponding
# Safari/Chrome version. * `{qutebrowser_version}`: The currently
# running qutebrowser version.  The default value is equal to the
# unchanged user agent of QtWebKit/QtWebEngine.  Note that the value
# read from JavaScript is always the global value. With QtWebEngine
# between 5.12 and 5.14 (inclusive), changing the value exposed to
# JavaScript requires a restart.
# Type: FormatString
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version} Edg/{upstream_browser_version}', 'https://accounts.google.com/*')

# User agent to send.  The following placeholders are defined:  *
# `{os_info}`: Something like "X11; Linux x86_64". * `{webkit_version}`:
# The underlying WebKit version (set to a fixed value   with
# QtWebEngine). * `{qt_key}`: "Qt" for QtWebKit, "QtWebEngine" for
# QtWebEngine. * `{qt_version}`: The underlying Qt version. *
# `{upstream_browser_key}`: "Version" for QtWebKit, "Chrome" for
# QtWebEngine. * `{upstream_browser_version}`: The corresponding
# Safari/Chrome version. * `{qutebrowser_version}`: The currently
# running qutebrowser version.  The default value is equal to the
# unchanged user agent of QtWebKit/QtWebEngine.  Note that the value
# read from JavaScript is always the global value. With QtWebEngine
# between 5.12 and 5.14 (inclusive), changing the value exposed to
# JavaScript requires a restart.
# Type: FormatString
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99 Safari/537.36', 'https://*.slack.com/*')

# Load images automatically in web pages.
# Type: Bool
config.set('content.images', True, 'chrome-devtools://*')

# Load images automatically in web pages.
# Type: Bool
config.set('content.images', True, 'devtools://*')

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'file://*')

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'chrome-devtools://*')

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'devtools://*')

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'chrome://*/*')

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'qute://*/*')

# Editor (and arguments) to use for the `edit-*` commands. The following
# placeholders are defined:  * `{file}`: Filename of the file to be
# edited. * `{line}`: Line in which the caret is found in the text. *
# `{column}`: Column in which the caret is found in the text. *
# `{line0}`: Same as `{line}`, but starting from index 0. * `{column0}`:
# Same as `{column}`, but starting from index 0.
# Type: ShellCommand
c.editor.command = ['alacritty', '-e', 'nvim', '{file}']

# CSS border value for hints.
# Type: String
c.hints.border = '2px solid #b2d3d9'

# Characters used for hint strings.
# Type: UniqueCharString
c.hints.chars = 'fjdkslaghtyrueiwqpvbcnm'

# Make characters in hint strings uppercase.
# Type: Bool
c.hints.uppercase = True

# Enable smooth scrolling for web pages. Note smooth scrolling does not
# work with the `:scroll-px` command.
# Type: Bool
c.scrolling.smooth = False

# Padding (in pixels) around text for tabs.
# Type: Padding
c.tabs.padding = {'top': 10, 'bottom': 10, 'left': 10, 'right': 10}

# Format to use for the tab title. The following placeholders are
# defined:  * `{perc}`: Percentage as a string like `[10%]`. *
# `{perc_raw}`: Raw percentage, e.g. `10`. * `{current_title}`: Title of
# the current web page. * `{title_sep}`: The string `" - "` if a title
# is set, empty otherwise. * `{index}`: Index of this tab. *
# `{aligned_index}`: Index of this tab padded with spaces to have the
# same   width. * `{id}`: Internal tab ID of this tab. * `{scroll_pos}`:
# Page scroll position. * `{host}`: Host of the current web page. *
# `{backend}`: Either `webkit` or `webengine` * `{private}`: Indicates
# when private mode is enabled. * `{current_url}`: URL of the current
# web page. * `{protocol}`: Protocol (http/https/...) of the current web
# page. * `{audio}`: Indicator for audio/mute status.
# Type: FormatString
c.tabs.title.format = '{index}: {current_title}'

# Width (in pixels) of the progress indicator (0 to disable).
# Type: Int
c.tabs.indicator.width = 0

# Page to open if :open -t/-b/-w is used without URL. Use `about:blank`
# for a blank page.
# Type: FuzzyUrl
c.url.default_page = 'https://yts.mx/'

# Search engines which can be used via the address bar.  Maps a search
# engine name (such as `DEFAULT`, or `ddg`) to a URL with a `{}`
# placeholder. The placeholder will be replaced by the search term, use
# `{{` and `}}` for literal `{`/`}` braces.  The following further
# placeholds are defined to configure how special characters in the
# search terms are replaced by safe characters (called 'quoting'):  *
# `{}` and `{semiquoted}` quote everything except slashes; this is the
# most   sensible choice for almost all search engines (for the search
# term   `slash/and&amp` this placeholder expands to `slash/and%26amp`).
# * `{quoted}` quotes all characters (for `slash/and&amp` this
# placeholder   expands to `slash%2Fand%26amp`). * `{unquoted}` quotes
# nothing (for `slash/and&amp` this placeholder   expands to
# `slash/and&amp`). * `{0}` means the same as `{}`, but can be used
# multiple times.  The search engine named `DEFAULT` is used when
# `url.auto_search` is turned on and something else than a URL was
# entered to be opened. Other search engines can be used by prepending
# the search engine name to the search term, e.g. `:open google
# qutebrowser`.
# Type: Dict
c.url.searchengines = {'rs': 'https://doc.rust-lang.org/std/?search={}', 'duck': 'https://duckduckgo.com/?q={}&ia=web', 'DEFAULT': 'https://www.google.sk/search?q={}', 'archrepo': 'https://www.archlinux.org/packages/?q={}', 'you': 'https://www.youtube.com/results?search_query={}&page=&utm_source=opensearch', 'tw': 'http://www.twitch.tv/{}'}

# Page(s) to open at the start.
# Type: List of FuzzyUrl, or FuzzyUrl
# c.url.start_pages = ['https://yts.mx/']
c.url.start_pages = ['file:///home/infiniter/.config/qutebrowser/homepage/index.html']

# Background color of the completion widget for odd rows.
# Type: QssColor
c.colors.completion.odd.bg = '#000000'

# Background color of the completion widget for even rows.
# Type: QssColor
c.colors.completion.even.bg = '#222222'

# Foreground color of completion widget category headers.
# Type: QtColor
c.colors.completion.category.fg = '#0b0b0b'

# Background color of the completion widget category headers.
# Type: QssColor
c.colors.completion.category.bg = '#19a85b'

# Foreground color of the selected completion item.
# Type: QtColor
c.colors.completion.item.selected.fg = '#000000'

# Background color of the selected completion item.
# Type: QssColor
c.colors.completion.item.selected.bg = '#f9dc2b'

# Font color for hints.
# Type: QssColor
c.colors.hints.fg = '#f9dc2b'

# Background color for hints. Note that you can use a `rgba(...)` value
# for transparency.
# Type: QssColor
c.colors.hints.bg = '#0b0b0b'

# Font color for the matched part of hints.
# Type: QtColor
c.colors.hints.match.fg = '#e52929'

# Foreground color of the URL in the statusbar on successful load
# (http).
# Type: QssColor
c.colors.statusbar.url.success.http.fg = '#f9dc2b'

# Foreground color of the URL in the statusbar on successful load
# (https).
# Type: QssColor
c.colors.statusbar.url.success.https.fg = '#f9dc2b'

# Foreground color of unselected odd tabs.
# Type: QtColor
c.colors.tabs.odd.fg = '#b2d3d9'

# Background color of unselected odd tabs.
# Type: QtColor
c.colors.tabs.odd.bg = '#0b0b0b'

# Foreground color of unselected even tabs.
# Type: QtColor
c.colors.tabs.even.fg = '#b2d3d9'

# Background color of unselected even tabs.
# Type: QtColor
c.colors.tabs.even.bg = '#0b0b0b'

# Foreground color of selected odd tabs.
# Type: QtColor
c.colors.tabs.selected.odd.fg = '#0b0b0b'

# Background color of selected odd tabs.
# Type: QtColor
c.colors.tabs.selected.odd.bg = '#19a85b'

# Foreground color of selected even tabs.
# Type: QtColor
c.colors.tabs.selected.even.fg = '#0b0b0b'

# Background color of selected even tabs.
# Type: QtColor
c.colors.tabs.selected.even.bg = '#19a85b'

# Foreground color of pinned unselected odd tabs.
# Type: QtColor
c.colors.tabs.pinned.odd.fg = 'white'

# Background color of pinned unselected odd tabs.
# Type: QtColor
c.colors.tabs.pinned.odd.bg = '#0b0b0b'

# Foreground color of pinned unselected even tabs.
# Type: QtColor
c.colors.tabs.pinned.even.fg = 'white'

# Background color of pinned unselected even tabs.
# Type: QtColor
c.colors.tabs.pinned.even.bg = '#0b0b0b'

# Foreground color of pinned selected odd tabs.
# Type: QtColor
c.colors.tabs.pinned.selected.odd.fg = '#0b0b0b'

# Background color of pinned selected odd tabs.
# Type: QtColor
c.colors.tabs.pinned.selected.odd.bg = '#19a85b'

# Foreground color of pinned selected even tabs.
# Type: QtColor
c.colors.tabs.pinned.selected.even.fg = '#0b0b0b'

# Background color of pinned selected even tabs.
# Type: QtColor
c.colors.tabs.pinned.selected.even.bg = '#19a85b'

# Font used in the completion widget.
# Type: Font
c.fonts.completion.entry = '12pt League Mono'

# Font used in the completion categories.
# Type: Font
c.fonts.completion.category = 'bold 13pt League Mono'

# Font used for the downloadbar.
# Type: Font
c.fonts.downloads = '12pt League Mono'

# Font used for the hints.
# Type: Font
c.fonts.hints = 'bold 12pt League Mono'

# Font used in the statusbar.
# Type: Font
c.fonts.statusbar = '13pt League Mono'

# Font used for selected tabs.
# Type: Font
c.fonts.tabs.selected = '12pt League Mono'

# Font used for unselected tabs.
# Type: Font
c.fonts.tabs.unselected = '12pt League Mono'

# Bindings for normal mode
config.bind(';;C', 'spawn chromium {url}')
config.bind(';;M', 'spawn --userscript csfd')
config.bind(';;c', 'hint links spawn chromium {hint-url}')
config.bind(';;d', 'spawn --userscript remove_seen')
config.bind(';;m', 'hint links spawn mpv {hint-url}')
config.bind(';;y', 'hint links userscript add-youtube-queue')
config.bind(';M', 'hint --rapid links spawn umpv {hint-url}')
config.bind(';m', 'config-cycle content.user_stylesheets ~/.config/qutebrowser/themes/darculized/darculized-all-sites.css ""')
config.bind(';p', 'enter-mode passthrough')
config.bind('<Ctrl+f>', 'hint links tab-bg')
config.bind('<Ctrl+h>', 'home')
config.bind('<Ctrl+j>', 'fake-key <Down>')
config.bind('<Ctrl+k>', 'fake-key <Up>')
config.bind('<Ctrl+m>', 'enter-mode insert ;; insert-text viktor.nagy1995@gmail.com')
config.bind('<Ctrl+n>', 'fake-key <Down>')
config.bind('<Ctrl+p>', 'fake-key <Up>')
config.bind('<Ctrl+r>', 'hint all delete')
config.bind('<Ctrl+s>', 'config-source')
config.bind('<Ctrl+v>', 'enter-mode insert')
config.bind('<Ctrl+z>', 'tab-next')
config.bind('<Tab>', 'nop')
config.bind('E', 'edit-url -t')
config.bind('J', 'tab-prev')
config.bind('K', 'tab-next')
config.bind('M', 'spawn --userscript myscript')
config.bind('X', 'undo')
config.bind('b', 'hint links userscript open_download')
config.bind('cc', 'hint links yank')
config.bind('d', 'scroll-page 0 0.5')
config.bind('e', 'edit-url')
config.bind('gF', 'open https://www.facebook.com/messages/')
config.bind('gH', 'history')
config.bind('gM', 'open https://www.gmail.com')
config.bind('gO', 'open https://yts.ag/')
config.bind('gS', 'open https://www.youtube.com/user/EpicSkillshot/videos')
config.bind('gT', 'open https://www.twitch.tv/directory/game/League%20of%20Legends')
config.bind('gY', 'open https://www.youtube.com')
config.bind('gd', 'tab-give')
config.bind('gf', 'open -t https://www.facebook.com/messages/')
config.bind('gh', 'history -t')
config.bind('gm', 'open -t https://www.gmail.com')
config.bind('gn', 'enter-mode insert ;; jseval -q document.getElementsByClassName("_1mf _1mj")[0].click()')
config.bind('go', 'open -t https://yts.ag/')
config.bind('gp', 'tab-pin')
config.bind('gs', 'jseval -q document.getElementsByClassName("rc")[0].firstChild.firstChild.click()')
config.bind('gt', 'open -t https://www.twitch.tv/directory/game/League%20of%20Legends')
config.bind('gv', 'jseval -q $("paper-tab[tabindex=\'-1\']").click()')
config.bind('gy', 'open -t https://www.youtube.com')
config.bind('j', 'scroll-page 0 0.1')
config.bind('k', 'scroll-page 0 -0.1')
# config.bind('m', 'hint links userscript myscript')
config.bind('m', 'hint links spawn mpv {hint-url}')
config.bind('tT', 'hint links spawn twitch -qt {hint-url}')
config.bind('tt', 'spawn twitch -qt {url}')
config.bind('u', 'scroll-page 0 -0.5')
config.bind('ws', 'view-source')
config.bind('x', 'tab-close')
config.bind('yt', 'tab-clone')
config.bind('z', 'tab-close -p')

# Bindings for command mode
config.bind('<Ctrl+j>', 'completion-item-focus next', mode='command')
config.bind('<Ctrl+k>', 'completion-item-focus prev', mode='command')
config.bind('<Ctrl+n>', 'completion-item-focus next', mode='command')
config.bind('<Ctrl+p>', 'completion-item-focus prev', mode='command')

# Bindings for insert mode
config.bind('<Ctrl+j>', 'fake-key <Down>', mode='insert')
config.bind('<Ctrl+k>', 'fake-key <Up>', mode='insert')
config.bind('<Ctrl+m>', 'insert-text viktor.nagy1995@gmail.com', mode='insert')
config.bind('<Ctrl+n>', 'fake-key <Down>', mode='insert')
config.bind('<Ctrl+p>', 'fake-key <Up>', mode='insert')
config.bind('<Escape>', 'mode-leave ;; jseval -q document.activeElement.blur();window.focus();', mode='insert')

# Bindings for passthrough mode
config.bind(';p', 'mode-leave', mode='passthrough')
