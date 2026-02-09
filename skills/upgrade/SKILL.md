---
user-invocable: true
description: This skill should be used when the user says "upgrade", "update system", "sync", or when another skill detects a version mismatch between plugin_version and system_version in alive.local.yaml.
plugin_version: "2.1.0"
---

# alive:upgrade

Upgrade the user's ALIVE system to match the current plugin version. Detects what's out of date, applies changes with subagents, verifies with sweep.

## UI Treatment

This skill uses **Tier 3: Utility** formatting.

**Visual elements:**
- Compact logo (4-line ASCII art header)
- Double-line border wrap (entire response)
- Version footer: `ALIVE v2.1` (right-aligned)

See `rules/ui-standards.md` for exact border characters, logo assets, and formatting specifications.

---

## How Version Tracking Works

**Two version numbers:**

| Version | Location | Updated by |
|---------|----------|------------|
| `plugin_version` | Frontmatter of every skill file | Plugin auto-update |
| `system_version` | `{alive-root}/.claude/alive.local.yaml` | This upgrade skill (after success) |

When `plugin_version > system_version` → system needs upgrading.
When they match → system is current.

---

## Flow

```
1. Detect versions (plugin vs system)
2. If match → "You're up to date"
3. If mismatch → identify required migrations
4. Show migration plan, get user approval
5. Session 1: Sync rules + CLAUDE.md → EXIT (Claude must reload)
6. Session 2: Structural changes via subagents
7. Run /alive:sweep to verify
8. Update system_version in alive.local.yaml
```

---

## Step 1: Version Detection

```
▸ checking versions...

Plugin version: 2.1.0 (from skill frontmatter)
System version: [read from alive.local.yaml]
```

**Read `{alive-root}/.claude/alive.local.yaml`** and extract `system_version`.

| Scenario | Action |
|----------|--------|
| `system_version` missing | Treat as `"unknown"` — run all migrations |
| `system_version` < `plugin_version` | Run migrations for each version gap |
| `system_version` == `plugin_version` | "You're up to date" → exit |

```
▸ versions detected
  └─ Plugin: 2.1.0 | System: unknown
  └─ Migrations needed: pre-2.1.0 → 2.1.0
```

---

## Step 2: Show Migration Plan

List all changes that will be applied. **Get user approval before proceeding.**

```
UPGRADE PLAN: → 2.1.0
════════════════════════════════════════════════════════════════════════════

This upgrade requires TWO sessions (Claude must restart to load new rules).

SESSION 1 (now):
  [A] Rules sync — update .claude/rules/ to match plugin
  [B] CLAUDE.md assimilation — merge new sections into your .claude/CLAUDE.md
  → Then EXIT and restart Claude

SESSION 2 (after restart):
  [C] Folder structure — add _references/, fix old folder names
  [D] Manifest schema — update all manifest.json files
  [E] Config — set system_version in alive.local.yaml
  → Then /alive:sweep to verify

════════════════════════════════════════════════════════════════════════════

Proceed?
[1] Yes — start Session 1
[2] I already did Session 1 — skip to Session 2
[3] Cancel
```

---

## Why 2 Sessions?

Claude operates with its loaded rules. If you sync rules mid-session, Claude still has the old knowledge loaded. Only a fresh session loads the new rules. Session 1 updates the files, Session 2 uses the updated knowledge.

---

## Session 1: Knowledge Sync

### Step A: Rules Sync (Subagent)

**Launch a Task subagent with this prompt:**

```
You are upgrading ALIVE rules files. Compare the plugin's rules against the user's installed rules and sync them.

PLUGIN RULES: ~/.claude/plugins/cache/aliveskills/alive/2.0.1/rules/
USER RULES: {alive-root}/.claude/rules/

For EACH rule file in the plugin directory:

1. If the file doesn't exist in the user's directory → COPY it from plugin
2. If the file exists but differs → READ both versions, then OVERWRITE the user's file with the plugin version

The rules files are system files owned by the plugin. They should match the plugin exactly. User customizations to rules are not expected — these are behavioral instructions, not user content.

After processing all files, report:
- Which files were copied (new)
- Which files were updated (changed)
- Which files were already current (skipped)
- Total files processed

Expected rule files: behaviors.md, conventions.md, intent.md, learning-loop.md, ui-standards.md, voice.md, working-folder-evolution.md
```

**Show results:**
```
▸ syncing rules...
  └─ behaviors.md — updated ✓
  └─ conventions.md — updated ✓
  └─ intent.md — current, skipped
  └─ learning-loop.md — updated ✓
  └─ ui-standards.md — current, skipped
  └─ voice.md — current, skipped
  └─ working-folder-evolution.md — current, skipped

✓ Rules synced (3 updated, 4 current)
```

### Step B: CLAUDE.md Assimilation (Subagent)

**CRITICAL: Do NOT overwrite the user's CLAUDE.md. Merge changes in.**

**Launch a Task subagent with this prompt:**

