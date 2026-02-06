---
user-invocable: true
description: This skill should be used when the user says "work on X", "focus on X", "open X", "status of X", "let's do X", "continue", "resume", "keep going", or "pick up where I left off". Focuses on one specific venture, experiment, or life area.
---

# alive:do

Focus on ONE entity. Load context from its `_brain/` folder and show current state.

**Different from `/alive:daily`:** Do focuses on ONE entity. Daily shows EVERYTHING.

## Flow

```dot
digraph do_flow {
    "Start" -> "User specified entity?";
    "User specified entity?" -> "Find entity" [label="yes"];
    "User specified entity?" -> "Check session-index" [label="no"];
    "Check session-index" -> "Offer recent entity" [label="found"];
    "Check session-index" -> "Ask which entity" [label="empty"];
    "Find entity" -> "Check structure";
    "Offer recent entity" -> "Check structure";
    "Ask which entity" -> "Check structure";
    "Check structure" -> "Offer upgrade" [label="_state/ found"];
    "Check structure" -> "cd into entity" [label="_brain/ OK"];
    "Offer upgrade" -> "cd into entity" [label="after upgrade"];
    "cd into entity" -> "Load _brain/";
    "Load _brain/" -> "Check freshness";
    "Check freshness" -> "Flag stale" [label="> 2 weeks"];
    "Check freshness" -> "Show summary" [label="fresh"];
    "Flag stale" -> "Show summary";
    "Show summary" -> "Offer actions";
}
```

## Step 1: Identify Entity

**User specifies entity:**
```
"work on acme" → 04_Ventures/acme/
"focus on health" → 02_Life/health/
```

**User says "continue" or "resume" (no entity):**
1. Read `.claude/state/session-index.jsonl`
2. Find most recent `status: "ongoing"` entry
3. Offer that entity:
```
▸ checking session-index...
  └─ Last session: 04_Ventures/alive-llc (yesterday, [breakthrough])

Continue with alive-llc?
[1] Yes
[2] Pick different entity
```

**No session-index or no ongoing threads:**
```
No recent session found.

Which entity?
[1] 04_Ventures/acme-agency
[2] 04_Ventures/side-project
[3] 05_Experiments/new-idea
```

**Multiple matches:**
```
"work on beta" matches:
[1] 04_Ventures/beta
[2] 05_Experiments/beta-test

Which one?
```

## Step 2: Check Structure (v1 Detection)

Before loading, check if entity uses v1 structure:

```
Check: Does {entity}/_state/ exist? (should be _brain/)
```

If v1 detected:
```
[!] 04_Ventures/acme uses v1 structure (_state/)

Upgrade to v2?
[1] Yes, upgrade now
[2] No, continue with v1
```

If yes → invoke `/alive:upgrade` with this entity, then continue.
If no → use `_state/` paths for this session.

## Step 2.5: Change to Entity Directory (MANDATORY)

**Before loading context, `cd` into the entity directory:**

```bash
cd {alive-root}/{entity}/
```

For example:
```bash
cd ~/Desktop/alive/04_Ventures/acme-agency/
```

**Why this matters:**
- Claude's system context automatically reads `.claude/CLAUDE.md` from the working directory
- Local `CLAUDE.md` files get picked up
- All relative paths in the session work correctly
- The entity becomes the "home base" for the session

**Show the change:**
```
▸ cd 04_Ventures/acme-agency/
  └─ Working directory set
```

## Step 3: Load Context (MANDATORY — All 4 Files)

**You MUST read all 4 files. Do not skip any.**

Read in order:
1. `{entity}/_brain/status.md` — Phase and focus
2. `{entity}/_brain/tasks.md` — Work queue
3. `{entity}/_brain/manifest.json` — Structure map
4. `{entity}/_brain/changelog.md` — **Last 200 lines** (recent session history)

**The changelog is CRITICAL.** It contains:
- What happened in recent sessions
- Decisions made and why
- Context that won't be in status.md
- Where we left off last time

**Show retrieval paths:**
```
▸ reading 04_Ventures/acme/_brain/status.md
  └─ Phase: Building (updated 2 days ago)

▸ reading 04_Ventures/acme/_brain/tasks.md
  └─ 7 tasks, 2 @urgent

▸ reading 04_Ventures/acme/_brain/manifest.json
  └─ 12 files tracked, 3 references

▸ reading 04_Ventures/acme/_brain/changelog.md (last 200 lines)
  └─ Last session: 2026-02-04 — Plugin UI updates
```

