---
name: progress-notifier
description: Show and update floating progress cards in the local Progress Notifier macOS app when the user asks for progress notifications or invokes progress-notifier. Accepts an item name, percentage, and estimated seconds remaining; completes with a visual pulse and sound.
---

# Progress Notifier

Use the bundled `scripts/progress-notify` client on the Mac. It starts the built app if needed; the checkout is `~/Code/progress-notifier`. If no app bundle exists, build it with `./scripts/build.sh` from that checkout. Python 3 and Apple Command Line Tools are required for the client and build respectively.

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

Clicking X or dismissing hides that name for the rest of its run: further updates remain silent until a `100` update clears the dismissal. A new run may then reuse the name. Completion updates for unknown names are harmless no-ops. App restart clears all in-memory items and dismissals. Closing the last card leaves the app listening; quit it from its menu bar icon.

The API is `http://127.0.0.1:8766`, local to the Mac running the app. For direct clients:

```sh
curl --fail --silent --show-error http://127.0.0.1:8766/items \
  -H 'Content-Type: application/json' \
  -d '{"name":"Project · Build release","progress":30,"etaSeconds":120}'
```

`GET /items` lists visible items; `DELETE /items?name=URL_ENCODED_NAME` dismisses one. No authentication is needed for local processes. Requests from web page origins are rejected. Do not expose or proxy this API to the network as part of sending progress. A client error should not block the main task; report unavailable notifications briefly and continue the user's work.
