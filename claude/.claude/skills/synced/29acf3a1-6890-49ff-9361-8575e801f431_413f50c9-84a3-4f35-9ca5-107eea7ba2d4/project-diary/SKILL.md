---
name: project-diary
description: Use this skill whenever someone at Sensory-Minds posts a narrative update about a running project — weekly or monthly check-ins, post-release recaps, retrospectives, milestone summaries, sprint wrap-ups, or any freeform "here's where the project stands" dump from a project manager or business unit director. Trigger phrases include "diary entry for [project]", "weekly update on", "log this for [project]", "monthly status of", "post-release notes", "retro on", "after the release of", and any free-form description of project progress, risks, team changes, achievements, or upcoming work that should be recorded. Trigger this skill even if the user doesn't say the word "diary" — if they are describing what happened on a project in a way that is meant to be recorded as a status entry, this is the skill. Do not trigger for one-off questions about a project, for meeting notes, or for client-facing communications — only for the internal project diary log.
---

# Project Diary

Capture a freeform project update from a PM or BUD, structure it into a four-chapter entry, and post it to the **Project Diary** database in Notion.

## What you're producing

A single Notion page in the Project Diary database with:

- **Name** (title): a short, descriptive entry title
- **RAG** (status): inferred from the update — one of `On Track`, `At Risk`, `Critical`, `Paused`, `Complete`
- **⭐ Projects** (relation): linked to the matching project in the Projects database
- **Page body**: four H2 sections — Risks, Team, Achievements & decisions, Upcoming

## Fixed database references

Hardcoded — do not guess or re-derive these:

- Project Diary data source ID: `367330a1-9630-8060-a2b3-000b28b7bbb1`
- Projects data source ID: `1c10836d-56da-4058-b93a-7380dee0e1e2`
- Projects data source URL (for search): `collection://1c10836d-56da-4058-b93a-7380dee0e1e2`

## Workflow

### 1. Identify the project

Read the update. The project may be named explicitly ("the JTI Connect rollout", "Acme Portal v2") or referenced loosely ("our retro from Tuesday", "this sprint"). Use `Notion:notion-search` scoped to the Projects data source:

```
query: <the project name or distinctive keywords from the update>
data_source_url: collection://1c10836d-56da-4058-b93a-7380dee0e1e2
```

- **One clear match** → use it.
- **Multiple plausible matches** → ask the user which one, listing the candidates with their phase/business unit so they can pick at a glance.
- **No match** → ask which project this is for. Do not auto-create a project record; that's out of scope for this skill.

### 2. Determine RAG status

Read the whole update and pick one. Be honest — if the tone is rosy but the facts say otherwise, pick what the facts support and say why before writing the page. The RAG column is decision-support; an inaccurate green hurts the user.

- **On Track** — milestones being hit, no blocking issues, scope and team stable, risks are routine and being managed.
- **At Risk** — meaningful concerns have surfaced (slipping dates, dependency risk, capacity gaps, scope pressure, quality concerns) but still recoverable with adjustment.
- **Critical** — delivery, budget, client relationship, or quality is in real jeopardy; needs intervention or escalation; existing mitigations aren't holding.
- **Paused** — work has stopped or is on hold (client pause, deprioritisation, awaiting input). Use only if explicitly stated.
- **Complete** — the project is finished. Use only if the update is unambiguously a wrap.

When signals are mixed, lean toward the more cautious status (At Risk over On Track, Critical over At Risk) and note what tipped you in the confirmation message.

### 3. Structure the four chapters

Reorganise everything the user wrote into these four H2 sections, in this order:

```markdown
## Risks
What might go wrong and what's being done about it.

## Team
Who's involved this period; capacity or people changes.

## Achievements & decisions
What got done, what got decided.

## Upcoming
What's planned before the next entry.
```

**Preserve the user's voice.** Do not paraphrase into generic agency-speak — keep their phrasing, tone, and specifics (names, numbers, dates). Fix obvious typos. Where the user covered a topic that maps cleanly to a section, drop it in that section. Where they covered something cross-cutting (e.g. "Maria's leaving has slowed code review which is why the sprint slipped"), split the relevant beats across the right sections — team change in Team, slipped sprint in Risks or Achievements depending on where it landed.

If a section has nothing in the update, write a short honest line — `_Nothing notable this period._` — rather than inventing content.

