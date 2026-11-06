---
name: merge-tag-release-deploy
description: Release a finished branch in a develop/main GitLab repository such as metzler-website-relaunch-2026 - merge it into develop and push, merge develop into main with the changelog and version bump squashed into the merge as chore(release), then push main and a vX.Y.Z tag that starts the production build. Staging is not part of this flow. Use only when the user explicitly invokes merge-tag-release-deploy.
disable-model-invocation: true
---

# Merge, tag, release, deploy

Run only when the user explicitly invokes this skill. Invoking it authorizes
pushing the branch, `develop`, `main` and the release tag. It does **not**
authorize anything on `staging` or any production deploy job.

## The flow

```
branch ──► develop ──► main + chore(release) squashed into the merge ──► push main + tag
```

1. Verify and push the branch.
2. Merge it into `develop` and push `develop`.
3. Merge `develop` into `main` with the changelog and version bump folded in.
4. Push `main`, tag the release commit and push the tag.

**Staging is not part of this flow.** Never merge into or push `staging` here,
even if the branch was deployed there earlier. See [Staging](#staging-separate-flow).

## Before you start

- Read `.gitlab-ci.yml`. Expected today: `develop` runs lint/test/`build_test`;
  `main` runs lint/test/`build_prod`; a `vX.Y.Z` tag runs `build_prod_release`
  (`$CI_REGISTRY_IMAGE:vX.Y.Z`), with `deploy_prod_vm1/vm2`, `migrate_prod` and
  the load balancer drain/restore jobs left manual. If the file says otherwise,
  follow it and update this skill.
- `git fetch origin --tags`. Branches may be checked out in other worktrees
  (`git worktree list`); work there after checking the worktree is clean and
  level with its upstream (`git rev-list --left-right --count
  <branch>...origin/<branch>` → `0 0`).
- Before every merge, list exactly what it brings in, so nothing unrelated
  rides along:

  ```sh
  git log --oneline --no-merges origin/<target>..<source>
  ```

## 1. Verify and push the branch

The branch is cut from `origin/develop` and its commits follow the global
commit rules (Conventional Commits, Viktor's scope style such as
`fix(bmwr-354): …`, or an area scope like `fix(preview): …` without a ticket).
The *why* goes in the commit body; the merge commits below stay one line.

Run what CI runs, on the whole project, not only the specs you touched:

```sh
pnpm run prettier && pnpm run lint && pnpm run typecheck
DATABASE_URL="mongodb://127.0.0.1:27017/payload-test-db" pnpm run test:int
```

A change in shared code (e.g. `getCurrentTenant` calling `draftMode()`) can
break an unrelated spec that mocks `next/headers` itself; only the full suite
catches that. Start the local Mongo with `docker compose -f
docker-compose.local.yml up -d mongo` if needed. Never point the suite at a
staging tunnel. Fix every failure before merging.

```sh
git rebase origin/develop        # often a no-op
git push -u origin <branch>
```

## 2. Merge into develop

```sh
git switch develop && git merge --ff-only origin/develop
git merge --no-ff -m "Merge branch '<branch>' into develop" <branch>
git push origin develop
```

## 3. Release merge into main

If local `main` diverged from `origin/main` (the user rewrote the last release
while pushing it), compare them with `git diff --stat main origin/main`. When
only the message differs, `git reset --hard origin/main`.

```sh
git switch main && git merge --ff-only origin/main
git log --oneline --no-merges origin/main..develop   # the release scope
git merge --no-ff --no-commit develop
```

While the merge is uncommitted:

1. **Version.** Bump the patch of **`main`'s** `package.json` (`1.0.38` →
   `1.0.39`) unless the user says otherwise. `develop`'s version is stale;
   never read it.
2. **Changelog.** Add `## X.Y.Z - YYYY-MM-DD` (today) at the top of
   `CHANGELOG.md`, in Keep a Changelog sections `Added` / `Changed` / `Fixed` /
   `Security`, covering every commit in the release scope. Match the existing
   entries: full sentences in plain user-facing language about behaviour (what
   works now, what went wrong before), code names only where an editor or
   operator needs them, no ticket numbers or SHAs.
3. Stage both files and commit the merge with the release folded in. There is
   no separate release commit and no trailer (Viktor strips `Co-Authored-By`
   from release merges):

   ```sh
   git add CHANGELOG.md package.json
   git commit -m "Merge branch 'develop'" -m "chore(release): vX.Y.Z"
   ```

   If a separate `chore(release)` commit ended up on top of the merge, squash
   it in: `git reset --soft HEAD~1 && git commit --amend`.

## 4. Push main and the tag

```sh
git push origin main
git fetch origin
git log -1 --format='%h %s%n%b' origin/main   # must be the chore(release): vX.Y.Z merge
git tag vX.Y.Z origin/main
git push origin vX.Y.Z
```

- Tag `origin/main`, not local `main`, and report the hash the tag points at.
- Viktor's release tags are **lightweight** (`v1.0.35`, `v1.0.36`, `v1.0.39`).
  Annotate only if asked.
- Never move or re-push an existing tag; ask first.
- The tag starts `build_prod_release`. Production deploy, migration and load
  balancer jobs stay manual for the user; do not trigger them.

## Report

Report the branch, `develop` merge, release merge and tag SHAs, the release
scope and changelog entry, and the manual production jobs the user still runs.
Do not claim CI passed unless you checked it.

## Staging (separate flow)

Only on a separate, explicit request, never as part of the release flow above.
For reference when it is asked for:

- Merge in the `staging` worktree with exactly one line,
  `git merge --no-ff -m "Merge branch '<branch>' into staging [deploy]" <branch>`.
  CI auto-deploys only when the whole message ends with `[deploy]`
  (`/\[deploy\]\s*$/`); a body or trailer after it makes the deploy jobs
  manual. `migrate_staging` is always manual.
- Staging carries staging-only commits. On conflicts, read
  `git log origin/develop..origin/staging -- <files>` first; if staging solved
  the problem differently, `git merge --abort` and ask which design wins.
- Push `staging` only when the user says so. Never merge `staging` into
  `develop` or `main`.
