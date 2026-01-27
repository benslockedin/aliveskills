---
name: archive
description: This skill should be used when the user asks to "archive X", "move X to archive", "shelve X", "close X", "deactivate X", "done with X", "X is complete", "finished with X", or wants to move completed or inactive items to the archive.
---

# alive:archive

Move completed or inactive items to archive. Preserve full path structure.

## When to Use

Invoke when the user:
- Has completed a project/client/venture
- Wants to shelve something inactive
- Needs to clean up active areas
- Is closing out work

## Archive Principles

1. **Preserve paths** — Archive mirrors active structure
2. **Nothing is deleted** — Archive is permanent storage
3. **Searchable** — Archived content can still be found
4. **Reversible** — Can restore if needed

## Path Preservation

```
Active:   ventures/acme/clients/globex/
Archived: archive/ventures/acme/clients/globex/
```

The archive mirrors the working structure exactly.

## Flow

```
1. Identify what to archive
2. Confirm it's ready (no pending tasks)
3. Create archive path
4. Move content
5. Update manifests
6. Confirm archive
```

## Step-by-Step

### Step 1: Identify Target

```
What are you archiving?

[1] A subdomain (ventures/acme)
[2] An area (ventures/acme/clients/globex)
[3] A file (specific document)
```

### Step 2: Check Readiness

Before archiving, verify:

```
▸ checking ventures/acme/clients/globex/

Status: No _brain/ (this is an area)
Files: 5 documents
Related tasks: 2 found in parent subdomain

─────────────────────────────────────────────────────────────────────────
[!] Found 2 related tasks in ventures/acme/_brain/tasks.md:
    - [ ] Send final invoice to Globex
    - [ ] Archive Globex files

Complete these first?
[1] Yes, show me the tasks
[2] No, archive anyway
[3] Cancel
```

### Step 3: Archive

```
▸ archiving ventures/acme/clients/globex/

Creating: archive/ventures/acme/clients/globex/
Moving: 5 files

[1] Confirm archive
[2] Cancel
```

### Step 4: Execute

```
▸ moving to archive...

archive/ventures/acme/clients/globex/
├── contract.pdf
├── deliverables/
│   ├── report-v1.pdf
│   ├── report-v2.pdf
│   └── presentation.pptx
└── README.md
```

### Step 5: Update Manifests

**Parent manifest (ventures/acme/_brain/manifest.json):**
- Remove archived area from `areas[]`
- Update `folders[]` if needed

**Archive note:**
Add to archived content:
```markdown
<!-- Archived: 2026-01-23 from ventures/acme/clients/globex/ -->
```

### Step 6: Confirm

```
✓ Archived to archive/ventures/acme/clients/globex/

5 files moved.
Parent manifest updated.

This content is preserved and searchable via /alive:recall.
```

## Archiving Subdomains

When archiving a full subdomain (with _brain/):

```
▸ archiving ventures/old-project/

This is a full subdomain with state.

Current status: Completed
Last updated: 2026-01-15 (8 days ago)
Open tasks: 0

Archive everything including _brain/?
[1] Yes, archive full subdomain
[2] No, just archive specific areas
[3] Cancel
```

Result:
```
archive/ventures/old-project/
├── .claude/
│   └── CLAUDE.md
├── _brain/
│   ├── status.md
│   ├── tasks.md
│   ├── insights.md
│   ├── changelog.md
│   └── manifest.json
├── _working/
└── [all areas and files]
```

## Archiving Experiments

Experiments that didn't work out:

```
▸ archiving experiments/failed-idea/

Experiment status: Abandoned
Reason: Market validation failed

Archive with learnings?
[1] Yes, preserve everything
[2] Extract insights first, then archive
[3] Just delete (not recommended)
```

If extracting insights:
```
Found in experiments/failed-idea/_brain/insights.md:
- "Target market too small for subscription model"
- "Customer acquisition cost exceeded LTV"

Copy these to another subdomain before archiving?
[1] Yes, copy to ventures/main/_brain/insights.md
[2] No, keep only in archive
```

## Restoring from Archive

If something needs to come back:

```
User: "Restore the Globex project"

▸ checking archive/ventures/acme/clients/globex/

Found archived content from 2026-01-23.

Restore to original location?
[1] Yes, restore to ventures/acme/clients/globex/
[2] Restore to different location
[3] Just view archived content
```

## Archive vs Delete

**Never delete.** Archive instead.

| Action | When to use |
|--------|-------------|
| Archive | Project complete, client done, experiment concluded |
| Delete | Never (use archive) |

Exception: Temporary files in `_working/` can be deleted after promotion.

## Edge Cases

**Already archived:**
```
✗ ventures/acme/clients/globex/ not found

Check archive?
[1] Yes, search archive
[2] No
```

**Nested archive:**
```
[!] ventures/acme/ contains 3 areas that are already archived.

Archive parent anyway?
[1] Yes (will nest archives)
[2] No, archive only active content
```

**Partial archive:**
```
Archive specific items from ventures/acme/clients/?

[1] globex/ (completed)
[2] initech/ (completed)
[ ] techcorp (still active)

Select which to archive:
```

## Finding Archived Content

Use `/alive:recall` to search archives:

```
User: "Find the Globex contract"

▸ searching all locations including archive...

Found: archive/ventures/acme/clients/globex/contract.pdf
Archived: 2026-01-23

[1] View content
[2] Restore from archive
```

## Related Skills

- `/alive:recall` — Find archived content
- `/alive:sweep` — Identify archive candidates
- `/alive:new` — Create new subdomain (opposite of archive)
