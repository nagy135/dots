---
name: new-released-features
description: Explain the interesting features available by updating an app from its installed version to the latest release. Use when asked what new features an update would bring, for the current host app or an app supplied as an argument; omit fixes and chores.
---

# New released features

Tell the user what they would gain by updating now, in everyday language.
This is a read-only release comparison; do not install or update the app.

## Identify the app and baseline

Accept an optional first argument identifying the app, with an optional installed
version after it: `$new-released-features "Visual Studio Code" 1.100.0`.
A version alone, such as `$new-released-features 0.1.5`, overrides the baseline
for the current host app. With no arguments, detect both the host app and its
running or installed version. Honor explicit app/version details in prose too.

Use runtime context and relevant read-only tools or local app metadata. For
example, in T3 Code, environment metadata can identify the server version;
confirm whether that also represents the client being compared. For desktop
apps, inspect the running app's metadata or its installed bundle version. For a
CLI, use its documented version command. Prefer the running version over an
on-disk replacement when both are known.

The host app is the application the user is talking through, not automatically
the model provider, underlying agent CLI, or project in the working directory.
Do not use a repository's package version as proof of the installed app version.
If the app or baseline remains ambiguous after available checks, ask only for
the missing app/version. Never silently substitute a guessed version or a
recent-release time window for the user's baseline. A hosted app with no
observable version needs a user-provided baseline or an explicit explanation
that a precise update comparison is unavailable.

## Find the update available now

Check live official release notes, changelogs, release pages, or the app's update
feed. Establish the latest released version available for the user's platform
and release channel, using stable by default unless a different channel is
known or requested. Compare every intervening release: installed version
exclusive, target version inclusive. Follow pagination or archived notes when
needed; do not stop at the newest release's highlights.

Use release ordering and the project's version scheme rather than lexical
version sorting. Exclude drafts, unreleased changelog entries, roadmap items,
and prereleases outside the selected channel. Distinguish announced features
from ones actually shipped in the target version. Where relevant, check platform,
plan, region, opt-in, and staged-rollout restrictions; do not promise access
merely because a feature was announced. If the baseline is current or ahead of
the released channel, say there are no newer released features to gain.

## Select and explain features

Include new capabilities and meaningful improvements to what a person can do
with the app. Prioritize changes relevant to the user's known workflows, then
other substantial additions. Combine repeated changes to the same capability
across releases into one useful explanation of the final behavior.

Ignore all bug fixes, regressions, security patches, maintenance, dependency
bumps, refactors, CI/build changes, and chores. Do not fill a sparse list with
these. Judge by the actual behavior, not just a commit's `feat` label. Include a
workflow or interface improvement when it gives the user a meaningful new way
to work; skip cosmetic polish and vague performance claims. Mention a removal
or incompatible workflow change only when needed to explain an included feature.

Explain each item as what the user can now do and why it is useful, with a
concrete example when helpful. Translate engineering and marketing language;
avoid raw commit lists, issue IDs, internal implementation details, and hype.
Do not invent benefits or claim the user lacks something already in their
installed version. If source coverage is incomplete, state the gap and qualify
the comparison rather than claiming completeness.

## Response

Lead with **App: installed version → latest available version**, the platform or
channel when relevant, and the date checked. Follow with a concise list of
interesting features, ordered by usefulness. Use one or two plain-language
sentences per item; add the introducing version only when useful. Link official
sources beside the supported features, grouping citations where appropriate.
State material availability restrictions alongside the affected feature.

Do not impose a fixed feature count or dump the whole changelog. If the range
contains only fixes and chores, say there are no new user-facing features in
that update. If versions or sources cannot be verified, make that limitation
clear instead of presenting an invented comparison.
