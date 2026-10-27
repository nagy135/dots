---
name: progress-notifier
description: Show and update floating progress cards in the local Progress Notifier macOS app. Always use this skill for agent work without requiring an explicit invocation or request. Progress reporting is best effort; continue normally if the app is stopped, unavailable, or an update fails. Accepts a task name, percentage, ETA, and optional description, T3 project name and icon; flashes on updates and completes with sound.
---

# Progress Notifier

Use this skill by default for every agent task, without waiting for the user to invoke it or ask for progress notifications. Send an initial update, updates at meaningful milestones while working, and a completion or dismissal when finished. Honor an explicit user request to skip progress notifications.

Progress reporting is best effort: if the app is stopped or unavailable, the client is missing, or an update fails, continue the user's work normally. Do not retry, troubleshoot, or warn in chat unless the user explicitly asks for diagnostics. A notification failure must never block or fail the underlying task.

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

When running in a T3 thread, use the thread's actual project name and icon. Reuse project metadata supplied by the parent when available; otherwise discover the current project ID with `t3_thread_list`, then read it with `t3_project_read`. Pass its `title` as `--project` and its non-null `projectIcon` object as JSON with `--project-icon`; do not invent an emoji. When `projectIcon` is null, omit the flag: the app generates T3's default project monogram and color. Outside T3, use the known project name and omit the icon unless supplied. Keep the task title concise; the project appears in its own heading above it. Names must still be unique across concurrent tasks.

For **every run inside T3 Code**, attach the user-facing chat to the initial card.
**Delegates link to their parent chat, not their own subagent thread.** Resolve the
destination alongside the project metadata, before the initial notification:

- Reuse an explicit progress destination supplied by the parent: its T3 environment
  ID, resolved chat thread ID, and project metadata. This also works for delegates
  without T3 tools; do not replace it with the child's current thread ID.
- Otherwise get `environmentId` from `t3_environment_read` and `currentThreadId`
  from `t3_thread_list` with `includeSubagents: true`. Find the current thread by
  exact `threadId`, paging or using `t3_thread_read` if needed; the first list entry
  is not necessarily the current thread.
- While that thread has `relationshipToParent: "subagent"`, follow its
  `parentThreadId`, reading parent metadata as needed. Use the first ancestor whose
  relationship is not `subagent` as the destination. Nested delegates therefore
  share the same chat. A `fork` is its own user-facing chat; do not follow its parent.

Pass the resolved IDs as `--t3-environment-id` and `--t3-thread-id` to
`scripts/progress-notify`. These are T3 IDs: do not use `CODEX_THREAD_ID`, provider
session IDs, project IDs, or infer a destination from task titles. If neither T3
tools nor an explicit parent destination are available, send an ordinary unlinked
notification. Omitted destinations are preserved by subsequent updates, including
completion, so the flags are needed only on the first update (or when correcting it).

When delegating work, include the resolved progress destination and project metadata
in each delegate's task brief, instructing it to use these for its initial progress
card. Pass the same destination through nested delegation. Each delegate keeps its
own unique, stable task name; sharing the destination makes Enter open the parent
chat and gives related cards the same thread-group symbol without merging progress.

```sh
~/.agents/skills/progress-notifier/scripts/progress-notify 'Build release' 0 180 \
  --project 'progress-notifier' --description 'Preparing the release build' \
  --t3-environment-id '<environmentId>' --t3-thread-id '<resolvedChatThreadId>'
```

With the panel focused, **Enter** (or keypad Enter) opens the selected task's
linked chat (the parent chat for delegates) and focuses
`/Applications/T3 Code (Beta).app`. This works in compact and expanded modes and
for recalled completed results. Unlinked cards do
nothing on Enter. The destination is stored as optional
`"t3Thread":{"environmentId":"...","threadId":"..."}` in the API and saved state;
`GET /items` returns it when present. Both IDs must contain 1–512 ASCII letters,
digits, hyphens, underscores, or colons. Existing cards remain unlinked until an update
supplies the IDs; a new run never inherits a previous run's destination.

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
percentage and bar for each note. Shift+D opens all tasks with earlier descriptions;
if all are already open, it folds them all. In that mode, D toggles only the selected
task and moving selection preserves the other ledgers. With a single ledger opened
using D, moving selection switches the ledger to that task and folds the others.
Both D and Shift+D expand compact mode. A mint outline marks the selection. Navigation
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
