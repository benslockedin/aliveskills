---
user-invocable: true
description: Audit the system for stale content, orphan files, and cleanup opportunities. Use when the user says "sweep", "clean up", "audit", "check for stale", "maintenance", or "spring cleaning".
plugin_version: "3.1.0"
---

# alive:sweep

Audit one ALIVE unit at a time using 3 focused sub-agents in parallel. Entity-scoped — sweep one unit deeply, then optionally loop to the next.

## UI Treatment

Uses the **ALIVE Shell** — Tier 3: Utility.

```
╭──────────────────────────────────────────────────────────╮
│  ALIVE · sweep                          [date]            │
│  [N] stale  ·  [N] actionable                             │
│  ──────────────────────────────────────────────────────── │
│  [Stale items with recommendations]                       │
│  ──────────────────────────────────────────────────────── │
│  [ACTIONS]                                                │
╰──────────────────────────────────────────────────────────╯
```

See `rules/ui-standards.md` for shell format, logo assets, and tier specifications.

---

## When to Use

Invoke when the user:
- Wants to check system health
- Asks about stale content
- Needs to clean up or organise
- Says "sweep", "audit", "maintenance", "spring cleaning"

---

## Step 1: Unit Discovery + Selection

**Show all units with quick health indicators. User picks ONE to sweep, or takes the quick overview.**

Scan each domain for units (folders with `_brain/`). For each unit, read `_brain/status.md` to get Phase and Updated date. Also count `03_Inputs/` items.

```
╭──────────────────────────────────────────────────────────────────────╮
│    ______/ \-.   _      _____      _____ ___ ___                      │
│ .-/     (    o\_//     / __\ \    / / __| __| _ \                     │
│  |  ___  \_/\---'      \__ \\ \/\/ /| _|| _||  _/                    │
│  |_||  |_||            |___/ \_/\_/ |___|___|_|                       │
│                        aliveOS [Unlimited Elephant 3.0.1]              │
│  ──────────────────────────────────────────────────────────────────── │
│                                                                       │
│  units                                                                │
│  ──────────────────────────────────────────────────────────────────── │
│  [1] 04_Ventures/acme          Building    2 days ago                 │
│  [2] 04_Ventures/side-project  Starting    18 days ago  [!]           │
│  [3] 05_Experiments/new-idea   Starting    1 day ago                  │
│  [4] 02_Life/health            Maintaining 5 days ago                 │
│                                                                       │
│  03_Inputs/: 2 items pending                                          │
│                                                                       │
│  ──────────────────────────────────────────────────────────────────── │
│  #) pick unit to sweep    q) quick overview                           │
│                                                        ALIVE v3.0.1   │
╰──────────────────────────────────────────────────────────────────────╯
```

**Use AskUserQuestion** with the discovered units as options, plus "Quick overview" as the last option.

**Staleness indicators:**
- `[!]` if Updated date is >14 days old
- No indicator if fresh

---

## Quick Overview (Fast Path)

When user picks "Quick overview" or says "quick sweep":

**Skip sub-agents entirely.** Just scan top-level structure and read dates.

```
▸ quick system scan...

HEALTH SUMMARY
─────────────────────────────────────────────────────────────────────────
Root:        ✓ Clean (6 allowed folders, 0 violations)
Inputs:      3 items (oldest 5 days)

Units:
  acme                 Building    Updated 2 days ago     7 _working/ files
  side-project         Growing     Updated 18 days ago    3 _working/ files  [!]
  new-idea             Starting    Updated 1 day ago      0 _working/ files

Status: [!] 1 unit stale

─────────────────────────────────────────────────────────────────────────
[#] Pick a unit for deep sweep
[d] Done
```

Quick overview leads naturally into picking a unit for deep sweep, or exiting.

---

## Step 2: Dispatch 3 Sub-Agents in Parallel

**Once the user picks a unit, dispatch 3 sub-agents using the Task tool — all in a single message so they run in parallel.**

Each agent gets a focused domain, explicit instructions on HOW to check (which tools to use), and returns structured findings.

```python
# All 3 dispatched in parallel in a single message
Task(subagent_type="general-purpose", prompt=AGENT_1_PROMPT, description="Sweep structure: {unit}")
Task(subagent_type="general-purpose", prompt=AGENT_2_PROMPT, description="Sweep content: {unit}")
Task(subagent_type="general-purpose", prompt=AGENT_3_PROMPT, description="Sweep files: {unit}")
```

---

### Agent 1: Root + Structure

**Checks:** Root directory audit + A (Required Structure) + C (Manifest Reconciliation) + H (Orphaned & Misplaced Files) + I (Nested Project Check) + K (Archive References)

