# Inbox Domain Template

**Domain:** inbox/
**Purpose:** Universal input, triage point

---

## Structure

```
inbox/
├── [file.md]         # Raw captures, notes, dumps
├── [transcript.md]   # Call/meeting transcripts
├── [document.pdf]    # Documents to process
└── ...               # Anything to be triaged
```

---

## What Goes in Inbox

**Everything that needs processing.**

- Quick notes dumped for later
- Transcripts from calls/meetings
- Documents to review
- Ideas captured on the go
- Forwarded content
- Anything you don't have time to sort now

---

## Inbox Principles

1. **Zero friction** — Dump anything here, sort later
2. **Temporary** — Items move out, inbox stays clear
3. **Process regularly** — Use `/alive:digest` to triage
4. **Nothing permanent** — Inbox is a buffer, not storage

---

## Processing Flow

```
CAPTURE  →  INBOX  →  DIGEST  →  DESTINATION
   ↓          ↓          ↓           ↓
 Quick      Buffer    Extract    _brain/ or
 grab       zone      & route    area folder
```

---

## Using /alive:digest

Process inbox with the digest skill:

```
/alive:digest
```

This will:
1. Survey inbox items (prioritized)
2. Let you select what to process
3. Triage each item (quick route vs full extraction)
4. Route content to destinations
5. Archive or delete source files

---

## Item Types

| Type | Processing | Destination |
|------|------------|-------------|
| Quick note | Extract action items | tasks.md, _working/ |
| Transcript | Full extraction (agent) | changelog.md, tasks.md, people/ |
| Document | Summarize, file | Area folder, manifest |
| Email | Extract tasks, file | tasks.md, area folder |
| Idea | Capture, categorize | insights.md, _working/ |

---

## Naming Convention

No strict naming required — this is a dump zone.

Helpful patterns:
- `YYYY-MM-DD-topic.md` — Dated items
- `call-with-[name].md` — Call transcripts
- `quick-note.md` — Temporary notes

---

## Best Practices

### Daily Triage

Process inbox daily or every few days. Don't let it become a graveyard.

### Zero Inbox Goal

Aim for empty inbox. Everything should move to:
- A subdomain's `_brain/` or area
- `archive/inbox/` if ephemeral
- Deleted if worthless

### Quick Capture

When capturing, don't overthink:
```
"Just dump it in inbox, sort later."
```

Better to capture imperfectly than to lose context.

---

## After Processing

Processed items go to:
- **Relevant area** — If content belongs somewhere specific
- **archive/inbox/** — If ephemeral but worth keeping
- **Deleted** — If temporary and worthless

---

## Notes

- Inbox is for triage, not storage
- Process regularly to avoid overwhelm
- Use `/alive:digest` for guided processing
- When in doubt, capture to inbox and sort later
