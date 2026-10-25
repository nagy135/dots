---
name: progress-notifier
description: Show and update floating progress cards in the local Progress Notifier macOS app. Agents may use it proactively without being asked; progress reporting is required when the user invokes progress-notifier or asks for progress notifications. Accepts a task name, percentage, ETA, and optional description, T3 project name and icon; flashes on updates and completes with sound.
---

# Progress Notifier

Without an explicit request, you may use this skill at your discretion when progress cards would help the user follow the work. When the user explicitly invokes this skill or asks for progress notifications, you must report progress for the requested work: send an initial update, updates at meaningful milestones while working, and a completion or dismissal when finished. Do not treat an explicit invocation as optional or replace the cards with chat-only updates. App availability is handled as described below.

Use the bundled `scripts/progress-notify` client on the Mac (requires Python 3). It sends updates only when Progress Notifier is already running. If the app is stopped or unavailable, the client silently succeeds without sending anything. Do not launch, build, install, retry, or ask the user to start the app as part of reporting progress. The user chooses when to open `/Applications/Progress Notifier.app`.

## One run, one task group

Create **one task/card for the agent's run** and use its **exact same `name` on every
update**, from the first update through completion. That name is the grouping key:
all descriptions and recorded percentages are stored under that one task. The project
label is display metadata; it does not group different task names into one ledger.

Choose a stable task title describing the whole job, unique among concurrent agents.
Do not rename it to the current phase, create a new task for each milestone, or put
changing milestone text in the name. Keep `--project` and its icon consistent. Put
what just happened in **`--description` on every agent progress update**, including
the initial update and completion. Revise the percentage and seconds remaining as
work advances. Missing descriptions are supported for legacy clients, but agents
following this skill should always provide one.

```sh
~/.agents/skills/progress-notifier/scripts/progress-notify 'Build release' 0 180 \
  --project 'progress-notifier' --description 'Preparing the release build'
~/.agents/skills/progress-notifier/scripts/progress-notify 'Build release' 45 90 \
  --project 'progress-notifier' --description 'Compiled the app; running tests'
~/.agents/skills/progress-notifier/scripts/progress-notify 'Build release' 100 0 \
  --project 'progress-notifier' --description 'Tests passed and the release is ready'
```

These commands update **one card**, producing one newest-first ledger with three
saved description/percentage entries. `name` stays `Build release`; only description,
progress, and ETA change. Parallel runs use different stable names so their ledgers
do not overwrite each other. Percentages may be fractional. ETA is **seconds remaining
at this update**, not a timestamp or total duration. The app counts it down but never
fabricates progress or completes a task when the ETA expires.

When running in a T3 thread, use the thread's actual project name and icon. Discover the current project ID with `t3_thread_list`, then read it with `t3_project_read`. Pass its `title` as `--project` and its non-null `projectIcon` object as JSON with `--project-icon`; do not invent an emoji. When `projectIcon` is null, omit the flag: the app generates T3's default project monogram and color. Outside T3, use the known project name and omit the icon unless supplied. Keep the task title concise; the project appears in its own heading above it. Names must still be unique across concurrent tasks.

```sh
~/.agents/skills/progress-notifier/scripts/progress-notify 'Build release' 20 120 --project 'progress-notifier' --description 'Prepared build inputs'
~/.agents/skills/progress-notifier/scripts/progress-notify 'Check Nix config' 40 60 --project 'nix-darwin' \
  --project-icon '{"kind":"lucide","name":"snowflake","color":"blue"}' \
  --description 'Checked the host configuration'
```

The API fields are `project` and `projectIcon`. T3 icon shapes are `{"kind":"emoji","emoji":"🎹"}`, `{"kind":"lucide","name":"snowflake","color":"blue"}`, and `{"kind":"monogram","text":"PN","color":"violet"}`. Omitted metadata is preserved on later updates, including completion. Send `--project ''` to clear both fields. Old clients and saved items remain supported. Every update flashes its card, even if only the ETA changes; compact bars flash individually. Reduce Motion disables scaling.

