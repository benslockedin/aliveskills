---
user-invocable: true
description: This skill should be used when the user says "create X", "new venture", "new experiment", "new project", "set up X", "start something new", or wants to scaffold a new entity with full structure.
plugin_version: "2.1.0"
---

# alive:new

Create a new entity or area. Scaffold the v2 structure with proper templates.

## UI Treatment

This skill uses **Tier 3: Utility** formatting.

**Visual elements:**
- Compact logo (4-line ASCII art header)
- Double-line border wrap (entire response)
- Version footer: `ALIVE v2.0` (right-aligned)

See `rules/ui-standards.md` for exact border characters, logo assets, and formatting specifications.

---

## When to Use

Invoke when the user wants to:
- Create a new venture, experiment, or life area (entity)
- Create an organizational folder within a entity (area)
- Set up project structure from scratch

## Entity vs Area

| Type | Has _brain/ | Has .claude/ | Has _working/ | Has _references/ | Identity |
|------|-------------|--------------|---------------|------------------|----------|
| **Entity** | Yes | Yes | Yes | Yes | `.claude/CLAUDE.md` |
| **Area** | No | No | No | No | `README.md` |

**Entitys** are projects with their own state.
**Areas** are organizational folders within entities.

## Flow

```
1. Ask: Entity or Area?
2. If Entity: Ask for type (venture/experiment/life) and name
3. If Area: Ask which entity and area name
4. If Entity: Offer ICP template (if applicable)
5. Create structure
6. Initialize files
7. Confirm creation
```

## Creating a Entity

### Step 1: Gather Information

```
Creating a new entity.

What type?
[1] Venture (business with revenue intent)
[2] Experiment (testing grounds, no model yet)
[3] Life area (personal responsibility)
```

Then:
```
Name? (lowercase, no spaces)
> acme-corp
```

### Step 2: Offer ICP Template (Ventures)

For ventures, offer relevant templates:

```
What type of venture?
[1] Agency — Client work, deliverables
[2] E-commerce — Products, inventory
[3] Creator — Content, courses, community
[4] Job — Employment, bringing work into ALIVE
[5] Custom — Start with generic template
```

### Step 3: Create Structure

**Entity structure:**
```
04_Ventures/acme-corp/
├── .claude/
│   └── CLAUDE.md          # Identity
├── _brain/
│   ├── status.md          # Current phase
│   ├── tasks.md           # Work queue
│   ├── insights.md        # Learnings
│   ├── changelog.md       # History
│   └── manifest.json      # Structure map
├── _working/              # Drafts
└── _references/           # Reference material (summary .md files + raw/ subfolders)
    ├── emails/
    │   ├── 2026-02-06-client-update.md   # YAML front matter + AI summary + source pointer
    │   └── raw/
    │       └── 2026-02-06-client-update.txt
    └── screenshots/
        ├── 2026-02-06-competitor.md
        └── raw/
            └── 2026-02-06-competitor.png
```

### Step 4: Initialize Files

Use templates from `.claude/templates/brain/` as the starting point for _brain/ files. Fill in the placeholders with user-provided information.

**CLAUDE.md:**
```markdown
# [Name]

**Type:** [Agency | E-com | Creator | Job | Custom]
**Created:** [DATE]

---

## What This Is

[One paragraph: What is this venture? What does it do?]

---

## Stakeholders

[Key people - founders, partners, team]

---

## State

Everything current lives in `_brain/`:
- `status.md` — Phase and focus
- `tasks.md` — Work queue
- `insights.md` — Learnings
- `changelog.md` — History
- `manifest.json` — Structure map

Drafts live in `_working/`.
Reference material lives in `_references/` (summary .md files with raw originals in `raw/` subfolders).
```

**status.md:**
```markdown
# Status

**Phase:** Starting
**Updated:** [DATE]

## Current Focus
[To be defined]

## Blockers
None yet.

## Next Milestone
[First milestone to achieve]
```

