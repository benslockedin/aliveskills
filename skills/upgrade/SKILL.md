---
user-invocable: true
description: This skill should be used when the user says "upgrade", "migrate to v2", "convert to v2", or when `/alive:daily` or `/alive:do` detect v1 structure (`_state/` instead of `_brain/`, `inbox/` instead of `03_Inputs/`).
---

# alive:upgrade

Migrate an ALIVE system from v1 to v2 structure.

## v1 → v2 Changes

| v1 | v2 |
|----|-----|
| `inbox/` | `03_Inputs/` |
| `_state/` | `_brain/` |
| No session-index | `.claude/state/session-index.jsonl` |
| No memories folder | `{entity}/_brain/memories/` (created on breakthrough saves) |

## Flow (2-Session Approach)

**Upgrade requires TWO sessions.** Claude can't reload rules mid-session.

```
SESSION 1: Update Knowledge
─────────────────────────────────
1. Check rules status
2. Sync rules + CLAUDE.md from plugin
3. Tell user to exit and restart
4. EXIT (don't do structural changes yet)

SESSION 2: Structural Migration
─────────────────────────────────
1. Detect rules are current (or ask if already done)
2. Proceed with structural migration
3. Verify
```

## CRITICAL: Why 2 Sessions?

**Claude operates with its loaded mental model.** If you sync rules mid-session, Claude still has v1 knowledge. Only a fresh session loads the new rules.

**Wrong approach:**
1. Sync rules ← Claude still has v1 knowledge
2. Do structural migration ← Using v1 mental model = errors

**Correct approach:**
1. Session 1: Sync rules → EXIT
2. Session 2: Claude loads v2 rules → Do structural migration

---

## Step 0: Check If Already Upgraded

**First, ask if user has already done Session 1:**

```
Have you already updated rules and restarted Claude?

[1] No — this is my first time running upgrade
[2] Yes — I already updated rules and restarted
[3] Not sure — check for me
```

**If [2] Yes or rules are current:** Skip to Step 3 (structural migration)
**If [1] No or rules outdated:** Start with Step 1

## Step 1: Scan for v1 Patterns

Find all v1 artifacts, categorized:

```
▸ scanning for v1 patterns...

ROOT INBOX (v1):
  └─ inbox/ (should be 03_Inputs/)

ENTITY _STATE/ FOLDERS (v1):
  └─ 04_Ventures/acme/_state/
  └─ 04_Ventures/beta/_state/
  └─ 02_Life/finance/_state/

NESTED inbox/ FOLDERS:
  └─ 04_Ventures/acme/clients/foo/inbox/
  └─ 04_Ventures/hypha/inbox/

SKIP — TEMPLATES:
  └─ _working/template/*/_state/

SKIP — ARCHIVE:
  └─ 01_Archive/*/_state/

V2 FILES STATUS:
  └─ .claude/state/session-index.jsonl [missing/exists]

RULES STATUS:
  └─ .claude/rules/ [missing/exists]
  └─ If exists: [X files, Y outdated, Z missing]

ENTITY MEMORIES FOLDERS:
  └─ 04_Ventures/acme/_brain/memories/ [missing/exists]
  └─ 04_Ventures/beta/_brain/memories/ [missing/exists]
  (memories/ created automatically on breakthrough saves, missing is OK)
```

## Step 2: Confirm Scope

**Always ask before proceeding:**

```
Found 3 entities with _state/ folders and inbox/ directory.

What should be upgraded?
[1] Everything (recommended)
[2] Let me pick individually
[3] Cancel
```

**Handle special cases explicitly:**

| Case | Ask |
|------|-----|
| Template directories | "Found _state/ in templates. Skip templates?" |
| Archive | "Found _state/ in 01_Archive/. Upgrade archived items too?" |
| Nested entities | "Found _state/ at client level. Treat as entities?" |

**Default recommendations:**
- Templates → Skip (preserve as v1 templates)
- Archive → Skip (preserve history)
- Nested `_state/` → Ask (could be intentional entities)
- Nested `inbox/` → Rename to `03_Inputs/` (client-level inputs are valid)

## Step 2.5: Sync Rules + CLAUDE.md (SESSION 1)

**This step completes Session 1. Do NOT proceed to structural changes yet.**

