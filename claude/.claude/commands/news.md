---
description: Summarize incoming git changes or recent commits.
---

Summarize git news for the current repository. If the user supplied a numeric argument, summarize the last that many commits on the current branch. If no argument was supplied, fetch remote refs if needed and summarize changes available to pull from the upstream branch without modifying the worktree. Start with a brief summary of the most interesting changes. Then list changed files, with one or two sentences describing what changed in each file. Keep the whole response concise. Each file needs to be in new list element and its description is next line for better readability. Argument: $ARGUMENTS
