---
name: settle
description: Commit conversation work, push to origin, report leftover changes, and settle the current T3 Code thread. Use only when explicitly invoked.
disable-model-invocation: true
---

# Settle

Run only when explicitly invoked as `$settle` or `/settle`. This authorizes the
workflow without routine confirmation. Editing the skill does not invoke it.

1. Inspect the conversation, repository instructions, changes, and unpushed
   commits. Commit everything we worked on in this thread. Exclude unrelated
   work, including staged changes and commits; preserve its staged/unstaged state.
   Select files or hunks explicitly. Ask if ownership is unclear.
2. Choose `origin/develop` or `origin/main` from repository context, honoring an
   explicit user or repository destination. Ask if unclear.
3. Run relevant checks. Inspect recent commits with authors and follow Viktor's
   Conventional Commit style. Skip empty commits.
4. Integrate and push only our work to the chosen destination without force,
   preserving concurrent work. Verify the commits reached `origin`. Report
   blockers and leave the thread active if delivery is incomplete.
5. Call T3 Code's `t3_thread_organize` with `{"action":"settle"}` and no
   `threadId`. Settlement takes effect when the turn ends. If unavailable or
   failed, say so.
6. Report commit SHA(s), destination, settlement status, and a brief summary of
   changes left in the original worktree, including untracked files. State when
   nothing remains.
