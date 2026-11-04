---
name: store-idea
description: Save a discussed idea, recommendation, plan, or existing summary and its relevant artifacts into ~/Documents/Ideas. Use when the user says "store idea", "save this idea", or asks to keep the current discussion there for later.
---

# Store idea

Save enough context for Viktor to understand and resume the idea later without reopening the conversation. Invoking this skill authorizes saving locally into `~/Documents/Ideas`; carry out the save rather than returning a draft or asking whether to save it.

## Choose what to keep

- Follow a named topic, summary, or artifact when the user specifies one. Otherwise save the substantive idea most recently discussed, using the conversation for context. Do not mistake the instruction to save for the idea itself.
- Reuse the latest useful summary when it already captures the idea. Otherwise write a concise summary from the discussion. Incorporate later corrections and preferences; leave out superseded recommendations unless they explain a relevant tradeoff.
- Preserve an existing useful artifact, such as an HTML comparison, diagram, PDF, or spreadsheet, in its original format alongside the summary. A visual result should not be reduced to prose alone. If it exists only in tool output, recover its content when available; if recovery is impossible, save an accurate summary and say the original artifact could not be included.
- Ask a short clarification only if several unrelated topics are equally plausible and the conversation does not identify which one to save.

## Save the idea

Create `~/Documents/Ideas` if needed. By default use a folder named `YYYY-MM-DD-short-topic` containing `summary.md` and any relevant artifacts. Use the local save date and a descriptive, filesystem-safe topic. Honor a more specific destination or format requested by the user.

The summary should stand on its own. Include the title and save date, what the idea is and why it matters, important user constraints, the current recommendation or decision with its tradeoffs, and useful next steps or open questions. Include only the parts that apply; do not force an empty template. Preserve source links and, if already known, the conversation link.

Keep concrete facts, units, amounts, and uncertainty intact. Date volatile information such as prices and availability using its original check date; saving is not a request to refresh the research or turn tentative advice into a decision.

Copy artifacts rather than moving their originals. Use relative links from `summary.md`. Make saved HTML portable: preserve embedded images, or copy required local assets into the idea folder and adjust references. Do not leave it dependent on a temporary workspace path. Keep external source links as links. Copy only files relevant to the idea, not an entire workspace or unrelated private data.

Inspect an existing matching idea before writing. Update it when the user explicitly asks to update that idea; otherwise choose a non-conflicting name (for example, append `-2`) so a new save cannot overwrite earlier work. Do not publish, sync, or act on the saved idea unless separately asked.

## Verify and report

Check that the saved summary and artifacts exist and are readable, and that local links and required asset paths resolve. For an unchanged copied artifact, compare it with the original. Review any regenerated artifact in the appropriate renderer.

Reply briefly with a clickable absolute link to the saved summary or main artifact and mention any material omission. Do not repeat the whole summary in chat.
