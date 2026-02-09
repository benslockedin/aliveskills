---
user-invocable: true
description: This skill should be used when the user says "process inputs", "digest", "triage", "handle inbox", "sort these", "what's in my inbox", "what's in inputs", or "anything to process". Processes the 03_Inputs/ buffer.
---

# alive:digest

Process the 03_Inputs/ buffer. Survey items, triage with user, extract content, route to entities.

## UI Treatment

This skill uses **Tier 3: Utility** formatting.

**Visual elements:**
- Compact logo (4-line ASCII art header)
- Double-line border wrap (entire response)
- Version footer: `ALIVE v2.0` (right-aligned)

See `rules/ui-standards.md` for exact border characters, logo assets, and formatting specifications.

---

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
5. **Never delete, always archive** — Processed files move to `01_Archive/{relevant subdomain}/{mirrored path}/...`, never deleted

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

Storing email:
  Summary → 04_Ventures/acme/_references/emails/2026-02-06-client-update-request.md
  Raw     → 04_Ventures/acme/_references/emails/raw/2026-02-06-client-update-request.txt

Archiving source: 03_Inputs/client-email-acme.md → 01_Archive/03_Inputs/

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
  - _references/ → for source material

Route transcript to: 04_Ventures/acme/_references/calls/2026-01-22-partner-sync.md
```

### Routing Destinations

**Extracted content** routes to `_brain/`:

| Extraction | Destination |
|------------|-------------|
| Decision | `_brain/changelog.md` |
| Task | `_brain/tasks.md` |
| Insight | `_brain/insights.md` |
| Person info | `02_Life/people/[name].md` |

### Source File Routing

After extraction, the **source file** needs to be stored. Default is `_references/` — the same format used by `/alive:capture-context`.

Every reference creates two files: a **summary `.md`** at the type folder root, and the **original content** in a `raw/` subfolder. The summary should be detailed enough that you rarely need the raw file.

**Text-based source files** (emails, transcripts, notes, messages) → create a summary `.md` with YAML front matter + detailed AI summary + source pointer, and store the original text in `raw/`:

```markdown
---
type: email
date: 2026-02-06
summary: Client requests project update and asks about new feature
source: John Smith (Acme Corp)
tags: [client, update-request, feature]
subject: Re: Project status
from: john@acme.com
to: team@company.com
---

## Summary

John is requesting a project status update by end of week. He also
raises a new feature request for bulk export functionality. He mentions
the board meeting is next Tuesday and needs numbers to present.

### Key Points
- Status update needed by Friday
- New feature request: bulk export
- Board meeting Tuesday — needs metrics

### Action Items
- Send project update by Friday
- Respond to bulk export feature request

## Source

`raw/2026-02-06-client-update-request.txt`
```

File naming: summary `.md` and raw file share the same base name.
Subfolder: dynamic based on content type (`emails/`, `calls/`, `meeting-transcripts/`, `messages/`, `notes/`, `articles/`)

```
_references/emails/2026-02-06-client-update-request.md        ← summary
_references/emails/raw/2026-02-06-client-update-request.txt   ← raw original
_references/calls/2026-01-22-partner-sync.md                  ← summary
_references/calls/raw/2026-01-22-partner-sync.txt             ← raw original
```

**Non-text source files** (screenshots, PDFs, audio) → same pattern. Summary `.md` at type root, original in `raw/`:

```
_references/documents/2026-02-06-contract-scan.md             ← summary with analysis
_references/documents/raw/2026-02-06-contract-scan.pdf        ← original file
```

The summary `.md` uses `## Analysis` instead of `## Summary` and points to the raw file:

```markdown
---
type: document
date: 2026-02-06
summary: Scanned contract with Globex, 12-month term, $50k value
source: Legal team
tags: [contract, globex]
---

## Analysis

[AI-generated description of the document contents,
key terms, important clauses, relevant observations.
Detailed enough that you rarely need to open the original.]

## Source

`raw/2026-02-06-contract-scan.pdf`
```

**Finished artifacts** (spreadsheets, contracts, final documents) → these aren't references, they're project files. Route to the appropriate area folder in the entity:

```
04_Ventures/acme/clients/globex/contract-v1.pdf
04_Ventures/acme/financials/q1-budget.xlsx
```

**The test:** Is this source material you might reference later? → `_references/`. Is this a finished file that belongs in a project? → Area folder.

**After routing, archive the original from inputs:**
```
mv 03_Inputs/client-email-acme.md → 01_Archive/03_Inputs/client-email-acme.md
```

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

- `/alive:capture-context` — Capture and route content into ALIVE
- `/alive:do` — Work on entity after digest
- `/alive:daily` — Shows inputs count, links here

