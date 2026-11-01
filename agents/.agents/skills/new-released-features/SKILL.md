---
name: new-released-features
description: Explain useful features gained by updating the current app or a specified app, excluding fixes and chores.
---

# New released features

Explain what the user would gain by updating now. Do not install updates.

- Accept an app as the first argument and an optional installed version:
  `$new-released-features "Visual Studio Code" 1.100.0`. A version alone
  overrides the current app's baseline. Without arguments, detect the host app
  and running version using runtime tools or installed app metadata. The host
  app is where this conversation runs; do not confuse it with the model provider,
  agent CLI, or working-directory project. Ask for missing details only when
  detection fails; never guess the baseline.
- Check live official release notes or changelogs for every release newer than
  the baseline through the latest available version. Match the user's platform
  and channel; default to stable. Exclude unreleased plans and out-of-channel
  prereleases. Flag plan, platform, opt-in, or rollout restrictions.
- Select interesting new capabilities and meaningful workflow improvements.
  Prioritize the user's workflows and combine related additions. Ignore all
  fixes, security patches, maintenance, dependencies, refactors, build changes,
  chores, cosmetic polish, and vague performance claims.
- Lead with **App: installed version → latest available version** and the date
  checked. Give concise bullets explaining what the user can now do and why
  it helps, in everyday language, with official source links. Avoid commit
  dumps, implementation jargon, hype, and features already in their version.
- If already current, or only fixes and chores shipped, say there are no new
  features to gain. Disclose unverifiable versions or incomplete release notes
  rather than inventing a comparison.
