---
user-invocable: true
description: This skill should be used when the user says "set up ALIVE", "get started", "initialize", "new here", "how do I start", or when `/alive:daily` detects no ALIVE structure exists. Fresh v2 setup for new users.
---

# alive:onboarding

First-time setup wizard for ALIVE v2. Guide new users through configuration.

**Different from `/alive:upgrade`:** Onboarding is fresh setup. Upgrade migrates v1 → v2.

## When to Use

Invoke when:
- User is new to ALIVE
- User asks how to get started
- `onboarding_complete: false` in alive.local.yaml
- User explicitly requests setup

## Onboarding Principles

1. **Show, don't just tell** — Create real structure as you explain
2. **User describes their world** — ALIVE scaffolds around them
3. **Quick wins** — Get to "aha" moment fast
4. **Minimal viable setup** — Don't over-scaffold

## Flow

```
1. Welcome + explain what ALIVE is
2. Ask about user's context (ventures, experiments, life)
3. Create initial structure
4. Configure statusline (optional)
5. Quick tour of key concepts
6. First capture exercise
7. Aha moment: context survives restart
8. Mark onboarding complete
```

## Step-by-Step

### Step 1: Welcome

```
╭────────────────────────────────────────────────────────────────────────╮
│                                                                        │
│      ▄▀█ █░░ █ █░█ █▀▀                                                 │
│      █▀█ █▄▄ █ ▀▄▀ ██▄         The operating system for your context.  │
│                                                                        │
╰────────────────────────────────────────────────────────────────────────╯

Welcome to ALIVE.

I'm Claude with persistent memory. What you tell me today, I'll
remember tomorrow. Decisions, tasks, insights — they survive session
resets.

Let's set up your system. This takes about 5 minutes.

Ready?
[1] Yes, let's go
[2] Show me around first
[3] I've used ALIVE before (skip setup)
```

### Step 2: Understand Their World

```
ABOUT YOU
─────────────────────────────────────────────────────────────────────────

First, tell me about your work.

Do you have any active businesses or projects?
[1] Yes, I have ventures (businesses with revenue/intent)
[2] Yes, I have experiments (testing ideas, no model yet)
[3] Both
[4] Neither — I'm exploring ALIVE first
```

If yes to ventures:
```
What are your ventures? (I'll create structure for each)

Enter names, separated by commas:
> acme agency, saas product
```

If yes to experiments:
```
Any experiments you're running?

Enter names, or skip:
> new-app-idea
```

### Step 3: Create Structure

**Implementation:**
1. Create domain folders (archive/, life/, inputs/, ventures/, experiments/)
2. Create each venture/experiment entity with _brain/, _working/, CLAUDE.md
3. Create v2 system files:
   - `.claude/state/session-index.jsonl` (empty)
4. Create `alive.local.yaml` with v2 defaults
5. **Install ALIVE rules (CRITICAL):**
   - Create `.claude/rules/` directory
   - Copy ALL files from plugin's `rules/` folder to `.claude/rules/`
   - Plugin rules location: `~/.claude/plugins/cache/aliveskills/alive/{version}/rules/`

Note: Entity-level memories go in `{entity}/_brain/memories/` (created on breakthrough saves).

**Rules installation:**
```bash
# Copy from plugin to ALIVE root
cp -r ~/.claude/plugins/cache/aliveskills/alive/*/rules/* {alive-root}/.claude/rules/
```

```
▸ installing ALIVE rules...
  └─ behaviors.md
  └─ conventions.md
  └─ intent.md
  └─ learning-loop.md
  └─ ui-standards.md
  └─ voice.md
  └─ working-folder-evolution.md
✓ 7 rules installed to .claude/rules/
```

```
▸ creating your ALIVE structure...

DOMAINS
├── archive/           Rest — completed items
├── life/              First — personal (always prioritized)
│   └── people/        Your contacts (source of truth)
├── inputs/             Triage — incoming context
├── ventures/          Work — your businesses
│   ├── acme-agency/
│   └── saas-product/
└── experiments/       Test — your experiments
    └── new-app-idea/

✓ Structure created

Each venture/experiment has:
- _brain/ (status, tasks, insights, changelog)
- _working/ (drafts)
- .claude/CLAUDE.md (identity)
```

### Step 4: Configure Statusline (Optional)

```
STATUSLINE
─────────────────────────────────────────────────────────────────────────

ALIVE can customize your Claude Code statusline to show:
- Session ID (for recall)
- Context usage
- Cost
- Urgent tasks (when any)
- Inbox count (when any)

Example: session:abc123 | Opus 4.5 | ctx:32% | $1.24 | 🔥 2 | 📥 5

Set up statusline?
[1] Yes, configure it
[2] Skip for now
```

If yes:
```
▸ configuring statusline...

Copying statusline-command.sh to ~/.claude/
Updating ~/.claude/settings.json

✓ Statusline configured

You'll see ALIVE status in your prompt on next session.
```

