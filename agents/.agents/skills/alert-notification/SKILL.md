---
name: alert-notification
description: Request Viktor's attention once with a centered, error-styled Hammerspoon alert on his Mac. Use only when he directly asks for an alert notification or invokes $alert-notification.
disable-model-invocation: true
---

# Alert notification

A direct request authorizes **one attention alert for the current task**, at the
moment specified by the user. If no moment is specified, use it when the task
needs Viktor's attention (a question, blocker, or completed result). A request to
create, edit, or discuss this skill does not authorize an alert.

Keep the authorization pending while working, including across continuation or
compaction, until that moment arrives. Send once, then consume it; do not enable
recurring progress or completion notifications on later turns. A failed attempt
also consumes it: report the failure in chat without retrying. Honor cancellation.
If the task ends without the requested trigger occurring, let the request expire.

Use Hammerspoon's `hs.alert.show` API through its `hs` CLI. This is the usual
central on-screen overlay, with a dark red background, red border, and white
text. Keep the message to one or two short lines explaining what needs attention.
Use “Attention needed” rather than claiming an error when nothing failed.

Run the bundled helper on Viktor's **Mac**, using the actual installed skill path:

```sh
python3 ~/.agents/skills/alert-notification/scripts/alert.py 'Attention needed: please review the result.'
```

The alert uses the screen with the focused window and disappears after 10 seconds.
The helper requires running Hammerspoon with `require("hs.ipc")` enabled (already
configured on Viktor's Mac). It neither launches nor reloads Hammerspoon, changes
global styles, nor closes other alerts. From a remote host, use an available Mac
execution connection; if none exists, report that delivery is unavailable.

Include the alert's message in chat so it remains readable after dismissal.
Only claim delivery after the helper succeeds. Displaying or dismissing an alert
is not a user answer or approval; continue independent work and wait only where
the task actually depends on Viktor's response.

API reference: [hs.alert.show](https://www.hammerspoon.org/docs/hs.alert.html#show).
