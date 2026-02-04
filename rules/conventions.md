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
├── 01_Archive/           # Inactive (mirrors structure)
├── 02_Life/              # Personal — always has people/
│   └── people/           # All people (source of truth)
├── 03_Inputs/            # Incoming context, triage
├── 04_Ventures/          # Revenue-generating
│   └── [name]/           # Entity
└── 05_Experiments/       # Testing grounds
    └── [name]/           # Entity
```

---

## Entities vs Areas

| | Entity | Area |
|---|--------|------|
| Has `.claude/` | Yes | No |
| Has `_brain/` | Yes | No |
| Has `_working/` | Yes | No |
| Identity file | `.claude/CLAUDE.md` | `README.md` |
| Example | `04_Ventures/acme/` | `04_Ventures/acme/clients/` |

**Entities** are projects with their own state.
**Areas** are organizational folders within entities.

---

## Nested Entities (Sub-Projects)

Sub-projects are containers WITHIN an entity that have their own lifecycle. They get their own `_brain/` AND their own `_working/`.

**The rule:** If it can be started, paused, or completed independently — it gets `_brain/` and `_working/`.

| Container | Gets _brain/? | Gets _working/? | Why |
|-----------|---------------|-----------------|-----|
| `04_Ventures/agency/` | Yes | Yes | Entity |
| `04_Ventures/agency/clients/bigco/` | Yes | Yes | Independent lifecycle (can be "done") |
| `04_Ventures/agency/clients/` | No | No | Organizational folder (area) |
| `04_Ventures/agency/brand/` | No | No | Organizational folder (area) |
| `04_Ventures/shop/campaigns/summer/` | Yes | Yes | Independent lifecycle |
| `04_Ventures/shop/products/` | No | No | Organizational folder |

**Nested entity structure:**
```
04_Ventures/agency/clients/bigco/
├── _brain/           ← Sub-project state
│   ├── status.md
│   ├── tasks.md
│   └── ...
├── _working/         ← Sub-project drafts (NOT in parent's _working/)
│   └── proposal-v0.md
```

**WRONG:** `04_Ventures/agency/_working/clients/bigco/proposal.md`
**RIGHT:** `04_Ventures/agency/clients/bigco/_working/proposal.md`

**When creating sub-projects:**
1. Create `_brain/` with status.md, tasks.md, insights.md, changelog.md, manifest.json
2. Create `_working/` for drafts (at sub-project level, not parent)
3. Log creation in parent's `_brain/changelog.md`
4. Update parent's `_brain/manifest.json`

Use `/alive:new` to create sub-projects properly.

---

## _brain/ Files

Every entity has `_brain/` with these files:

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
  "type": "entity",
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
- `type` — Always "entity" for entities
- `goal` — Single-sentence goal for filtering decisions
- `sessions` — Array of all session IDs that touched this entity
- `summary` (on files) — AI-generated one-liner
- `sessions` (on files) — Session IDs that touched this file
- `key: true` (on files) — Mark important files

---

## File Naming

### _working/ Files

Pattern: `[entity]_[context]_[name].ext`

```
04_Ventures/acme/_working/
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

**NEVER DELETE. ALWAYS ARCHIVE.**

Files should never be deleted from ALIVE. Always move to archive instead. This preserves history and allows recovery.

When something is done, move to `01_Archive/[original-path]`:

```
Active:   04_Ventures/acme/clients/globex/
Archived: 01_Archive/04_Ventures/acme/clients/globex/
```

Archive mirrors the working structure.

**When cleaning up processed files:**
```bash
# Wrong
rm -rf 03_Inputs/old-files/

# Right
mv 03_Inputs/old-files/ 01_Archive/03_Inputs/2026-02-04-cleanup/
```

**Protected files:** Never delete or archive these special files:

| File | Location | Purpose |
|------|----------|---------|
| `Icon` or `Icon\r` | Domain root folders (`01_Archive/`, `02_Life/`, etc.) | macOS folder icons |
| `.DS_Store` | Any folder | macOS folder metadata |

These are system files that should be ignored, not processed or moved.

---

## People

Source of truth for people is `02_Life/people/`.

Other entities reference, don't duplicate:

```markdown
# In 04_Ventures/acme/clients/globex/README.md

Key Contact: John Smith
See: 02_Life/people/john-smith.md
```

---

## Third-Party Skill Overrides

When using third-party skills (like superpowers), ALIVE conventions take precedence.

### Plan File Locations

**Override for `superpowers:brainstorming` and `superpowers:writing-plans`:**

| Skill Default | ALIVE Override |
|---------------|----------------|
| `docs/plans/` | `_working/plans/` |
| `{root}/docs/plans/` | `{entity}/_working/plans/` |

**Why:** Plans are work-in-progress until approved. WIP files belong in `_working/`, not permanent documentation folders.

```
# Wrong (superpowers default)
~/alive/docs/plans/feature-plan.md

# Right (ALIVE override)
~/alive/04_Ventures/acme/_working/plans/feature-plan.md
```

**When brainstorming/planning:**
1. Create plans in `{current-entity}/_working/plans/`
2. Once approved and implemented, promote to appropriate location or archive
3. Never create `docs/plans/` at the ALIVE root

### General Override Principle

**Before ANY skill creates files, ALWAYS check:**

1. **Am I in an ALIVE entity?** — Check for `_brain/` folder
2. **Does this content fit somewhere in ALIVE structure?**
   - Plans/specs/designs → `{entity}/_working/plans/`
   - Drafts → `{entity}/_working/`
   - Completed docs → appropriate area within entity
   - Session artifacts → `{entity}/_working/sessions/`
3. **Use ALIVE folder conventions** — Numbered domains, `_brain/`, etc.

**This applies to ALL skills including:**
- `superpowers:brainstorming` → `_working/plans/`
- `superpowers:writing-plans` → `_working/plans/`
- Any skill that outputs documents, specs, or artifacts

**Never create orphan files at:**
- ALIVE root (`~/alive/`)
- Random `docs/` folders outside entities
- `/tmp/` or scratchpad (unless truly temporary)

**The question to ask:** "Where in this entity's structure does this file belong?"
