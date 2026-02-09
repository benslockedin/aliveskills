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
| Has `_references/` | Yes | No |
| Identity file | `.claude/CLAUDE.md` | `README.md` |
| Example | `04_Ventures/acme/` | `04_Ventures/acme/clients/` |

**Entities** are projects with their own state.
**Areas** are organizational folders within entities.

---

## Nested Entities

Sub-entities are containers WITHIN an entity that have their own lifecycle. They get their own `_brain/`, `_working/`, and `_references/`.

**The rule:** If it can be started, paused, or completed independently — it gets `_brain/`, `_working/`, and `_references/`.

| Container | Gets _brain/? | Gets _working/? | Gets _references/? | Why |
|-----------|---------------|-----------------|---------------------|-----|
| `04_Ventures/agency/` | Yes | Yes | Yes | Entity |
| `04_Ventures/agency/clients/bigco/` | Yes | Yes | Yes | Independent lifecycle (can be "done") |
| `04_Ventures/agency/clients/` | No | No | No | Organizational folder (area) |
| `04_Ventures/agency/brand/` | No | No | No | Organizational folder (area) |
| `04_Ventures/shop/campaigns/summer/` | Yes | Yes | Yes | Independent lifecycle |
| `04_Ventures/shop/products/` | No | No | No | Organizational folder |

**Nested entity structure:**
```
04_Ventures/agency/clients/bigco/
├── _brain/           ← Sub-entity state
│   ├── status.md
│   ├── tasks.md
│   └── ...
├── _working/         ← Sub-entity drafts (NOT in parent's _working/)
│   └── proposal-v0.md
├── _references/      ← Sub-entity references (NOT in parent's _references/)
└── README.md
```

**WRONG:** `04_Ventures/agency/_working/clients/bigco/proposal.md`
**RIGHT:** `04_Ventures/agency/clients/bigco/_working/proposal.md`

**When creating sub-entitys:**
1. Create `_brain/` with status.md, tasks.md, insights.md, changelog.md, manifest.json
2. Create `_working/` for drafts (at sub-entity level, not parent)
3. Create `_references/` for reference material (at sub-entity level, not parent)
4. Log creation in parent's `_brain/changelog.md`
5. Update parent's `_brain/manifest.json`

Use `/alive:new` to create sub-entitys properly.

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
  "name": "project-name",
  "description": "One sentence description",
  "created": "2026-01-20",
  "updated": "2026-01-23",
  "session_id": "abc12345",

  "folders": ["_brain", "_working", "_references", "clients", "content"],

  "areas": [
    {
      "path": "clients/",
      "description": "Active client projects",
      "has_entities": false,
      "files": [
        {
          "path": "README.md",
          "description": "Client area overview"
        }
      ]
    },
    {
      "path": "content/",
      "description": "Marketing and brand content",
      "files": [
        {
          "path": "landing-page.md",
          "description": "Main landing page copy",
          "session_id": "xyz789"
        }
      ]
    }
  ],

  "working_files": [
    {
      "path": "_working/landing-v0.html",
      "description": "Draft landing page with hero and features",
      "session_id": "abc123"
    }
  ],

  "key_files": [
    {
      "path": "CLAUDE.md",
      "description": "Entity identity and navigation"
    }
  ],

  "handoffs": [],

  "references": [
    {
      "path": "_references/emails/2026-02-06-supplier-quote.md",
      "type": "email",
      "summary": "Supplier confirms 15% price increase, bulk order before Feb 28"
    }
  ]
}
```

**Key fields:**
- `description` (on files) — AI-generated one-liner describing the file
- `session_id` (on files) — Last session that modified this file (optional)
- `key_files` — Important reference files at entity root or cross-cutting
- `handoffs` — Pending session handoffs for `/alive:do` to detect on load
- `areas[].has_entities` — True if area contains nested entities (e.g. clients/)
- `areas[].files[]` — Files within this area, with description and optional session_id
- `references` — Lightweight index of files in `_references/`. Each entry has `path`, `type`, and `summary`. Loaded via three-tier pattern: manifest (index) → front matter (rich metadata) → raw content (full text/asset).

---

## _references/ Structure

External context useful to the entity — emails, messages, call transcripts, screenshots, articles, documents.

Each content TYPE gets a subfolder. Inside each type folder, `.md` summary files sit at root level and a `raw/` subfolder holds the original source files.

```
_references/
├── meeting-transcripts/
│   ├── 2026-02-08-content-planning.md        ← YAML front matter + detailed AI summary + source pointer
│   ├── 2026-02-04-partner-sync.md
│   └── raw/
│       ├── 2026-02-08-content-planning.txt
│       └── 2026-02-04-partner-sync.txt
├── emails/
│   ├── 2026-02-06-supplier-quote.md
│   └── raw/
│       └── 2026-02-06-supplier-quote.txt
├── screenshots/
│   ├── 2026-02-06-competitor-landing.md       ← front matter + analysis + source pointer
│   └── raw/
│       └── 2026-02-06-competitor-landing.png
└── documents/
    ├── 2026-02-06-contract-scan.md
    └── raw/
        └── 2026-02-06-contract-scan.pdf
