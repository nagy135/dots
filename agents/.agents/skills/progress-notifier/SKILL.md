---
name: progress-notifier
description: Show and update floating progress cards in the local Progress Notifier macOS app when the user asks for progress notifications or invokes progress-notifier. Accepts an item name, percentage, and estimated seconds remaining; completes with a visual pulse and sound.
---

# Progress Notifier

Use the bundled `scripts/progress-notify` client on the Mac (requires Python 3). It sends updates only when Progress Notifier is already running. If the app is stopped or unavailable, the client silently succeeds without sending anything. Do not launch, build, install, retry, or ask the user to start the app as part of reporting progress. The user chooses when to open `/Applications/Progress Notifier.app`.

```sh
~/.agents/skills/progress-notifier/scripts/progress-notify 'Project · Build release' 0 180
~/.agents/skills/progress-notifier/scripts/progress-notify 'Project · Build release' 45 90
~/.agents/skills/progress-notifier/scripts/progress-notify 'Project · Build release' 100 0
```

Keep the exact same name across updates. Choose a short descriptive name unique to the task so concurrent agents do not overwrite each other. Percentages may be fractional. The third argument is **seconds remaining at the time of this update**, not a Unix timestamp or the original total duration. The app counts the ETA down but never fabricates progress or completes an item when its timer expires.

Report meaningful milestones while the requested work runs. Use honest estimates; revise them as new information arrives. Send `100 0` only when the work actually succeeds. This plays the macOS Glass sound, flashes and enlarges the card, then removes it after 1.25 seconds. On failure or cancellation, dismiss the card and explain the outcome in chat; do not signal success.

```sh
~/.agents/skills/progress-notifier/scripts/progress-notify --list
~/.agents/skills/progress-notifier/scripts/progress-notify --dismiss 'Project · Build release'
~/.agents/skills/progress-notifier/scripts/progress-notify --health
```

An item's X or `--dismiss` hides that name for the rest of its run: further updates remain silent until a `100` update clears the dismissal. A new run may then reuse the name. Completion updates for unknown names are harmless no-ops.

Q, ⌘W, or the window's X hides the window while the app keeps receiving updates. Updates do not reopen a hidden window. Opening the app again restores the current items. Click anywhere except an X, or press M, to toggle between the full list and a tiny task counter. With no items, the expanded window says “No progress”. Items and dismissals are saved across quitting/relaunching. Use the menu bar's Quit or ⌘Q to stop the app entirely; later skill calls silently skip until the user opens it again.

The API is `http://127.0.0.1:8766`, local to the Mac running the app. For direct clients:

```sh
curl --fail --silent --show-error http://127.0.0.1:8766/items \
  -H 'Content-Type: application/json' \
  -d '{"name":"Project · Build release","progress":30,"etaSeconds":120}'
```

`GET /items` lists tracked items (including while the window is hidden); `DELETE /items?name=URL_ENCODED_NAME` dismisses one. No authentication is needed for local processes. Requests from web page origins are rejected. Do not expose or proxy this API to the network as part of sending progress. A stopped or unavailable app needs no chat warning; continue the user's work. For explicit diagnostics only, `--health --require-running` returns an error when unavailable.