**tasks.md:**
```markdown
# Tasks

## Urgent
(none yet)

## To Do
- [ ] Define initial scope
- [ ] Set first milestone
- [ ] Identify key stakeholders

## Done (Recent)
- [x] Created entity ([DATE])
```

**manifest.json:**
```json
{
  "name": "[Name]",
  "description": "[One sentence]",
  "created": "[DATE]",
  "updated": "[DATE]",
  "session_id": "[current-session]",
  "folders": ["_brain", "_working", "_references"],
  "areas": [],
  "working_files": [],
  "references": [],
  "key_files": [],
  "handoffs": []
}
```

### Step 5: Confirm Creation

```
✓ Created 04_Ventures/acme-corp/

Structure:
├── .claude/CLAUDE.md
├── _brain/
│   ├── status.md
│   ├── tasks.md
│   ├── insights.md
│   ├── changelog.md
│   └── manifest.json
├── _working/
└── _references/           # Summary .md files + raw/ subfolders per type

Next: /alive:do acme-corp to start working.
```

## Creating an Area

### Step 1: Identify Entity

```
Creating an area (organizational folder).

Which entity?
[1] 04_Ventures/acme-corp
[2] 04_Ventures/beta
[3] Other (specify)
```

### Step 2: Get Area Details

```
Area name? (lowercase)
> clients

Purpose?
> Active client projects
```

### Step 3: Create Area

**Area structure:**
```
04_Ventures/acme-corp/clients/
└── README.md
```

**README.md:**
```markdown
# Clients

Active client projects.

---

## Contents

Each client gets a subfolder with their project files.

---

## Notes

- Completed clients move to 01_Archive/
- Key contacts should exist in 02_Life/people/
```

### Step 4: Update Parent Manifest

Add to `04_Ventures/acme-corp/_brain/manifest.json`:
```json
{
  "areas": [
    {
      "path": "clients/",
      "description": "Active client projects",
      "has_entities": false
    }
  ]
}
```

### Step 5: Confirm

```
✓ Created 04_Ventures/acme-corp/clients/

Added to manifest.json as area.
```

## ICP Templates

When creating ventures, offer relevant templates:

### Agency Template
```
04_Ventures/[name]/
├── clients/           # Client projects
├── templates/         # Reusable deliverables
├── operations/        # SOPs, processes
└── pipeline/          # Leads, proposals
```

### Creator Template
```
04_Ventures/[name]/
├── content/           # By platform
├── products/          # Courses, digital
├── community/         # Resources
└── funnel/            # Sales assets
```

### E-commerce Template
```
04_Ventures/[name]/
├── products/          # Inventory
├── suppliers/         # Vendor info
├── marketing/         # Campaigns
└── operations/        # Fulfillment
```

### Job Template
```
04_Ventures/[name]/
├── projects/          # Work projects
├── docs/              # Documentation
├── meetings/          # Notes
└── growth/            # Career development
```

## Edge Cases

**Name already exists:**
```
✗ 04_Ventures/acme already exists

[1] Open existing entity
[2] Choose different name
```

**Invalid name:**
```
✗ Invalid name: "Acme Corp!"

Names must be:
- Lowercase
- No spaces (use hyphens)
- Alphanumeric + hyphens only

Try again:
```

## Creating a Sub-Entity

Sub-entitys are containers WITHIN a entity that have their own lifecycle (and therefore their own `_brain/`).

### When to Create a Sub-Entity

| Parent Type | Sub-Entity Examples |
|-------------|---------------------|
| Agency venture | Clients, retainers |
| E-commerce venture | Campaigns, product lines |
| Creator venture | Courses, launches |
| Experiment | Iterations, sprints |

**Rule:** If it can be started, paused, or completed independently — it gets `_brain/`.

### Step 1: Identify Context

