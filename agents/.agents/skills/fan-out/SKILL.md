---
name: fan-out
description: Run the same task independently with three or more agents, synthesize research, or present separate implementation variants. Use when the user invokes fan-out or requests multiple independent attempts at the same task.
---

# Fan out

## Choose the task

- Accept an optional free-form task after `$fan-out` (or `/fan-out`). With no argument, use the active task from the conversation, including its latest corrections and constraints. Ask one concise clarification only if no task can be identified or several are equally plausible.
- Default to three child agents; the parent does not count. Honor a requested larger count. Launch at least three independent attempts at the **same complete task**, rather than dividing it into complementary subtasks. Different approaches or research angles are welcome, but every agent must deliver a complete answer or solution.
- Preserve the user's scope and permissions. Invoking this skill authorizes delegation, not additional external actions.

## Launch independent attempts

- Prepare a common brief with the task, relevant context and inputs, constraints, success criteria, and expected deliverable. Give every child the same essential information. Label attempts A, B, C, and so on, and retain their task IDs and artifact locations.
- Use available child-agent tools and follow the host's provider, model, option, and isolation rules. In T3 Code, use delegated tasks rather than creating top-level conversations. Inherit the current model and options unless the user requests otherwise. Do not recursively invoke fan-out in the children.
- Keep attempts independent until they return: do not seed one with another's conclusions. Tell children to return their own result, evidence, uncertainties, and validation. The parent coordinates and evaluates instead of replacing the requested child attempts with its own work.
- Run concurrently where capacity permits; queue remaining attempts if necessary. If delegation is unavailable, state the limitation instead of simulating agents. Retry or replace failed attempts only when the failure appears recoverable; report any missing results without claiming the full fan-out completed.

## Research, analysis, and review

- Have each agent investigate the whole question independently and return a concise conclusion, supporting sources or file references, reasoning, and unresolved questions. Use read-only access for research and review.
- Wait for all attempts to reach a terminal state, inspect their actual outputs, and reconcile them. Check material disagreements against the underlying evidence; agreement between agents alone is not verification. Deduplicate findings and distinguish established facts from inference.
- Present one coherent summary answering the task, with useful citations, meaningful disagreements, and remaining uncertainty. Briefly identify what each attempt contributed when it helps explain the synthesis; do not concatenate three repetitive reports.

## Implementation and other artifact-producing tasks

- Have every agent implement its own complete variant. Before launching, assign a separate workspace and output location to each attempt, and include those locations in its brief. Never let competing variants edit the same files.
- For code, use separate worktrees or isolated copies from the same baseline. Use host-managed worktree isolation when available. Check whether the task depends on uncommitted files: worktrees normally start from committed state, so explicitly supply the relevant patch and new files to every attempt or use isolated copies that include them. Preserve unrelated local changes.
- For documents, designs, generated files, or other artifacts, give each attempt a distinct directory or filename. Isolate builds, generated outputs, and previews too when they would otherwise collide.
- Each child must return the variant's location, a brief explanation of its approach, exact validation performed and results, and any limitations. Require concrete, inspectable deliverables rather than descriptions of planned work.
- Keep shared external actions with the parent. Children should prepare local variants or drafts, not independently publish, deploy, send messages, or update the same remote resource. Perform an authorized shared action once, after comparison; if the action itself cannot be isolated, keep the variants as reviewable drafts.
- Inspect every variant and present **each separately** with its label, links or paths, differences, and validation results. Finish with a concise comparison and recommendation. Preserve all variants for inspection; do not silently merge, discard, or choose one on the user's behalf. If the user also requested an integrated result, produce it after comparison while retaining the separate variants.
