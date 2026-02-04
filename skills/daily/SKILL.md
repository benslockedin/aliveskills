---
user-invocable: true
description: Use when the user says "daily", "dashboard", "morning", "let's go", "what's happening", "what should I work on", "start my day", "overview", "show me everything", or wants to see the full system state across all entities including ongoing threads, goals, urgent tasks, and inputs status.
---

# alive:daily

Morning entry point. Surface what matters across ALL entities. The heartbeat of the learning loop.

## Overview

Daily aggregates context from every entity and the session index to show:
- Goals from each entity's status.md
- Ongoing threads from session-index.jsonl (with quality ratings)
- Urgent tasks across all entities
- Working files in progress
- Inputs pending triage
- Stale entities needing attention

**Different from `/alive:do`:** Daily shows EVERYTHING. Do focuses on ONE entity.

## V1 Detection (REQUIRED FIRST STEP)

Before anything else, check for v1 structure:

```
Check: Does inbox/ exist? (should be 03_Inputs/)
Check: Does any _state/ exist? (should be _brain/)
```

If v1 detected:
```
[!] Detected ALIVE v1 structure

Your system uses the older v1 format. Upgrade to v2?
[1] Yes, upgrade now
[2] No, continue with v1
```

If yes → invoke `/alive:upgrade` then restart daily.

## Data Sources

| Source | Extract |
|--------|---------|
| `alive.local.yaml` | Sync script configuration (optional) |
| `.claude/state/session-index.jsonl` | Ongoing threads with quality tags |
| `{entity}/_brain/status.md` | Goal line, phase, focus |
| `{entity}/_brain/tasks.md` | @urgent tagged items |
| `{entity}/_brain/manifest.json` | working_files array |
| `03_Inputs/` | Count of pending items |

## Flow

```dot
digraph daily_flow {
    "Start" -> "Check v1 structure";
    "Check v1 structure" -> "Offer upgrade" [label="v1 found"];
    "Check v1 structure" -> "Check sync config" [label="v2 OK"];
    "Offer upgrade" -> "Run /alive:upgrade" [label="yes"];
    "Offer upgrade" -> "Check sync config" [label="no"];
    "Run /alive:upgrade" -> "Check sync config";
    "Check sync config" -> "Run sync scripts" [label="scripts found"];
    "Check sync config" -> "Scan entities" [label="no scripts"];
    "Run sync scripts" -> "Scan entities";
    "Scan entities" -> "Read session-index";
    "Read session-index" -> "Aggregate data";
    "Aggregate data" -> "Display dashboard";
    "Display dashboard" -> "Wait for selection";
}
```

## External Sync (Optional)

**Power users can configure sync scripts** via `/alive:power-user-install` or manually.

Check for `alive.local.yaml` at ALIVE root:

```yaml
# alive.local.yaml
sync:
  slack: .claude/scripts/slack-sync.mjs
  gmail: .claude/scripts/gmail-sync.mjs
```

**If sync sources are configured:**

```
▸ checking alive.local.yaml for sync scripts...
  └─ Found: slack, gmail

▸ running sync scripts...
  └─ slack-sync.mjs... ✓ 3 new items
  └─ gmail-sync.mjs... ✓ 1 new item

4 new items added to 03_Inputs/
```

**If no config or no sync section:**
```
▸ checking alive.local.yaml...
  └─ No sync scripts configured
```

Skip to entity scanning.

**Script requirements:**
- Scripts should output to `03_Inputs/`
- Scripts should be idempotent (safe to run multiple times)
- Scripts should return exit code 0 on success
- Output format: one line per item added (for counting)

## Numbered Actions (REQUIRED)

Every actionable item gets a number. User picks a number to focus.