**Implementation:**
1. Copy `.claude/templates/config/statusline-command.sh` to `~/.claude/statusline-command.sh`
2. Add to `~/.claude/settings.json`:
   ```json
   {
     "statusline": {
       "command": "~/.claude/statusline-command.sh"
     }
   }
   ```

### Step 5: Quick Tour

```
KEY CONCEPTS
─────────────────────────────────────────────────────────────────────────

[_brain/] — The memory of each project
  status.md    Where you are now
  tasks.md     What needs doing
  insights.md  What you've learned
  changelog.md What happened (including decisions)

[_working/] — Drafts and works-in-progress

[life/people/] — Everyone you know, linked across projects

[inputs/] — Dump anything here, sort later

─────────────────────────────────────────────────────────────────────────
[1] Continue
[2] Tell me more about _brain/
```

### Step 6: First Capture

```
FIRST CAPTURE
─────────────────────────────────────────────────────────────────────────

Let's try capturing something.

What's the most important thing you're working on right now?
Just describe it briefly:

> Working on launching the new pricing page for acme
```

Process capture:
```
▸ capturing to ventures/acme-agency/

Adding to _brain/status.md:
  Phase: Building
  Focus: Launching new pricing page

Adding to _brain/tasks.md:
  - [ ] Launch new pricing page @active

✓ Captured

This context is now saved. I'll remember it next session.
```

### Step 7: Aha Moment

```
THE MAGIC
─────────────────────────────────────────────────────────────────────────

Here's the real power:

Start a new conversation tomorrow. Ask me:
  "What am I working on?"

I'll check your _brain/ files and tell you:
  "You're working on launching the pricing page for acme-agency."

No re-explaining. No lost context. AI that remembers.

─────────────────────────────────────────────────────────────────────────
[1] Got it — finish setup
[2] Show me more examples
```

### Step 7.5: Verify Installation (MANDATORY)

**Before marking complete, verify the system is correctly configured:**

```
▸ verifying installation...

STRUCTURE
  ✓ archive/ exists
  ✓ life/ exists
  ✓ inputs/ exists
  ✓ ventures/ exists
  ✓ experiments/ exists

SYSTEM FILES
  ✓ .claude/CLAUDE.md exists
  ✓ .claude/rules/ exists (7 files)
  ✓ .claude/state/ exists
  ✓ alive.local.yaml exists

RULES CHECK
  ✓ behaviors.md
  ✓ conventions.md
  ✓ intent.md
  ✓ learning-loop.md
  ✓ ui-standards.md
  ✓ voice.md
  ✓ working-folder-evolution.md

All checks passed.
```

**If any check fails:**
```
✗ VERIFICATION FAILED

Missing:
  ✗ .claude/rules/ — rules not installed

[1] Fix now (install missing components)
[2] Cancel onboarding
```

**Do NOT proceed to Step 8 until all checks pass.**

### Step 8: Complete Setup

```
SETUP COMPLETE
─────────────────────────────────────────────────────────────────────────

Your ALIVE system is ready.

THE LEARNING LOOP:
  /alive:daily   — Start your day, see everything
  /alive:do      — Focus on one entity
  /alive:save    — End session, preserve context
  /alive:input   — Add external content

START NOW:
  "work on acme-agency" — Load context and begin
  "what's in my inputs" — See what needs processing

─────────────────────────────────────────────────────────────────────────

Free: Join the ALIVE community on Skool → skool.com/aliveoperators
(Templates, guides, Q&A with other operators)

✓ Onboarding complete
```

Update alive.local.yaml:
```yaml
onboarding_complete: true
```

## Returning Users

If `onboarding_complete: true`:

```
User: "/alive:onboard"

You've already completed onboarding.

[1] Show quick reference (/alive:help)
[2] Re-run setup (reset onboarding)
[3] Join the community (skool.com/aliveoperators)
```

## Skip Options

At any point:
```
[s] Skip to end — I know what I'm doing
```

## Edge Cases

**No ventures or experiments:**
```
That's fine — ALIVE works for any context.

Want me to create:
[1] A "personal" venture (for side projects)
[2] An experiment space (for exploring ideas)
[3] Just the core structure (life/, inputs/)
```

**Existing content:**
```
[!] Found existing structure in this folder.

[1] Continue — add ALIVE on top
[2] Fresh start — archive existing, start clean
[3] Cancel — exit setup
```

## Post-Onboarding

After setup, suggest first action:
```
What's first?

[1] Work on [venture name] — load context
[2] Capture some context — log something you know
[3] Explore — look around the structure
```

## Related Skills

- `/alive:daily` — Morning entry point (most common next step)
- `/alive:do` — Focus on one entity
- `/alive:help` — Quick reference
- `/alive:upgrade` — For v1 → v2 migration (not fresh setup)
