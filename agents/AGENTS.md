# Global Rules

- Never post anything to YouTrack: no comments, issue updates, field/state changes, or new issues. Draft the text in chat and let Viktor post it, even when asked to "comment there".
- Posting on GitLab merge requests (e.g. replies and resolved threads via pr-turn/mr-turn) is allowed.

## Commit messages

- Use [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/) for all commits: `<type>[optional scope][!]: <short description>`, e.g. `fix(auth): handle expired tokens`.
- Use `feat` for new features and `fix` for bug fixes; use other appropriate types such as `docs`, `refactor`, `perf`, `test`, `build`, `ci`, or `chore` for other changes.
- Mark breaking changes with `!` immediately before `:` or a `BREAKING CHANGE: <description>` footer; explain what breaks in the description or footer.
- Add a body or footers only when useful, separated from the subject and each other by a blank line.
