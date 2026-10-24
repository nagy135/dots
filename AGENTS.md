# Skill delivery

Shared skill sources live in `agents/.agents/skills`. Commit and push changes
to `master` on `origin` (`git@github.com:nagy135/dots.git`) before updating
remote checkouts. This repository uses the provider directly; no Git relay is
needed for these checkouts.

## Mac

The checkout is `/Users/Viktor/.dots`. `/Users/Viktor/.agents` links to
`.dots/agents/.agents`; the Claude and Codex `commit-push-deploy` skill paths
resolve to the shared source. Editing the source updates those installed files.

## nixpi

Connect as `infiniter@nixpi.tail6650cb.ts.net`. The checkout is
`/home/infiniter/.dots` on `master`. Before updating, inspect the hostname,
branch, working tree, and fetch/push URLs; preserve unrelated changes. Pull:

```sh
git -C /home/infiniter/.dots pull --ff-only origin master
```

The `commit-push-deploy` skill uses these links. Create missing links only;
inspect existing paths rather than replacing them:

```sh
mkdir -p /home/infiniter/.agents/skills /home/infiniter/.claude/skills /home/infiniter/.codex/skills
ln -s /home/infiniter/.dots/agents/.agents/skills/commit-push-deploy /home/infiniter/.agents/skills/commit-push-deploy
ln -s /home/infiniter/.agents/skills/commit-push-deploy /home/infiniter/.claude/skills/commit-push-deploy
ln -s /home/infiniter/.agents/skills/commit-push-deploy /home/infiniter/.codex/skills/commit-push-deploy
```

## Verification

These are static skill files: no build, Nix activation, service restart, or HTTP
health check is required. Verify the published commit with `git rev-parse HEAD`
and `git ls-remote origin refs/heads/master`. Check that both installed skill
paths resolve to the checkout and compare `SKILL.md` and `agents/openai.yaml`
with the committed source using `cmp`. For this manual-only skill, verify
`disable-model-invocation: true` in `SKILL.md` and
`allow_implicit_invocation: false` in `agents/openai.yaml`. A fresh agent session
is needed to verify discovery behavior; file checks alone do not prove that an
existing session reloaded its skill catalog.

No installation was found in the checked root/infiniter home locations on
Hetzner. Nixzero was unreachable during delivery; its installation status is
unverified. Inspect those hosts before treating them as deployment targets.