```
▸ checking rules status...

Plugin rules: ~/.claude/plugins/cache/aliveskills/alive/{version}/rules/
Plugin CLAUDE.md: ~/.claude/plugins/cache/aliveskills/alive/{version}/CLAUDE.md
User rules:   {alive-root}/.claude/rules/
User CLAUDE.md: {alive-root}/.claude/CLAUDE.md
```

**Compare and sync:**
1. Check each plugin rule file against user's version
2. If user file is missing → copy from plugin
3. If user file differs from plugin → merge (preserve user customizations, update plugin sections)
4. Update `.claude/CLAUDE.md` with v2 framework paths

```
▸ syncing v2 knowledge...

RULES:
  └─ behaviors.md [outdated] → updated ✓
  └─ conventions.md [outdated] → updated ✓
  └─ intent.md [missing] → installed ✓
  └─ learning-loop.md [current] → skipped
  └─ ui-standards.md [outdated] → updated ✓
  └─ voice.md [current] → skipped
  └─ working-folder-evolution.md [missing] → installed ✓

CLAUDE.MD:
  └─ .claude/CLAUDE.md → updated with v2 paths ✓

✓ v2 knowledge installed (5 files updated)
```

### EXIT REQUIRED

```
╭─ IMPORTANT ────────────────────────────────────────────────────────────╮
│                                                                        │
│  Rules and CLAUDE.md have been updated to v2.                          │
│                                                                        │
│  Claude needs to RESTART to load the new knowledge.                    │
│                                                                        │
│  Please:                                                               │
│  1. Exit this Claude Code session (Ctrl+C or close terminal)          │
│  2. Start a new Claude Code session                                    │
│  3. Run /alive:upgrade again                                           │
│                                                                        │
│  On the next run, upgrade will detect the rules are current and        │
│  proceed directly to structural migration.                             │
│                                                                        │
╰────────────────────────────────────────────────────────────────────────╯
```

**STOP HERE. Do not proceed to Step 3 in this session.**

---

## Step 3: Execute Renames (SESSION 2 ONLY)

**Only run this step if:**
- User selected [2] "Yes — I already updated rules" in Step 0, OR
- Rules check confirms they are current

**Order matters:**

1. Rename `inbox/` → `03_Inputs/`
2. Rename each `_state/` → `_brain/`

Show progress:
```
▸ renaming inbox/ → 03_Inputs/
  ✓ done (3 files preserved)

▸ renaming 04_Ventures/acme/_state/ → _brain/
  ✓ done

▸ renaming 04_Ventures/beta/_state/ → _brain/
  ✓ done
```

## Step 4: Create/Update v2 Files

### 4a: System Files (If Missing)

```
▸ checking v2 system files...

.claude/state/session-index.jsonl
  └─ [exists] skipping
  └─ OR [missing] creating empty file
```

**session-index.jsonl format** (if creating):
```jsonl
{"created":"2026-01-30","note":"Migrated from v1"}
```

### 4b: Sync Rules (CRITICAL)

**Compare user's rules to plugin's rules and sync if different:**

```
▸ checking rules...

Plugin rules: ~/.claude/plugins/cache/aliveskills/alive/{version}/rules/
User rules:   {alive-root}/.claude/rules/
```

**If user has no rules directory:**
```
[!] No rules installed

ALIVE rules enforce system behaviour. Without them, Claude won't follow
ALIVE conventions.

Install rules now?
[1] Yes, install rules (recommended)
[2] Skip (system will be unreliable)
```

**If rules exist but are outdated:**
```
▸ comparing rules...

OUTDATED:
  └─ behaviors.md (plugin: 2026-02-01, yours: 2026-01-15)
  └─ conventions.md (plugin: 2026-02-01, yours: 2026-01-15)

MISSING:
  └─ working-folder-evolution.md (new in this version)

UP TO DATE:
  └─ intent.md
  └─ voice.md

Sync rules to latest?
[1] Yes, update all (recommended)
[2] Update only outdated
[3] Skip
```

**Implementation:**
```bash
# Compare checksums
for file in ~/.claude/plugins/cache/aliveskills/alive/*/rules/*.md; do
  filename=$(basename "$file")
  user_file="{alive-root}/.claude/rules/$filename"
  if [ ! -f "$user_file" ]; then
    echo "MISSING: $filename"
  elif ! diff -q "$file" "$user_file" > /dev/null 2>&1; then
    echo "OUTDATED: $filename"
  fi
done
```

