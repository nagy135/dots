# GitHub and GitLab operations

Read this reference when using any of the adapted tstack skills. It supplies
host mechanics; it does not grant permission to merge or post by itself.

## Identify the request and repositories

Use the supplied request URL first; otherwise inspect `git remote -v`, the
current branch and its upstream. GitLab can be self-hosted and have nested
groups. Do not classify an unfamiliar host as GitHub by default: confirm through
existing `gh`/`glab` configuration or the host API, without printing tokens.
Use `gh` for GitHub and `glab` (and the installed `glab` skill) for GitLab.
Check CLI version, relevant `--help`, and authentication for that host.

Record host, target repository/project, request number/IID, source repository,
source branch, target branch and current head SHA. For forks, fetch the target
repository separately and push only to the source repository. Existing requests
can target a release or stacked branch; never silently retarget to the default.
For new requests, discover the default branch unless the user specified a base.
Preserve unrelated local work and concurrent remote changes.

In examples, substitute verified values; angle-bracket placeholders are not shell
syntax. Use `--repo`/`-R` with the verified repository URL on CLI operations and
`--hostname <host>` for self-hosted API calls. GitLab `:id` only works when the
current repository is the intended API project; otherwise use a numeric project
ID or fully URL-encoded project path (including every nested group).
MR API paths use the **target project** and project-local **IID**, not global MR ID.
Pipeline/job API paths use the project that actually owns that pipeline.

## Read, create and update

GitHub:

- Read: `gh pr view <url> --json url,state,isDraft,headRefOid,headRefName,baseRefName,headRepository,headRepositoryOwner,mergeable,mergeStateStatus,reviewDecision,statusCheckRollup,autoMergeRequest`.
  Read the target repository from the request URL or REST `base.repo`.
  If the installed CLI does not expose a field, use its REST/GraphQL API.
- Find an existing request by source repository/branch and target before creating.
- Create: `gh pr create --repo <target> --head <source> --base <target-branch> --title <title> --body-file <file>`.
- Update: `gh pr edit <url> --body-file <file>`.
- Read all pages of inline review threads and replies through GraphQL, plus
  review summaries and general comments. `gh pr view --comments` alone is incomplete.
- Read checks with `gh pr checks <url>` and inspect branch/ruleset approval rules.
  REST alternatives: `repos/<owner>/<repo>/pulls/<number>`,
  `repos/<owner>/<repo>/commits/<sha>/check-runs`, and commit status endpoints.

GitLab:

- Read: `glab mr view <iid> --repo <target-url> --output json` or
  `glab api --hostname <host> projects/<project>/merge_requests/<iid>`.
- Inspect `source_project_id`, `target_project_id`, `source_branch`, `target_branch`,
  `sha`, `diff_refs`, `state`, `draft`, `detailed_merge_status`, `head_pipeline`,
  approval and discussion state, and automatic-merge state supported by the server.
- Find existing MRs using `glab mr list --source-branch <branch> --repo <target-url>`;
  confirm source project and target branch to distinguish forks.
- Create: `glab mr create --repo <target-url> --source-branch <branch> --target-branch <target-branch> --title <title> --description-file <file> --yes`.
  For forks add `--head <source-project>`. Do not add `--auto-merge` in full-stop.
- Update: `glab mr update <iid> --repo <target-url> --description-file <file>`.
- Read every page of `projects/<project>/merge_requests/<iid>/discussions?per_page=100`
  and `/notes?per_page=100` with `glab api --paginate`. Include all replies and
  unresolved resolvable notes, even those on an older diff.
- Read `/approval_state` and `/approvals` for approval requirements where supported.
  An unavailable endpoint or absent field is not evidence that approvals passed;
  verify edition-specific policy and merge status instead.
- Read `/pipelines` for the MR, then the relevant pipeline and its jobs (including
  downstream/child pipelines where required). Confirm it covers the current head.
  A merged-results pipeline can have a synthetic SHA: verify its relationship to
  the source and target heads rather than assuming it is stale or current.

Keep descriptions in files and use the CLI file flags. For API mutations use
structured fields or a JSON body file with `--input`, not interpolated shell text.
In T3 Code, immediately call `link_pull_request` with the full URL after creating,
taking over, or pushing each PR/MR. Report a linking failure without duplicating
request creation.

## Reply and resolve

Use the leaving-pr-comments skill for authorized replies. Verify findings against
current code; preserve real outstanding issues across pushes. Reply in the actual
thread, then resolve only after successful posting and verify the resolved state.
Do not resolve genuine objections merely to clear a gate.

GitHub uses GraphQL review-thread replies/resolution for inline feedback; general
PR comments and review summaries are different objects. Paginate connections.
GitLab uses:

