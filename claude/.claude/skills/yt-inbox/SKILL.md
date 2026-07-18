---
name: yt-inbox
description: Build a list of recent YouTrack issues the user was likely notified about (comments, status changes, mentions), including ALL comments on each issue, grouped into FYI / waiting-on-others / waits-on-me tables with items awaiting the user's action at the BOTTOM. Use when the user asks for their YouTrack notifications, recent activity, "what happened on my tickets", or "what did I get notified for". Optional argument - number of issues (default 50).
---

# YouTrack Notification Inbox

Reconstruct the user's recent YouTrack notification feed. The YouTrack MCP does not expose the actual notification feed, so approximate it: issues the user is involved in, sorted by most recent update, with the last activity attributed to whoever caused it. The output is ordered by importance ASCENDING — pure FYI first, items waiting on the user LAST — so the actionable items sit at the bottom of the terminal, closest to the prompt.

## Arguments

`$ARGUMENTS` may contain a number N — how many issues to list. Default: 50.

## Steps

1. **Load tools.** If the YouTrack MCP tools are deferred, load them via ToolSearch:
   `select:mcp__youtrack__get_current_user,mcp__youtrack__search_issues,mcp__youtrack__get_issue_comments`

2. **Identify the user.** Call `get_current_user` to get their login (needed to tell their own actions apart from others').

3. **Find candidate issues.** Call `search_issues` with:
   ```
   for: me or reporter: me or mentions: me or commenter: me sort by: updated desc
   ```
   with `customFieldsToReturn: ["Type", "State", "Assignee", "Priority"]`.
   `search_issues` caps `limit` at 20 — page with `offset` 0, 20, 40, … (in parallel) until you have N issues or `hasNextPage` is false. If the feed has fewer than N issues, say so and list them all.

4. **Fetch ALL comments for every issue — do not stop at the first page.**
   For each issue, call `get_issue_comments` with `limit: 10`, starting at `offset: 0`, and keep incrementing the offset by 10 until a call returns fewer than 10 comments. Missing later pages silently hides the most recent activity (this includes restricted-visibility comments, e.g. Sensory-Minds-only — they are returned normally since the MCP runs as the user, they just carry no visibility marker).
   Comment `createdAt`/`updatedAt` are epoch **milliseconds** — convert to human-readable dates in the user's time zone.
   **For more than ~15 issues, fan out:** split the issue list into batches of ~10 and spawn parallel subagents (general-purpose), each instructed to load the tool via ToolSearch, paginate all comments, and return a compact JSON array per issue with: last comment by someone other than the user (author, date, short gist), last comment overall, `waitsOnMe` (false, or the specific ask), and a one-line `whyNotified`. Pass each batch the issue states/assignees/priorities/updatedAt so agents can classify without extra calls. This keeps the raw comment threads out of the main context.

5. **Determine why the user was notified.** For each issue, look at the most recent activity **by someone other than the user** — the user's own comments and changes don't generate notifications to themselves. Attribute it concretely: who commented (quote or paraphrase the comment briefly), or what state/assignee change the `updatedAt` timestamp likely reflects (a state change with no matching comment timestamp usually means a field update — describe it as "State → Verified", never invent a comment).

6. **Classify each issue by actionability** (this drives the grouping):
   - **FYI** — resolved/verified, or activity that needs nothing from the user.
   - **Waiting on others** — the user acted last; someone else must respond, review, or test.
   - **Waits on me** — an explicit unanswered request/question/@mention directed at the user, or an unresolved issue assigned to them that others are waiting on.

7. **Report.** Output EXACTLY three markdown tables in this order, numbered continuously across all three (1…N), sorted within each group by importance ascending (FYI: oldest `updatedAt` first; waits-on-me: most urgent LAST — freshest direct questions and explicit asks at the very bottom):

   **FYI — nothing needed from you**

   | # | Link | Summary | State | Prio | Assignee | Updated | Last activity / why notified |

   **Waiting on others — you acted last**

   | # | Link | Summary | State | Prio | Assignee | Updated | Status |

   **⚠️ Waits on you — most urgent last**

   | # | Link | Summary | State | Prio | Assignee | Updated | What's expected from you |

   Formatting rules:
   - The Link column contains the BARE URL (e.g. `https://agile.sensory-minds.com/issue/bmwr-104`), NOT a markdown link — terminals auto-linkify plain URLs; markdown links are not clickable for this user.
   - Address the user as "you"; refer to others by their YouTrack login.
   - In the last column, name who acted and quote or tightly paraphrase their comment; **bold** the explicit asks ("please push this to staging"), unanswered direct questions, and the Open state / assignee login on waits-on-me rows.
   - Keep gists short (one line per row); mention related tickets by ID where relevant.
   - In "Waiting on others", say what the user did last and who/what is awaited.
   - In "Waits on me", state the concrete expected action, who asked, and add a caveat if it may already be handled elsewhere (e.g. discussed in a daily).

8. **Bottom line.** After the tables, add ONE short paragraph titled "**Bottom line — your queue:**" summarizing ONLY the waits-on-me items in priority order: the hard asks first (explicit requests, unanswered direct questions, untouched Open tickets), then softer follow-ups. Where the user's current git branch or working directory is obviously relevant (e.g. asked to push to staging while on the `staging` branch), note it.

## Pitfalls

- Never summarize an issue from a partial comment list — always paginate to the end (step 4).
- Do not modify anything: no comments, no state changes, no work logs. This skill is read-only.
- `updatedAt` on the issue can be newer than the newest comment (field-only changes); don't invent a comment to explain it.
- A request answered by a LATER comment from the user is not "waits on me" — check chronology before flagging.
- Continuous numbering across the three tables, never restarting at 1 per table.