**Why grouped:** All structural/filesystem compliance — "Does the right stuff exist in the right places?"

**Always checks root** regardless of which unit is selected — root violations affect the whole system.

#### Agent 1 Prompt

```
You are auditing an ALIVE unit for STRUCTURAL compliance. You check that files exist in the right places.

UNIT: {unit_path}
ALIVE ROOT: ~/Desktop/alive

---

HOW TO CHECK: Use `Glob` to discover files. Use `Read` to read file contents. Use `Bash` with `ls` for directory listings. Be thorough — check actual disk contents, don't guess.

QUALITY GATE: Before returning, list which files and directories you actually read/listed. Do not guess or assume — every finding must come from an actual tool call.

---

## ROOT AUDIT (always runs)

Use `Bash` with `ls -1` on the ALIVE root. The ONLY allowed top-level items are:

```
.claude/              ✓ System config
01_Archive/           ✓ Inactive items
02_Life/              ✓ Personal
03_Inputs/            ✓ Incoming context
04_Ventures/          ✓ Revenue-generating
05_Experiments/       ✓ Testing grounds
alive.local.yaml      ✓ User preferences (optional)
.gitignore            ✓ Git config (optional)
.DS_Store             ✓ macOS (ignore)
Icon\r                ✓ macOS folder icon (ignore)
```

Everything else at root is a violation. Common pitfalls:
- `docs/` or `docs/plans/` → should be `{unit}/_working/plans/`
- `inbox/` → old v1 naming, should be `03_Inputs/`
- `_state/` → old v1 naming, should be `_brain/`
- Random .md files (TODO.md, NOTES.md, TASKS.md, FUTURE-TODO.md) → should be in a unit's `_brain/`
- Unnumbered domains (`archive/`, `ventures/`) → old v1 naming
- `temp/`, `scratch/`, `test.md` → doesn't belong
- Nested `.git/` inside units → flag

Report: ROOT_VIOLATION: {item} — {what it is} — {suggested fix}
If clean: ROOT: OK

Also count items in `03_Inputs/` (excluding .DS_Store, Icon files):
Report: INPUTS: {count} items pending

---

## A. Required Structure

Check that these exist in the unit:
- .claude/CLAUDE.md OR root-level CLAUDE.md (unit identity)
- _brain/status.md
- _brain/tasks.md
- _brain/insights.md
- _brain/changelog.md
- _brain/manifest.json
- _working/ folder
- _references/ folder

For each missing: MISSING: {path} — {what it should contain}

---

## C. Manifest Reconciliation

Read _brain/manifest.json and reconcile against actual disk contents.

1. **Ghost entries:** Files in manifest that DON'T exist on disk
   - Check every path in areas[].files[], working_files[], key_files[], references[]
   - Use `Glob` with the file path to verify existence
   - Report: GHOST: {path} listed in manifest but missing from disk

2. **Untracked files:** Files on disk NOT in manifest
   - Use `Glob` with `**/*` in the unit to list ALL files recursively
   - Exclude: .claude/, _brain/, .DS_Store, Icon files
   - Compare against ALL manifest entries (areas[].files[], working_files[], key_files[], references[])
   - For each untracked file:
     a. Read the file to understand its contents
     b. Run `stat -f "%SB" -t "%Y-%m-%d" {file}` for creation date and `stat -f "%Sm" -t "%Y-%m-%d" {file}` for modification date
     c. Determine which manifest section it belongs in:
        - In `_working/` → `working_files[]`
        - In `_references/` → `references[]` (include `type` field)
        - In an area folder listed in `areas[]` → that area's `files[]`
        - In an area folder NOT in `areas[]` → report MISSING_AREA too, then propose for that area's `files[]`
        - At unit root → `key_files[]`
     d. Generate the COMPLETE proposed manifest entry as JSON
   - Report format (one per file):
     ```
     UNTRACKED: {path}
     section: {working_files|references|areas["{area_path}"].files|key_files}
     entry: {"path": "{relative_path}", "description": "{AI-generated description}", "date_created": "{YYYY-MM-DD}", "date_modified": "{YYYY-MM-DD}", "session_ids": []}
     ```
   - The fix agent will use these entries verbatim to insert into manifest.json

3. **Folder list accuracy:** Does manifest.folders[] match actual folders?
   - Use `ls` to list actual top-level folders in the unit
   - Report: MISSING_FOLDER: {folder} on disk but not in manifest.folders[]
   - Report: GHOST_FOLDER: {folder} in manifest.folders[] but not on disk

4. **Area accuracy:** Do manifest.areas[] match actual area folders?
   - Report: MISSING_AREA: {folder} on disk but not in manifest.areas[]
   - Report: GHOST_AREA: {area} in manifest.areas[] but not on disk

5. **Missing file metadata:** Every file entry must have: `date_created`, `date_modified`, `session_ids` (array)
   - Report: MISSING_METADATA: {path} — missing {fields}
   - Check manifest root for `goal` and `session_ids` (array, not singular)
   - Report: LEGACY_FIELD: manifest root has `session_id` (singular) — should be `session_ids` (array)
   - Report: MISSING_GOAL: manifest root missing `goal` field

---

## H. Orphaned & Misplaced Files

1. **Files in unit root** that shouldn't be there:
   - Allowed in root: CLAUDE.md (if no .claude/), README.md
   - Everything else: ORPHAN: {filename} in unit root

2. **Common pitfalls inside units:**
   - plans/ → should be _working/plans/
   - docs/plans/ → should be _working/plans/
   - inbox/ → old naming
   - _state/ → should be _brain/
   - FUTURE-TODO.md → merge into _brain/tasks.md
   - TODO.md, NOTES.md → should be in _brain/
   - Report: MISPLACED: {path} — {why} — {suggested fix}

3. **Areas without README.md:**
   - Every area folder (non-_prefixed, non-_brain, non-_working, non-_references, non-.claude) should have README.md
   - Report: NO_README: {area_path}

---

## I. Nested Project Check

For any area with has_projects: true in manifest:
- Check each nested project has its own _brain/, _working/, _references/
- Check nested projects DON'T use parent's _working/
- Report: PROJECT_MISSING: {project_path} missing {_brain|_working|_references}
- Report: PROJECT_MISUSE: {project_path} has files in parent's _working/

---

## K. Archive References

Search unit files for paths containing `01_Archive/`. Check if the referenced archive path actually exists.
- Report: DEAD_ARCHIVE_REF: {file} references {archive_path} which doesn't exist

---

OUTPUT FORMAT:

Return findings grouped by severity. Use EXACTLY this format:

### CRITICAL
- CODE: description

### WARNING
- CODE: description

### INFO
- CODE: description

### CLEAN
- check: OK

### FILES READ
- List every file/directory you actually inspected
```

---

### Agent 2: Content Health

**Checks:** B (Status.md Structure) + D (_brain/ Freshness) + E (Tasks Health) + F (Insights Boundary Check)

**Why grouped:** All about _brain/ file content quality — "Is the content well-formed and current?"

#### Agent 2 Prompt

```
You are auditing an ALIVE unit for CONTENT HEALTH. You check that _brain/ files are well-formed, current, and properly maintained.

UNIT: {unit_path}

---

HOW TO CHECK: Use `Read` to read file contents. Use `Bash` with `stat -f "%Sm" -t "%Y-%m-%d" {file}` to get actual file modification dates on macOS. Today's date is {today}.

QUALITY GATE: Before returning, list which files you actually read. Every finding must come from an actual file read — do not guess content or dates.

---

## B. Status.md Structure Validation

Read _brain/status.md and check for the required sections:

1. **Goal:** — One sentence defining the unit's purpose
2. **Phase:** — [Starting | Building | Launching | Growing | Maintaining | Paused]
3. **Updated:** — ISO date (YYYY-MM-DD)
4. **Key People** — People involved
5. **State of Play** — Current situation
6. **Priorities** — What matters most
7. **Blockers** — What's stopping progress ("None" if clear)
8. **Next Milestone** — What "done" looks like for this phase

Check for:
- Missing sections → MISSING_STATUS_SECTION: {section name}
- "Current Focus" instead of "State of Play" → LEGACY_STATUS_FORMAT
- Missing Goal → MISSING_GOAL
- Full person details in Key People instead of links to 02_Life/people/ → PEOPLE_IN_STATUS

---

## D. _brain/ Freshness

For EACH _brain/ file, check when it was last meaningfully updated:

| File | How to check the date |
|------|----------------------|
| status.md | Look for **Updated:** date in content |
| tasks.md | Look for most recent [x] done date, OR use `stat` for filesystem mod date |
| changelog.md | Look for most recent `## YYYY-MM-DD` header |
| manifest.json | Check the `"updated"` field value |
| insights.md | Use `stat` for filesystem mod date |

Age brackets:
| Age | Flag |
|-----|------|
| < 14 days | OK |
| 14-28 days | STALE |
| > 28 days | VERY_STALE |

Report: FRESHNESS: {file} — {age} days — {OK|STALE|VERY_STALE}

---

## E. Tasks Health

Read _brain/tasks.md and check:

1. **Stuck tasks:** Tasks marked `[~]` (in-progress) — check if they've been in-progress for >7 days
   - Look for date annotations, or check changelog for when work started
   - Report: STUCK: "{task text}" — in-progress for >{N} days

2. **Urgent idle:** Tasks marked `@urgent` that are NOT `[~]` (not being worked on)
   - Report: URGENT_IDLE: "{task text}" — marked urgent but not in-progress

3. **Bloated task list:** >30 total items across all sections
   - Report: BLOATED: {count} tasks — consider archiving completed items or breaking into projects

4. **Done section overflow:** >20 items in "Done (Recent)" section
   - Report: DONE_OVERFLOW: {count} done items — archive older completions

---

## F. Insights Boundary Check

Read _brain/insights.md and scan each entry for misplaced content:

| Pattern | Flag | Suggestion |
|---------|------|------------|
| Entries about Claude/API/technical patterns | INSIGHT_MISPLACED: "{title}" — auto-memory territory | Should be in ~/.claude/projects/*/memory/MEMORY.md |
| Entries about specific people (not domain learnings) | INSIGHT_MISPLACED: "{title}" — people belong in status.md Key People or 02_Life/people/ | Re-categorise under strategy/product/process/market |
| Entries that read like decisions (rationale, alternatives rejected) | INSIGHT_MISPLACED: "{title}" — decision territory | Should be in changelog |
| Entries older than 6 months with no "Applies to" | INSIGHT_STALE: "{title}" — {age} old, no "Applies to" reference | Ask user if still relevant |