**After sync:**
```
▸ syncing rules...
  └─ behaviors.md ✓
  └─ conventions.md ✓
  └─ working-folder-evolution.md ✓ (new)

✓ Rules synced (3 files updated)
```

### 4c: Sync Statusline (If Configured)

**Check if user has statusline configured, and if so, update it:**

```
▸ checking statusline...

~/.claude/statusline-command.sh
  └─ [not found] skipping (user hasn't configured statusline)
  └─ OR [outdated] plugin version is newer
  └─ OR [up to date] no action needed
```

**If statusline exists but is outdated:**
```
[!] Statusline script outdated

Your statusline was installed on 2026-01-28.
Plugin has newer version with fixes for:
  • 03_Inputs/ path detection (was inbox/)
  • ALIVE root indicator
  • Smart path detection

Update statusline?
[1] Yes, update (recommended)
[2] No, keep current
```

**Implementation:**
```bash
# Compare statusline if it exists
user_statusline="$HOME/.claude/statusline-command.sh"
plugin_statusline="$HOME/.claude/plugins/cache/aliveskills/alive/*/templates/config/statusline-command.sh"

if [ -f "$user_statusline" ]; then
  if ! diff -q $plugin_statusline "$user_statusline" > /dev/null 2>&1; then
    echo "OUTDATED: statusline-command.sh"
  fi
fi
```

**After sync:**
```
▸ updating statusline...
  └─ ~/.claude/statusline-command.sh ✓

✓ Statusline updated
```

**Note on memories/:** The `_brain/memories/` folder is created automatically by `/alive:save` when a session is marked as a breakthrough. Don't create it during upgrade — it appears organically when needed.

## Step 5: Verify

```
▸ verifying migration...

STRUCTURE
  ✓ No inbox/ found (now 03_Inputs/)
  ✓ No _state/ found in upgraded entities
  ✓ session-index.jsonl exists
  ✓ All _brain/ folders have required files

RULES
  ✓ .claude/rules/ exists
  ✓ All 7 rule files present and up to date

STATUSLINE (if configured)
  ✓ ~/.claude/statusline-command.sh up to date
  └─ OR [skipped] not configured

Migration complete.
```

**If verification fails, do NOT mark complete:**
```
✗ VERIFICATION FAILED

Missing:
  ✗ .claude/rules/ — rules not synced

[1] Fix now
[2] Cancel upgrade
```

## Edge Cases

**Single entity upgrade (from /alive:do):**

When called from `do` with a specific entity:
```
Upgrading 04_Ventures/acme only.

[1] Upgrade this entity
[2] Upgrade entire system
[3] Cancel
```

**Already v2:**
```
✓ System is already v2 structure.
  └─ 03_Inputs/ exists
  └─ All entities use _brain/

Nothing to upgrade.
```

**Mixed state:**
```
[!] Partial v2 detected

Already v2:
  └─ 04_Ventures/acme/_brain/

Still v1:
  └─ 04_Ventures/beta/_state/
  └─ inbox/

Upgrade remaining v1 items?
```

## Step 6: Update References (Optional)

After renames, offer to update documentation:

```
[!] Found references to v1 paths in:
  └─ .claude/CLAUDE.md (12 mentions of _state/)
  └─ .claude/rules/navigation.md (5 mentions)
  └─ .claude/rules/state-files.md (8 mentions)

Update these to v2 paths?
[1] Yes, update all
[2] No, I'll do it manually
```

If yes, replace:
- `_state/` → `_brain/`
- `inbox/` → `03_Inputs/`
- `subdomain` → `entity` (terminology)

## After Upgrade

```
✓ Migration complete.

Summary:
• Renamed inbox/ → 03_Inputs/
• Renamed X entities from _state/ → _brain/
• Created/verified v2 system files
• [Updated/Skipped] documentation references

Next: Run /alive:daily to see your v2 dashboard.
```

## Related Skills

- `/alive:daily` — Detects v1, calls this skill
- `/alive:do` — Detects v1, calls this skill
- `/alive:onboarding` — Fresh v2 setup (no migration)
