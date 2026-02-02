---
user-invocable: true
description: Use when ending a work session, wrapping up, stepping away, or preserving session context. Triggers on "save", "wrap up", "end session", "done for now", "I'm done", "brb", "stepping away", "checkpoint", "commit progress".
---

# alive:save

End session. Preserve context. Complete the loop by updating ALL state files.

## Critical Principle

**VERIFY BEFORE CONFIRMING. Save is the chance to complete the loop.**

Save touches ALL state files, not just changelog:
1. Update what happened (changelog)
2. Update where we are (status)
3. Update what's done/next (tasks)
4. Capture any insights
5. Handle working files (promote or keep)
6. Document new files with descriptions
7. Update structure map (manifest)
8. Log to session-index
9. VERIFY with checklist before confirming

---

## The 3-2-1 Flow

Three questions first. Then complete the loop.

```
WHY ──► WHAT'S NEXT ──► HOW ──► [Complete the Loop]
```

Use `AskUserQuestion` for each step — clickable choices, not typed responses.

### Step 1: WHY

```
Why are you saving?

[1] Ending session — done for now
[2] Pre-compact — about to hit context limit
[3] Checkpoint — mid-session save, continuing after
```

### Step 2: WHAT'S NEXT

```
What's next for this thread?

[1] Ongoing — I'll be back
[2] Paused — parking it, low priority
[3] Closed — work is done
```

### Step 3: HOW (Quality)

```
How was this session?

[1] Routine — just working
[2] Productive — got stuff done
[3] Important — worth remembering
[4] Breakthrough — this changes things
```

Quality drives escalating behavior (see Escalating Actions).

---

## The Closest Subdomain Rule

**Always save to the CLOSEST subdomain to where work happened.**

```
ventures/agency/                    ← Parent subdomain
├── _brain/                         ← Save here for agency-level work
├── clients/                        ← Area (no _brain/)
│   └── acme/                       ← Nested subdomain
│       └── _brain/                 ← Save HERE for acme-specific work
```

**How to identify:**
1. Look at which files were edited
2. Find the nearest parent folder with `_brain/`
3. That's where you save

**Examples:**
- Edited `ventures/agency/clients/acme/proposal.md` → Save to `acme/_brain/`
- Edited `ventures/agency/templates/invoice.md` → Save to `agency/_brain/`
- Edited files in both → Save to BOTH (see Multi-Domain Sessions)

## Cascade Logic

After saving to closest subdomain, check if parent needs update:

```
Changes to nested subdomain (acme)?
    ↓
Save to acme/_brain/
    ↓
Does parent (agency) need to know?
    ├── New structure created? → Update parent manifest
    ├── Phase change? → Update parent status
    └── No impact on parent? → Done
```

---

## Escalating Actions

| Quality | Actions |
|---------|---------|
| **Routine** | Changelog, tasks, status, manifest, session-index |
| **Productive** | + Check `_working/` files, promote if ready |
| **Important** | + Extract insights → `insights.md` |
| **Breakthrough** | + Create capture in `_brain/memories/`, can update `CLAUDE.md` |

---

## Changelog Entry Format

Prepend to `_brain/changelog.md` (most recent first):

```markdown
## 2026-01-30 — Session Summary
**Session:** [session-id]
**Quality:** [routine/productive/important/breakthrough]
**Status:** [ongoing/paused/closed]

### Changes
- What was done (specific, not vague)

### Decisions
- **Decision name:** What was chosen. Rationale: why.

### Next
- Immediate next steps (if ongoing)
- Or: "Thread closed" (if closed)

---
```

## Status Update

Review each field in `_brain/status.md`, update if changed:

- **Goal** — the subdomain's overarching objective
- **Phase** — current stage (planning, building, launching, etc.)
- **Updated** — today's date
- **Current Focus** — what we're working on right now
- **Blockers** — anything preventing progress
- **Next Milestone** — the next concrete target

## Tasks Update

In `_brain/tasks.md`:

- Mark completed tasks `[x]` with date
- Add new tasks to appropriate section
- Mark in-progress tasks `[~]`

```markdown
## Urgent
- [ ] Task @urgent

## Active
- [~] In-progress task

## Done (Recent)
- [x] Completed task (2026-01-30)
```

## Insights Entry (Important+ Only)

For Important or Breakthrough saves, append to `_brain/insights.md`:

```markdown
## 2026-01-30 — [Insight Title]

**Category:** [market / product / process / technical / people]
**Learning:** The insight itself
**Evidence:** How we know this
**Applies to:** Where this matters going forward

---
```

Ask: "Any insights from this session?"

---

## Working File Handling (Productive+ Only)

Check `_working/` for files that need decisions.

**Versioning:**
- `v0.x` = Work in progress → lives in `_working/`
- `v1-draft` = Complete draft → lives in destination area
- `v1` = Final, approved → lives in destination area

