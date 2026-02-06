---
user-invocable: true
description: Use when ending a work session, wrapping up, stepping away, or preserving session context. Triggers on "save", "wrap up", "end session", "done for now", "I'm done", "brb", "stepping away", "checkpoint", "commit progress".
---

# alive:save

End session. Preserve context. Complete the loop by updating ALL state files.

## UI Treatment

This skill uses **Tier 2: Core Workflow** formatting.

**Visual elements:**
- Compact logo (4-line ASCII art header)
- Double-line border wrap (entire response)
- Community footer: `Free: Join the ALIVE community → skool.com/aliveoperators`

See `rules/ui-standards.md` for exact border characters, logo assets, and formatting specifications.

---

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

### Handoff Check (MANDATORY — After Steps 1-2)

**If user selected EITHER of these:**
- WHY = "Pre-compact" (context limit), OR
- WHAT'S NEXT = "Ongoing" (coming back)

**You MUST invoke `/alive:handoff` using the Skill tool. Do NOT attempt to create a handoff document yourself — the skill has specific logic you cannot replicate inline.**

**Action:** Call the Skill tool with `skill: "alive:handoff"` NOW, then proceed to Step 3.

After the handoff skill completes, show:
```
✓ Handoff created
  └─ Next session will be prompted to resume

Continuing with save...
```

**If NEITHER condition is met** (ending + closed/paused), skip handoff and proceed to Step 3.

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
04_Ventures/agency/                 ← Parent subdomain
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
- Edited `04_Ventures/agency/clients/acme/proposal.md` → Save to `acme/_brain/`
- Edited `04_Ventures/agency/templates/invoice.md` → Save to `agency/_brain/`
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
| **Productive** | + Check `_working/` files, + Check session-modified files |
| **Important** | + Extract insights → `insights.md` |
| **Breakthrough** | + Create capture in `_brain/memories/`, can update `CLAUDE.md` |

---

## Session ID Source (IMPORTANT)

**Use the session ID from the ALIVE startup hook in the system-reminder.**

Look for this in the system context at the start of the conversation:
```
SessionStart:startup hook success: ALIVE session initialized. Session ID: xxxxxxxx
```

The 8-character ID after "Session ID:" is YOUR session ID for this save.

**DO NOT generate a new UUID.** The session ID comes from the startup hook, not from you.

---

## Changelog Entry Format

Prepend to `_brain/changelog.md` (most recent first):

```markdown
## 2026-01-30 — Session Summary
**Session:** [session-id from startup hook]
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

Check `_working/` for files that need decisions. Use a systematic checklist approach.

**Versioning:**
- `v0.x` = Work in progress → lives in `_working/`
- `v1-draft` = Complete draft → lives in destination area
- `v1` = Final, approved → lives in destination area

### Step 1: List All Working Files

```
▸ checking _working/ folder...

WORKING FILES REVIEW
────────────────────────────────────────────────────────────────────────

[1] _working/v2-feedback-session-2026-02-02.md
    └─ Last modified: this session
    └─ Status: ?

[2] _working/proposal-v0.3.md
    └─ Last modified: 2 days ago
    └─ Status: ?

[3] _working/old-notes.md
    └─ Last modified: 3 weeks ago
    └─ Status: ?

────────────────────────────────────────────────────────────────────────
For each file, choose: [K]eep  [P]romote  [A]rchive
```

**NEVER DELETE. ALWAYS ARCHIVE.** Files are moved to `01_Archive/`, never removed.

### Step 2: Process Each File (Chinese Menu Style)

Go through each file systematically:

```
[1] _working/v2-feedback-session-2026-02-02.md

What should happen to this file?
[K] Keep in _working/ — still in progress
[P] Promote — move to permanent location
[A] Archive — no longer needed (move to 01_Archive/)
```

**Collect all decisions first, then execute.**

### Step 3: Handle Promotions

For each file marked [P]romote:

```
PROMOTING: v2-feedback-session-2026-02-02.md

1. New name (or keep current):
   > v2-feedback-session-2026-02-02.md

2. Destination:
   [1] docs/           → documentation
   [2] decisions/      → decision records
   [3] marketing/      → marketing assets
   [4] Keep in root    → key file
   [5] Other (specify)

3. Description for manifest:
   > "Feedback session tracking for v2 plugin development"
```

### Step 4: Execute All Moves

```
▸ processing working files...

KEEPING:
  └─ _working/proposal-v0.3.md (still WIP)

PROMOTING:
  └─ _working/v2-feedback-session.md → docs/v2-feedback-session.md
     └─ Added to manifest: docs/files[]

ARCHIVING:
  └─ _working/old-notes.md → 01_Archive/_working/old-notes.md

✓ Working folder cleaned
```

### Step 5: Update Manifest

For each promoted file:
1. Remove from `working_files`
2. Add to appropriate area's `files[]` array with description
3. Include `session_id` for traceability

**Key principle:** `_working/` is temporary. Finished files MUST move.

---

## Session-Modified Files (Productive+ Only)

**After handling `_working/` files, check for OTHER files modified this session.**

Files in `_brain/` are automatically tracked. But you may have modified:
- Key files (feedback docs, tracking files)
- Files in areas (docs/, decisions/, etc.)
- New files created outside `_working/`

```
▸ checking for session-modified files...

Files modified this session (outside _brain/):
  └─ _working/v2-feedback-session-2026-02-02.md (already in working_files)
  └─ docs/new-guide.md (NOT in manifest)
  └─ testing-feedback-all.md (in key_files, may need update)
```

**For each file not in manifest:**
```
Found file not in manifest:
  └─ docs/new-guide.md

Add to manifest?
[1] Yes — add to appropriate area
[2] No — temporary file, don't track
```

**For key_files modified this session:**
```
Key file updated this session:
  └─ testing-feedback-all.md

Update description in manifest?
[1] Yes — update description
[2] No — description still accurate
```

**Implementation hint:** Compare files touched in conversation against manifest entries. Flag any gaps.

**Key principle:** If you created or significantly modified a file, it should be in the manifest.

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
  "folders": ["_brain", "_working", "_references", "docs"],
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
  ],
  "handoffs": []
}
```

**For each new file this session:**
1. Identify which area it belongs to
2. Add to that area's `files` array with description
3. If promoted from `_working/`, remove from `working_files`

**References:** If any files were added to `_references/` during the session, update the manifest's `references` array with an entry for each: `path`, `type` (e.g. article, transcript, doc), and `summary`.

---

## Memories (Breakthrough Only)

Create `_brain/memories/` folder if needed, then `[date]-[session-id].md`:

```markdown
# Session Memory — 2026-01-30

**Session:** abc123
**Quality:** Breakthrough
**Entity:** 04_Ventures/alive-llc

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

**Append** a new line to the END of `.claude/state/session-index.jsonl`:

Use `echo '...' >> file` (double `>>`) to append, NOT overwrite. Each entry is one JSON object per line (JSONL format). Newest entries go at the bottom.

```json
{
  "ts": "2026-01-30T14:30:00Z",
  "session_id": "abc123",
  "entity": "04_Ventures/alive-llc",
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

Session Files (Productive+):
- [ ] Checked _working/ for files to promote
- [ ] Checked for session-modified files outside _brain/
- [ ] All modified files in manifest or explicitly skipped

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
[1] 04_Ventures/alive-llc — Plugin rebuild
[2] 04_Ventures/acme-agency — Client note

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
- `/alive:capture-context` — Capture context mid-session
- `/alive:handoff` — Session continuity (called automatically when pre-compact or ongoing)