```
ONGOING THREADS
─────────────────────────────────────────────────────────────────────────
[1] alive-llc — Plugin rebuild [breakthrough]        yesterday
[2] supernormal — Client proposal [productive]       2 days ago

URGENT TASKS
─────────────────────────────────────────────────────────────────────────
[3] alive-llc: Finalize daily skill @urgent
[4] supernormal: Send proposal to Acme @urgent

WORKING FILES
─────────────────────────────────────────────────────────────────────────
[5] alive-llc/_working/v2-design.md                  1 day old

─────────────────────────────────────────────────────────────────────────
[#] Pick number to focus    [i] Process inputs    [n] New entity
```

When user picks:
- Thread number → `/alive:revive` with that session
- Task/file number → `/alive:do` with that entity
- `[i]` → `/alive:digest`
- `[n]` → `/alive:new`

## Section: Goals

Extract from each `_brain/status.md`:
- Look for `**Goal:**` line
- Or `**Focus:**` line
- Or first sentence after `## Current Focus`

Show entity name + goal. Max 5, sorted by recency.

```
YOUR GOALS
─────────────────────────────────────────────────────────────────────────
• alive-llc: Ship v2 plugin by Feb 15
• supernormal: Close 3 new clients this month
• hypha: Launch Feb 6
```

## Section: Ongoing Threads

Read `.claude/state/session-index.jsonl`:
- Filter: `status: "ongoing"` only
- Sort: Most recent first
- Show: Entity, summary, quality tag, relative time
- Max 5

Quality tags: `[routine]` `[productive]` `[important]` `[breakthrough]`

```
ONGOING THREADS
─────────────────────────────────────────────────────────────────────────
[1] alive-llc — Plugin rebuild [breakthrough]        yesterday
[2] supernormal — Client proposal [productive]       2 days ago
```

If no session-index.jsonl exists or empty:
```
ONGOING THREADS
─────────────────────────────────────────────────────────────────────────
No ongoing threads. Start fresh today.
```

## Section: Urgent Tasks

Scan all `_brain/tasks.md` files:
- Filter: Lines containing `@urgent`
- Prefix with entity name
- Max 5

```
URGENT TASKS
─────────────────────────────────────────────────────────────────────────
[3] alive-llc: Finalize daily skill @urgent
[4] supernormal: Send proposal to Acme @urgent
```

## Section: Working Files

Scan all `_brain/manifest.json` files:
- Look for `working_files` array
- Show path + age
- Max 5

```
WORKING FILES
─────────────────────────────────────────────────────────────────────────
[5] alive-llc/_working/v2-design.md                  1 day old
[6] supernormal/_working/acme-proposal-v0.md         3 days old
```

## Section: Inputs

Check `03_Inputs/` folder:
- Count files/folders (not counting .DS_Store)
- Flag if count > 0
- Flag if no captures in 3+ days

```
INPUTS
─────────────────────────────────────────────────────────────────────────
[!] 5 items pending triage
```

## Section: Stale Entities

Check each entity's `_brain/manifest.json` for `updated` date:
- Flag if > 7 days (configurable)
- Show as numbered option

```
STALE ENTITIES
─────────────────────────────────────────────────────────────────────────
[7] 05_Experiments/cricket-grid — 3 weeks stale
```

## Freshness Flags

| Age | Flag | Meaning |
|-----|------|---------|
| < 7 days | (none) | Fresh |
| 7-14 days | `[!]` | Getting stale |
| > 14 days | `[!!]` | Needs attention |

## Edge Cases

**No ALIVE structure:**
```
[?] No ALIVE structure detected.
Run /alive:onboarding to set up.
```

**Empty system (structure exists but no entities):**
```
Your ALIVE system is empty. Let's get started.
[1] Create first venture
[2] Create first experiment
[3] Capture some context
```

## The Learning Loop

Daily is the START:

```
DAILY ────► DO ────► SAVE ────► (repeat)
```

After showing dashboard, remind:
- Pick a number to focus → loads that entity via `/alive:do`
- When done → `/alive:save` to preserve context
- Tomorrow → back to `/alive:daily`

## Related Skills

- `/alive:do` — Focus on one entity
- `/alive:revive` — Resume past session
- `/alive:digest` — Process inputs
- `/alive:save` — End session
