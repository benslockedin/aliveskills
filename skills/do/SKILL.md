---
name: do
user-invocable: true
description: Start a work session on a project, loading its context and state. Use when the user says "work on X", "open X", "focus on X", "status of X", "continue", "resume", "whatsup", or "what's up".
---

# alive:do

Start a work session. Load context from a subdomain's `_brain/` folder and show current state.

## When to Use

Invoke when the user wants to:
- Begin working on a specific venture, experiment, or life area
- Check the status of a project
- Resume where they left off
- Get oriented ("whatsup", "what's happening")

## Flow

```
1. Identify subdomain (ask if ambiguous)
2. Read _brain/status.md
3. Read _brain/tasks.md
4. Read _brain/manifest.json
5. Show retrieval paths + summary
6. Offer next actions
```

## Step-by-Step

### Step 1: Identify the Subdomain

If user specifies a subdomain:
```
"work on acme" → ventures/acme/
"focus on health" → life/health/
```

If ambiguous, ask:
```
Which subdomain?

[1] ventures/acme
[2] ventures/beta
[3] experiments/gamma
```

### Step 2: Load Context

Read these files in order:

1. `{subdomain}/_brain/status.md` — Current phase and focus
2. `{subdomain}/_brain/tasks.md` — Work queue
3. `{subdomain}/_brain/manifest.json` — Structure map

Show retrieval paths:
```
▸ reading ventures/acme/_brain/status.md
  └─ Phase: Building (updated 2 days ago)

▸ reading ventures/acme/_brain/tasks.md
  └─ 7 tasks, 2 @urgent
```

### Step 3: Show Summary

Present the loaded context clearly:

**Vibrant theme:**
```
╭─ ALIVE ────────────────────────────────────────────────────────────────╮
│  do • ventures/acme                                                    │
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
- [ ] Create demo video
```

**Minimal theme:**
```
## ventures/acme

**Phase:** Building
**Focus:** Landing page launch by Friday

**Tasks:** 7 total, 2 urgent
- Finalize pricing page @urgent
- Fix payment webhook @urgent
```

### Step 4: Offer Next Actions

```
─────────────────────────────────────────────────────────────────────────
[1] Start on urgent tasks
[2] View full task list
[3] Check changelog
[s] Save when done

What's first?
```

## Context Freshness

Flag stale context:

| Age | Signal |
|-----|--------|
| < 2 weeks | `[OK]` — proceed normally |
| 2-4 weeks | `[!]` — flag, ask if still valid |
| > 4 weeks | Warn explicitly, suggest refresh |

Example:
```
[!] ventures/acme/_brain/status.md is 3 weeks old
    └─ May need refresh. Continue anyway?
```

## Edge Cases

**Subdomain doesn't exist:**
```
✗ ventures/acme/ not found

Create it?
[1] Yes, create ventures/acme/
[2] No, show available subdomains
```

**No _brain/ folder:**
```
[!] ventures/acme/ exists but has no _brain/

This subdomain needs initialization.
[1] Initialize _brain/ now
[2] Cancel
```

**Multiple matches:**
```
"work on beta" matches:
[1] ventures/beta
[2] experiments/beta-test

Which one?
```

## After Loading

Once context is loaded:
- Stay focused on this subdomain (scoped reading)
- Track changes for the session
- When done, prompt to save with `/alive:save`

## Related Skills

- `/alive:save` — End session, log changes
- `/alive:new` — Create a new subdomain
- `/alive:help` — Quick reference
