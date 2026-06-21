---
description: Summarize incoming git changes or recent commits.
---

Summarize git news for the current repository. Interpret the argument as follows:

- **Numeric argument** (e.g. `5`): summarize the last that many commits on the current branch.
- **Branch name argument** (e.g. `feature/foo` or `origin/main`): fetch remote refs if needed, then summarize the commits on that branch that are not yet reachable from the current branch — i.e. what would come in if you pulled/merged it. Resolve the name against local and remote refs (try `<name>` and `origin/<name>`). If the name matches neither a number nor a known ref, say so and list the branches that do exist.
- **No argument**: fetch remote refs if needed and summarize changes available to pull from the upstream branch of the current branch, without modifying the worktree.

Never modify the worktree (no checkout, merge, pull, or reset). Start with a brief summary of the most interesting changes. Then list changed files, with one or two sentences describing what changed in each file. Keep the whole response concise. Each file needs to be in new list element and its description is next line for better readability. Argument: $ARGUMENTS
