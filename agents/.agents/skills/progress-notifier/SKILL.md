---
name: progress-notifier
description: Show and update floating progress cards in the local Progress Notifier macOS app. Agents may use it proactively without being asked; progress reporting is required when the user invokes progress-notifier or asks for progress notifications. Accepts a task name, percentage, ETA, and optional T3 project name and icon; flashes on updates and completes with sound.
---

# Progress Notifier

Without an explicit request, you may use this skill at your discretion when progress cards would help the user follow the work. When the user explicitly invokes this skill or asks for progress notifications, you must report progress for the requested work: send an initial update, updates at meaningful milestones while working, and a completion or dismissal when finished. Do not treat an explicit invocation as optional or replace the cards with chat-only updates. App availability is handled as described below.

Use the bundled `scripts/progress-notify` client on the Mac (requires Python 3). It sends updates only when Progress Notifier is already running. If the app is stopped or unavailable, the client silently succeeds without sending anything. Do not launch, build, install, retry, or ask the user to start the app as part of reporting progress. The user chooses when to open `/Applications/Progress Notifier.app`.

```sh
~/.agents/skills/progress-notifier/scripts/progress-notify 'Project · Build release' 0 180
~/.agents/skills/progress-notifier/scripts/progress-notify 'Project · Build release' 45 90
~/.agents/skills/progress-notifier/scripts/progress-notify 'Project · Build release' 100 0
```

Keep the exact same name across updates. Choose a short descriptive name unique to the task so concurrent agents do not overwrite each other. Percentages may be fractional. The third argument is **seconds remaining at the time of this update**, not a Unix timestamp or the original total duration. The app counts the ETA down but never fabricates progress or completes an item when its timer expires.

When running in a T3 thread, use the thread's actual project name and icon. Discover the current project ID with `t3_thread_list`, then read it with `t3_project_read`. Pass its `title` as `--project` and its non-null `projectIcon` object as JSON with `--project-icon`; do not invent an emoji. When `projectIcon` is null, omit the flag: the app generates T3's default project monogram and color. Outside T3, use the known project name and omit the icon unless supplied. Keep the task title concise; the project appears in its own heading above it. Names must still be unique across concurrent tasks.

```sh
~/.agents/skills/progress-notifier/scripts/progress-notify 'Build release' 20 120 --project 'progress-notifier'
~/.agents/skills/progress-notifier/scripts/progress-notify 'Check Nix config' 40 60 --project 'nix-darwin' \
  --project-icon '{"kind":"lucide","name":"snowflake","color":"blue"}'
```

The API fields are `project` and `projectIcon`. T3 icon shapes are `{"kind":"emoji","emoji":"🎹"}`, `{"kind":"lucide","name":"snowflake","color":"blue"}`, and `{"kind":"monogram","text":"PN","color":"violet"}`. Omitted metadata is preserved on later updates, including completion. Send `--project ''` to clear both fields. Old clients and saved items remain supported. Every update flashes its card, even if only the ETA changes; compact bars flash individually. Reduce Motion disables scaling.

Report meaningful milestones while the requested work runs. Use honest estimates; revise them as new information arrives. Send `100 0` only when the work actually succeeds. This plays the macOS Glass sound, flashes and enlarges the card, then removes it after 1.25 seconds. On failure or cancellation, dismiss the card and explain the outcome in chat; do not signal success.

```sh
~/.agents/skills/progress-notifier/scripts/progress-notify --list
~/.agents/skills/progress-notifier/scripts/progress-notify --dismiss 'Project · Build release'
~/.agents/skills/progress-notifier/scripts/progress-notify --health
```

An item's X or `--dismiss` hides that name for the rest of its run: further updates remain silent until a `100` update clears the dismissal. A new run may then reuse the name. Completion updates for unknown names are harmless no-ops.

Q, ⌘W, or the window's X hides the window while the app keeps receiving updates. Updates do not reopen a hidden window. Opening the app again restores the current items. Click anywhere except an X, or press M, to toggle between the full list and a compact list with an icon and title-free bar for each item, without a header. Compact rows use the project icon, or a task-name monogram when there is no project metadata; hover to see the task name. With no items, the expanded window says “No progress”. Items and dismissals are saved across quitting/relaunching. Use the menu bar's Quit or ⌘Q to stop the app entirely; later skill calls silently skip until the user opens it again.

The API is `http://127.0.0.1:8766`, local to the Mac running the app. For direct clients:

```sh
curl --fail --silent --show-error http://127.0.0.1:8766/items \
  -H 'Content-Type: application/json' \
  -d '{"name":"Project · Build release","progress":30,"etaSeconds":120}'
```

`GET /items` lists tracked items (including while the window is hidden); `DELETE /items?name=URL_ENCODED_NAME` dismisses one. No authentication is needed for local processes. Requests from web page origins are rejected. Do not expose or proxy this API to the network as part of sending progress. A stopped or unavailable app needs no chat warning; continue the user's work. For explicit diagnostics only, `--health --require-running` returns an error when unavailable.
