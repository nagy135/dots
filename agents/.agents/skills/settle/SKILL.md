---
name: settle
description: Commit the work from the current conversation, push it to the repository's integration branch on origin, report unrelated changes left in the worktree, and settle the current T3 Code thread. Use when the user asks to finish work with this commit, push, and settle workflow.
---

# Settle

Invoking `$settle` (or `/settle` in Claude) authorizes committing all work from
the current conversation, pushing it to the intended integration branch on
`origin`, and settling this T3 Code thread. Proceed without routine confirmation.
A request to create or edit this skill does not invoke the workflow.

## Select the work and destination

Read the repository instructions and conversation to identify everything we
worked on. Inspect staged, unstaged, and untracked changes, the current branch,
upstream, fetch/push URLs, and unpushed commits. Include all conversation work,
including work completed earlier in the thread. Existing dirty files or staged
changes alone do not establish that they belong to this task.

Preserve unrelated changes, including their staged/unstaged state. Select task
files or hunks explicitly; do not use blanket staging. When task and unrelated
changes share a file, separate the hunks. Use a temporary index or isolated
worktree when needed to avoid committing someone else's staged changes. If
ownership cannot be established, ask before including the uncertain changes.
Never discard, overwrite, or stash unrelated work just to obtain a clean tree.

Use the destination specified by the user or repository instructions. Otherwise
inspect `origin` and the branch/upstream context to choose `develop` or `main`.
Ask which branch to use if both are plausible, neither exists, or the evidence
conflicts. Do not silently push to the current feature branch as a substitute.

Inspect the complete set of commits that would be published, not just the new
diff. If the current branch contains unrelated unpushed commits, isolate the
task commits rather than publishing them too. When integrating from a feature
branch, use a separate worktree if needed to preserve the original dirty tree.
Ask before proceeding if the intended integration cannot be determined safely.

## Commit and publish

Run the checks required for the actual change and review the selected diff.
Before writing a commit message, inspect recent commits with authors:

```sh
git log -20 --format='%h %an <%ae> %s'
```

Follow Viktor's established scope and subject style, including commits made on
his behalf, within Conventional Commits: `<type>[optional scope][!]: <subject>`.
Use `feat` for features, `fix` for fixes, and appropriate types otherwise. Mark
and explain breaking changes. Other contributors' styles do not override ours.

Commit only the selected task changes. Skip an empty commit; if the task was
already committed, publish any remaining task commits. Fetch the destination,
integrate the task work, and push to the exact branch on `origin` without force.
Preserve concurrent remote work. If integration conflicts require a substantive
decision, or checks or pushing fail, resolve what is within scope and report
any blocker; leave the thread active while delivery is incomplete.

Verify that the published task commits are reachable from the destination on
`origin`, and record the commit SHA(s) and destination branch. If everything is
already published, verify that state and continue without creating a commit.

## Settle and report

Recheck the original worktree and index. Summarize every remaining unrelated
change, including untracked files, by path and purpose where known. State when
nothing remains. These changes do not block settlement once task work is
published. Include any temporary worktree still left behind.

After successful publication and verification, call T3 Code's
`t3_thread_organize` tool (possibly exposed with an MCP prefix) with
`{"action":"settle"}`, omitting `threadId` to target this thread. Settlement of
the current thread takes effect when the turn completes; report it accordingly.
Do not archive the thread or settle other threads. If the tool is unavailable
or fails, report that the Git work is complete but thread settlement remains
unavailable or failed; do not claim it succeeded.

Finish with a concise report of what was committed, the SHA(s), the published
`origin/<branch>`, verification, settlement status, and what stayed in the
worktree. Always include blockers or incomplete steps.