```
You are assimilating changes from the plugin's CLAUDE.md into the user's installed CLAUDE.md. The user may have added custom content to their CLAUDE.md — you MUST preserve it.

PLUGIN CLAUDE.MD: ~/.claude/plugins/cache/aliveskills/alive/2.0.1/CLAUDE.md
USER CLAUDE.MD: {alive-root}/.claude/CLAUDE.md

Instructions:
1. Read BOTH files completely
2. Identify sections/content in the PLUGIN version that are MISSING from the USER version
3. Identify sections in the USER version that have OUTDATED content compared to the PLUGIN version
4. For each difference, apply this logic:

   MISSING SECTION in user file:
   → Add the section from plugin at the appropriate location (match the plugin's ordering)

   OUTDATED SECTION (same heading, different content):
   → Replace the section content with the plugin version
   → BUT: If the user has added custom lines BELOW a section (like personal notes, extra context), preserve those custom additions

   SECTION EXISTS ONLY IN USER FILE (not in plugin):
   → KEEP IT. This is user customization. Do not remove.

5. After making changes, report:
   - Sections added (new from plugin)
   - Sections updated (content refreshed)
   - User sections preserved (not in plugin, kept)
   - No changes needed (already current)

IMPORTANT: Use the Edit tool for each change, not Write. Make surgical edits.
```

**Show results:**
```
▸ assimilating CLAUDE.md changes...
  └─ Added: _references/ to Structure section
  └─ Updated: Session Protocol (delegates to /alive:save)
  └─ Preserved: [any user-custom sections]

✓ CLAUDE.md assimilated (1 added, 1 updated, 0 user sections preserved)
```

### Session 1 Exit

```
╭─ RESTART REQUIRED ─────────────────────────────────────────────────────╮
│                                                                        │
│  Rules and CLAUDE.md have been updated.                                │
│                                                                        │
│  Claude must RESTART to load the new knowledge.                        │
│                                                                        │
│  1. Exit this session (Ctrl+C or close terminal)                       │
│  2. Start a new Claude Code session                                    │
│  3. Run /alive:upgrade again                                           │
│                                                                        │
│  Next run will detect Session 1 is done and proceed to                 │
│  structural migration.                                                 │
│                                                                        │
╰────────────────────────────────────────────────────────────────────────╯
```

**STOP. Do not proceed to Session 2 steps.**

---

## Session 2: Structural Migration

**Only run if user selected [2] in Step 2, or if rules check confirms they are current.**

### Step C: Folder Structure (Subagent)

**Launch a Task subagent with this prompt:**

```
You are upgrading the ALIVE folder structure. Scan the user's ALIVE directory and fix any structural issues.

ALIVE ROOT: {alive-root}

TASK 1 — Find all entities:
Entities are folders that contain a _brain/ subdirectory. Search:
- {alive-root}/04_Ventures/*/          (depth 1)
- {alive-root}/04_Ventures/*/*/        (depth 2, nested entities)
- {alive-root}/05_Experiments/*/       (depth 1)
- {alive-root}/05_Experiments/*/*/     (depth 2)
- {alive-root}/02_Life/*/              (depth 1, if any are entities)

List every entity found.

TASK 2 — For each entity, check:
a) Does _references/ folder exist? If not → create it
b) Does _state/ exist instead of _brain/? If so → rename _state/ to _brain/

TASK 3 — Check root-level folders:
a) Does inbox/ exist? If so → rename to 03_Inputs/
b) Does archive/ exist without 01_ prefix? → rename to 01_Archive/
c) Does life/ exist without 02_ prefix? → rename to 02_Life/
d) Does ventures/ exist without 04_ prefix? → rename to 04_Ventures/
e) Does experiments/ exist without 05_ prefix? → rename to 05_Experiments/

TASK 4 — Check system directories:
a) Does {alive-root}/.claude/state/ exist? If not → create it
b) Does {alive-root}/.claude/state/session-index.jsonl exist? If not → create empty file

IMPORTANT:
- Do NOT touch anything in 01_Archive/
- Do NOT rename folders inside templates/
- ASK before renaming if unsure
- Report every action taken

Report format:
- Entities found: [count]
- _references/ created: [list]
- Folders renamed: [list]
- System files created: [list]
- Already current: [list]
- Skipped: [list with reason]
```

**Show results:**
```
▸ checking folder structure...
  └─ 5 entities found
  └─ _references/ created in: 04_Ventures/acme, 05_Experiments/beta
  └─ No old folder names detected
  └─ System directories present

✓ Folder structure current (2 folders created)
```

### Step D: Manifest Schema (Subagent)

**Launch a Task subagent with this prompt:**

