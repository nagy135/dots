---
name: audio-notify
description: Send spoken summary or progress notifications to Viktor's paired Android phone through the private nixpi audio notification server. Use when he requests audio or spoken notifications, and on every subsequent turn until he asks to stop.
---

# Audio Notify

## Persistent notification preference

As soon as the user asks for audio or spoken notifications, enable **audio notifications for every run and every turn from that point onward in the conversation**, including the turn that enables them. The request establishes an ongoing preference, not a one-time notification. Continue without requiring the user to repeat the request, until they say "stop notifying" or otherwise clearly ask to stop audio notifications. Carry this preference into continuation or compaction summaries so it survives context changes. This skill handles audio notifications independently and does not enable or invoke any other notification channel. A request to edit or discuss notification skills alone does not enable notifications.

## Notification modes

Honor the user's requested mode and keep it active across turns until they change it or stop notifications. If they request notifications without specifying a mode, default to **summary**. Preserve both the active audio preference and its mode in continuation or compaction summaries.

- **Summary notifications:** Send only one audio notification at the end of the turn, explaining what was done and the outcome. Do not send intermediate progress notifications.
- **Progress notifications:** Send an audio notification whenever there is a self-contained progress update worth communicating: a completed step, a meaningful finding, a blocker, or a transition to the next stage. Mirror each such commentary update in a short spoken notification at that point, for example, "I finished implementation; now I'm running tests." Do not wait until the end of the turn to report these updates. Notify based on meaningful progress, not automatically after every tool call. Also send one completion summary at the end of the turn.

In either mode, explain the changes made and the outcome in the final response. If no changes were made, summarize the result or blocker. Wait for that turn's work and any running commands to finish before sending the completion summary; progress notifications may describe work still underway. Report delivery failures accurately.

## Written copy in chat

Every time you send an audio notification, include the **exact same message text in the user-visible chat** so the user can read it if they did not hear it. Include progress notification text in the corresponding commentary update, and completion summary text in the final response. Tool output alone does not count as the chat copy. You may add detail around the message, but do not replace it with a paraphrase. If the text already appears verbatim in that chat update, do not duplicate it. Keep the written message even if notification delivery fails, and report the delivery result separately.

## Audio delivery

The notification will be spoken aloud on every paired phone unless a device is selected. Prefer one or two short sentences; omit credentials and unnecessarily sensitive content.

The server is `https://nixpi.tail6650cb.ts.net:8444` (Tailscale required). The phone must be paired, listening, and reachable. Agent credentials live in `~/.config/audio-notifications/client.json` on the Mac and nixpi; never print them or embed them in source/APKs.

Use the bundled helper (Python 3, standard library only):

```sh
python3 scripts/notify.py send 'The build is finished and the tests passed.' --wait 30
python3 scripts/notify.py devices
python3 scripts/notify.py status MESSAGE_ID
```

Resolve `scripts/notify.py` relative to this skill folder. `send` accepts `--device DEVICE_ID`, `--ttl 300`, and `--key UNIQUE_REQUEST_ID`. It generates an idempotency key if omitted and prints it before sending. Reuse that key and the same payload after an uncertain timeout; do not blindly send a new request that might speak twice. Keys/receipts are retained seven days after message expiry.

`202` means queued, not spoken. Report spoken only when the delivery status is `spoken`; `failed`, `expired`, and a still-queued message are distinct results. A spoken receipt means Android's TTS engine finished, not proof that the person heard it. The helper exits 0 only for successful API operations (or, with `--wait`, when every recipient reports spoken); it exits 2 if delivery failed, expired, or remains queued after the wait. An offline phone receives queued messages upon reconnection until their TTL expires (default five minutes).

REST equivalent:

- `POST /v1/messages`, `Authorization: Bearer API_TOKEN`, `Content-Type: application/json`, `Idempotency-Key: unique-key`.
- JSON: `{"text":"Your message","ttlSeconds":300}`; optional `deviceId` targets one paired device.
- `GET /v1/messages/:id` returns per-device receipts.
- `GET /v1/devices` lists paired devices and connection state.

For pairing, run `python3 scripts/notify.py pair-code`. It creates a one-use code valid seven days; give that code to the user to enter on the app's single screen. Pairing a replacement installation creates a new device; remove obsolete devices only when requested with authenticated `DELETE /v1/devices/:id`.
