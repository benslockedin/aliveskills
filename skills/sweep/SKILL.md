---
name: sweep
description: This skill should be used when the user asks to "sweep", "clean up", "audit", "check for stale", "maintenance", "anything stale", "what needs cleanup", "spring cleaning", "tidy up", or wants to audit the system for stale content and cleanup opportunities.
---

# alive:sweep

Audit the system. Find stale content, identify cleanup opportunities, maintain health.

## When to Use

Invoke when the user:
- Wants to check system health
- Asks about stale content
- Needs to clean up
- Says "sweep", "audit", "maintenance"

## Sweep Checks

| Check | What it finds |
|-------|---------------|
| Stale _brain/ | Subdomains not updated recently |
| Empty areas | Folders with no content |
| Orphaned files | Files outside proper structure |
| Stuck tasks | Tasks marked in-progress too long |
| Large _working/ | Drafts that should be promoted or archived |
| Missing manifests | Subdomains without manifest.json |

## Flow

```
1. Scan all domains
2. Run health checks
3. Present findings
4. Offer cleanup actions
5. Execute selected cleanups
```

## Step-by-Step

### Step 1: Scan System

```
╭─ ALIVE ────────────────────────────────────────────────────────────────╮
│  sweep                                                                 │
╰────────────────────────────────────────────────────────────────────────╯

▸ scanning system...

Checking:
  └─ ventures/ (3 subdomains)
  └─ experiments/ (2 subdomains)
  └─ life/ (4 areas)
  └─ inbox/ (5 items)
  └─ archive/
```

### Step 2: Health Report

```
SYSTEM HEALTH
─────────────────────────────────────────────────────────────────────────

STALE SUBDOMAINS (not updated >2 weeks)
[1] [!] ventures/old-project     42 days stale
[2] [!] experiments/abandoned    28 days stale

STUCK TASKS (in-progress >1 week)
[3] ventures/acme: "Update documentation" (12 days)
[4] ventures/beta: "Fix login bug" (8 days)

LARGE _working/ (>5 files)
[5] ventures/acme/_working/ — 12 files, oldest 3 weeks

EMPTY AREAS
[6] ventures/acme/templates/ — 0 files

ORPHANED FILES
[7] ventures/random-note.md — file in subdomain root

INBOX BACKLOG
[8] inbox/ — 5 items pending (oldest: 2 weeks)

─────────────────────────────────────────────────────────────────────────
[#] Address specific issue    [a] Address all    [i] Ignore for now

What to address?
```

### Step 3: Address Issues

#### Stale Subdomain

```
▸ [1] ventures/old-project — 42 days stale

Last updated: 2025-12-12
Status: "Building" (unchanged)
Open tasks: 3

Options:
[1] Archive — Move to archive/ (project complete/abandoned)
[2] Refresh — Open and update status
[3] Ignore — Mark as intentionally dormant
[4] Skip
```

#### Stuck Task

```
▸ [3] ventures/acme: "Update documentation"

In progress for: 12 days
Assigned: (none)

Options:
[1] Complete — Mark as done
[2] Reset — Move back to To Do
[3] Remove — Delete task
[4] Update — Change status/details
[5] Skip
```

#### Large _working/

```
▸ [5] ventures/acme/_working/ — 12 files

Files:
  - acme_landing-v0.html (3 weeks old)
  - acme_landing-v1.html (2 weeks old)
  - acme_landing-v2.html (1 week old)
  - acme_old-proposal.md (4 weeks old)
  ... and 8 more

Suggestions:
[1] Promote v2 to main, archive older versions
[2] Review each file
[3] Bulk archive files >2 weeks old
[4] Skip
```

#### Orphaned File

```
▸ [7] ventures/random-note.md

File in subdomain root (should be in area or _working/).

Content preview:
"Quick note about the API changes..."

Options:
[1] Move to _working/
[2] Move to specific area
[3] Process as capture
[4] Delete
[5] Skip
```

### Step 4: Execute Cleanups

```
▸ executing cleanups...

[1] ✓ Archived ventures/old-project/
[3] ✓ Moved task to "Done"
[5] ✓ Promoted landing-v2, archived v0 and v1
[7] ✓ Moved random-note.md to _working/

4 issues resolved.
```

## Automated Sweep

Configure sweep interval in `alive.local.yaml`:

```yaml
sweep_interval_days: 7
last_sweep: 2026-01-16
```

When interval exceeded, prompt:
```
[!] It's been 8 days since last sweep.

Run system audit?
[1] Yes, run sweep
[2] Remind me later
[3] Disable reminders
```

## Sweep Thresholds

| Check | Default Threshold |
|-------|-------------------|
| Stale _brain/ | 14 days |
| Stuck in-progress | 7 days |
| Large _working/ | 5+ files |
| Old drafts | 14 days in _working/ |
| Inbox backlog | 7 days oldest item |

## Quick Sweep

For fast overview without detail:

```
User: "Quick sweep"

▸ quick system scan...

HEALTH SUMMARY
─────────────────────────────────────────────────────────────────────────
Subdomains:  5 active, 2 stale
Tasks:       23 open, 4 stuck
Inbox:       5 items (oldest 2 weeks)
Working:     18 drafts across 3 subdomains

Status: [!] Needs attention

[1] Full sweep (see details)
[2] Ignore for now
```

## Sweep by Domain

Focus on specific domain:

```
User: "Sweep ventures only"

▸ scanning ventures/...

[Shows only venture-related issues]
```

## Post-Sweep

After sweep completion:

```
✓ Sweep complete

Resolved: 4 issues
Remaining: 2 issues (ignored)
Next sweep: 2026-01-30

System health: [OK] Good
```

Update `alive.local.yaml`:
```yaml
last_sweep: 2026-01-23
```

## Edge Cases

**Everything clean:**
```
▸ scanning system...

✓ No issues found

System is healthy:
- All subdomains active
- No stuck tasks
- Inbox clear
- _working/ folders tidy

Next scheduled sweep: 2026-01-30
```

**Massive cleanup needed:**
```
Found 47 issues.

Batch cleanup?
[1] Address critical only (12 items)
[2] Address by category
[3] Address all (will take time)
[4] Export list for manual review
```

## Related Skills

- `/alive:archive` — Move items to archive
- `/alive:digest` — Process inbox backlog
- `/alive:do` — Refresh stale subdomain
