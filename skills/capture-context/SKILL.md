---
user-invocable: true
description: Capture context into the ALIVE system. Use when user shares any content — their own thoughts, external emails, meeting transcripts, articles, Slack messages, quick notes, decisions, or anything worth preserving. Triggers on "capture this", "note this", "remember this", "FYI", "here's some context", "process this", "I got this email", "from my call", "digest this", "quick note", "btw", "I learned", "I decided".
---

# alive:capture-context

Capture context into ALIVE. User gives you content, you analyse it, extract what matters, and route it to the right places.

## UI Treatment

This skill uses **Tier 3: Utility** formatting.

**Visual elements:**
- Compact logo (4-line ASCII art header)
- Double-line border wrap (entire response)
- Version footer: `ALIVE v2.0` (right-aligned)

See `rules/ui-standards.md` for exact border characters, logo assets, and formatting specifications.

---

## The Premise

The user has context they want in the system. It might be a quick thought, a pasted email, a meeting transcript, a screenshot, an article — anything. Your job:

1. Receive it
2. Understand what it is
3. Know where we are in ALIVE (active entity, what areas exist)
4. Extract the valuable parts (decisions, tasks, insights, people, key context)
5. Route extractions to the right `_brain/` files
6. Store the source material where it belongs

**One skill for all incoming context. No distinction between "your thoughts" and "external content."**

---

## Context Check (BEFORE Processing)

**You MUST load context before routing anything.** Without this, you're guessing.

| Check | Why |
|-------|-----|
| Active entity (from `/alive:do`) | Default routing destination |
| `{entity}/_brain/manifest.json` | Know what areas exist (clients/, content/) |
| `{entity}/_brain/status.md` | Current focus — informs relevance |
| `02_Life/people/` listing | Check for existing person files before creating |

```
▸ loading context...
  └─ Active: 04_Ventures/acme
  └─ Areas: clients/, content/, partnerships/
  └─ Focus: "Closing Q1 deals"
  └─ People: 47 files in 02_Life/people/
```

If no entity is active, scan entities for keyword matches to suggest routing.

---

## Flow

```
Content received
    ↓
Detect complexity
    ↓
┌─────────────┐     ┌─────────────────┐
│ Quick note  │     │ Substantial     │
│ (1-2 items) │     │ (multi-extract) │
└──────┬──────┘     └────────┬────────┘
       ↓                     ↓
  Quick capture         Full extraction
       ↓                     ↓
  Confirm + write       Show extractions
                             ↓
                        Confirm routing
                             ↓
                        Write to destinations
                             ↓
                        Store source material
                             ↓
                        Update person files
                             ↓
                        Confirm done
```

---

## Quick Capture (Simple Content)

For brief, clear context — a decision, a task, a quick FYI. One or two items, no complex extraction needed.

**Triggers:** Short statements, "FYI", "btw", "note this", single clear item.

### Step 1: Parse and Classify

| Signal | Type | Destination |
|--------|------|-------------|
| "decided", "chose", "going with" | Decision | `_brain/changelog.md` |
| "learned", "realised", "found out" | Insight | `_brain/insights.md` |
| "need to", "should", "follow up", "todo" | Task | `_brain/tasks.md` |
| "now in", "phase", "focus" | Status update | `_brain/status.md` |
| "met", "talked to", "call with" | Person | `02_Life/people/` + changelog |

### Step 2: Confirm and Write

```
▸ quick capture

Decision: Use Stripe over PayPal
Rationale: PayPal fees too high in AU
Route to: 04_Ventures/acme/_brain/changelog.md

[1] Confirm
[2] Edit
[3] Different destination
```

### Step 3: Done

```
✓ Captured to 04_Ventures/acme/_brain/changelog.md
```

### FYI Mode (Ultra-Quick)

When it's obviously a simple log entry:

```
User: "FYI the deadline moved to Friday"

▸ quick capture

✓ Logged to 04_Ventures/acme/_brain/changelog.md
  └─ "Deadline moved to Friday"
```

---

## Full Extraction (Substantial Content)

For emails, transcripts, articles, multi-item pastes — anything that needs proper extraction.

**Triggers:** Multi-line pasted content, emails, transcripts, articles, complex context with multiple extractable items.

### Step 1: Detect Content Type

| Type | Signals |
|------|---------|
| Email | "From:", "To:", "Subject:", forwarded markers |
| Transcript | Speaker labels, timestamps, dialogue format |
| Slack/Chat | @mentions, emoji reactions, thread format |
| Article | Long-form prose, headings, no dialogue |
| Document | Structured content, sections |
| Notes | Bullet points, informal structure |
| Unknown | Ask user to clarify |

```
▸ detecting content type...
  └─ Email thread (3 messages)
```

### Step 2: Process or Dump?

Always offer the choice:

```
[1] Process now — extract and route to entity
[2] Dump to 03_Inputs/ — save for later triage with /alive:digest
```

If dump → save raw content to `03_Inputs/[date]-[type]-[subject].md` and exit.

### Step 3: Extract

Run extraction based on content type. Pull out:

| Extract | What to Look For |
|---------|------------------|
| **Decisions** | Agreements, confirmations, "we'll do X", conclusions |
| **Tasks** | Action items, commitments, deadlines, follow-ups |
| **Insights** | Key learnings, revelations, market signals |
| **People** | Names + roles, companies, relationships |
| **Key context** | Budget figures, dates, constraints, important facts |