- Reply: `POST projects/<project>/merge_requests/<iid>/discussions/<discussion-id>/notes`
  with a `body` field.
- Resolve: `PUT projects/<project>/merge_requests/<iid>/discussions/<discussion-id>`
  with boolean `resolved=true`, only for resolvable discussions.

Do not post to YouTrack, even when a PR/MR links an issue there.

## Readiness and merge

Fetch the actual target remote and branch before the final check. Verify the live
head still matches the locally verified commit, all required checks/pipelines and
human approvals pass, all actionable discussions are addressed, no human requests
changes, and the request is open and ready. Required manual jobs, pending checks,
unknown mergeability and missing access are not green. If CI is not configured,
confirm that fact and report the local proof; do not invent a pipeline result.
Approval can be reset by a push or rebase; re-read it after the final change.

GitHub: inspect branch policy, checks and reviews on the latest head. Merge only
under full-send or another explicit merge authorization, using the repository's
allowed strategy and `--match-head-commit <verified-sha>`. Never `--admin`.

GitLab: require `detailed_merge_status=mergeable` plus verified pipeline,
approval and discussion state. `checking`, `unchecked`, `approvals_syncing`,
`not_approved`, `ci_still_running`, `ci_must_pass`, `conflict`, and
`discussions_not_resolved` are not ready. Use project settings/recent merges to
choose the strategy. Under merge authorization only, use
`glab mr merge <iid> --repo <target-url> --sha <verified-sha> --auto-merge=false --yes`
with the appropriate strategy flags. If project policy requires a merge train,
use its supported train/auto-merge operation instead; never bypass it.

After any merge/queue operation, re-read the request until the host confirms
`merged`; a successful enqueue or enabled auto-merge is not a completed merge.
Record the merge/squash SHA actually returned by the host.

### Full-stop: prevent automatic merging

Before work and before each push, and again at handoff:

- GitHub: inspect automatic merge and queue state. Disable existing auto-merge
  with `gh pr merge <url> --disable-auto`; remove an existing queue entry using
  GitHub's dequeue operation. Re-read both states. Never call an ordinary merge
  command or `--auto` while running full-stop.
- GitLab: inspect auto-merge and merge-train membership. Cancel existing auto-merge
  using `POST projects/<project>/merge_requests/<iid>/cancel_auto_merge` on servers
  supporting it. On older servers use `/cancel_merge_when_pipeline_succeeds` and
  inspect its response body: HTTP 201 alone can contain `status=error`.
  Cancellation also removes a queued MR from its merge train; verify that through
  the MR/train API. Use the server's documented train removal endpoint if needed.
  Never call `glab mr merge` to disable automatic merging: it is a merge operation,
  and the CLI defaults to enabling auto-merge when CI is running.

If you cannot verify automatic merging is disabled, stop before editing or pushing
and report the blocker. Full-stop never authorizes merging, a queue/train entry,
or a push to the target/default branch, including through a delegate.

## Monitoring

Handle current feedback and failures before waiting. Use one watcher per request.
In T3 Code, the owning parent thread uses `watch_pull_request` with the full URL
if the host is supported, then ends the turn. Delegated reviewers never watch.
Do not re-register an existing watch on every wake. Re-check the live gate after
an event; unwatch before a ready/blocked handoff or question. A missing/unsupported
watcher must not be described as active.

Outside T3 Code, or if its watcher does not support this host:

- GitHub: bundled `babysit-pr/scripts/pr-wait` is GitHub-only. Use `green` if no
  supported gating bot is configured, and inspect review/discussion state yourself.
  `ready` assumes Greptile/Macroscope; its exit status never replaces the merge gate.
- GitLab: use `glab ci status --repo <pipeline-project-url> --branch <source-branch> --wait`
  for CI when that command selects the MR's relevant pipeline. Otherwise use an
  available pipeline watcher pinned to the verified pipeline ID. Always re-read
  MR pipelines, head, approvals and discussions afterward: branch CI alone does
  not prove merged-results or review completion. Use the harness's supported
  background execution for long waits; do not keep a tool call blocking chat.
- A CI waiter does not monitor review comments or approvals. If review/merge-train
  progress remains pending and there is no supported host-aware event watcher,
  report that monitoring limitation and hand off the open request as waiting or
  blocked. Never claim unattended monitoring or readiness, silently stop, or spin
  a custom polling/sleep loop.

## Authoritative references

Consult installed CLI help for flags and the deployed host version for API support:

- https://cli.github.com/manual/gh_pr
- https://docs.gitlab.com/cli/mr/
- https://docs.gitlab.com/api/merge_requests/
- https://docs.gitlab.com/api/merge_request_approvals/
- https://docs.gitlab.com/api/discussions/
- https://docs.gitlab.com/api/merge_trains/