```
Working files found:

_working/proposal-v0.3.md
  Last modified: this session

Is this file finished?
[1] Yes — promote to permanent location
[2] No — keep in _working/ (still WIP)
[3] Delete (no longer needed)
```

**If promoting:**

1. Rename: `v0.x` → `v1-draft` (or `v1` if approved)
2. Ask for destination:

```
Where should this file live permanently?

[1] docs/           → documentation
[2] clients/        → client-specific
[3] assets/         → images, media
[4] templates/      → reusable templates
[5] Other (specify)
```

3. Move file from `_working/` to destination
4. Update manifest (remove from `working_files`, add to area)

**Key principle:** `_working/` is temporary. Finished files MUST move.

---

## The Manifest Rule

**Every file needs a manifest entry with description. No exceptions.**

In `_brain/manifest.json`:

```json
{
  "name": "ProjectName",
  "description": "One sentence purpose",
  "updated": "2026-01-30",
  "session_id": "abc123",
  "folders": ["_brain", "_working", "docs"],
  "areas": [
    {
      "path": "docs/",
      "description": "Reference documentation",
      "files": [
        {"path": "README.md", "description": "Index of documentation"},
        {"path": "architecture.md", "description": "System architecture"}
      ]
    }
  ],
  "working_files": [
    {"path": "_working/draft-v0.md", "description": "Landing page draft"}
  ],
  "key_files": [
    {"path": "CLAUDE.md", "description": "Entity identity"}
  ]
}
```

**For each new file this session:**
1. Identify which area it belongs to
2. Add to that area's `files` array with description
3. If promoted from `_working/`, remove from `working_files`

---

## Memories (Breakthrough Only)

Create `_brain/memories/` folder if needed, then `[date]-[session-id].md`:

```markdown
# Session Memory — 2026-01-30

**Session:** abc123
**Quality:** Breakthrough
**Entity:** ventures/alive-llc

## Key Quotes
> "Verbatim quote worth preserving"

## Decisions
- **Decision:** What. Rationale: Why.

## Insights
- What was learned
```

Ask: "Any changes to this entity's identity or purpose?"
If yes, offer to update entity `CLAUDE.md`.

---

## Session Index Entry

Write to `.claude/state/session-index.jsonl`:

```json
{
  "ts": "2026-01-30T14:30:00Z",
  "session_id": "abc123",
  "entity": "ventures/alive-llc",
  "save_type": "end_session",
  "status": "ongoing",
  "quality": "productive",
  "summary": "Brief description of session"
}
```

---

## VERIFY Before Writing (Mandatory)

**Run through checklist before writing any files.**

```
▸ verifying save completeness...

Changelog:
- [ ] Includes session ID
- [ ] Lists specific changes (not vague)
- [ ] Decisions include rationale
- [ ] Next steps are actionable
- [ ] Passes zero-context test

Status:
- [ ] Current Focus reflects NOW
- [ ] Phase is accurate
- [ ] Blockers updated

Tasks:
- [ ] Completed tasks marked [x]
- [ ] New tasks added

Manifest:
- [ ] session_id updated
- [ ] New files added with descriptions
- [ ] working_files accurate
- [ ] Saving to CLOSEST subdomain

Fix any failures before proceeding.
```

## Post-Write Verification (Mandatory)

**After writing, verify each file was updated.**

```
▸ verifying writes...

- [ ] changelog.md — new entry exists
- [ ] status.md — fields updated
- [ ] tasks.md — changes reflected
- [ ] manifest.json — session_id current

If ANY file wasn't updated, fix now.
```

---

## Zero-Context Standard

Before saving, verify:

> "If I came to this project with no memory, would this entry tell me what happened and why?"

**Check:**
- Decisions include rationale
- Changes are specific
- Next steps are actionable

---

## Multi-Entity Sessions

If session touched multiple subdomains:

```
This session touched:
[1] ventures/alive-llc — Plugin rebuild
[2] ventures/supernormal — Client note

Save to both?
```

Write separate entries. Cross-reference if related.

---

## BRB Mode

For quick save ("brb", "stepping away"):

Auto-select: Why = Checkpoint, Status = Ongoing, Quality = Routine

```
▸ quick checkpoint

✓ Saved to [entity]/_brain/changelog.md
  └─ "Work in progress: [summary]"

Resume with /alive:do
```

---

## Edge Cases

**No active entity:**
Ask which subdomain work happened in.

**Nothing to save:**
Offer to log checkpoint anyway.

**Infrastructure work:**
Write to `.claude/state/changelog.md` for system-level changes.

---

## Related Skills

- `/alive:do` — Load entity to work
- `/alive:daily` — Morning dashboard
- `/alive:revive` — Resume past session
- `/alive:capture` — Quick mid-session note
