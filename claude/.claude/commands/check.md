---
description: Review the current branch against another branch and report summary, possible mistakes, and shortcuts/TODOs
argument-hint: <base-branch>
allowed-tools: [Bash, Read, Grep, Glob]
---

# /check — Branch review against $ARGUMENTS

Review the **current branch** against the base branch `$ARGUMENTS`. If `$ARGUMENTS` is empty, ask the user which branch to compare against and stop.

## Steps

1. Resolve refs:
   - `git rev-parse --abbrev-ref HEAD` — current branch name.
   - Verify `$ARGUMENTS` exists with `git rev-parse --verify $ARGUMENTS`. If it does not, report that the branch was not found and stop.
   - Compute the merge base: `git merge-base $ARGUMENTS HEAD`.
2. Gather the diff scope (use the merge-base, not a two-dot diff, so unrelated commits on the base branch don't pollute the review):
   - `git log --oneline $ARGUMENTS...HEAD` — commits on the current branch.
   - `git diff --stat $(git merge-base $ARGUMENTS HEAD)...HEAD` — file-level overview.
   - `git diff $(git merge-base $ARGUMENTS HEAD)...HEAD` — full diff.
3. For any non-obvious change, read the surrounding code in the modified files so the review reflects the actual file state, not just the hunk.
4. Produce the report in exactly the three sections below. No preamble, no closing summary.

## Output format

Output exactly this structure, in this order:

### 1. Summary
- Bullet points describing what the branch does relative to `$ARGUMENTS`. One bullet per logical change, not per file. Group related file edits.

### 2. Possible mistakes
- Bugs, regressions, broken invariants, security issues, missed edge cases, type/contract mismatches, dead code paths, accidental reverts, anything that looks unintentional. Cite `file:line` for each. If none, write "None spotted." — do not invent issues.

### 3. TODOs & shortcuts
- Explicit `TODO`/`FIXME`/`XXX` markers added on this branch, plus implicit shortcuts: stubbed functions, hardcoded values, disabled tests, skipped validation, swallowed errors, commented-out code, "temporary" workarounds, missing error handling at boundaries. Cite `file:line` for each. If none, write "None spotted."

## Rules

- Be direct and specific. No hedging, no filler.
- Cite `file:line` for every concrete claim in sections 2 and 3.
- Only flag issues introduced or touched by this branch — ignore pre-existing problems on lines the branch did not modify.
- Do not run linters, typecheckers, tests, or the dev server. Static review only.
- Do not commit, push, or modify files.