Valid categories: strategy, product, process, market

---

OUTPUT FORMAT:

Return findings grouped by severity. Use EXACTLY this format:

### CRITICAL
- CODE: description

### WARNING
- CODE: description

### INFO
- CODE: description

### CLEAN
- check: OK

### FILES READ
- List every file you actually read
```

---

### Agent 3: Files & Naming

**Checks:** G (_working/ Folder Audit — improved) + J (_references/ Folder Audit) + L (Naming Convention Audit — new)

**Why grouped:** All about file-level checks — staleness, naming, structure.

#### Agent 3 Prompt

```
You are auditing an ALIVE unit for FILE HEALTH AND NAMING. You check that files are named correctly, not stale, and properly structured.

UNIT: {unit_path}

---

HOW TO CHECK: Use `Glob` to discover files. Use `Read` to check file contents. Use `Bash` with `stat -f "%Sm" -t "%Y-%m-%d" {file}` to get modification dates AND `stat -f "%SB" -t "%Y-%m-%d" {file}` to get creation dates (macOS). Today's date is {today}.

QUALITY GATE: Before returning, list which files you actually inspected. Every finding must come from an actual tool call.

---

## G. _working/ Folder Audit

Use `Glob` with `{unit_path}/_working/**/*` to list all files. For each file:

