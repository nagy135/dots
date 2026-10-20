---
name: teach-me
description: Explain code changes with brief, numbered code samples and the reason for each change, optionally narrowed to files, patterns, or a topic. Use only when the user explicitly invokes teach-me.
disable-model-invocation: true
---

# Teach me

Run only when the user explicitly invokes this skill, such as `$teach-me` or `/teach-me`. Do not select it automatically for general requests to explain code or changes. Follow-up questions about an existing walkthrough continue that invocation.

Explain the selected changes so the user can understand and discuss individual decisions. This is an explanation task; do not edit code unless the user asks for a change.

## Select the changes

- With no argument, explain all current working tree changes: staged, unstaged, and untracked files. Inspect both diffs and new files; do not omit staged-only changes or describe overlapping diffs twice.
- An optional argument is a free-form scope, such as `src/auth.ts`, `all the css files`, or `the retry logic`. Apply it to the current changes unless the user explicitly names another comparison, commit, or range. A file argument selects its changes, not a tutorial on the whole file.
- Read enough surrounding code to explain behavior and purpose accurately. If the scope has no matching changes, say so briefly. Ask for clarification only when ambiguity would materially change the explanation.

## Explain briefly

- Use a sequential numbered list, starting at 1, with one item per logical change. Group related hunks, including across files when they implement one decision. Cover every distinct change in scope, consolidating repetitive edits instead of silently dropping them.
- Each item names the file or location, shows the smallest useful code excerpt from the actual changes in a fenced block, and gives one or two short sentences explaining what it does and why it is there. Prefer a file link with a line number when available.
- Use a `diff` excerpt when the before/after or removed code matters; otherwise show the relevant resulting code with its language tag. Preserve actual code rather than inventing a simplified replacement. For changes without readable code, briefly describe the artifact instead.
- Explain the concrete effect or problem addressed. Distinguish inferred rationale from intent established by code, tests, or conversation. Avoid generic syntax lessons, speculative benefits, and unsupported claims.
- Keep the response as brief as possible while retaining the snippet and reason. Skip introductions, conclusions, repeated context, and unsolicited alternatives. Let follow-up questions drive deeper explanations.

## Keep follow-ups addressable

Keep item numbers stable within the walkthrough so the user can say `5. can we instead do xyz here`. Answer about that item without repeating the whole walkthrough or renumbering existing items. Append any newly discussed changes with new numbers; start over at 1 only for a new walkthrough.
