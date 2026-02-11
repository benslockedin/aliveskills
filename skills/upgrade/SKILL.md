---
user-invocable: true
description: Update ALIVE system files to the latest plugin version — rules, CLAUDE.md, and configuration. Use when the user says "upgrade", "update system", or when a version mismatch is detected.
plugin_version: "3.0.1"
---

# alive:upgrade

Upgrade the user's ALIVE system to match the current plugin version. Detects what's out of date, applies changes with subagents, verifies with sweep.

## UI Treatment

This skill uses **Tier 3: Utility** formatting.

**Visual elements:**
- Compact logo (4-line ASCII art header)
- Double-line border wrap (entire response)
- Version footer: `ALIVE v3.0.1` (right-aligned)

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
3. If mismatch → check Migration Registry for required migrations
4. If NO structural migrations → fast path (bump system_version only)
5. If structural migrations → show plan, get user approval
6. Session 1: Sync rules + CLAUDE.md → EXIT (Claude must reload)
7. Session 2: Structural changes via subagents
8. Run /alive:sweep to verify
9. Update system_version in alive.local.yaml
```

---

## Step 1: Version Detection

```
▸ checking versions...

Plugin version: 3.0.1 (from skill frontmatter)
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
  └─ Plugin: 3.0.1 | System: unknown
  └─ Migrations needed: pre-2.1.1 → 3.0.1
```

---

## Step 1.5: Check Migration Registry (Fast Path)

After detecting a version mismatch, check the Migration Registry (at the bottom of this skill) for entries covering the version gap.

**If NO structural migration entry exists for the version gap** (e.g. the gap is a skill-only update), take the fast path:

```
▸ checking versions...
  └─ Plugin: 3.0.1 | System: 2.1.1

▸ checking migration registry...
  └─ Structural migrations needed for 2.1.1 → 3.0.1
  └─ See migration plan below

✓ System version synced. No migration needed.
```

**Implementation:**
1. Read the Migration Registry section of this skill
2. Look for an entry covering the user's current `system_version` → `plugin_version` gap
3. If an entry exists with `type: skill-only` → fast path: just update `system_version` in alive.local.yaml and exit
4. If an entry exists with structural changes → proceed to Step 2 (full migration)
5. If no entry exists at all and `system_version` is `"unknown"` → proceed to Step 2 (full migration for fresh/unknown systems)

**Fast path actions:**
- Update `system_version` in `{alive-root}/.claude/alive.local.yaml` to match `plugin_version`
- Show the user what changed (from the registry entry's description)
- Exit — no restart needed, no structural changes

**STOP here if fast path was taken. Do not proceed to Step 2.**

---

## Step 2: Show Migration Plan

List all changes that will be applied. **Get user approval before proceeding.**

```
UPGRADE PLAN: → 2.1.1
════════════════════════════════════════════════════════════════════════════

This upgrade requires TWO sessions (Claude must restart to load new rules).

SESSION 1 (now):
  [A] Rules sync — update .claude/rules/ to match plugin
  [B] CLAUDE.md assimilation — merge new sections into your .claude/CLAUDE.md
  → Then EXIT and restart Claude

SESSION 2 (after restart):
  [C] Folder structure — add _references/, fix old folder names
  [D] Manifest schema — update all manifest.json files
  [E] References audit — restructure loose context into _references/ format
  [F] Config — set system_version in alive.local.yaml
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

PLUGIN RULES: ~/.claude/plugins/cache/aliveskills/alive/3.0.1/rules/
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

PLUGIN CLAUDE.MD: ~/.claude/plugins/cache/aliveskills/alive/3.0.1/CLAUDE.md
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