### 1. File Naming
Check files follow `[unit]_[context]_[name].ext` pattern.
- Report: BAD_WORKING_NAME: {filename} — missing unit prefix or context

### 2. File Age (use `stat` for ACTUAL dates — do not guess)

Run `stat -f "%Sm" -t "%Y-%m-%d" {file}` on each file to get the real modification date. Calculate age from today.

Age brackets:
| Age | Flag |
|-----|------|
| < 7 days | OK |
| 7-14 days | AGING |
| 14-28 days | STALE_DRAFT |
| > 28 days | VERY_STALE_DRAFT |

Report: WORKING_AGE: {filename} — modified {date} — {age} days — {OK|AGING|STALE_DRAFT|VERY_STALE_DRAFT}

### 3. Abandoned Draft Detection

For each file, get BOTH creation and modification dates:
```bash
stat -f "%SB" -t "%Y-%m-%d" {file}   # creation date
stat -f "%Sm" -t "%Y-%m-%d" {file}    # modification date
```

If creation date ≈ modification date (within 1 day) AND age > 7 days → file was created but never edited.
- Report: ABANDONED_DRAFT: {filename} — created {date}, never modified, {age} days old

### 4. Plans Cleanup

Check `_working/plans/` specifically. For each plan file >14 days old:
- Read `_brain/tasks.md` and check if the plan is referenced anywhere
- If not referenced: STALE_PLAN: {filename} — {age} days old, not referenced in tasks.md

### 5. Sessions Cleanup

Check `_working/sessions/` for handoff files:
- Read `_brain/manifest.json` and check manifest.handoffs[]
- Any file in _working/sessions/ NOT referenced in manifest.handoffs[] is orphaned
- Report: ORPHAN_HANDOFF: {filename} — not in manifest.handoffs[]

### 6. Evolution Candidates

Group files by shared prefix (first part before underscore or first 2 path segments). If 3+ files share a prefix:
- Report: EVOLVE: prefix "{prefix}" — {count} related files — consider promoting to folder

---

## J. _references/ Folder Audit