**Implementation:**
```
Read(file_path: "{entity}/_brain/changelog.md", offset: -200)
```
Or read the full file if it's less than 200 lines.

**References:** If the manifest has a `references` array, mention the count to the user (e.g. "3 reference docs available"). Don't load the files — just surface awareness. Users can ask to read specific references on demand.

## Step 3.5: Check for Pending Handoffs

**After loading manifest, check for pending handoffs:**

```
▸ checking for pending handoffs...
```

Look in `manifest.json` for:
```json
{
  "handoffs": [
    {
      "path": "_working/sessions/description-sessionid-timestamp.md",
      "status": "pending",
      "created": "2026-02-02T15:30:00",
      "description": "Brief description"
    }
  ]
}
```

**If pending handoffs found:**

```
╭─ UNFINISHED SESSION ──────────────────────────────────────────────────╮
│                                                                        │
│  Found handoff from previous session:                                  │
│                                                                        │
│  📄 alive-plugin-feedback-abc12345-2026-02-02-1530.md                  │
│     Created: 2026-02-02 15:30                                          │
│     Reason: Context compaction                                         │
│                                                                        │
╰────────────────────────────────────────────────────────────────────────╯

Resume this session?
[1] Yes — load handoff and continue
[2] No — start fresh (archive handoff)
```

**If [1] Yes (ARCHIVE IMMEDIATELY):**
1. Read the handoff document content into memory
2. **IMMEDIATELY archive the file** (don't wait until later):
   ```
   ▸ archiving handoff (already read)...
     └─ Moving to 01_Archive/{entity-path}/sessions/
     └─ Removing from manifest.handoffs

   ✓ Handoff archived — context loaded
   ```
3. Present the context, current state, and next steps to user
4. Skip to "After Loading" section — user is now briefed

**Why archive immediately?** The handoff's job is done once read. Archiving later gets forgotten. Archive on read ensures 100% adherence.

**If [2] No:**
- Archive the handoff (user chose not to resume, so it's stale)
- Continue with normal do flow

**If no pending handoffs:**
```
▸ checking for pending handoffs...
  └─ None found
```

Continue to Step 4.

## Step 4: Check Freshness

Check `updated` date in manifest.json or file timestamps:

| Age | Action |
|-----|--------|
| < 2 weeks | Proceed normally |
| 2-4 weeks | Flag: `[!] Status is X days old. Still accurate?` |
| > 4 weeks | Warn + ask: `[!!] Status is very stale. Update before working?` |

```
[!] 04_Ventures/acme/_brain/status.md is 3 weeks old
    └─ Still accurate? [y] continue  [u] update first
```

## Step 5: Show Summary

```
╭─ ALIVE ────────────────────────────────────────────────────────────────╮
│  do • 04_Ventures/acme                                                 │
╰────────────────────────────────────────────────────────────────────────╯

▸ loaded context

STATUS
Phase: Building
Focus: Landing page launch by Friday

TASKS (7 total)
@urgent:
- [ ] Finalize pricing page
- [ ] Fix payment webhook

To Do:
- [ ] Write launch email
- [ ] Update docs
```

## Step 6: Offer Actions

Every actionable item gets a number:

```
─────────────────────────────────────────────────────────────────────────
[1] Finalize pricing page @urgent
[2] Fix payment webhook @urgent
[3] Write launch email
[c] View changelog
[s] Save when done

What's first?
```

## Edge Cases

**Entity doesn't exist:**
```
✗ 04_Ventures/acme/ not found

[1] Create 04_Ventures/acme/ (→ /alive:new)
[2] Show available entities
```

**No _brain/ or _state/ folder:**
```
[!] 04_Ventures/acme/ exists but has no context folder

Initialize _brain/ now?
[1] Yes, initialize
[2] Cancel
```

## After Loading

- Stay scoped to this entity (don't read other entities)
- Track changes for session
- When done → `/alive:save`

## Related Skills

- `/alive:daily` — See ALL entities
- `/alive:save` — End session
- `/alive:new` — Create entity
- `/alive:upgrade` — Migrate v1 → v2
- `/alive:handoff` — Session continuity (creates handoff docs for resumption)
