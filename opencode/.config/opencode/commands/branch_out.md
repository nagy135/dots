---
description: Run a task through several independent low-reasoning GPT-5.6 Sol agents.
---

Branch out the following task to three independent `branch-out-worker` subagents:

$ARGUMENTS

Launch all three subagents concurrently using the task tool. Give each agent the complete task and enough context to work autonomously. Assign complementary perspectives when that improves coverage; otherwise have them independently attempt the task.

After all agents finish, reconcile their results. For research or review work, return one synthesized answer and clearly identify meaningful disagreements. For implementation work, prevent overlapping edits by assigning distinct scopes, inspect the resulting changes, resolve integration issues, and run appropriate verification. Do not duplicate a subagent's work while it is running.