Use `Glob` with `{unit_path}/_references/**/*` to discover all reference files.

### 1. Structure Validation
Each type subfolder (emails/, calls/, meeting-transcripts/, etc.) must have a `raw/` subfolder.
- Report: MISSING_RAW_DIR: {type-folder}/ has no raw/ subfolder

### 2. Summary-Raw Pairing
Every summary `.md` at the type folder root should have a corresponding file in `raw/` sharing the same base name (different extension). And vice versa.
- Report: ORPHAN_SUMMARY: {filename}.md has no matching file in raw/
- Report: ORPHAN_RAW: raw/{filename} has no matching summary .md
- Exception: `notes/` type may not always need raw files

### 3. Front Matter Validation
Read each summary `.md` and check for valid YAML front matter:
- Required fields: `type`, `date`, `description`
- Must have `## Summary` or `## Analysis` section
- Must have `## Source` section pointing to raw file
- Report: BAD_FRONTMATTER: {filename} — missing {field}
- Report: NO_FRONTMATTER: {filename} — no YAML front matter found
- Report: NO_SOURCE: {filename} — missing ## Source pointer to raw file

### 4. Manifest Cross-Reference
Read manifest.json references[] array. Compare against actual files in _references/.
- Report: ORPHAN_REF: {path} exists on disk but not in manifest references[]
- Report: GHOST_REF: {path} in manifest references[] but missing from disk

### 5. Stale References
Check `date` field in front matter. References >90 days old get INFO-level flag.
- Report: OLD_REF: {filename} — {age} days old

### 6. Raw Files at Wrong Level
Check for raw content files (.txt, .pdf, .png, .jpg, .doc) at type folder root instead of in raw/.
- Report: MISPLACED_RAW: {filename} should be in raw/ subfolder

---

## L. Naming Convention Audit (Broad)

### 1. Folder Names
Use `ls` to list all folders recursively in the unit (excluding .claude/, _brain/ internals).
Rules:
- Must be lowercase-with-hyphens
- Exceptions: numbered domains (01_Archive, etc.), underscore-prefixed system folders (_brain, _working, _references), .claude
- Report: BAD_FOLDER_NAME: {path} — should be lowercase-with-hyphens

### 2. _references/ File Naming
All summary files must follow `YYYY-MM-DD-descriptive-name.md` pattern.
All raw files must follow `YYYY-MM-DD-descriptive-name.ext` pattern.
- Report: BAD_REF_NAME: {filename} — doesn't follow YYYY-MM-DD-descriptive-name pattern

### 3. Raw/Summary Name Pairing
Summary .md and corresponding raw file should share the same base name (before extension).
- Report: NAME_MISMATCH: summary {summary_name} doesn't match raw {raw_name}

### 4. Spaces in Filenames
Flag any file with spaces in the name.
- Exceptions: macOS system files (Icon\r, .DS_Store)
- Report: SPACES_IN_NAME: {path} — rename to use hyphens

### 5. CLAUDE.md Location
Check if both `.claude/CLAUDE.md` AND root-level `CLAUDE.md` exist.
- If both exist: DUAL_CLAUDE_MD: Both .claude/CLAUDE.md and root CLAUDE.md exist — pick one
- If only root: INFO_CLAUDE_MD: CLAUDE.md at unit root — .claude/CLAUDE.md preferred

---

OUTPUT FORMAT:

Return findings grouped by severity. Use EXACTLY this format:

### CRITICAL
- CODE: description

### WARNING
- CODE: description

### INFO
- CODE: description

### CLEAN
- check: OK

