---
name: file-pr
description: File a concise GitHub pull request or GitLab merge request when asked to file, open, or create a PR/MR.
---

# File PR

Read [host operations](../full-send/references/hosts.md) for host detection,
GitHub/GitLab commands, readiness checks, and monitoring. In this skill,
"PR" includes a GitLab merge request; use the actual request target branch.

Before filing, check whether a PR for this branch already exists. Review the
diff locally against the actual target branch (discover its remote; do not assume `origin/main`) to make sure its
contents match the goal.

PR titles usually become commit messages, so follow the repository's title
conventions. Look at recently merged PRs and Git history for examples. Prefer a
concise, human-readable title that explains why the change matters:

BAD

> ❌ perf(server): negotiate permessage-deflate on the websocket

GOOD

> ✅ perf(server): cut websocket frame size by 70%+ with gzipping

Open the description with a simple explanation of the problem based on the
user's original prompt, then briefly explain the solution. Do not lead with an
implementation inventory:

BAD

> ❌ Removed implicit workspace carry-over from every "new thread" entry point (cmd+n / cmd+shift+o, sidebar v1/v2 buttons, command palette). New threads inherit only the project from context; branch, worktree, and env mode always come from the configured defaults. Deleted buildContextualThreadOptions, startNewThreadInProjectFromContext, and the v1 sidebar's seed-context machinery.

GOOD

> ✅ My "new worktree" default was ignored when starting new threads on existing worktrees. Super unintuitive. Now your preferences always apply.

End the description with the public model name and harness that made the
changes, for example `Created with <model> in <harness>.` Include subagent
models that wrote part of the change. Use the model name the harness reports.
If model identity is unavailable, name the harness without guessing a model.

Before submission, check the title, description, quotes, and attachments for
secrets and private details.

Use the host-specific create command from the reference, with an explicit
source and target repository/branch and a description file. Honor repository
templates. Open a real PR rather than a draft so review bots run, unless the user
requests a draft. In full-stop, never enable auto-merge during creation.
In T3 Code, call `link_pull_request` with the full URL as the next tool call
after creating, taking over, or pushing a PR/MR.

For GitHub only: If `gh pr create` fails
because the GraphQL rate limit is used up, open it through REST with
`gh api repos/<owner>/<repo>/pulls -f title=... -f head=... -f base=... -F body=@<file>`. If the user also asked
to babysit it, continue with the `babysit-pr` skill.

Do not post a follow-up PR comment unless it serves the user's request. When a
comment is needed, use the `leaving-pr-comments` skill.

<!-- Adapted from https://github.com/t3dotgg/tstack/tree/1085050f3baed1ac724caa4a8166145fb2ac88af/skills/file-pr (MIT). Local GitHub/GitLab support; do not overwrite blindly when updating. -->
