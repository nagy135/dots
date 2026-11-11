---
name: merge-tag-release-deploy
description: Prepare a feature branch release through develop and main locally; push to origin and trigger deployment pipelines only with an explicit push and deploy request. Use only when explicitly invoked.
disable-model-invocation: true
---

# Merge, tag, release, deploy

Run only when explicitly invoked. **Default: local release preparation only.**
The skill's name alone never authorizes pushing or deployment.

## Argument

`$merge-tag-release-deploy` performs the local steps below without pushing,
creating a tag, or triggering pipelines. Adding `push and deploy`, `--push-and-deploy`,
or equivalent explicit wording such as “publish and deploy” also authorizes
publishing the feature branch, `develop`, `main`, and the release tag to `origin`.
An explicit “do not push/deploy” keeps the run local.

## Local steps

Inspect the working trees and branch history, fetch `origin`, and fast-forward
local `develop` and `main` where possible. Preserve unpublished local work;
stop on unexplained divergence. Use existing worktrees for checked-out branches.
Review the commits entering each merge and run the repository's release checks.

1. Rebase the feature branch onto local `develop`.
2. Merge the feature branch into `develop` with `--no-ff`.
3. Merge `develop` into `main` with `--no-ff`, recording the merge SHA.
4. On `main`, create a `chore(release): vX.Y.Z` commit updating `CHANGELOG.md`
   and the package version (and lockfile if required). Default to a patch bump
   from **main's version before the merge**, unless asked otherwise. Match the
   existing changelog style and cover the full release scope in user-facing language.
5. Squash that release commit into the immediately preceding develop-to-main
   merge: `git reset --soft HEAD~1`, then `git commit --amend`. Preserve both
   merge parents and include `chore(release): vX.Y.Z` in the resulting message.

Verify that the final `main` merge contains the changelog and version changes,
retains both parents, and has no separate release commit on top. Stop here by default.

## Only with push and deploy

Read the repository's CI configuration, then push the feature branch, `develop`,
and `main` to `origin`. If rebasing rewrote a published feature branch, use
`--force-with-lease` for that branch only; never force-push `develop` or `main`.
Create a lightweight `vX.Y.Z` tag on the final release merge and push that tag.
Never move an existing release tag. These pushes trigger the configured pipelines;
do not manually run deploy or migration jobs. Staging is outside this skill.

Report the version and final commit SHAs, whether everything remains local or
was pushed, and any observed pipeline status. Do not claim deployment succeeded
without verifying it.