### FILES READ
- List every file/directory you actually inspected
```

---

## Step 3: Aggregate & Present Report

Collect findings from all 3 agents. Present a unified report using the ALIVE Shell.

```
╭──────────────────────────────────────────────────────────────────────╮
│    ______/ \-.   _      _____      _____ ___ ___                      │
│ .-/     (    o\_//     / __\ \    / / __| __| _ \                     │
│  |  ___  \_/\---'      \__ \\ \/\/ /| _|| _||  _/                    │
│  |_||  |_||            |___/ \_/\_/ |___|___|_|                       │
│                        aliveOS [Unlimited Elephant 3.0.1]              │
│                        {unit_path}                                     │
│  ──────────────────────────────────────────────────────────────────── │
│  sweep results                                 [date]                  │
│  {N} critical  ·  {N} warnings  ·  {N} info                          │
│  ──────────────────────────────────────────────────────────────────── │
│                                                                       │
│  ROOT                                                                 │
│  ──────────────────────────────────────────────────────────────────── │
│  ✓ Root structure clean                                               │
│  03_Inputs/: 2 items pending → /alive:digest                          │
│                                                                       │
│  STRUCTURE (Agent 1)                                                  │
│  ──────────────────────────────────────────────────────────────────── │
│  [1] ✗ MISSING: _references/ folder                                   │
│       → Create folder                                                 │
│  [2] ✗ UNTRACKED: content/landing.md not in manifest                  │
│       → Add to manifest                                               │
│  [3] [!] NO_README: clients/ has no README.md                         │
│       → Create from template                                          │
│                                                                       │
│  CONTENT HEALTH (Agent 2)                                             │
│  ──────────────────────────────────────────────────────────────────── │
│  [4] [!] STALE: status.md — 18 days — needs refresh                  │
│  [5] [!] STUCK: "Fix login" in-progress 12 days                      │
│  ✓ Tasks health OK (14 items)                                         │
│  ✓ Insights boundaries OK                                             │
│                                                                       │
│  FILES & NAMING (Agent 3)                                             │
│  ──────────────────────────────────────────────────────────────────── │
│  [6] [!] VERY_STALE_DRAFT: acme_old-draft.md — 35 days               │
│       → Archive or promote                                            │
│  [7] [!] ABANDONED_DRAFT: acme_idea.md — created 20 days ago, never  │
│       modified → Archive or develop                                   │
│  [8] EVOLVE: "acme_landing-" — 4 files → promote to folder           │
│  [9] SPACES_IN_NAME: "my file.md" → rename to my-file.md             │
│  ✓ _references/ structure OK                                          │
│  ✓ Folder naming OK                                                   │
│                                                                       │
│  ──────────────────────────────────────────────────────────────────── │
│  #) address specific issue                                            │
│  a) address all critical + warnings                                   │
│  c) address critical only                                             │
│  i) ignore — just wanted the report                                   │
│  e) export to _working/sweep-report.md                                │
│                                                                       │
│                                                        ALIVE v3.0.1   │
╰──────────────────────────────────────────────────────────────────────╯
```

---

## Step 4: Triage Findings Into Fix Categories

After the user selects which issues to address (by number, "all critical + warnings", etc.), **triage every selected finding into one of three categories** before executing anything:

### Category 1: Skill Redirect

Findings where another ALIVE skill handles this better. Don't fix inline — suggest the skill.

| Finding | Redirect |
|---------|----------|
| **FRESHNESS: STALE or VERY_STALE** | `/alive:work` on this unit to refresh |
| **Inputs backlog** | `/alive:digest` to process inputs |
| **Unit has no _brain/** | `/alive:new` to initialise |

**How to handle:** List these as suggestions in the report. Don't dispatch agents for them.

```
These are best handled by other skills:
  → _brain/ files are 18 days stale — run /alive:work to refresh
  → 03_Inputs/ has 3 items — run /alive:digest
```

### Category 2: Needs User Input

Findings where the fix depends on a decision only the user can make. Handle these in main context with `AskUserQuestion`.

| Finding | What to ask |
|---------|------------|
| **MISSING_GOAL** | "What's the one-sentence goal for this unit?" |
| **ORPHAN file** | "Where should {file} go? _working/ / {area}/ / archive?" |
| **STUCK task** | "'{task}' has been in-progress {N} days — mark done / reset / keep?" |
| **URGENT_IDLE** | "'{task}' is urgent but not started — start now / deprioritise?" |
| **STALE_DRAFT / ABANDONED_DRAFT** | "'{file}' is {N} days old — archive / promote / keep?" |
| **EVOLVE candidate** | "Promote {N} files with prefix '{x}' to a folder? What name?" |
| **INSIGHT_MISPLACED** | "'{title}' looks like {type} — move to {destination}?" |
| **INSIGHT_STALE** | "'{title}' is {N} months old — still relevant?" |
| **PEOPLE_IN_STATUS** | "Move {person}'s details to 02_Life/people/ and link?" |
| **DUAL_CLAUDE_MD** | "Both .claude/CLAUDE.md and root CLAUDE.md exist — keep which?" |
| **ROOT_VIOLATION** (ambiguous) | "'{item}' at root — which unit should this go to?" |

**How to handle:** Batch these into a single `AskUserQuestion` (up to 4 questions per call). Collect all answers, then pass them to the auto-fix agents as resolved decisions.

### Category 3: Auto-Fixable

Everything else. These have a clear, deterministic fix. Dispatch to sub-agents.

| Finding | Fix |
|---------|-----|
| **MISSING file/folder** | Create from template |
| **GHOST manifest entry** | Remove from manifest |
| **UNTRACKED file** | Add to manifest with audit-generated description |
| **MISSING_METADATA** | Add missing fields to manifest entries |
| **LEGACY_FIELD** | Convert `session_id` → `session_ids` array |
| **MISSING_STATUS_SECTION** | Add section with placeholder to status.md |
| **LEGACY_STATUS_FORMAT** | Replace "Current Focus" with "State of Play" |
| **NO_README** | Create README.md from area template |
| **ORPHAN_HANDOFF** | Archive to `01_Archive/{unit}/sessions/` |
| **BAD_WORKING_NAME** | Rename following `[unit]_[context]_[name].ext` |
| **BAD_FRONTMATTER / NO_FRONTMATTER** | Add/fix YAML front matter |
| **NO_SOURCE** | Add `## Source` section pointing to raw file |
| **ORPHAN_REF** | Add to manifest references[] |
| **GHOST_REF** | Remove from manifest references[] |
| **MISPLACED_RAW** | Move to raw/ subfolder |
| **BAD_FOLDER_NAME** | Rename to lowercase-with-hyphens |
| **BAD_REF_NAME** | Rename to YYYY-MM-DD-descriptive-name pattern |
| **NAME_MISMATCH** | Rename raw/summary to share base name |
| **SPACES_IN_NAME** | Rename to use hyphens |
| **MISPLACED** (clear destination) | Move to correct location |
| **ROOT_VIOLATION** (clear destination) | Move to correct location |
| **BLOATED / DONE_OVERFLOW** | Archive old done items from tasks.md |
| **STALE_PLAN** | Archive to 01_Archive/ |
| **PROJECT_MISSING** | Create missing _brain/_working/_references |

