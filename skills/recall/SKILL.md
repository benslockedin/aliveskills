---
name: recall
user_invocable: true
description: This skill should be used when the user asks to "find X", "search for X", "look up X", "recall X", "when did we X", "what did we decide about X", "where's that thing about X", "remember when we X", or wants to search past context, decisions, sessions, or files across the ALIVE system.
---

# alive:recall

Search past context. Find decisions, sessions, insights, or files across the ALIVE system.

## When to Use

Invoke when the user:
- Wants to find something from the past
- Asks "what did we decide about X"
- Asks "when did we discuss X"
- Needs to locate a file or decision
- Wants to search across subdomains

## Search Targets

| Target | Location | Contains |
|--------|----------|----------|
| Decisions | `_brain/changelog.md` | Choices + rationale |
| Insights | `_brain/insights.md` | Learnings |
| Tasks | `_brain/tasks.md` | Work items |
| Sessions | `_brain/changelog.md` | Session summaries |
| Files | `_brain/manifest.json` | File index with summaries |
| People | `life/people/` | Person files |
| Transcripts | `.claude/projects/` | Session transcripts |

## Flow

```
1. Parse search query
2. Determine search scope (specific subdomain or all)
3. Search relevant files
4. Rank and present results
5. Offer to load full context
```

## Step-by-Step

### Step 1: Parse Query

```
User: "What did we decide about pricing?"

Query: "pricing"
Type: Decision search
Scope: All subdomains (no specific one mentioned)
```

### Step 2: Search

Search order:
1. `_brain/changelog.md` — Decisions section
2. `_brain/insights.md` — Related learnings
3. `_brain/manifest.json` — File summaries

Show retrieval:
```
▸ searching "pricing"...
  └─ ventures/acme/_brain/changelog.md    2 matches
  └─ ventures/beta/_brain/changelog.md    1 match
  └─ ventures/acme/_brain/insights.md     1 match
```

### Step 3: Present Results

```
╭─ ALIVE ────────────────────────────────────────────────────────────────╮
│  recall • "pricing"                                                    │
╰────────────────────────────────────────────────────────────────────────╯

▸ found 4 matches

DECISIONS
─────────────────────────────────────────────────────────────────────────
[1] ventures/acme • 2026-01-23
    "Pricing model: Chose $97/mo. Rejected $47 (too cheap)..."

[2] ventures/acme • 2026-01-20
    "Pricing page: Decided to show annual pricing first..."

[3] ventures/beta • 2026-01-18
    "Beta pricing: Free during beta, charge after launch..."

INSIGHTS
─────────────────────────────────────────────────────────────────────────
[4] ventures/acme • 2026-01-22
    "Pricing psychology: Charm pricing ($97 vs $100) works..."

─────────────────────────────────────────────────────────────────────────
[#] View full entry    [s] Search again    [b] Back

Select a result:
```

### Step 4: Show Full Context

When user selects a result:
```
▸ loading ventures/acme/_brain/changelog.md

## 2026-01-23 — Session Summary

### Decisions
- **Pricing model:** Chose $97/mo based on competitor analysis.
  Rejected $47 (too cheap, wrong positioning) and $197 (barrier
  too high for cold traffic).

### Changes
- Updated pricing page
- Added FAQ section

─────────────────────────────────────────────────────────────────────────
[w] Work on this subdomain    [s] Search again    [b] Back
```

## Search Types

### Decision Search

```
User: "What did we decide about the tech stack?"

▸ searching decisions for "tech stack"...

Found in ventures/acme/_brain/changelog.md (2026-01-15):
- **Tech stack:** Chose Next.js + Supabase. Rejected Rails
  (team unfamiliar) and Firebase (vendor lock-in concerns).
```

### Session Search

```
User: "What happened last Tuesday?"

▸ searching sessions for 2026-01-21...

Found 2 sessions:
[1] ventures/acme — Landing page work (3 hours)
[2] ventures/beta — Bug fixes (1 hour)
```

### File Search

```
User: "Where's the contract with Acme?"

▸ searching manifest files for "contract"...

Found:
[1] ventures/agency/clients/acme/contract.pdf
    "MSA with Acme Corp, $50k retainer, expires March 2026"
```

### Person Search

```
User: "What do we know about John?"

▸ searching life/people/ for "john"...

Found: life/people/john-smith.md
- Role: CTO, TechCorp
- Last contact: 2026-01-20
- Context: Partnership discussion
```

## Scoped Search

### Specific Subdomain

```
User: "Find pricing decisions in acme"

▸ searching ventures/acme/ only...

[Searches only that subdomain]
```

### All Subdomains

```
User: "Find all mentions of AWS"

▸ searching all subdomains...

ventures/acme: 3 matches
ventures/beta: 1 match
experiments/infra: 5 matches
```

### Cross-Reference

```
User: "Find everything related to the launch"

▸ searching "launch"...

Decisions: 4
Tasks: 7
Insights: 2
Files: 3

[Show categorized results]
```

## Advanced: Transcript Search

For deep recall, search session transcripts:

```
User: "What exactly did we discuss about the API design?"

▸ searching transcripts for "API design"...

Found in session abc123 (2026-01-18):
[Shows relevant excerpt from transcript]

Load full transcript?
[1] Yes
[2] No, this is enough
```

Transcript location: `.claude/projects/[project-id]/[session-id].jsonl`

## Edge Cases

**No results:**
```
▸ searching "quantum computing"...

No matches found.

Try:
[1] Broader search terms
[2] Search transcripts (deeper)
[3] Check archived subdomains
```

**Too many results:**
```
▸ searching "meeting"... 47 matches

Narrow the search:
[1] By subdomain
[2] By date range
[3] By type (decisions/tasks/insights)
```

**Stale results:**
```
[!] This decision is from 6 weeks ago.
    May no longer be current.

Verify before acting on it?
```

## Related Skills

- `/alive:do` — Load subdomain after finding
- `/alive:digest` — Process found content
- `/alive:archive` — Find archived items
