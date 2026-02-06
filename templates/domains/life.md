# Life Domain Template

**Domain:** 02_Life/
**Purpose:** Personal responsibilities — life first, always

---

## Structure

```
02_Life/
├── people/           # Source of truth for all people
│   └── [name].md     # Person files
└── [area]/           # Life areas (health, finance, etc.)
    ├── .claude/
    │   └── CLAUDE.md
    ├── _brain/
    │   ├── status.md
    │   ├── tasks.md
    │   ├── insights.md
    │   ├── changelog.md
    │   └── manifest.json
    ├── _working/
    └── _references/
```

---

## people/ Directory

The `people/` folder is the source of truth for all people across ALIVE. Other domains reference people here, they don't duplicate them.

### Person File Template

```markdown
# [Name]

**Role:** [What they do]
**Company:** [Where they work]
**Relationship:** [How you know them]
**Last Contact:** [Date]

---

## Context

[How you met, key background]

---

## Notes

- [Relevant notes about this person]

---

## Links

- 04_Ventures/[project]/clients/[company] — Client relationship
- 04_Ventures/[project]/partners/[company] — Partnership
```

---

## Life Area Template

For health, finance, relationships, etc.

### CLAUDE.md

```markdown
# [Area Name]

**Type:** Life Area
**Created:** [DATE]

---

## What This Is

[One paragraph: What is this area about?]

---

## Key Practices

- [Regular activities]
- [Habits]
- [Routines]

---

## State

Everything current lives in `_brain/`:
- `status.md` — Current focus
- `tasks.md` — What needs doing
- `insights.md` — Learnings
- `changelog.md` — History
```

### status.md

```markdown
# Status

**Phase:** [Maintaining | Improving | Crisis | Growing]
**Updated:** [DATE]

## Current Focus
[What's the priority right now?]

## Blockers
None.

## Next Milestone
[What does progress look like?]
```

---

## Common Life Areas

| Area | Purpose |
|------|---------|
| health/ | Physical and mental health |
| finance/ | Money, investments, budgets |
| relationships/ | Family, friends, community |
| growth/ | Learning, skills, development |
| home/ | Living space, maintenance |

---

## Notes

- Life areas are optional — create only what you need
- people/ is always present (source of truth for all people)
- Life first, always — this domain takes priority