Plus any Category 2 items where the user has now provided their answer — those become auto-fixable with the decision resolved.

**IMPORTANT: Never delete. Always archive.** All cleanup actions that remove files must move them to `01_Archive/`, mirroring the original path.

---

## Step 5: Execute Fixes

### 5a. Present Triage Summary

Show the user what will happen before dispatching:

```
▸ triage complete

  skill redirects (2):
    → Stale _brain/ — run /alive:work
    → 3 inputs pending — run /alive:digest

  need your input (3):
    [q1] Where should orphan.md go? _working/ / docs/ / archive?
    [q2] "Fix login" stuck 12 days — done / reset / keep?
    [q3] What's the one-sentence goal for this unit?

  auto-fixable (7):
    Create _references/ folder, add 2 files to manifest,
    fix 1 frontmatter, rename 2 files, create 1 README

  Proceed? [y] yes  [s] skip auto-fixes, just ask questions
```

### 5b. Collect User Decisions

Use `AskUserQuestion` to batch all Category 2 items. Once answered, merge resolved decisions into the auto-fix list.

### 5c. Dispatch Fix Agents

**If ≤ 5 auto-fixes:** Single sub-agent handles everything.

**If > 5 auto-fixes:** Split into 2 parallel sub-agents:
- **Agent A: Structure & Files** — create folders, move/rename/archive files, create READMEs
- **Agent B: Content & Manifest** — edit status.md, fix frontmatter, update manifest.json, clean tasks.md

**If both agents touch manifest.json** (likely): Agent A handles filesystem moves and notes what changed. Agent B handles all manifest.json writes. To avoid conflicts, Agent A returns a list of manifest changes needed, and Agent B applies them along with its own.

**Alternatively, if fixes are heavily manifest-focused** (mostly ghost entries, untracked files, metadata): single agent is better to avoid coordination overhead.

Use your judgement — the goal is speed without conflicts.

#### Fix Agent Prompt Template

