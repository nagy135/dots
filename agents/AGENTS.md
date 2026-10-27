# Global Rules

- Start every agent run with `$progress-notifier`: create the initial progress notification before planning, inspecting task files, running task commands, or editing. Only loading the [skill](.agents/skills/progress-notifier/SKILL.md) and looking up its required project metadata may precede that notification.
- Keep one stable task/card name throughout the run. Update it at meaningful milestones with a short description, honest progress, and remaining ETA; mark it complete only after success, or dismiss it on failure or cancellation. Follow the skill's project metadata and completion rules.
- Progress notifications are best effort: if the app or client is unavailable or an update fails, continue the task without retries, troubleshooting, or chat warnings. Honor an explicit request to skip notifications.
- Never post anything to YouTrack: no comments, issue updates, field/state changes, or new issues. Draft the text in chat and let Viktor post it, even when asked to "comment there".
- Posting on GitLab merge requests (e.g. replies and resolved threads via pr-turn/mr-turn) is allowed.

## macOS pkill

This machine runs macOS 26.6.2 with BSD `/usr/bin/pkill`. Put all options before the pattern: `pkill -u "$(id -u)" -f '<task-specific pattern>'`. Arguments after the first pattern become additional patterns, even if they look like options. First preview with `pgrep -u "$(id -u)" -fl '<task-specific pattern>'` and verify that every match belongs to your task.

## Commit messages

- Before writing a commit message, list recent commits with their authors (e.g. `git log -20 --format='%h %an <%ae> %s'`). Inspect more history if needed to identify our established convention.
- Follow the convention established by Viktor's commits and commits made on his behalf, including scope and subject style, within the Conventional Commits rules below. Other contributors using a different convention must not cause us to change ours.
- Use [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/) for all commits: `<type>[optional scope][!]: <short description>`, e.g. `fix(auth): handle expired tokens`.
- Use `feat` for new features and `fix` for bug fixes; use other appropriate types such as `docs`, `refactor`, `perf`, `test`, `build`, `ci`, or `chore` for other changes.
- Mark breaking changes with `!` immediately before `:` or a `BREAKING CHANGE: <description>` footer; explain what breaks in the description or footer.
- Add a body or footers only when useful, separated from the subject and each other by a blank line.