```

### Access Pattern

```
Tier 1: manifest.json        → Quick index (always loaded)
Tier 2: Summary .md file      → Detailed AI summary + rich metadata (on demand)
Tier 3: raw/ file             → Original content — full text or binary (on demand)
```

The summary `.md` should be detailed enough that you rarely need the raw file.

### Subfolders

Dynamic — created by content type, not prescribed. Examples: `emails/`, `calls/`, `meeting-transcripts/`, `screenshots/`, `messages/`, `articles/`, `documents/`. Each type folder contains a `raw/` subfolder for original files.

### File Naming

Summary files and raw files share the same base name with different extensions:

| File | Pattern | Example |
|------|---------|---------|
| Summary | `YYYY-MM-DD-descriptive-name.md` | `emails/2026-02-06-supplier-quote.md` |
| Raw (text) | `YYYY-MM-DD-descriptive-name.txt` | `emails/raw/2026-02-06-supplier-quote.txt` |
| Raw (binary) | `YYYY-MM-DD-descriptive-name.ext` | `screenshots/raw/2026-02-06-competitor-landing.png` |

### Text Content (emails, transcripts, messages)

Summary `.md` with YAML front matter + `## Summary` (with subheaders for key points, action items, decisions as appropriate) + `## Source` pointer to raw file:

```markdown
---
type: email
date: 2026-02-06
summary: Supplier confirms 15% price increase on fabric starting March
source: John Smith
tags: [pricing, supplier]
subject: Q1 pricing update
from: john@supplier.com
to: team@company.com
---

## Summary

John confirms a 15% price increase on all fabric orders starting March 1.
Recommends placing a bulk order before Feb 28 to lock in current pricing.

### Key Points
- 15% increase effective March 1
- Bulk order before Feb 28 locks current rate
- Minimum order: 500 units for bulk pricing

### Action Items
- Decide on bulk order quantity by Feb 20
- Confirm shipping timeline with warehouse

## Source

`raw/2026-02-06-supplier-quote.txt`
```

### Non-Text Content (screenshots, videos, PDFs)

Same pattern — summary `.md` at type root, original in `raw/`:

```
_references/screenshots/
├── 2026-02-06-competitor-landing.md
└── raw/
    └── 2026-02-06-competitor-landing.png
```

Summary `.md` uses `## Analysis` instead of `## Summary`:

```markdown
---
type: screenshot
date: 2026-02-06
summary: Competitor landing page showing new $49/mo pricing tier
source: competitor website
tags: [competitor, pricing]
---

## Analysis

[AI-generated detailed description — what's shown, key information,
relevant observations. Detailed enough that you rarely need the original.]

## Source

`raw/2026-02-06-competitor-landing.png`
```

### Front Matter Fields

| Field | Required | Notes |
|-------|----------|-------|
| `type` | Yes | email, call, screenshot, message, article, document, etc. |
| `date` | Yes | ISO format |
| `summary` | Yes | One-line (mirrors manifest entry) |
| `source` | Usually | Who/where it came from |
| `tags` | Usually | Array for searchability |
| `from`, `to`, `subject` | email | Email metadata |
| `participants`, `duration` | call | Call metadata |
| `platform` | message | Slack, iMessage, etc. |

### Manifest Entry

```json
"references": [
  {
    "path": "_references/emails/2026-02-06-supplier-quote.md",
    "type": "email",
    "summary": "Supplier confirms 15% price increase, bulk order before Feb 28"
  }
]
```

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

When using third-party skills, ALIVE conventions take precedence.

### Plan File Locations

| Skill Default | ALIVE Override |
|---------------|----------------|
| `{root}/docs/plans/` | `{entity}/_working/plans/` |

**Why:** Plans are work-in-progress until approved. WIP files belong in `_working/`, not permanent documentation folders.

```
# Wrong
~/alive/docs/plans/feature-plan.md

# Right
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

**Never create orphan files at:**
- ALIVE root (`~/alive/`)
- Random `docs/` folders outside entities
- `/tmp/` or scratchpad (unless truly temporary)

**The question to ask:** "Where in this entity's structure does this file belong?"
