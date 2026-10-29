---
name: leaving-pr-comments
description: Format authorized GitHub PR and GitLab MR comments, review replies, and discussion-resolution explanations on the user’s behalf. Does not itself authorize posting.
---

# Leaving PR Comments

Use only when posting is authorized by the user or an invoked workflow.
Never post to YouTrack. Prefix GitHub comments with this note callout:

```md
> [!NOTE]
> 🤖 **<model> responding on behalf of <user>**

Actual comment starts here.
```

For GitLab, use a plain blockquote for portable rendering:

```md
> 🤖 **<model> responding on behalf of <user>**

Actual comment starts here.
```

Use the verified public name of the model that wrote the comment, and the
user's name or verified host login.

If the harness does not expose a model name, use the harness name. Do not guess.

Before posting, check the entire comment, including quoted text and
attachments, for secrets and private details.

Keep the attribution inside the note and the actual reply outside it. The
context line must start with the robot emoji. Do not add a horizontal rule,
Setext underline, heading, signature footer, or a second attribution.

Apply this format to top-level PR comments, inline review comments, replies to
bots or reviewers, and written explanations used before resolving or
dismissing feedback. Do not add it to PR descriptions, commit messages, or text
the user explicitly asked to post verbatim without attribution.

Write the comment itself in a direct style:

- Lead with the conclusion.
- Cite the relevant code, behavior, check, or reproduction.
- Keep it concise and avoid filler, canned thanks, or status narration.
- Distinguish verified facts from judgment.

Preview the final Markdown before posting so quoting and blank lines render as
shown. After posting, verify the host returned the comment/review ID or URL, and read it back.
Use GitLab discussion replies for threaded feedback, rather than an unrelated
top-level note; resolve the discussion with the discussions API only after the
reply succeeds. Read [host operations](../full-send/references/hosts.md) for routes.
Resolve a review thread only after its response was posted successfully.

<!-- Adapted from https://github.com/t3dotgg/tstack/tree/1085050f3baed1ac724caa4a8166145fb2ac88af/skills/leaving-pr-comments (MIT). Local GitHub/GitLab support; do not overwrite blindly when updating. -->
