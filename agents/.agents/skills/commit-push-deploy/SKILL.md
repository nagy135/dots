---
name: commit-push-deploy
description: Commit task changes using established conventions, push to origin, pull on the runtime machine, and deploy and verify. Use for $commit-push-deploy or requests to commit, push, and deploy. Record clarified deployment steps in the repository's AGENTS.md.
---

# Commit, push, deploy

Invoking this skill authorizes committing, pushing, pulling, and deploying the
current task. Proceed without routine confirmation.

## Find the procedure

Read the repository's `AGENTS.md`, deployment docs, scripts, and runtime setup.
Identify the deployment host, checkout, branch, service, commands, and health
check. Inspect local changes, unpushed commits, upstream, and fetch/push URLs.
Preserve unrelated work and use a separate worktree if another session owns
the checkout.

Use [$fleet-work](../fleet-work/SKILL.md) for access, Git relays, and Nix delivery.
If the runtime location is uncertain, check **nixpi first**, then the other fleet
machines until the target is clear. A checkout alone does not prove the project
runs there. Deploy to each affected runtime.

If material instructions remain unclear or conflicting, ask the user a focused
question before the dependent action. Continue independent preparation; retain
the answer for `AGENTS.md`.

## Commit and push

Run required checks and review the diff. Before each commit message, inspect
recent commits with authors; extend the history if needed:

```sh
git log -20 --format='%h %an <%ae> %s'
```

Follow Viktor's established scope and subject style, including commits made on
his behalf, within Conventional Commits: `<type>[optional scope][!]: <subject>`.
Use `feat` for features, `fix` for fixes, and appropriate types otherwise. Mark
and explain breaking changes. Other contributors' styles do not override ours.

Commit only task changes and clarified instructions; skip empty commits.
Check the remote head, preserve concurrent work, and push the intended branch
to `origin` without force-pushing. Complete any sensory-minds Mac relay through
the Mac's external `origin`. Confirm publication and record the commit SHA.

## Pull and deploy

On each target, verify the host, checkout, branch, remotes, and working tree.
Preserve local changes, credentials, and runtime data. Pull the published branch
with `--ff-only` and verify the intended revision; resolve divergence or an
unexpected remote advance before deployment.

Run the project's established deployment commands in order, including any
required dependencies, build, migrations, activation, or restart. Initiate Nix
builds on the target, retaining configured workers. Check service health and
verify the running revision or artifact; a successful pull or build is
insufficient. Inspect failures before retrying, especially migrations.

## Record and finish

Before finishing, save clarified and newly verified deployment instructions in
the **project repository's `AGENTS.md`**, creating it if needed and preserving
existing guidance. Record host/SSH identity, absolute checkout path, branch and
remote/relay flow, exact commands and order, service, health checks, and relevant
constraints. Keep secrets out and identify anything still unverified.

Include this documentation in the task commit when possible. If finalized after
deployment, commit and push the update and pull it on the targets too; redeploy
only if it affects runtime behavior. Remove task-created worktrees and branches
once integrated and delivered.

Report the commit, published branch, deployed host/revision, verification, and
`AGENTS.md` location. State exact blockers, remaining steps, and unrelated local
changes still present; do not claim completion when delivery is incomplete.
