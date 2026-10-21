---
name: terminal-notifier
description: Send macOS summary or progress notifications with terminal-notifier. Use when the user requests terminal or macOS desktop notifications, for the current turn with `once` or `one time`, otherwise on every subsequent turn until they ask to stop.
---

# Terminal Notifier

## Notification preference and duration

As soon as the user asks for terminal or macOS desktop notifications, enable them for the current turn. By default, this also enables **terminal notifications for every subsequent run and turn in the conversation** until they say "stop notifying" or otherwise clearly ask to stop terminal notifications.

Accept the mode and duration as words after the skill mention (including a Markdown skill link) or in the notification request. Interpret `summary` and `progress` as modes, and `once` and `one time` as equivalent duration modifiers. The words can be supplied together or separately, with or without quotes; `one time` is one modifier even though it contains two words. Accept the duration before or after the mode.

- `summary`: one completion notification at the end of every turn until stopped.
- `progress`: meaningful progress notifications plus a completion summary on every turn until stopped.
- `summary once` or `summary one time`: one completion notification at the end of this turn only.
- `progress once` or `progress one time`: meaningful progress notifications plus a completion summary during this turn only.
- `once` or `one time` without a mode: use summary mode for this turn only.

A one-time request applies to the **whole current turn**, not just the next individual notification. After that turn's completion summary is attempted, disable terminal notifications for future turns unless the user requests them again. This also ends any previously persistent terminal preference; do not silently resume it. A delivery failure does not extend the one-time request to another turn.

Carry the channel, mode, and duration into continuation or compaction summaries. Preserve a pending one-time request if the current turn is still underway, but do not carry an expired request forward as enabled. This skill handles terminal notifications independently and does not enable or invoke any other notification channel. A request to edit or discuss notification skills alone does not enable notifications.

## Notification modes

Honor the user's requested mode for the requested duration. If they request notifications without specifying a mode, default to **summary**. Keep the mode active across turns only for a persistent request.

- **Summary notifications:** Send only one terminal notification at the end of the turn, explaining what was done and the outcome. Do not send intermediate progress notifications.
- **Progress notifications:** Send a terminal notification whenever there is a self-contained progress update worth communicating: a completed step, a meaningful finding, a blocker, or a transition to the next stage. Mirror each such commentary update in a short notification at that point, for example, "I finished implementation; now I'm running tests." Do not wait until the end of the turn to report these updates. Notify based on meaningful progress, not automatically after every tool call. Also send one completion summary at the end of the turn.

In either mode, explain the changes made and the outcome in the final response. If no changes were made, summarize the result or blocker. Wait for that turn's work and any running commands to finish before sending the completion summary; progress notifications may describe work still underway. Report delivery failures accurately.

## Written copy in chat

Every time you send a terminal notification, include the **exact same message text in the user-visible chat** so the user can read it if they missed the notification. Include progress notification text in the corresponding commentary update, and completion summary text in the final response. Tool output alone does not count as the chat copy. You may add detail around the message, but do not replace it with a paraphrase. If the text already appears verbatim in that chat update, do not duplicate it. Keep the written message even if notification delivery fails, and report the delivery result separately.

## Terminal delivery

For a turn that runs a command, send the completion notification **after it exits**, including whether it succeeded or failed. A command that fails still counts as finished; do not use `&&` to gate the notification. If a command tool returns a live session, wait for its final exit before reporting completion. In progress mode, intermediate updates may be sent while the command runs, without claiming it has finished. Turns without commands still require the completion notification.

Use the installed `terminal-notifier` on the user's Mac:

```sh
terminal-notifier -title 'Command finished' -message 'The requested command succeeded'
```

Adapt the title and message to the progress update or completion summary. When reporting a command's completion, identify the command and its result, and keep command output and exit status visible in the normal response. If the command runs on another machine, send notifications from this Mac and wait for the remote command to return before reporting completion.

Check that `terminal-notifier` exits successfully before saying a notification was sent. If it reports that notifications are not allowed, tell the user to enable **terminal-notifier** in **System Settings → Notifications**, and report that delivery failed. Do not repeatedly retry a permission failure.

If the user asks only for a shell snippet to run themselves, give a snippet that notifies on both success and failure, for example:

```sh
long_running_command; result=$?; terminal-notifier -title 'Command finished' -message "Exit status: $result"; (exit "$result")
```