```
You are upgrading ALIVE manifest.json files to the v2 schema. Check every entity's manifest and update if needed.

ALIVE ROOT: {alive-root}

TASK 1 — Find all manifest files:
Search for _brain/manifest.json in all entities (same entity paths as folder structure task).

TASK 2 — For each manifest.json, read it and check:

a) Does "folders" array include "_references"?
   If not → add "_references" to the array

b) Does a "references" array exist at the top level?
   If not → add: "references": []

c) Does a "key_files" array exist?
   If not → add: "key_files": [{"path": "CLAUDE.md", "description": "Entity identity"}]

d) Does a "handoffs" array exist?
   If not → add: "handoffs": []

e) Are there any OLD schema fields that should be removed?
   Remove if found: "type", "goal" (top-level), "sessions" (top-level array),
   top-level "files" array with "summary"/"modified"/"key" fields

f) Check areas[].files[] format — each file entry should have:
   {"path": "...", "description": "..."} and optionally "session_id"
   If old format (with "summary" instead of "description") → rename field

TASK 3 — Update the "updated" field to today's date and "session_id" to the current session ID.

IMPORTANT:
- Use Edit tool, not Write — preserve existing data
- Do NOT remove areas, working_files, or other valid content
- Only add missing fields and remove deprecated ones
- Report every change made per manifest

Report format per entity:
- Entity: [path]
- Fields added: [list]
- Fields removed: [list]
- Already current: true/false
```

**Show results:**
```
▸ updating manifest schemas...
  └─ 04_Ventures/acme — added references[], _references to folders
  └─ 04_Ventures/beta — already current
  └─ 05_Experiments/test — added handoffs[], key_files[]

✓ Manifests updated (2 changed, 1 current)
```

### Step E: Config Update

**Update `{alive-root}/.claude/alive.local.yaml`:**

Read the current file. Add or update `system_version` field:

```yaml
theme: vibrant
onboarding_complete: true
system_version: "2.1.0"
```

Use Edit if the file exists (preserve other fields). Use Write only if the file doesn't exist.

```
▸ updating config...
  └─ alive.local.yaml — set system_version: "2.1.0"

✓ Config updated
```

---

## Step 3: Post-Upgrade Sweep

**Invoke `/alive:sweep` using the Skill tool** to verify everything is aligned.

```
▸ running post-upgrade sweep...
```

The sweep will catch any issues the subagents missed. If sweep finds problems, fix them before marking upgrade complete.

---

## Step 4: Final Verification

```
╔══════════════════════════════════════════════════════════════════════════╗
║                                                                        ║
║    ▄▀█ █░░ █ █░█ █▀▀                                                   ║
║    █▀█ █▄▄ █ ▀▄▀ ██▄            upgrade complete                      ║
║                                                                        ║
║  ══════════════════════════════════════════════════════════════════    ║
║                                                                        ║
║  UPGRADE SUMMARY                                                       ║
║  ──────────────────────────────────────────────────────────────────    ║
║  Plugin: 2.1.0 → System: 2.1.0 ✓                                      ║
║                                                                        ║
║  [A] Rules: X updated, Y current                                       ║
║  [B] CLAUDE.md: X sections added, Y updated                            ║
║  [C] Folders: X _references/ created, Y renames                        ║
║  [D] Manifests: X updated, Y current                                   ║
║  [E] Config: system_version set to 2.1.0                               ║
║  [F] Sweep: ✓ passed                                                   ║
║                                                                        ║
║  ──────────────────────────────────────────────────────────────────    ║
║                                                                ALIVE v2.1║
╚══════════════════════════════════════════════════════════════════════════╝
```

---

## Edge Cases

**Already up to date:**
```
✓ System is current (2.1.0)
  └─ No upgrade needed.
```

**No alive.local.yaml:**
```
[!] No alive.local.yaml found at {alive-root}/.claude/

This file tracks your system version. Creating it now.
```
Create the file with `system_version: "2.1.0"` and `onboarding_complete: true`.

**Single entity upgrade (from /alive:do):**
```
This skill upgrades the ENTIRE system, not individual entities.
Proceeding with full system upgrade.
```

**Partial upgrade (Session 1 done, Session 2 pending):**
Detect by checking: rules are current but `system_version` < `plugin_version`.
Skip directly to Session 2 steps.

---

## Migration Registry

### pre-2.1.0 → 2.1.0

| Category | Changes |
|----------|---------|
| **Folders** | Add `_references/` to all entities. Rename `inbox/`→`03_Inputs/`, `archive/`→`01_Archive/`, `life/`→`02_Life/`, `ventures/`→`04_Ventures/`, `experiments/`→`05_Experiments/`, `_state/`→`_brain/`. |
| **Rules** | Sync all 7 rule files. Key changes: `_references/` system in conventions.md and behaviors.md, folder renames in all files, visual identity system in ui-standards.md. |
| **CLAUDE.md** | Add `_references/` to structure, update session protocol to delegate to `/alive:save`, remove duplicated sections (Capture Triggers, Context Freshness, etc.), condense Life First. |
| **Manifests** | Add `references[]`, `key_files[]`, `handoffs[]`. Add `_references` to folders. Remove deprecated `type`, `goal`, old `files[]` format. |
| **Config** | Add `system_version: "2.1.0"` to alive.local.yaml. |
| **Statusline** | Update statusline-command.sh if configured (numbered folder detection, ALIVE root indicator). |

**Future migrations will be added as new sections here.**

---

## Related Skills

- `/alive:daily` — Checks version mismatch, suggests upgrade
- `/alive:do` — Checks version mismatch, suggests upgrade
- `/alive:save` — Checks version mismatch, suggests upgrade
- `/alive:sweep` — Called post-upgrade for verification
- `/alive:onboarding` — Fresh setup (no migration needed)
