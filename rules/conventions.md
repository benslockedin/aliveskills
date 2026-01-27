# Conventions

File naming, _brain files, and manifest schema.

---

## Directory Structure

```
project/
├── .claude/
│   ├── CLAUDE.md         # System identity
│   ├── state/            # System logs (session-log, file-changes)
│   ├── rules/            # Behavioral rules
│   ├── hooks/            # Hook scripts
│   └── templates/        # Scaffolding templates
├── archive/              # Inactive (mirrors structure)
├── inbox/                # Incoming context, triage
├── life/                 # Personal — always has people/
│   └── people/           # All people (source of truth)
├── ventures/             # Revenue-generating
│   └── [name]/           # Subdomain
└── experiments/          # Testing grounds
    └── [name]/           # Subdomain
```

---

## Subdomains vs Areas

| | Subdomain | Area |
|---|-----------|------|
| Has `.claude/` | Yes | No |
| Has `_brain/` | Yes | No |
| Has `_working/` | Yes | No |
| Identity file | `.claude/CLAUDE.md` | `README.md` |
| Example | `ventures/acme/` | `ventures/acme/clients/` |

**Subdomains** are projects with their own state.
**Areas** are organizational folders within subdomains.

---

## Nested _brain/ (Sub-Projects)

Sub-projects are containers WITHIN a subdomain that have their own lifecycle. They get their own `_brain/`.

**The rule:** If it can be started, paused, or completed independently — it gets `_brain/`.

| Container | Gets _brain/? | Why |
|-----------|---------------|-----|
| `ventures/agency/` | Yes | Subdomain |
| `ventures/agency/clients/bigco/` | Yes | Independent lifecycle (can be "done") |
| `ventures/agency/clients/` | No | Organizational folder (area) |
| `ventures/agency/brand/` | No | Organizational folder (area) |
| `ventures/shop/campaigns/summer/` | Yes | Independent lifecycle |
| `ventures/shop/products/` | No | Organizational folder |

**When creating sub-projects:**
1. Create `_brain/` with status.md, tasks.md, insights.md, changelog.md, manifest.json
2. Create `_working/` for drafts
3. Log creation in parent's `_brain/changelog.md`
4. Update parent's `_brain/manifest.json`

Use `/alive:new` to create sub-projects properly.

---

## _brain/ Files

Every subdomain has `_brain/` with these files:

| File | Purpose | Update frequency |
|------|---------|------------------|
| `status.md` | Current phase and focus | When phase changes |
| `tasks.md` | Work queue | Frequently |
| `insights.md` | Learnings worth remembering | When learned |
| `changelog.md` | Session history + decisions | Every session |
| `manifest.json` | Structure map with file summaries | On file changes |

### status.md

```markdown
# Status

**Phase:** [Starting | Building | Launching | Growing | Maintaining]
**Updated:** [DATE]

## Current Focus
[What are we working on RIGHT NOW? Be specific.]

## Blockers
[What's stopping progress? "None" if clear.]

## Next Milestone
[What does "done" look like for this phase?]
```

### tasks.md

```markdown
# Tasks

## Urgent
- [ ] Critical task @urgent

## Active
- [~] Currently working on this

## To Do
- [ ] Not yet started

## Done (Recent)
- [x] Completed task (2026-01-23)
```

**Markers:**
- `[ ]` — Not started
- `[~]` — In progress
- `[x]` — Done
- `@urgent` — Priority flag

### insights.md

```markdown
# Insights

## 2026-01-23 — Insight Title

**Category:** [market | product | process | people | technical]
**Learning:** The insight itself
**Evidence:** How we know this
**Applies to:** Where this matters

---
```

### changelog.md

```markdown
# Changelog

## 2026-01-23 — Session Summary
**Session:** abc123-def456

### Changes
- What was done

### Decisions
- **Decision name:** What was decided. Why. What was rejected.

### Next
- What's coming

---
```

**Note:** decisions.md is removed. Decisions live in changelog with the `### Decisions` section.

---

## Manifest Schema

```json
{
  "name": "Project Name",
  "type": "subdomain",
  "description": "One sentence description",
  "goal": "Single sentence goal",
  "created": "2026-01-20",
  "updated": "2026-01-23",
  "session_id": "last-session-id",

  "folders": ["_brain", "_working", "clients", "content"],

  "areas": [
    {
      "path": "clients/",
      "description": "Active client projects",
      "has_subdomains": false
    }
  ],

  "files": [
    {
      "path": "_brain/status.md",
      "summary": "Building phase, landing page launch Friday",
      "sessions": ["abc123", "def456"],
      "modified": "2026-01-23"
    },
    {
      "path": "clients/acme/contract.pdf",
      "summary": "MSA with Acme, $50k retainer, expires March 2026",
      "sessions": ["xyz789"],
      "modified": "2026-01-10",
      "key": true
    }
  ],

  "working_files": [
    {
      "path": "_working/landing-v0.html",
      "summary": "Draft landing page with hero, features, pricing",
      "sessions": ["abc123", "def456", "ghi789"],
      "created": "2026-01-20",
      "modified": "2026-01-23"
    }
  ],

  "sessions": ["abc123", "def456", "ghi789"]
}
```

**Key fields:**
- `type` — Always "subdomain" for subdomains
- `goal` — Single-sentence goal for filtering decisions
- `sessions` — Array of all session IDs that touched this subdomain
- `summary` (on files) — AI-generated one-liner
- `sessions` (on files) — Session IDs that touched this file
- `key: true` (on files) — Mark important files

---

## File Naming

### _working/ Files

Pattern: `[subdomain]_[context]_[name].ext`

```
ventures/acme/_working/
├── acme_landing-page-draft.md        ✓
├── acme_client_proposal-v1.md        ✓
├── landing-page-draft.md             ✗ (no context)
```

**Rule:** Anyone reading the filename should know where it belongs.

### Versioning

| Stage | Location | Example |
|-------|----------|---------|
| v0.x | `_working/` | `acme_landing-v0.html` |
| v1-draft | Area folder | `content/landing-v1-draft.html` |
| v1 | Area folder | `content/landing-v1.html` |

Promote from _working/ when draft is complete.

---

## System Logs

System-wide logs live in `.claude/state/`:

| File | Purpose |
|------|---------|
| `session-log.jsonl` | Session start/end events |
| `file-changes.jsonl` | Audit trail of all file edits |
| `commit-log.jsonl` | Explicit context saves |

Format: JSON Lines (one JSON object per line, append-friendly).

---

## Archive

When something is done, move to `archive/[original-path]`:

```
Active:   ventures/acme/clients/globex/
Archived: archive/ventures/acme/clients/globex/
```

Archive mirrors the working structure.

---

## People

Source of truth for people is `life/people/`.

Other subdomains reference, don't duplicate:

```markdown
# In ventures/acme/clients/globex/README.md

Key Contact: John Smith
See: life/people/john-smith.md
```