Send a short `--description` at meaningful milestones to say what just happened:

```sh
~/.agents/skills/progress-notifier/scripts/progress-notify 'Build release' 45 90 \
  --project 'progress-notifier' --description 'Compiled the app; running tests'
```

The API accepts optional plain text descriptions (up to 2,000 characters; newlines and tabs allowed); agents must include one as described above.
Each is saved with that request's percentage and server timestamp. Consecutive identical
description/percentage pairs are deduplicated. Omitted or blank descriptions preserve
existing notes and add no entry; progress and ETA still update. The card shows the latest
note and the number of earlier descriptions (excluding the current note). The arrow/count is hidden when there are no earlier descriptions or when the ledger is unfolded. Up/Down or K/J selects a task (Down/J next, Up/K previous).
D unfolds the timestamp ledger for the focused task only, newest first, with a recorded
percentage and bar for each note. When details are open, moving selection switches the
ledger to that task and folds the others. A mint outline marks the selection. Navigation
keeps it visible; background updates do not change which task is selected. The latest 200 notes per task persist
through relaunch and H recall. `GET /items` returns `description`, `updateCount`, and
`updates` (id, description, progress, recordedAt). The API `updateCount` includes the current note; the on-card arrow excludes it. Do not treat the notes as separate tasks.

Report meaningful milestones while the requested work runs. Use honest estimates; revise them as new information arrives. Send `100 0` only when the work actually succeeds. This plays the macOS Glass sound, flashes and enlarges the card, and keeps it visible as completed history until the user clears it with C or dismisses it. Do not automatically dismiss successful results. The active API entry retires after the brief feedback phase, so the same name can be used for a new run while its completed record remains visible. C hides completed records without deleting history; H can recall them. Like other recalled history, completed records are hidden on app relaunch. On failure or cancellation, dismiss the card and explain the outcome in chat; do not signal success.

```sh
~/.agents/skills/progress-notifier/scripts/progress-notify --list
~/.agents/skills/progress-notifier/scripts/progress-notify --dismiss 'Project · Build release'
~/.agents/skills/progress-notifier/scripts/progress-notify --health
```

Dismissing an active item with its X or `--dismiss` hides that name for the rest of its run: further updates remain silent until a `100` update clears the dismissal. A new run may then reuse the name. Completion updates for unknown names are harmless no-ops. Dismissing a completed history record only hides that record; it does not suppress a new run. A name-based dismissal targets an active run when present, otherwise it hides that name’s visible completed records.

Q, ⌘W, or the window's X hides the window while the app keeps receiving updates. Updates do not reopen a hidden window. Opening the app again restores the current items. Click anywhere except an X, or press M, to toggle between the full list and a compact list with an icon and title-free bar for each item, without a header. Compact rows use the project icon, or a task-name monogram when there is no project metadata. With no items, the expanded window says “No progress”. Items and dismissals are saved across quitting/relaunching. Use the menu bar's Quit or ⌘Q to stop the app entirely; later skill calls silently skip until the user opens it again.

The API is `http://127.0.0.1:8766`, local to the Mac running the app. For direct clients:

```sh
curl --fail --silent --show-error http://127.0.0.1:8766/items \
  -H 'Content-Type: application/json' \
  -d '{"name":"Project · Build release","progress":30,"etaSeconds":120,"description":"Compiled the app; running tests"}'
```

`GET /items` lists tracked items (including while the window is hidden); `DELETE /items?name=URL_ENCODED_NAME` dismisses one. No authentication is needed for local processes. Requests from web page origins are rejected. Do not expose or proxy this API to the network as part of sending progress. A stopped or unavailable app needs no chat warning; continue the user's work. For explicit diagnostics only, `--health --require-running` returns an error when unavailable.