```
You are fixing specific issues found during an ALIVE sweep audit.

UNIT: {unit_path}
ALIVE ROOT: ~/Desktop/alive

---

FIXES TO APPLY:

{numbered list of specific fixes, each with:}
- Finding code and description (from audit)
- Exact action to take
- File paths involved
- For user-input items: the user's decision

Example:
1. MISSING: _references/ folder
   → Create folder: {unit_path}/_references/

2. GHOST: manifest lists "docs/old-file.md" but file doesn't exist
   → Read _brain/manifest.json, remove the entry from areas[].files[], Write updated file

3. NO_README: clients/ has no README.md
   → Create {unit_path}/clients/README.md with content:
   # Clients
   Client projects and engagements.

4. BAD_REF_NAME: emails/supplier-email.md doesn't follow YYYY-MM-DD pattern
   → Rename to emails/2026-02-06-supplier-email.md (use file's creation date from `stat`)
   → Update manifest references[] path to match

5. STALE_DRAFT (user chose: archive): acme_old-draft.md is 35 days old
   → Move {unit_path}/_working/acme_old-draft.md to ~/Desktop/alive/01_Archive/{unit_path}/_working/acme_old-draft.md
   → Remove from manifest working_files[]

6. UNTRACKED (batch): 3 files not in manifest — insert audit-generated entries
   → Read _brain/manifest.json
   → Insert into areas["docs/"].files[]:
     {"path": "docs/setup-guide.md", "description": "Step-by-step setup guide for new developers", "date_created": "2026-02-01", "date_modified": "2026-02-08", "session_ids": []}
   → Insert into working_files[]:
     {"path": "_working/acme_pricing-draft.md", "description": "Draft pricing model with 3 tiers", "date_created": "2026-02-10", "date_modified": "2026-02-10", "session_ids": []}
   → Insert into key_files[]:
     {"path": "README.md", "description": "Unit overview and navigation", "date_created": "2026-01-20", "date_modified": "2026-02-05", "session_ids": []}
   → Write updated manifest.json (single write, all entries at once)

---

RULES:
- NEVER delete files. Always move to 01_Archive/ mirroring original path.
- After all fixes, read _brain/manifest.json fresh, apply ALL manifest changes in a single Write.
- Use `Bash` with `mkdir -p` for creating directories.
- Use `Bash` with `mv` for moving/renaming files.
- Use `Read` then `Edit` for file content changes.
- Use `Read` then `Write` for manifest.json (read fresh, apply all changes, write once).

---

RETURN FORMAT:

For each fix, report:
✓ [N] {code}: {what was done}
✗ [N] {code}: {what went wrong}

Then:
MANIFEST: {summary of manifest changes applied}
```

### 5d. Report Results

After agents complete, present results to user:

```
▸ fixes applied

[1] ✓ Created _references/ folder
[2] ✓ Added content/landing.md to manifest
[3] ✓ Created clients/README.md
[6] ✓ Archived acme_old-draft.md to 01_Archive/
[9] ✓ Renamed supplier-email.md → 2026-02-06-supplier-email.md

5/5 fixes applied. Manifest updated.
```

If any fix failed, show the error and offer to retry or skip.

---

## Step 6: Loop

After cleanup (or if user chose "ignore"):

```
─────────────────────────────────────────────────────────────────────────
Sweep another unit?

[1] 04_Ventures/side-project  [!]
[2] 05_Experiments/new-idea
[d] Done

─────────────────────────────────────────────────────────────────────────
```

Show remaining unswepped units. User can pick another or exit.

---

## Sweep Thresholds

| Check | Threshold |
|-------|-----------|
| _brain/ freshness (OK) | < 14 days |
| _brain/ freshness (STALE) | 14-28 days |
| _brain/ freshness (VERY_STALE) | > 28 days |
| _working/ file (OK) | < 7 days |
| _working/ file (AGING) | 7-14 days |
| _working/ file (STALE_DRAFT) | 14-28 days |
| _working/ file (VERY_STALE_DRAFT) | > 28 days |
| Abandoned draft detection | created ≈ modified AND age > 7 days |
| Stale plan in _working/plans/ | > 14 days AND not in tasks.md |
| Stuck in-progress task | > 7 days |
| Bloated task list | > 30 items |
| Done section overflow | > 20 done items |
| Large _working/ | 5+ files |
| Evolution trigger | 3+ files with shared prefix |
| Stale references | > 90 days (INFO only) |
| Inputs backlog | > 0 items |

---

## Edge Cases

**Everything clean:**
```
✓ No issues found

{unit_name} is fully compliant. No structural issues, content is fresh, files are tidy.
```

**Massive cleanup needed (>20 issues):**
```
Found {N} issues. This is a big cleanup.

[c] Critical only ({N} items)
[a] All critical + warnings ({N} items)
[e] Export report to _working/sweep-report.md for manual review
```

**Unit has no _brain/ at all:**
```
[!] {unit_path} has no _brain/ folder

This doesn't look like a properly initialised unit.

[1] Initialise _brain/ now (create all files from template)
[2] Archive — move to 01_Archive/
[3] Skip
```

**Empty unit (no files beyond _brain/):**
Report as INFO — unit exists but has no content yet. Not necessarily a problem.

---

## Post-Sweep

After the user is done sweeping (exits the loop):

```
✓ Sweep complete

Units swept: {N}
Resolved: {N} issues
Remaining: {N} issues (not addressed)

─────────────────────────────────────────────────────────────────────────
Tip: Run /alive:sweep regularly to keep your system healthy.
```

Update `alive.local.yaml` if it exists:
```yaml
last_sweep: {today}
```

---

## Related Skills

- `/alive:archive` — Move items to archive
- `/alive:digest` — Process inputs backlog
- `/alive:work` — Refresh stale unit
- `/alive:new` — Create missing structure
- `/alive:upgrade` — Fix v1 → v2 naming issues