TASK 1 — Find all projects:
Projects are folders that contain a _brain/ subdirectory. Search:
- {alive-root}/04_Ventures/*/          (depth 1)
- {alive-root}/04_Ventures/*/*/        (depth 2, nested projects)
- {alive-root}/05_Experiments/*/       (depth 1)
- {alive-root}/05_Experiments/*/*/     (depth 2)
- {alive-root}/02_Life/*/              (depth 1, if any are projects)

List every project found.

TASK 2 — For each project, check:
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
- Projects found: [count]
- _references/ created: [list]
- Folders renamed: [list]
- System files created: [list]
- Already current: [list]
- Skipped: [list with reason]
```

**Show results:**
```
▸ checking folder structure...
  └─ 5 projects found
  └─ _references/ created in: 04_Ventures/acme, 05_Experiments/beta
  └─ No old folder names detected
  └─ System directories present

✓ Folder structure current (2 folders created)
```

### Step D: Manifest Schema (Subagent)

**Launch a Task subagent with this prompt:**

```
You are upgrading ALIVE manifest.json files to the v2 schema. Check every project's manifest and update if needed.

ALIVE ROOT: {alive-root}

TASK 1 — Find all manifest files:
Search for _brain/manifest.json in all projects (same project paths as folder structure task).

TASK 2 — For each manifest.json, read it and check against the TARGET SCHEMA below. Fix any deviations.

TARGET SCHEMA (v2):

{
  "name": "project-name",
  "description": "One sentence description",
  "goal": "Single-sentence goal that filters all decisions",
  "created": "2026-01-20",
  "updated": "2026-01-23",
  "session_ids": ["abc12345", "def67890"],

  "folders": ["_brain", "_working", "_references", "...other folders"],

  "areas": [
    {
      "path": "clients/",
      "description": "Active client projects",
      "has_projects": false,
      "files": [
        {
          "path": "README.md",
          "description": "Client area overview",
          "date_created": "2026-01-20",
          "date_modified": "2026-01-23",
          "session_ids": ["abc12345"]
        }
      ]
    }
  ],

  "working_files": [
    {
      "path": "_working/landing-v0.html",
      "description": "Draft landing page with hero and features",
      "date_created": "2026-01-20",
      "date_modified": "2026-01-23",
      "session_ids": ["abc123"]
    }
  ],

  "key_files": [
    {
      "path": "CLAUDE.md",
      "description": "Project identity and navigation",
      "date_created": "2026-01-20",
      "date_modified": "2026-01-23"
    }
  ],

  "handoffs": [],

  "references": [
    {
      "path": "_references/emails/2026-02-06-supplier-quote.md",
      "type": "email",
      "description": "Supplier confirms 15% price increase, bulk order before Feb 28",
      "date_created": "2026-02-06",
      "date_modified": "2026-02-06",
      "session_ids": ["xyz789"]
    }
  ]
}

MIGRATION CHECKS — compare each manifest against the target schema:

a) ROOT FIELDS:
   - "goal" missing → add "goal": "" (empty, user will fill in)
   - "session_id" (string) exists → convert to "session_ids" (array): ["old-value"]
   - "session_ids" missing entirely → add "session_ids": []

b) FOLDERS ARRAY:
   - "_references" not in "folders" → add it

c) REQUIRED TOP-LEVEL ARRAYS:
   - "references" missing → add "references": []
   - "key_files" missing → add "key_files": [{"path": "CLAUDE.md", "description": "Project identity"}]
   - "handoffs" missing → add "handoffs": []

d) DEPRECATED FIELDS — remove if found:
   - "type" (top-level)
   - "sessions" (top-level array)
   - Top-level "files" array with old "summary"/"modified"/"key" fields

e) FILE ENTRY FORMAT — check ALL entries in areas[].files[], working_files[], key_files[], references[]:
   - "summary" field → rename to "description"
   - "session_id" (string) → convert to "session_ids" (array)
   - "date_created" missing → add with today's date
   - "date_modified" missing → add with today's date

f) REFERENCES ENTRIES — each must have "type" field (email, call, screenshot, etc.)

g) Update "updated" field to today's date and append current session ID to "session_ids".

IMPORTANT:
- Use Edit tool, not Write — preserve existing data
- Do NOT remove areas, working_files, or other valid content
- Only add missing fields and remove deprecated ones
- Report every change made per manifest

Report format per project:
- Project: [path]
- Fields added: [list]
- Fields removed: [list]
- Fields renamed: [list]
- Already current: true/false
```

**Show results:**
```
▸ updating manifest schemas...
  └─ 04_Ventures/acme — added goal, references[], converted session_id → session_ids
  └─ 04_Ventures/beta — already current
  └─ 05_Experiments/test — added handoffs[], key_files[], date fields on 3 entries

✓ Manifests updated (2 changed, 1 current)
```

### Step E: References Content Audit (Subagent)

**This step audits each project's `_references/` folder and restructures any loose or non-conforming context files into the correct format.**

Step C creates the `_references/` folder. This step ensures what's INSIDE it is correct — and finds context files elsewhere in the project that should be moved into `_references/`.

**Launch a Task subagent with this prompt:**

```
You are auditing and restructuring _references/ content across all ALIVE projects. Your job is to ensure every project's reference material follows the correct structure.

ALIVE ROOT: {alive-root}

WHAT _references/ SHOULD LOOK LIKE:

_references/
├── meeting-transcripts/
│   ├── 2026-02-08-content-planning.md        ← YAML front matter + AI summary
│   └── raw/
│       └── 2026-02-08-content-planning.txt   ← Original source file
├── emails/
│   ├── 2026-02-06-supplier-quote.md
│   └── raw/
│       └── 2026-02-06-supplier-quote.txt
├── screenshots/
│   ├── 2026-02-06-competitor-landing.md
│   └── raw/
│       └── 2026-02-06-competitor-landing.png
└── documents/
    ├── 2026-02-06-contract-scan.md
    └── raw/
        └── 2026-02-06-contract-scan.pdf

REQUIRED YAML FRONT MATTER on every summary .md file:

---
type: email | call | screenshot | document | article | message
date: 2026-02-06
description: One-line description of what this reference contains
source: Where it came from (person name, tool, etc.)
tags: [keyword, keyword, keyword]
# Additional fields by type:
# emails: from, to, subject
# calls/meetings: participants, duration
# messages: platform
---

FIND ALL ENTITIES:
Search for _brain/ folders in:
- {alive-root}/04_Ventures/*/
- {alive-root}/04_Ventures/*/*/
- {alive-root}/05_Experiments/*/
- {alive-root}/05_Experiments/*/*/
- {alive-root}/02_Life/*/

FOR EACH ENTITY, run these 6 audits:

AUDIT 1 — Find loose context files that should be in _references/:
Search the entire project (excluding _brain/, _working/, .claude/, 01_Archive/) for files that look like reference material:
- Transcript files (.txt files with meeting/call content)
- Email exports
- Screenshot images with no summary .md
- PDFs, documents that are source material (not working drafts)
- Files in folders named "context/", "notes/", "research/", "docs/" that are external source material
- Any file that is clearly captured external content, not something the user created

For each found: report the file path and what type of reference it appears to be.
Do NOT move anything — just report. The user will approve moves.

AUDIT 2 — Check _references/ subfolder structure:
For each subfolder in _references/:
a) Does a raw/ subfolder exist? If not → flag as needing one
b) Are there files directly in _references/ root that should be in a type subfolder? → flag

AUDIT 3 — Validate YAML front matter on all summary .md files in _references/:
For each .md file (NOT in raw/ subfolders):
a) Does it have YAML front matter (--- delimiters)? If not → flag as MISSING FRONT MATTER
b) Does front matter have ALL required fields?
   Required always: type, date, description, source, tags
   Required for emails: from, to, subject
   Required for calls/meetings: participants, duration (if known)
c) Does "description" use the correct field name? (not "summary") → flag if wrong
d) Is the front matter well-formed YAML? → flag if malformed

For each issue: report the file, what's missing/wrong, and suggest the fix.

AUDIT 4 — Check raw/ file pairing:
For each summary .md in _references/:
a) Does a corresponding raw file exist in the raw/ subfolder? → flag if missing
b) Does the summary .md have a ## Source section pointing to the raw file? → flag if missing
c) Do the summary .md and raw file share the same base name? → flag if mismatched

For each found raw file:
a) Does a corresponding summary .md exist? → flag orphaned raw files that have no summary

AUDIT 5 — Check file naming convention:
For all files in _references/ (both summary and raw):
a) Does the filename follow YYYY-MM-DD-descriptive-name pattern? → flag if not
b) Are there garbage filenames (CleanShot, IMG_xxxx, document (3), etc.)? → flag with suggested rename

AUDIT 6 — Check manifest references[] entries:
Read _brain/manifest.json and compare against actual _references/ contents:
a) Files in _references/ that have NO manifest entry → flag as untracked
b) Manifest entries that point to files that DON'T EXIST → flag as stale
c) Manifest entries missing required fields (type, description, date_created, date_modified, session_ids) → flag

AFTER ALL AUDITS, produce a structured report:

ENTITY: [path]
  Loose context files found: [count]
    - [path] → suggest move to _references/[type]/
  Missing raw/ subfolders: [count]
    - [subfolder]
  Front matter issues: [count]
    - [file]: missing [fields]
  Orphaned raw files: [count]
    - [file]: no summary .md
  Naming issues: [count]
    - [file] → suggested rename: [new name]
  Manifest sync issues: [count]
    - [file]: untracked / stale / missing fields

THEN: For each issue category, ask the user:
  "Fix [category] issues? [y/n]"

When fixing:
- Create missing raw/ subfolders
- Add missing YAML front matter fields to existing .md files (use Edit, not Write)
- Rename garbage filenames
- Add ## Source sections pointing to raw files
- Add missing manifest references[] entries
- Remove stale manifest entries
- Do NOT move loose context files without explicit user approval per file

IMPORTANT:
- Use Edit tool for all file modifications — never Write (which overwrites)
- Do NOT touch files in 01_Archive/
- Do NOT modify raw/ file contents — only rename if naming convention is wrong
- Report everything before fixing — user approves each category
- If an project's _references/ is empty, just report "No references yet" and move on
```

**Show results:**
```
▸ auditing _references/ content...
  └─ 04_Ventures/acme — 3 front matter issues, 1 orphaned raw file
  └─ 04_Ventures/beta — clean ✓
  └─ 05_Experiments/test — 2 loose context files found, 1 naming issue

Fix front matter issues in acme? [y/n]
Fix loose files in test? [y/n]
```

### Step F: Config Update

**Update `{alive-root}/.claude/alive.local.yaml`:**

Read the current file. Add or update `system_version` field:

```yaml
theme: vibrant
onboarding_complete: true
system_version: "3.0.1"
```

Use Edit if the file exists (preserve other fields). Use Write only if the file doesn't exist.

```
▸ updating config...
  └─ alive.local.yaml — set system_version: "3.0.1"

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
║  Plugin: 3.0.1 → System: 3.0.1 ✓                                      ║
║                                                                        ║
║  [A] Rules: X updated, Y current                                       ║
║  [B] CLAUDE.md: X sections added, Y updated                            ║
║  [C] Folders: X _references/ created, Y renames                        ║
║  [D] Manifests: X updated, Y current                                   ║
║  [E] References: X issues fixed, Y projects clean                      ║
║  [F] Config: system_version set to 3.0.1                               ║
║  [G] Sweep: ✓ passed                                                   ║
║                                                                        ║
║  ──────────────────────────────────────────────────────────────────    ║
║                                                            ALIVE v3.0.1║
╚══════════════════════════════════════════════════════════════════════════╝
```

---

## Edge Cases

**Already up to date:**
```
✓ System is current (3.0.1)
  └─ No upgrade needed.
```

**No alive.local.yaml:**
```
[!] No alive.local.yaml found at {alive-root}/.claude/

This file tracks your system version. Creating it now.
```
Create the file with `system_version: "3.0.1"` and `onboarding_complete: true`.

**Single project upgrade (from /alive:work):**
```
This skill upgrades the ENTIRE system, not individual projects.
Proceeding with full system upgrade.
```

**Partial upgrade (Session 1 done, Session 2 pending):**
Detect by checking: rules are current but `system_version` < `plugin_version`.
Skip directly to Session 2 steps.

---

## Migration Registry

### pre-2.1.1 → 2.1.1

| Category | Changes |
|----------|---------|
| **Folders** | Add `_references/` to all projects. Rename `inbox/`→`03_Inputs/`, `archive/`→`01_Archive/`, `life/`→`02_Life/`, `ventures/`→`04_Ventures/`, `experiments/`→`05_Experiments/`, `_state/`→`_brain/`. |
| **Rules** | Sync all 7 rule files. Key changes: `_references/` system in conventions.md and behaviors.md, folder renames in all files, visual identity system in ui-standards.md. |
| **CLAUDE.md** | Add `_references/` to structure, update session protocol to delegate to `/alive:save`, remove duplicated sections (Capture Triggers, Context Freshness, etc.), condense Life First. |
| **Manifests** | Add `references[]`, `key_files[]`, `handoffs[]`, `goal`. Add `_references` to folders. Convert `session_id` (string) → `session_ids` (array). Add `date_created`, `date_modified`, `session_ids` to file entries. Rename `summary` → `description`. Remove deprecated `type`, old `files[]` format. |
| **References** | Audit all `_references/` content: validate YAML front matter, ensure `raw/` subfolders exist, check summary/raw file pairing, fix garbage filenames, sync manifest `references[]` entries, find loose context files that should be in `_references/`. |
| **Config** | Add `system_version: "2.1.1"` to alive.local.yaml. |
| **Statusline** | Update statusline-command.sh if configured (numbered folder detection, ALIVE root indicator). |

### 2.1.0 → 2.1.1

**Type: skill-only** (no structural migration needed — fast path)

| Category | Changes |
|----------|---------|
| **Skills** | Onboarding rewritten as two-session flow (system setup → restart → content setup). Upgrade skill gains fast path for skill-only updates. All 16 skills bumped to 2.1.1. |
| **Onboarding** | `alive.local.yaml` now comprehensive: includes `alive_root`, `timezone`, `theme`, `working_style`, `onboarding_part` tracking. Two-session flow with forced restart between system and content setup. Added AI conversation history import prompt (Step 20). |
| **Versioning** | `alive.local.yaml` now always includes `system_version` from initial onboarding. Migration Registry supports `type: skill-only` entries for fast-path upgrades. |
| **Config** | Update `system_version: "2.1.1"` in alive.local.yaml. |

No structural changes. Plugin auto-update delivers the new skill files. Users just need `system_version` bumped.

### 2.1.1 → 3.0.1

| Category | Changes |
|----------|---------|
| **Product** | Rebranded to aliveOS Unlimited Elephant. Version jump from 2.1.1 to 3.0.1. |
| **Terminology** | "entity" → "project", "subdomain" → "project", "sub-entity" → "sub-project", "has_entities" → "has_projects" across all rules, templates, skills, and CLAUDE.md. |
| **Skills** | `do` renamed to `work`. `capture-context` renamed to `capture`. `power-user-install` renamed to `scan`. Skill descriptions rewritten (what-it-does first, triggers second). |
| **Rules** | New `anti-patterns.md` (9 rules). `capture` skill now proactively invokes on external content. All rules updated for terminology changes. |
| **UI** | Elephant mascot (Beate Schwichtenberg large, jrei small). Roman FIGlet "ALIVE" wordmark. Boot screen with manifesto. |
| **Config** | Update `system_version: "3.0.1"` in alive.local.yaml. |

---

**Future migrations will be added as new sections here.**

---

## Related Skills

- `/alive:daily` — Checks version mismatch, suggests upgrade
- `/alive:work` — Checks version mismatch, suggests upgrade
- `/alive:save` — Checks version mismatch, suggests upgrade
- `/alive:sweep` — Called post-upgrade for verification
- `/alive:onboarding` — Fresh setup (no migration needed)
