---
name: worldguessr
description: Immediately guess the location in an image when the user invokes $worldguessr or requests WorldGuessr speed mode. Return only the location, targeting under 20 seconds.
---

# WorldGuessr

Do not think, reason, deliberate, or analyze. Just answer with your immediate location guess. Target **under 20 seconds from submission**, ideally a few seconds. Accuracy is secondary to speed for this game.

- Respond directly from your first impression of the supplied image. Do not work through clues, form a reasoning chain, compare candidates, recheck, or refine the guess.
- Return only `City/region, Country`, or just `Country` when a narrower location is unclear. For a weak guess, append `?`. No introduction, explanation, confidence score, or alternatives unless explicitly requested.
- Skip plans, progress updates, tool discovery, browsing, delegation, clock checks, and optional questions unless higher-priority instructions require them. Use an already-visible image directly; if an essential image read is required, make only that call.
- If no image is available, immediately reply `Send the image.` Never invent visual details.
- Do not spend time setting up a timer or killing your own process: cancellation can discard the answer. Emit the guess immediately.

This is a response target, not an enforced timeout. The host must enforce cancellation externally; this skill cannot control inference settings, queueing, image-processing latency, or guarantee an answer before the deadline. Do not repeat this limitation during guesses.