If the user described risks without mitigations, or "upcoming" without owners or dates, leave their gaps as gaps and flag them in the confirmation. Don't paper over with plausible-sounding filler.

### 4. Title the entry

Default: `<Project name> — <YYYY-MM-DD>` using today's date.

Override when the update is clearly tied to a named milestone or event:

- Generic weekly check-in → `Acme Rollout — 2026-05-22`
- Post-release recap → `Acme Rollout — v2.1 Release`
- Sprint retrospective → `Acme Rollout — Sprint 14 Retro`
- Quarterly review → `Acme Rollout — Q2 Review`

Match the language of the update — German update gets a German-style title, English update gets English. Don't translate.

### 5. Create the page

Call `Notion:notion-create-pages` with:

```json
{
  "parent": { "data_source_id": "367330a1-9630-8060-a2b3-000b28b7bbb1" },
  "pages": [{
    "properties": {
      "Name": "<title from step 4>",
      "RAG": "<exact status string from step 2>",
      "⭐ Projects": "[\"<matched project page URL>\"]"
    },
    "content": "<the four H2 sections from step 3>"
  }]
}
```

Notes on the call:
- `RAG` must be exactly one of `"On Track"`, `"At Risk"`, `"Critical"`, `"Paused"`, `"Complete"` — case-sensitive.
- `⭐ Projects` is a relation and takes a **JSON-encoded string** containing an array of page URLs (this is how the Notion MCP serialises relation properties).
- The property name `⭐ Projects` includes the star emoji and a space — keep it exact.
- Don't put the title inside the `content` field — Notion renders the title from the property automatically.

### 6. Confirm back to the user

Reply with a tight summary:

- Matched project name
- Chosen RAG status + one-line reason
- Link to the new page
- Any gaps you noticed (missing mitigations, undefined "upcoming", capacity questions left open) so they can decide whether to add more

Keep this short. The person is busy and just wanted the entry logged.

## Defaults and edge cases

- **User wants to review before posting** — if they say "draft this first", "let me see it", "show me before you save", present the structured entry inline and only call `notion-create-pages` after they confirm.
- **Two-sentence update** — still post. Use the four sections honestly; thin sections are fine. Note the slim coverage in your confirmation.
- **Multiple projects mentioned in one update** — ask whether to split into separate entries or pick the primary one. Don't silently merge.
- **Client-confidential or restricted-client material in the dump** — the org-level AI usage policy already handles flagging. If that fires, surface it before posting; don't proceed silently.
- **No date given but user says "this week"** — use today's date.
- **Wrap-up update that sounds Complete but project is mid-flight** — confirm with the user before setting `Complete`; it's a one-way signal in practice.

## What not to do

- Don't auto-create a Project record if the project isn't in the database. Ask.
- Don't rewrite the user's wording into neutral agency tone. Keep their voice.
- Don't pad empty sections with fluff.
- Don't pick a softer RAG to be polite. Pick what the facts support.
- Don't add fields the schema doesn't have (no priority, no due dates, no tags) — the four properties listed above are the entire surface.

## Example (compressed)

User writes:
> Quick weekly on the Acme portal rebuild. Sprint 14 closed Friday — we shipped the SSO migration on time and finally killed the legacy session service. Big one. Marco onboarded as second backend, so capacity is back to normal after Lena's parental leave. Worry: client's new procurement contact is pushing back on the Phase 2 scope we already signed off, could blow up if not handled this week. Next: I'm meeting their CTO Thursday to lock scope, and the team starts Phase 2 spike on the new analytics module.

Output (page body):

```markdown
## Risks
Client's new procurement contact is pushing back on the Phase 2 scope we already signed off — could blow up if not handled this week.

## Team
Marco onboarded as second backend. Capacity back to normal after Lena's parental leave.

## Achievements & decisions
Sprint 14 closed Friday. Shipped the SSO migration on time. Finally killed the legacy session service.

## Upcoming
Meeting client CTO Thursday to lock Phase 2 scope. Team starts Phase 2 spike on the new analytics module.
```

Status: **At Risk** — Phase 2 scope pushback from a new procurement contact on an already-signed scope is a meaningful and time-boxed risk; the rest is healthy but the scope dispute is the dominant signal.

Title: `Acme Portal Rebuild — 2026-05-22`

Confirmation back to user: project matched, RAG reason, page link, and a flag that the scope-pushback risk has no mitigation other than the Thursday meeting — worth noting fallback if the meeting goes badly.
