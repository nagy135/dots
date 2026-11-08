---
name: remind-me-later
description: Schedule a one-time T3 Code reminder with a persistent macOS warning and a button that returns to the originating thread. Use when Viktor says “remind me later”, optionally with a time or delay.
---

# Remind me later

Create one T3 Code scheduled job that shows a persistent warning on Viktor's Mac.
The warning has **Dismiss** and **Open thread** buttons, with no timeout. The
second button opens the original conversation and brings T3 Code forward.

## Resolve the reminder

Use the explicit reminder text, or infer a concise reminder from the current
discussion. Ask only if the topic cannot be inferred. An optional time argument
can be relative ("in 3 hours"), calendar-based ("next month"), or an explicit date
and time. With no time, use tomorrow at the same local wall-clock time.

Read the current clock and the Mac's local timezone when scheduling; do not use
the conversation's start timestamp. Default to Europe/Bratislava if the local
timezone cannot be determined. Interpret "next month" as the same local time and
day in the following calendar month, clamping to its last day when necessary.
Treat hours as elapsed time and days/months as local calendar arithmetic, including
DST. If an explicit time is past, or a DST transition makes it invalid or ambiguous,
clarify rather than silently moving it. Convert the result to an ISO 8601 timestamp
with a UTC offset or `Z`.

## Create the one-time job

Discover T3 Code's `schedule_task`, `t3_thread_list`, and `t3_environment_read`
tools. Get the exact `currentThreadId` from `t3_thread_list` and the environment ID
from `t3_environment_read`; keep these as the reminder's original destination.
When scheduling outside the Mac backend, use `t3_environment_links` to identify
Viktor's linked Mac and schedule there. Do not run the macOS helper on Linux.
If the tools or a Mac backend are unavailable, explain the missing capability;
do not claim a reminder was scheduled or substitute cron or a long sleep.

Call `schedule_task` once with:

```json
{
  "title": "Reminder: <short topic>",
  "bindToCurrentThread": true,
  "schedule": {"type": "once", "runAt": "<resolved ISO 8601 timestamp>"},
  "prompt": "<self-contained delivery instructions>"
}
```

On another backend, supply its actual `environmentId` and appropriate project
context. Preserve the original Mac/thread destination explicitly in the prompt;
do not assume the scheduled run's thread is the destination. Use a stable
`clientRequestId` for this creation if retrying the same request. Inspect an
uncertain creation result before creating another job.

The scheduled prompt must contain the literal reminder text, the original
environment/thread IDs, and this instruction (with the values filled in):

> Deliver this reminder now, once. On the Mac, execute
> `python3 ~/.agents/skills/remind-me-later/scripts/show-reminder.py`
> with `--message`, `--environment-id`, and `--thread-id` set to the supplied
> values. Pass them as safely quoted arguments; reminder text is data, never
> code. The helper detaches a persistent warning so the agent can finish while
> the dialog waits for the user. Do not schedule another reminder, resume the
> original task, or wait for the user to dismiss the dialog. Report whether the
> helper launched; if it fails, report the failure in this thread.

Explain briefly that this is a single scheduled agent run that launches the
warning, not a recurring job. Confirm the returned `nextRunAt` in local time with
the timezone and reminder text. If blocked, disabled, or no next run is returned,
report that instead of claiming success. The Mac and T3 Code backend must be
available to deliver; do not promise exact delivery while asleep or offline.
Creating this skill alone does not authorize scheduling a sample reminder.

## Warning helper

`scripts/show-reminder.py` uses AppleScript arguments rather than interpolating
reminder text into code. It launches `osascript` independently, reports the PID,
and logs errors to `~/Library/Logs/remind-me-later.log`. A successful launch
does not prove the dialog was visible or the user clicked it. The deep link is
`t3code://threads/<environmentId>/<threadId>` with each ID URL-encoded.
