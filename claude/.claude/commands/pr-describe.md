---
description: Summarize this branch vs a source branch into a short, scannable PR description
argument-hint: <source-branch>
allowed-tools: [Bash, Read, Grep, Glob]
---

# /pr-describe — PR description for current branch vs $ARGUMENTS

Sum up the changes on the **current branch** compared to the source branch `$ARGUMENTS` to produce a short PR description. If `$ARGUMENTS` is empty, default to the repo's main branch (`main` or `master`, whichever exists) and note which one you used.

The goal: something easy to scan, surfacing only the most important info — not an exhaustive list of every change.

## Steps

1. Resolve refs:
   - `git rev-parse --abbrev-ref HEAD` — current branch name.
   - Determine the source branch: `$ARGUMENTS` if given, else `main` or `master`. Verify it exists with `git rev-parse --verify`. If not found, report and stop.
   - Compute the merge base: `git merge-base <source> HEAD`.
2. Gather the diff scope (use the merge-base, three-dot, so unrelated commits on the source branch don't pollute the description):
   - `git log --oneline <source>...HEAD` — commits, for intent.
   - `git diff --stat $(git merge-base <source> HEAD)...HEAD` — file-level overview.
   - `git diff $(git merge-base <source> HEAD)...HEAD` — full diff for the important files.
3. Identify the **important** changed files — the ones that carry the actual change. Skip noise like lockfiles, generated output, formatting-only churn, and trivial one-liners unless they're the point of the PR.
4. Output the description below. No preamble, no closing remarks.

## Output format

### Summary
A short, human-readable explanation of *why* this PR exists and what it accomplishes — 1–3 sentences or a few bullets. Focus on intent and outcome, not mechanics.

### Key changes
- `path/to/file` — one or two sentences on what changed there and why it matters.
- One entry per important file (or tightly-related group). Order by importance, most significant first.

## Rules

- Keep it tight and scannable — most important info only, omit the trivial.
- Describe intent and impact, not a line-by-line restatement of the diff.
- Don't invent reasons; if the motivation isn't clear from commits/diff, describe what changed without speculating on why.
- Static review only. Do not run tests, commit, push, or modify files.
