# Ventures Domain Template

**Domain:** ventures/
**Purpose:** Businesses with revenue intent

---

## Structure

```
ventures/
└── [name]/           # Each venture is a subdomain
    ├── .claude/
    │   └── CLAUDE.md # Identity
    ├── _brain/
    │   ├── status.md
    │   ├── tasks.md
    │   ├── insights.md
    │   ├── changelog.md
    │   └── manifest.json
    ├── _working/     # Drafts
    └── [areas]/      # Organizational folders
```

---

## Venture Types (ICP Templates)

### Agency

Client work, deliverables, retainers.

```
ventures/[name]/
├── clients/          # Client projects
├── templates/        # Reusable deliverables
├── operations/       # SOPs, processes
└── pipeline/         # Leads, proposals
```

### Creator

Content, courses, community.

```
ventures/[name]/
├── content/          # By platform (twitter/, youtube/, etc.)
├── products/         # Courses, digital products
├── community/        # Resources for community
└── funnel/           # Sales assets
```

### E-commerce

Products, inventory, fulfillment.

```
ventures/[name]/
├── products/         # Inventory
├── suppliers/        # Vendor info
├── marketing/        # Campaigns
└── operations/       # Fulfillment
```

### Job

Employment brought into ALIVE.

```
ventures/[name]/
├── projects/         # Work projects
├── docs/             # Documentation
├── meetings/         # Notes
└── growth/           # Career development
```

### Custom

Generic starting point.

```
ventures/[name]/
├── .claude/
├── _brain/
└── _working/
```

---

## CLAUDE.md Template

```markdown
# [Venture Name]

**Type:** [Agency | Creator | E-commerce | Job | Custom]
**Phase:** [Starting | Building | Launching | Growing | Maintaining]
**Created:** [DATE]

---

## What This Is

[One paragraph: What is this venture? What does it do?]

---

## Goal

[Single sentence: What is this venture trying to achieve?]

---

## Stakeholders

- [Founder/Owner]
- [Team members]
- [Key partners]

---

## State

Everything current lives in `_brain/`:
- `status.md` — Phase and focus
- `tasks.md` — Work queue
- `insights.md` — Learnings
- `changelog.md` — History
- `manifest.json` — Structure map

Drafts live in `_working/`.
```

---

## status.md Template

```markdown
# Status

**Phase:** Starting
**Updated:** [DATE]

## Current Focus
[What are we working on RIGHT NOW?]

## Blockers
None yet.

## Next Milestone
[What does "done" look like for this phase?]
```

---

## tasks.md Template

```markdown
# Tasks

## Urgent
(none yet)

## Active
(none yet)

## To Do
- [ ] Define initial scope
- [ ] Set first milestone
- [ ] Identify key stakeholders

## Done (Recent)
- [x] Created subdomain ([DATE])
```

---

## manifest.json Template

```json
{
  "name": "[Venture Name]",
  "type": "subdomain",
  "description": "[One sentence description]",
  "goal": "[Single sentence goal]",
  "created": "[DATE]",
  "updated": "[DATE]",
  "session_id": "[current-session]",
  "folders": ["_brain", "_working"],
  "areas": [],
  "files": [],
  "working_files": [],
  "sessions": []
}
```

---

## Notes

- Every venture must have revenue intent (even if future)
- Reference people from life/people/, don't duplicate
- When complete, archive to archive/ventures/[name]/