### Step 4: Show Extractions

Present everything found. Let the user verify before writing.

```
▸ extracted from email thread

PEOPLE
- Sarah Chen (CEO, Globex) — new contact
- John (mentioned as "our CTO")

DECISIONS
- Moving forward with pilot program
- Starting Feb 15

TASKS
- [ ] Send contract by Friday
- [ ] Schedule kickoff call

KEY CONTEXT
- Budget approved for $50k
- 3-month initial engagement

─────────────────────────────────────────────────────────────────────────
[1] Confirm and route    [2] Edit extractions    [3] Cancel
```

### Step 5: Determine Routing

**Use manifest to suggest specific areas.**

If entity is active AND manifest shows a matching area:
```
▸ checking manifest...
  └─ Found: clients/globex/ (matches "Globex" in email)

Route to: 04_Ventures/acme
- Tasks → _brain/tasks.md
- Decision → _brain/changelog.md
- Source file → clients/globex/
- People → 02_Life/people/ (with links)

[1] Confirm    [2] Different location    [3] Dump to 03_Inputs/
```

If entity is active but no matching area:
```
Route to: 04_Ventures/acme
- Tasks → _brain/tasks.md
- Decision → _brain/changelog.md
- People → 02_Life/people/

No matching area for source file. Options:
[1] Create clients/globex/ area
[2] Save source to _working/
[3] Save source to 03_Inputs/
```

If no active entity:
```
Where should this go?

▸ scanning entities for matches...
  └─ 04_Ventures/acme — "Globex" mentioned in status.md
  └─ 04_Ventures/beta — no match

[1] 04_Ventures/acme (suggested)
[2] 04_Ventures/beta
[3] 03_Inputs/ (triage later)
```

### Step 6: Write to Destinations

**Tasks → tasks.md**
```markdown
## To Do
- [ ] Send contract by Friday (from email 2026-01-30)
- [ ] Schedule kickoff call (from email 2026-01-30)
```

**Decisions → changelog.md**
```markdown
## 2026-01-30 — Context Captured

### Decisions
- **Globex pilot:** Moving forward with Feb 15 start. Budget $50k approved.

### Source
Email thread with Sarah Chen (Globex)
```

**Insights → insights.md**
```markdown
## 2026-01-30 — [Insight Title]

**Category:** [market / product / process / technical / people]
**Learning:** The insight itself
**Evidence:** How we know this
**Applies to:** Where this matters
```

### Step 7: Handle People

For every person mentioned:

1. Check `02_Life/people/` for existing file
2. If found → update with new context, update "Last contact"
3. If not found → offer to create

**New person file:**
```markdown
# Sarah Chen

**Role:** CEO
**Company:** Globex
**Met:** 2026-01-30 (email)

---

## Context
- Discussing pilot program with acme
- Budget holder, approved $50k

## References
- 04_Ventures/acme (potential client)
```

**Existing person:**
```
Sarah Chen mentioned in this content.
Found: 02_Life/people/sarah-chen.md

Update with this context?
[1] Yes, update    [2] Skip
```

### Step 8: Store Source Material

Save the original content for reference. Where it goes depends on context:

| Situation | Store Location |
|-----------|---------------|
| Matches an existing area (e.g. `clients/globex/`) | That area folder |
| Active entity, no matching area | `_working/` with entity prefix |
| No clear entity | `03_Inputs/` for later triage |

File naming: `[date]-[type]-[brief-subject].md`
Example: `2026-01-30-email-globex-pilot.md`

**Always preserve the original.** Even after extraction, the source has value.

### Step 9: Confirm Done

```
✓ Captured and routed to 04_Ventures/acme

Written:
- 2 tasks → _brain/tasks.md
- 1 decision → _brain/changelog.md
- 1 person → 02_Life/people/sarah-chen.md (created)

Source saved to: clients/globex/2026-01-30-email-globex-pilot.md
```

---

## Multiple Items in One Capture

When content contains items for different types:

```
"We decided X, I learned Y, and need to do Z"

Capturing 3 items:
1. Decision: X → changelog.md
2. Insight: Y → insights.md
3. Task: Z → tasks.md

Confirm all three?
```

---

## No Active Entity

If no entity has been loaded with `/alive:do`:

```
[?] No active entity.

Where does this belong?
[1] 04_Ventures/acme
[2] 04_Ventures/beta
[3] 02_Life/[area]
[4] 03_Inputs/ (triage later)
```

---

## Ambiguous Content

When it's unclear what type something is:

```
"John mentioned we should reconsider the pricing"

This could be:
[1] Task — "Reconsider pricing"
[2] Insight — "Pricing concern raised by John"
[3] Decision context — Log for future decision

Which fits best?
```

---

## Fallbacks

**No manifest.json:**
```
▸ no manifest found, scanning folders...
  └─ Found: clients/, content/, _working/
```
Use actual folder structure for routing suggestions.

**No 02_Life/people/ folder:**
```
▸ 02_Life/people/ not found
  └─ Offer to create with first person file
```

---

## Related Skills

- `/alive:save` — End full session (not mid-session capture)
- `/alive:digest` — Process items already IN `03_Inputs/`
- `/alive:do` — Load entity context first
