---
user-invocable: true
description: This skill should be used when the user says "process inputs", "digest", "triage", "handle inbox", "sort these", "what's in my inbox", "what's in inputs", or "anything to process". Processes the 03_Inputs/ buffer.
---

# alive:digest

Process the 03_Inputs/ buffer. Survey items, triage with user, extract content, route to entities.

## When to Use

Invoke when the user:
- Has items in `03_Inputs/` to process
- Wants to triage incoming content
- Needs to route captured content
- Says "process", "digest", "triage"

## Digest Principles

1. **User stays in control** — Never auto-process without confirmation
2. **Prioritize by importance** — Recent and urgent first
3. **Smart extraction** — Use appropriate agents for complex content
4. **Manifest-aware routing** — Route to existing areas when possible
5. **Never delete, always archive** — Processed files move to `01_Archive/03_Inputs/`, never deleted

## Flow (4 Steps)

```
STEP 1: Survey Inputs   → See what's there, prioritize
STEP 2: User Selection  → Pick what to digest now
STEP 3: Per-Item Triage → Decide how to handle each
STEP 4: Execute         → Route and extract
```

## Step 1: Survey Inputs

Scan `03_Inputs/` and present prioritized list:

```
╭─ ALIVE ────────────────────────────────────────────────────────────────╮
│  digest                                                                │
╰────────────────────────────────────────────────────────────────────────╯

▸ scanning 03_Inputs/

INPUTS (5 items)
─────────────────────────────────────────────────────────────────────────
[1] client-email-acme.md       Email       Today         🔥 urgent
[2] call-transcript-01-22.md   Transcript  2 days ago    ~45 min
[3] quick-note.md              Note        3 days ago
[4] meeting-recording.m4a      Audio       1 week ago
[5] random-thoughts.md         Note        1 week ago

─────────────────────────────────────────────────────────────────────────
[a] Digest all    [1-5] Select items    [q] Quit

Which items to digest?
```

### Priority Signals

| Signal | Priority |
|--------|----------|
| Today's date | 🔥 High |
| Client/business related | 🔥 High |
| Within 3 days | Medium |
| Over 1 week | Low |
| Audio/video (needs processing) | Flag |

## Step 2: User Selection

User picks which items to process:

```
> 1, 2

Selected:
[1] client-email-acme.md
[2] call-transcript-01-22.md

Proceed with these 2 items?
[1] Yes
[2] Add more
[3] Different selection
```

## Step 3: Per-Item Triage

Go through each selected item:

### Simple Item (Email/Note)

```
▸ [1/2] client-email-acme.md

Type: Email from client
Content: Request for project update + new feature ask
Detected:
  - 1 task (send update)
  - 1 reference (feature request)

Approach:
[1] Quick route — Add task, file email
[2] Extract details — Full breakdown
[3] Skip for now
```

### Complex Item (Transcript)

```
▸ [2/2] call-transcript-01-22.md

Type: Call transcript (~45 min)
Detected:
  - 3 people mentioned
  - Multiple topics discussed
  - Several action items

This needs deeper extraction.

Approach:
[1] Full extraction — Spawn transcript agent
[2] Summary only — Quick overview
[3] Manual — Review and route myself
[4] Skip for now
```

## Step 4: Execute

### Quick Route

For simple items:
```
▸ processing client-email-acme.md

Adding task to 04_Ventures/acme/_brain/tasks.md:
  - [ ] Send project update to client @urgent

Filing email to 04_Ventures/acme/clients/emails/

Moving source to: 01_Archive/03_Inputs/client-email-acme.md

✓ Done
```

### Full Extraction (Transcript Agent)

For complex items, spawn specialized agent:

```
▸ spawning transcript extraction agent...

Analyzing call-transcript-01-22.md...

EXTRACTION RESULTS
─────────────────────────────────────────────────────────────────────────
People (3):
  - John Smith (client) → 02_Life/people/john-smith.md [update]
  - Sarah Chen → exists
  - New: Mike from TechCorp → create?

Decisions (2):
  - Use AWS over GCP → 04_Ventures/acme/_brain/changelog.md
  - Launch date March 15 → 04_Ventures/acme/_brain/changelog.md

Tasks (4):
  - [ ] Send proposal by Friday
  - [ ] Schedule follow-up
  - [ ] Review AWS pricing
  - [ ] Update timeline

Insights (1):
  - Client prefers weekly updates → 04_Ventures/acme/_brain/insights.md

─────────────────────────────────────────────────────────────────────────
[1] Apply all extractions
[2] Review and select
[3] Edit before applying
```

## Routing Logic

### Check Manifest First

Before routing, check if entity has an area for the content:

```
▸ checking 04_Ventures/acme/_brain/manifest.json

Areas found:
  - clients/ → for client content
  - meetings/ → for transcripts

Route transcript to: 04_Ventures/acme/meetings/call-2026-01-22.md
```

### Routing Destinations

| Content Type | Destination |
|--------------|-------------|
| Decision | `_brain/changelog.md` |
| Task | `_brain/tasks.md` |
| Insight | `_brain/insights.md` |
| Person info | `02_Life/people/[name].md` |
| Transcript | Subdomain area or `meetings/` |
| Document | Subdomain area |
| Reference | `_working/` or relevant area |

### Source File Routing

After extraction, move source file:
- To entity area if relevant (`04_Ventures/acme/meetings/`)
- To `01_Archive/03_Inputs/` if ephemeral

## Multimodal Support

### Audio Files

```
[!] meeting-recording.m4a is an audio file.

This needs transcription before processing.

[1] Transcribe and process (may take time)
[2] Skip for now
[3] Just file without extraction
```

### Images/PDFs

```
[!] contract-scan.pdf detected.

[1] Extract text and summarize
[2] Just file with description
[3] Skip
```

## Extraction Agents

For complex items, use specialized prompts:

### Transcript Agent

Extracts:
- People mentioned (with roles)
- Decisions made
- Action items
- Insights/learnings
- Key topics discussed

### Email Agent

Extracts:
- Sender/recipients
- Action items
- Commitments made
- Follow-up needed

### Document Agent

Extracts:
- Summary
- Key points
- Related topics
- Routing suggestion

## Edge Cases

**Empty inputs:**
```
▸ scanning 03_Inputs/

Inputs is empty. Nothing to process.

[c] Capture something new
[b] Back
```

**Ambiguous routing:**
```
This transcript mentions both acme and beta projects.

Route extractions to:
[1] Both entitys
[2] Just acme
[3] Just beta
[4] Let me specify for each item
```

**Large batch:**
```
Inputs has 23 items.

Process:
[1] All items (may take time)
[2] Today's items only (3)
[3] Select specific items
[4] Oldest first (clear backlog)
```

## After Digest

```
✓ Digest complete

Processed: 2 items
Created: 1 person file
Added: 6 tasks
Logged: 2 decisions
Filed: 2 source files

03_Inputs remaining: 3 items
```

## Related Skills

- `/alive:input` — Single item capture and immediate routing
- `/alive:do` — Work on entity after digest
- `/alive:daily` — Shows inputs count, links here

---

## UI Treatment

This skill uses **Tier 3: Utility** formatting.

**Visual elements:**
- Compact logo (4-line ASCII art header)
- Double-line border wrap (entire response)
- Version footer: `ALIVE v2.0` (right-aligned)

See `rules/ui-standards.md` for exact border characters, logo assets, and formatting specifications.
