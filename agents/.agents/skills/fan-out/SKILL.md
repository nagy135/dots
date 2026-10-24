---
name: fan-out
description: Run three or more independent attempts at the same task; combine research or show separate implementation variants.
---

# Fan out

- Use the optional task after `$fan-out` or `/fan-out`; otherwise use the active conversation task. Clarify only if the task is unclear.
- Spawn three child agents by default, more if requested. Give each the same complete task, context, constraints, and success criteria. Keep attempts independent; do not split the task or recursively fan out.
- Follow the host's delegation rules and inherit model settings unless specified. In T3 Code, use delegated tasks, not top-level threads. Run concurrently where possible; report unavailable delegation or failed attempts honestly.
- **Research:** Each agent returns its answer, evidence, and uncertainties. Wait for all results, check important disagreements against evidence, and combine findings into one concise summary with sources and remaining uncertainty.
- **Implementation:** Assign each agent a separate worktree, copy, or output directory from the same baseline, including relevant uncommitted inputs. Require a complete variant with its location, approach, validation results, and limitations. Keep shared external actions with the parent and within existing authorization.
- Inspect all results. For implementation, show every variant separately with links or paths, differences, and validation; finish with a comparison and recommendation. Preserve variants for review. Integrate only if requested, retaining the originals.