```
Creating a sub-entity.

You're working in: 04_Ventures/acme-agency/

What are you creating?
[1] Client (for agency ventures)
[2] Campaign (for ecommerce/marketing)
[3] Project (generic sub-entity)
[4] Custom
```

### Step 2: Get Details

```
Name? (lowercase, hyphens)
> bigco

One-line description?
> Enterprise client, $10k/mo retainer
```

### Step 3: Create Structure

**Sub-entity structure:**
```
04_Ventures/acme-agency/clients/bigco/
├── _brain/
│   ├── status.md
│   ├── tasks.md
│   ├── insights.md
│   ├── changelog.md
│   └── manifest.json
├── _working/         ← Sub-entity gets its OWN _working/
├── _references/      ← Sub-entity gets its OWN _references/
└── README.md
```

**IMPORTANT:** Each sub-entity gets its own `_working/` and `_references/` folders. Working files for this sub-entity go here, NOT in the parent's folders.

```
# WRONG - using parent's _working/
04_Ventures/acme-agency/_working/clients/bigco/proposal.md

# RIGHT - sub-entity has its own _working/
04_Ventures/acme-agency/clients/bigco/_working/proposal.md
```

### Step 4: Initialize Files

**status.md:**
```markdown
# Status

**Phase:** Starting
**Goal:** [To be defined]
**Updated:** [DATE]

## Current Focus
[Initial setup]

## Blockers
None yet.
```

**tasks.md:**
```markdown
# Tasks

## Urgent
(none yet)

## To Do
- [ ] Define scope and deliverables
- [ ] Set up communication cadence
- [ ] Identify key contacts

## Done (Recent)
- [x] Created sub-entity ([DATE])
```

**changelog.md:**
```markdown
# Changelog

## [DATE] — Created

Sub-entity created within 04_Ventures/acme-agency/clients/.

**Type:** Client
**Description:** Enterprise client, $10k/mo retainer

---
```

**manifest.json:**
```json
{
  "name": "bigco",
  "description": "Enterprise client, $10k/mo retainer",
  "created": "[DATE]",
  "updated": "[DATE]",
  "session_id": "[current-session]",
  "folders": ["_brain", "_working", "_references"],
  "areas": [],
  "working_files": [],
  "references": [],
  "key_files": [],
  "handoffs": []
}
```

### Step 5: Update Parent

Add to `04_Ventures/acme-agency/_brain/manifest.json`:
```json
{
  "areas": [
    {
      "path": "clients/",
      "has_entities": true,
      "entities": ["bigco"]
    }
  ]
}
```

Add to `04_Ventures/acme-agency/_brain/changelog.md`:
```markdown
## [DATE] — Created client: bigco

Added new client sub-entity: bigco (Enterprise client, $10k/mo retainer)
```

### Step 6: Confirm

```
✓ Created 04_Ventures/acme-agency/clients/bigco/

Structure:
├── _brain/
│   ├── status.md
│   ├── tasks.md
│   ├── insights.md
│   ├── changelog.md
│   └── manifest.json
├── _working/
├── _references/
└── README.md

Parent changelog updated.
Parent manifest updated.

Next: /alive:do bigco to start working.
```

## Sub-Entity vs Area

| Question | Sub-Entity | Area |
|----------|-------------|------|
| Has its own lifecycle? | Yes | No |
| Can be "done"? | Yes | No |
| Needs status tracking? | Yes | No |
| Gets `_brain/`? | Yes | No |
| Gets `_working/`? | Yes | No |
| Gets `_references/`? | Yes | No |

**Examples:**
- `clients/bigco/` → Sub-entity (has lifecycle)
- `templates/` → Area (organizational only)
- `campaigns/summer-sale/` → Sub-entity (has lifecycle)
- `brand/` → Area (organizational only)

## Related Skills

- `/alive:do` — Start working on the new entity
- `/alive:onboarding` — Full system setup (not just one entity)
- `/alive:daily` — See all entities after creating
