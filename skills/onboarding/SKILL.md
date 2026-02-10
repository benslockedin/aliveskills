---
user-invocable: true
description: This skill should be used when the user says "set up ALIVE", "get started", "initialize", "new here", "how do I start", or when `/alive:daily` detects no ALIVE structure exists. Fresh v2 setup for new users.
plugin_version: "2.1.1"
---

# alive:onboarding

First-time setup wizard for ALIVE v2. Guides new users through complete configuration in two sessions: system setup first, then content setup after Claude reloads rules.

**Different from `/alive:upgrade`:** Onboarding is fresh setup. Upgrade migrates v1 → v2.

## When to Use

Invoke when:
- User is new to ALIVE
- User asks how to get started
- `alive.local.yaml` doesn't exist (new user)
- `onboarding_part: 1` in `alive.local.yaml` (resume Part 2)
- User explicitly requests setup

---

## UI Treatment

This skill uses **Tier 1: Entry Point** formatting.

**IMPORTANT:** Since rules aren't installed until Session 1, this skill must contain the full UI assets inline. Do not reference `rules/ui-standards.md` — use the assets below.

### Border Characters (Double-Line)

```
╔  Top-left corner
═  Horizontal line
╗  Top-right corner
║  Vertical line
╚  Bottom-left corner
╝  Bottom-right corner
```

**Standard width: 90 characters**

### Full Logo (Tier 1)

Use this exact logo for all onboarding screens:

```
                          ▒▒▒                              ▒▒
                                    ▒▒            ▒
                             ▒▒     ▒▒     ▒▒    ▒▒      ▒
       ▒▒▒                    ▒▒     ▒▒    ▒▒    ▒▒     ▒▒                    ▒▒▒
        ▒                      ▒▒    ▒▒   ▒▒▒   ▒▒     ▒▒                     ▒▒
           ▒▒▒         ▒▒         ▒▒  ▒ ▒▒▒▒▒▒▒ ▒▒  ▒▒        ▒▒          ▒▒▒
                         ▒▒      ▒▒▒    ▒▒▒  ▒▒     ▒▒▒      ▒▒
                ▒▒▒       ▒▒▒  ▒▒▒ ▒▒▒▒▒▒ ▒▒▒  ▒▒▒▒▒  ▒▒▒  ▒▒        ▒▒
                ▒▒▒            ▒▒▒▒▒    ▒▒▒▒▒▒▒    ▒▒▒▒▒▒            ▒▒
                     ▒▒   ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒   ▒▒▒
                     ▒▒  ▒▒▒▒▒▒ ▒ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ ▒▒▒▒▒▒ ▒  ▒▒
                        ▒▒▒    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    ▒▒▒
                          ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

      ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
      ▒▒▒▒▒▒▒▒▒▒     ▒▒▒▒▒▒       ▒▒▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
      ▒▒▒▒▒▒▒   ▒▒▒▒   ▒▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒     ▒▒▒▒     ▒▒▒▒▒     ▒▒▒▒     ▒▒▒▒▒▒▒
      ▒▒▒▒▒▒▒   ▒▒▒▒   ▒▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒   ▒▒▒▒▒  ▒▒▒▒▒
      ▒▒▒▒▒▒▒   ▒▒▒▒   ▒▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒   ▒▒▒▒▒  ▒▒▒▒▒
      ▒▒▒▒▒▒▒          ▒▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒          ▒▒▒▒▒
      ▒▒▒▒▒▒▒   ▒▒▒▒   ▒▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒▒     ▒▒▒▒▒▒   ▒▒▒▒▒▒▒▒▒▒▒▒
      ▒▒▒▒▒▒▒   ▒▒▒▒   ▒▒▒▒          ▒▒▒▒        ▒▒▒▒▒▒▒   ▒▒▒▒▒▒▒▒         ▒▒▒▒▒
      ▒▒▒▒▒▒▒   ▒▒▒▒   ▒▒▒▒          ▒▒▒▒        ▒▒▒▒▒▒▒   ▒▒▒▒▒▒▒▒▒        ▒▒▒▒▒
      ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
```

### Community Footer (Tier 1)

```
║  ──────────────────────────────────────────────────────────────────────────────────  ║
║  Free: Join the ALIVE community → skool.com/aliveoperators                           ║
║                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════╝
```

### Full Screen Template

Every onboarding screen should follow this structure:

```
╔══════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                      ║
║  [FULL LOGO FROM ABOVE]                                                              ║
║                                                                                      ║
║    onboarding                                                                        ║
║  ════════════════════════════════════════════════════════════════════════════════    ║
║                                                                                      ║
║  [CONTENT HERE]                                                                      ║
║                                                                                      ║
║  ──────────────────────────────────────────────────────────────────────────────────  ║
║  Free: Join the ALIVE community → skool.com/aliveoperators                           ║
║                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════╝
```

---

## Interaction Style

**MANDATORY: Use the `AskUserQuestion` tool for all multiple-choice questions.**

Do NOT just print `[1] [2] [3]` options as text. You MUST invoke the AskUserQuestion tool so users get clickable buttons.

**When to use AskUserQuestion:**
- All `[1] [2] [3]` choices in this skill
- Life area selection (use `multiSelect: true`)
- Timezone, theme, working style preferences
- Any yes/no or multiple choice question

**When NOT to use it (just ask in conversation):**
- Venture/experiment names
- Goals and descriptions
- People names
- Any freeform text input

---

## Stay On Track (Enforced)

**Onboarding MUST be completed in full. Do not let the user stray.**

If the user tries to:
- Ask unrelated questions
- Start working on something else
- Skip ahead without completing steps
- Get distracted by other topics

**Respond with:**
> "Let's finish setting up ALIVE first — it only takes a few more minutes and ensures everything works properly. We can dive into that right after."

Then immediately return to the current onboarding step.

**The only valid exits from onboarding are:**
1. User explicitly selects "Skip to end" option
2. User explicitly says "cancel onboarding" or "stop setup"
3. Session 1 completes (forced restart)
4. Session 2 completes successfully

**Do NOT:**
- Answer unrelated questions mid-onboarding
- Let the user "just quickly" do something else
- Abandon onboarding without explicit cancellation

---

## Onboarding Principles

1. **Assume zero knowledge** — User has never heard of ALIVE
2. **Explain before asking** — Tell them WHY before asking WHAT
3. **Life is the foundation** — Set it up properly in Session 2
4. **Interactive > passive** — Options to select, not freeform dumps
5. **Show the value** — Every step should feel worth doing
6. **Don't overwhelm** — One concept at a time, digestible chunks

## Template Locations

**All files MUST be created from templates — do not make up content.**

Templates are located at:
```
~/.claude/plugins/cache/aliveskills/alive/*/templates/
├── brain/              # _brain/ file templates
│   ├── status.md
│   ├── tasks.md
│   ├── insights.md
│   ├── changelog.md
│   └── manifest.json
├── domains/            # Domain structure templates
│   ├── ventures.md     # Venture types: Agency, Creator, E-commerce, Job, Custom
│   ├── life.md         # Life areas: health, finance, relationships, growth, home
│   ├── experiments.md
│   ├── inputs.md
│   └── archive.md
└── config/
    └── statusline-command.sh
```

**When creating files:**
1. Read the relevant template from the plugin
2. Copy and customize with user's input
3. Never invent file structures or content

---

## How Onboarding Tracking Works

**The `alive.local.yaml` file tracks onboarding progress:**

| Field | Set by | Purpose |
|-------|--------|---------|
| `onboarding_part` | Session 1 | Tracks that Session 1 is complete, Session 2 pending |
| `onboarding_complete` | Session 2 | Marks full onboarding as done |

When Session 1 completes → `onboarding_part: 1` is written.
When Session 2 completes → `onboarding_part` is removed, `onboarding_complete: true` is added.

Other skills check `onboarding_complete` to know if the system is set up.

---

## Full Flow (Overview)

```
SESSION 1: System Setup (this session)
────────────────────────────────────────
1.  Welcome + What is ALIVE?
2.  How ALIVE Works (the mental model)
3.  The Five Domains (explained)
4.  Directory Location (where to create ALIVE)
5.  User Preferences (timezone, theme, working style)
6.  Create Base Structure (domain folders + .claude/)
7.  Create alive.local.yaml (with all config)
8.  Install Rules & CLAUDE.md
9.  Configure Statusline
→   EXIT (Claude must restart to load new rules)

SESSION 2: Content Setup (after restart)
────────────────────────────────────────
10. Welcome Back (detect Session 1 complete)
11. Life Setup (areas, people, goals)
12. Ventures Setup (name, type, goal, phase)
13. Experiments Setup
14. Create Entity Structure (from templates)
15. Quick Tour of Key Concepts
16. First Capture Exercise
17. The Aha Moment
18. Verify Installation
19. Import Existing Content (migrate prompt)
20. Import AI Conversation History (context import plugin)
21. Complete + What's Next
```

---

## Why 2 Sessions?

Claude operates with its loaded rules. When you install rules and CLAUDE.md in Session 1, Claude still has no ALIVE knowledge loaded — it's running from the plugin skill text only.

Only a fresh session loads the new rules from `{alive-root}/.claude/rules/` and the CLAUDE.md identity.

**Session 1** installs the system files (rules, CLAUDE.md, statusline, base folders).
**Session 2** uses the loaded ALIVE knowledge to properly create entities with correct structure, conventions, and behaviours.

Without the restart, Claude would create entities without understanding ALIVE conventions — leading to incorrect folder structures, missing files, and broken patterns.

---

## Detection Logic

When onboarding is invoked, determine which part to run:

```
1. Try to find alive.local.yaml:
   - Check common locations: ~/Desktop/alive/.claude/alive.local.yaml
   - Check ~/alive/.claude/alive.local.yaml
   - Check ~/Documents/alive/.claude/alive.local.yaml
   - Ask user if not found in common locations

2. If alive.local.yaml NOT FOUND:
   → New user. Run Session 1 from Step 1.

3. If alive.local.yaml EXISTS:
   a. Read the file
   b. If onboarding_complete: true → "Already onboarded" (see Returning Users)
   c. If onboarding_part: 1 → Session 1 done. Run Session 2 from Step 10.
   d. If file exists but no onboarding fields → Treat as new user, Session 1.
```

---

## Session 1: System Setup

### Step 1: Welcome + What is ALIVE?

Use the full UI template from the "UI Treatment" section above. Display the full logo, double-line border, and community footer.

**Then use AskUserQuestion for the choice:**

```
AskUserQuestion({
  questions: [{
    question: "Ready to set up ALIVE?",
    header: "Setup",
    options: [
      { label: "Let's do this", description: "Start the full setup (~10 minutes across 2 sessions)" },
      { label: "Tell me more first", description: "I want to understand before committing" },
      { label: "I've used ALIVE before", description: "Skip to quick setup" }
    ],
    multiSelect: false
  }]
})
```

**Content to display inside the border:**

```
Welcome to ALIVE.

Here's the problem: Every time you start a new conversation with an AI,
it forgets everything. You explain the same context over and over.
Decisions get lost. Tasks fall through the cracks.

ALIVE fixes that.

It's a file-based system that gives me (Claude) persistent memory.
What you tell me today, I remember tomorrow. Across sessions. Across
projects. Across your whole life.

Think of it as a second brain that I can actually read.

──────────────────────────────────────────────────────────────────────────
This setup happens in two quick sessions:
  Session 1: System setup (~5 min) — install rules, pick preferences
  Session 2: Content setup (~5 min) — set up your life, ventures, projects

Worth it.
```

**If "Tell me more first":**

```
THE CORE IDEA
─────────────────────────────────────────────────────────────────────────

Most people use AI like this:
  → Start conversation
  → Explain everything from scratch
  → Get help
  → Close conversation
  → (Next time: repeat from scratch)

With ALIVE, it works like this:
  → Start conversation
  → I read your context files automatically
  → I already know your projects, priorities, and history
  → We pick up exactly where we left off

The magic: a simple folder structure that I understand.

You organise your world into domains (Life, Ventures, Experiments).
Each one has a "_brain" folder where context lives.
I read it. I update it. Context compounds over time.
```

Then use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Want to see a real example, or start setup?",
    header: "Next",
    options: [
      { label: "Start setup", description: "I get it — let's go" },
      { label: "Show me an example", description: "I want to see what a day looks like" }
    ],
    multiSelect: false
  }]
})
```

**If "Show me an example":**

```
EXAMPLE: A DAY WITH ALIVE
─────────────────────────────────────────────────────────────────────────

Morning:
  You: "What should I work on today?"
  Me:  I check your tasks across all projects.
       "You have 2 urgent items: the Acme proposal is due today,
       and you mentioned wanting to call your mum this week."

Working:
  You: "I just had a call with the Globex team. They want to move
       forward but need a lower price point."
  Me:  I log that to the Globex project. Decision recorded.
       Next time you ask about Globex, I'll remember.

Evening:
  You: "Wrap up"
  Me:  I save everything that happened today to your context files.
       Tomorrow, we pick up exactly here.

No re-explaining. No lost context. AI that actually remembers.
```

---

### Step 2: How ALIVE Works (The Mental Model)

```
HOW ALIVE WORKS
─────────────────────────────────────────────────────────────────────────

ALIVE uses a simple folder structure that I read and write.

Every project (we call them "entities") has a special folder called
"_brain" — this is where memory lives:

  your-project/
  └── _brain/
      ├── status.md     ← Where are we? What's the current focus?
      ├── tasks.md      ← What needs doing?
      ├── insights.md   ← What have we learned?
      └── changelog.md  ← What happened? (session history)

When you start a conversation, I read the _brain/ folder.
When you finish, we save changes back.

That's it. Simple files. No database. No cloud sync.
You own your context. It's just markdown.
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Makes sense?",
    header: "Continue",
    options: [
      { label: "Makes sense", description: "Continue to the five domains" },
      { label: "Why files?", description: "Why not a database or cloud service?" }
    ],
    multiSelect: false
  }]
})
```

**If "Why files?":**

```
WHY FILES?
─────────────────────────────────────────────────────────────────────────

Three reasons:

1. PORTABILITY
   Your context isn't locked in a proprietary system.
   It's markdown files you can read, edit, move, or backup.

2. TRANSPARENCY
   You can see exactly what I "remember" about you.
   No black box. Open the file, read the context.

3. SIMPLICITY
   No servers. No accounts. No sync issues.
   Works offline. Works forever.

The tradeoff: you need to organise a bit. But that's what this
setup is for — I'll create the structure, you just tell me about
your world.
```

---

### Step 3: The Five Domains (Explained)

```
THE FIVE DOMAINS
─────────────────────────────────────────────────────────────────────────

ALIVE organises everything into five areas. Each has a specific purpose:

┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│  01_Archive      Where completed things rest                        │
│                  (Out of sight, but preserved)                      │
│                                                                     │
│  02_Life         YOUR FOUNDATION — personal areas                   │
│                  (Health, finance, relationships, home...)          │
│                                                                     │
│  03_Inputs       The inbox — stuff to process                       │
│                  (Meeting notes, ideas, links to sort)              │
│                                                                     │
│  04_Ventures     Revenue-generating projects                        │
│                  (Businesses, freelance, products)                  │
│                                                                     │
│  05_Experiments  Ideas you're testing                               │
│                  (No business model yet, just exploring)            │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘

The numbers (01, 02...) keep them sorted. Life comes early because
it's the foundation — your personal context that spans everything.
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Ready to continue, or want to dive deeper into each domain?",
    header: "Domains",
    options: [
      { label: "Continue", description: "I get it — let's set things up" },
      { label: "Tell me more", description: "Explain each domain in detail" }
    ],
    multiSelect: false
  }]
})
```

**If "Tell me more":**

```
DOMAIN DEEP DIVE
─────────────────────────────────────────────────────────────────────────

01_ARCHIVE
  Things that are done. Completed projects, old experiments, closed
  chapters. We move things here instead of deleting — nothing is lost.

02_LIFE (Most Important)
  This is YOU. Not your work — your actual life. Health tracking,
  finances, relationships, personal goals. Most productivity systems
  ignore this. ALIVE doesn't.

  Life includes a special folder: people/
  Everyone you know lives here — linked across all your projects.
  Your cofounder? They're in people/, referenced from ventures.

03_INPUTS
  A universal inbox. Dump anything here: meeting transcripts, ideas,
  screenshots, voice notes. Later, we process and route them to the
  right place. Nothing gets lost, nothing needs immediate filing.

04_VENTURES
  Work that makes (or will make) money. Each venture gets its own
  _brain/ folder, its own context, its own history.

05_EXPERIMENTS
  Ideas you're testing. No pressure to monetise. No commitment.
  If they work, they graduate to Ventures. If not, they archive.
```

---

### Step 4: Directory Location

**Ask where to create the ALIVE system.**

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Where do you want to create your ALIVE system?",
    header: "Location",
    options: [
      { label: "Desktop", description: "~/Desktop/alive — easy to find (Recommended)" },
      { label: "Home folder", description: "~/alive — clean and accessible" },
      { label: "Documents", description: "~/Documents/alive — with other docs" },
      { label: "Custom location", description: "I'll specify a path" }
    ],
    multiSelect: false
  }]
})
```

**If Custom:**
Ask in conversation: "What's the full path where you want to create ALIVE?"

**Validate the location:**
- Check the parent directory exists
- Check we have write permissions
- Warn if there's already an `alive/` folder there

**Store the path** — all subsequent steps use this as the ALIVE root.

```
▸ ALIVE will be created at: ~/Desktop/alive/

Confirm this location?
```

Use AskUserQuestion to confirm:
```
AskUserQuestion({
  questions: [{
    question: "Confirm ALIVE location?",
    header: "Confirm",
    options: [
      { label: "Confirm", description: "Create ALIVE at this location" },
      { label: "Change", description: "Pick a different location" }
    ],
    multiSelect: false
  }]
})
```

---

### Step 5: User Preferences

```
QUICK PREFERENCES
─────────────────────────────────────────────────────────────────────────

Before we build your system, a few quick preferences.
These get saved to your config file and apply to every session.
```

**Timezone** (use AskUserQuestion):
```
AskUserQuestion({
  questions: [{
    question: "What timezone are you in?",
    header: "Timezone",
    options: [
      { label: "Australia (AEST)", description: "Australian Eastern Standard/Daylight" },
      { label: "US Pacific (PT)", description: "Los Angeles, San Francisco" },
      { label: "US Eastern (ET)", description: "New York, Miami" },
      { label: "UK (GMT/BST)", description: "London, Edinburgh" }
    ],
    multiSelect: false
  }]
})
```

(User can select "Other" to specify a different timezone)

**Visual Style** (use AskUserQuestion):
```
AskUserQuestion({
  questions: [{
    question: "How do you like your interface?",
    header: "Theme",
    options: [
      { label: "Vibrant (Recommended)", description: "Full visual experience with boxes and formatting" },
      { label: "Minimal", description: "Clean and fast, less decoration, saves context window" },
      { label: "Loud", description: "Emojis, emphasis, maximum clarity — ADHD-friendly" }
    ],
    multiSelect: false
  }]
})
```

**Working Style** (use AskUserQuestion):
```
AskUserQuestion({
  questions: [{
    question: "How do you typically work?",
    header: "Work style",
    options: [
      { label: "Solo operator", description: "It's mostly just me" },
      { label: "Small team", description: "A few collaborators" },
      { label: "Larger org", description: "Multiple people, shared context needed" }
    ],
    multiSelect: false
  }]
})
```

```
✓ Preferences saved. These will be written to your config file shortly.
```

---

### Step 6: Create Base Structure

Create the five domain folders and the `.claude/` system directory.

**Implementation:**
```bash
ALIVE_ROOT="{user-chosen-location}"

# Create domain folders
mkdir -p "$ALIVE_ROOT/01_Archive"
mkdir -p "$ALIVE_ROOT/02_Life"
mkdir -p "$ALIVE_ROOT/03_Inputs"
mkdir -p "$ALIVE_ROOT/04_Ventures"
mkdir -p "$ALIVE_ROOT/05_Experiments"

# Create .claude system directories
mkdir -p "$ALIVE_ROOT/.claude/rules"
mkdir -p "$ALIVE_ROOT/.claude/state"

# Open the folder in Finder so the user can see it
open "$ALIVE_ROOT"
```

**IMPORTANT:** After creating the directory, open it in Finder (macOS) or the system file manager. This gives the user a visual confirmation — they can see the folder structure being built in real time. This is intentional for the "wow" effect.

**Platform detection:**
- macOS: `open "$ALIVE_ROOT"`
- Linux: `xdg-open "$ALIVE_ROOT"`
- Windows/WSL: `explorer.exe "$ALIVE_ROOT"`

**Display to user:**

```
▸ creating base structure...

ALIVE/
├── 01_Archive/           ← Completed items rest here
├── 02_Life/              ← Your foundation (set up in Session 2)
├── 03_Inputs/            ← Your inbox (dump stuff here)
├── 04_Ventures/          ← Revenue-generating projects (Session 2)
├── 05_Experiments/       ← Ideas you're testing (Session 2)
└── .claude/              ← System files (installing next)
    ├── rules/
    └── state/

▸ opening folder...
  └─ Check your file manager — you should see your new ALIVE system

✓ Base structure created
```

---

### Step 7: Create alive.local.yaml

**Create the system configuration file at `{alive-root}/.claude/alive.local.yaml`.**

This file is the source of truth for ALIVE system configuration. It tracks onboarding progress, version info, and user preferences.

**Write this file:**

```yaml
# ALIVE System Configuration
# Created by /alive:onboarding — Session 1
# Location: {alive-root}/.claude/alive.local.yaml

version: 2
system_version: "2.1.1"
onboarding_part: 1
created: "[today's date]"

# System paths
alive_root: "{absolute-path-to-alive-root}"

# User preferences
timezone: "[from Step 5]"
theme: "[from Step 5]"
working_style: "[from Step 5]"
```

**Example with real values:**

```yaml
# ALIVE System Configuration
# Created by /alive:onboarding — Session 1
# Location: ~/Desktop/alive/.claude/alive.local.yaml

version: 2
system_version: "2.1.1"
onboarding_part: 1
created: "2026-02-10"

# System paths
alive_root: "/Users/will/Desktop/alive"

# User preferences
timezone: "Australia/Sydney"
theme: "vibrant"
working_style: "solo"
```

**Display to user:**

```
▸ creating system config...
  └─ .claude/alive.local.yaml

  version: 2
  system_version: 2.1.1
  timezone: [selection]
  theme: [selection]
  working_style: [selection]

✓ Config created
```

---

### Step 8: Install Rules & CLAUDE.md (CRITICAL)

**This step is MANDATORY. ALIVE will not work without it.**

**IMPORTANT:** These files are installed INSIDE the ALIVE directory (the location chosen in Step 4), NOT in the user's home `~/.claude/` folder.

Example: If user chose `~/Desktop/alive/` as their ALIVE location:
- Rules go to: `~/Desktop/alive/.claude/rules/`
- CLAUDE.md goes to: `~/Desktop/alive/.claude/CLAUDE.md`

#### 1. Rules (behaviour files)

```bash
# Source: Plugin rules directory
~/.claude/plugins/cache/aliveskills/alive/*/rules/

# Destination: INSIDE the ALIVE installation directory
{alive-root}/.claude/rules/
```

**Files to copy:**
- `behaviors.md` — How Claude reads and updates context
- `conventions.md` — File naming, folder structure
- `intent.md` — Understanding user commands
- `learning-loop.md` — The daily/do/save rhythm
- `ui-standards.md` — Visual formatting
- `voice.md` — How Claude communicates
- `working-folder-evolution.md` — When drafts become projects

#### 2. CLAUDE.md (system identity + user preferences)

Create `{alive-root}/.claude/CLAUDE.md` with the ALIVE system identity.

**Template location:** `~/.claude/plugins/cache/aliveskills/alive/*/CLAUDE.md` (the plugin's root CLAUDE.md)

**After copying, add the User Preferences section:**
```markdown
## User Preferences

**Timezone:** [from Step 5]
**Theme:** [from Step 5]
**Working Style:** [from Step 5]
```

This ensures Claude reads user preferences automatically every session.

#### Implementation

```bash
ALIVE_ROOT="{user-chosen-location}"

# Copy rules from plugin to ALIVE directory
cp -r ~/.claude/plugins/cache/aliveskills/alive/*/rules/* "$ALIVE_ROOT/.claude/rules/"

# Copy CLAUDE.md from plugin to ALIVE directory
cp ~/.claude/plugins/cache/aliveskills/alive/*/CLAUDE.md "$ALIVE_ROOT/.claude/CLAUDE.md"

# Then use Edit tool to add User Preferences section to CLAUDE.md
```

#### Display to user

```
▸ installing ALIVE system files...

  └─ .claude/CLAUDE.md        (System identity + your preferences)
  └─ .claude/rules/           (7 behaviour files)

✓ System files installed

These enable Claude to understand your ALIVE system automatically.
When you cd into this directory, Claude reads these files.
```

**Do NOT skip this step. Without these files, ALIVE skills will not function correctly.**

---

### Step 9: Configure Statusline (MANDATORY)

**The statusline is essential for ALIVE.** It shows critical system info at a glance.

```
STATUSLINE SETUP
─────────────────────────────────────────────────────────────────────────

ALIVE customises your Claude Code status bar to show:

  session:abc123 | ctx:32% | $1.24 | 🔥 2 urgent | 📥 5 inputs

This gives you at-a-glance awareness of:
  • Current session ID (for finding past conversations)
  • Context usage (how much of my memory you're using)
  • Conversation cost
  • Urgent tasks count (so you never miss priorities)
  • Unprocessed inputs count (so nothing slips through)

This is one of the most useful features of ALIVE. Setting it up now.
```

**Do NOT offer to skip this step.** Configure it automatically.

**If user asks "What's a statusline?":**

```
The statusline is the small text bar at the bottom of Claude Code.
By default it shows basic info. With ALIVE, it shows your system
status so you always know what needs attention.
```

**Implementation:**
1. Copy `~/.claude/plugins/cache/aliveskills/alive/*/templates/config/statusline-command.sh` to `~/.claude/statusline-command.sh`
2. Add to `~/.claude/settings.json`:
   ```json
   {
     "statusline": {
       "command": "~/.claude/statusline-command.sh"
     }
   }
   ```

```
✓ Statusline configured
```

---

### Session 1 Exit (MANDATORY)

**After completing Steps 1-9, force the user to close and restart.**

```
╭─ RESTART REQUIRED ─────────────────────────────────────────────────────╮
│                                                                        │
│  Session 1 is complete. The system files are installed.                │
│                                                                        │
│  Claude must RESTART to load the new ALIVE rules and identity.        │
│                                                                        │
│  Without restarting, I can't properly create your entities —          │
│  I need to load the rules I just installed.                           │
│                                                                        │
│  HERE'S WHAT TO DO:                                                   │
│                                                                        │
│  1. Exit this session (Ctrl+C or close terminal)                      │
│  2. Open a NEW terminal                                               │
│  3. cd into your ALIVE folder:                                        │
│                                                                        │
│     cd {alive-root}                                                    │
│                                                                        │
│     This is critical — Claude reads the rules from this folder.       │
│     If you're not in this directory, ALIVE won't work.                │
│                                                                        │
│  4. Start Claude Code (type: claude)                                  │
│  5. Run /alive:onboarding                                              │
│                                                                        │
│  I'll detect Session 1 is done and jump straight to                   │
│  setting up your Life, ventures, and experiments.                     │
│                                                                        │
╰────────────────────────────────────────────────────────────────────────╯
```

**STOP. Do not proceed to Session 2 steps. The user MUST restart Claude.**

**Session 2 `cd` check:** When Session 2 starts (Step 10), verify the user is in the correct directory by checking if `.claude/alive.local.yaml` exists in the current working directory. If not, instruct them to `cd {alive-root}` first.

---

## Session 2: Content Setup

**Only reached when `alive.local.yaml` has `onboarding_part: 1`.**

### Step 10: Welcome Back

Read `{alive-root}/.claude/alive.local.yaml` and confirm Session 1 was completed.

```
╔══════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                      ║
║  [FULL LOGO]                                                                         ║
║                                                                                      ║
║    onboarding — session 2                                                            ║
║  ════════════════════════════════════════════════════════════════════════════════    ║
║                                                                                      ║
║  Welcome back. Session 1 is complete.                                                ║
║                                                                                      ║
║  ✓ Rules installed                                                                   ║
║  ✓ CLAUDE.md configured                                                              ║
║  ✓ Statusline set up                                                                 ║
║  ✓ Base folders created                                                              ║
║  ✓ Preferences saved                                                                 ║
║                                                                                      ║
║  Now let's set up your world — Life, Ventures, and Experiments.                      ║
║                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════╝
```

---

### Step 11: Life Setup (THE FOUNDATION)

```
╭─ LIFE SETUP ───────────────────────────────────────────────────────────╮
│                                                                        │
│  This is the most important part.                                      │
│                                                                        │
╰────────────────────────────────────────────────────────────────────────╯

Most productivity systems focus on WORK and ignore LIFE.

That's backwards.

Your life is the foundation. Your health affects your work. Your
relationships affect your focus. Your finances affect your stress.
Everything connects.

ALIVE puts Life first. Let's set it up properly.
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Set up your Life domain?",
    header: "Life setup",
    options: [
      { label: "Yes — set up Life", description: "Configure health, finance, relationships, etc." },
      { label: "Skip Life", description: "I just want to track work (you can add Life later)" }
    ],
    multiSelect: false
  }]
})
```

**If "Skip Life":**

```
Are you sure?

Without Life setup, ALIVE becomes just another project tracker.
You'll miss:
  - Personal context that compounds over time
  - Relationship tracking across projects
  - Health/energy patterns that affect productivity
  - The foundation that makes everything else work
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Set up Life anyway?",
    header: "Confirm skip",
    options: [
      { label: "Set up Life", description: "You're right — let me set it up" },
      { label: "Skip anyway", description: "I'll add it later with /alive:new" }
    ],
    multiSelect: false
  }]
})
```

#### Step 11a: Life Areas

**Life areas come from `templates/domains/life.md`.**

Use AskUserQuestion with multiSelect:
```
AskUserQuestion({
  questions: [{
    question: "What areas of life do you want to track?",
    header: "Life areas",
    options: [
      { label: "Health", description: "Physical and mental health, fitness, medical" },
      { label: "Finance", description: "Money, investments, budgets, tax" },
      { label: "Relationships", description: "Family, friends, community" },
      { label: "Growth", description: "Learning, skills, personal development" }
    ],
    multiSelect: true
  }]
})
```

**Note:** These are the standard areas from the template. Users can add custom areas later with `/alive:new`.

Each selected area gets:
- `02_Life/[area]/.claude/CLAUDE.md` (from template)
- `02_Life/[area]/_brain/` (status.md, tasks.md, insights.md, changelog.md)
- `02_Life/[area]/_working/`
- `02_Life/[area]/_references/`

**For each selected area, brief follow-up using AskUserQuestion:**

Example for Health:
```
AskUserQuestion({
  questions: [{
    question: "What's your main health focus right now?",
    header: "Health",
    options: [
      { label: "Fitness", description: "Training, exercise, physical goals" },
      { label: "Medical", description: "Appointments, conditions, medications" },
      { label: "Mental wellness", description: "Stress, therapy, mindfulness" },
      { label: "General", description: "All of the above, I'll specify as I go" }
    ],
    multiSelect: false
  }]
})
```

Then ask in conversation: "Any current health goals? (Optional — press Enter to skip)"

```
✓ Health area configured
```

*(Repeat brief config for each selected area)*

#### Step 11b: Key People

```
KEY PEOPLE
─────────────────────────────────────────────────────────────────────────

ALIVE has a central place for all the people in your life: people/

This is powerful because:
  - One file per person, linked across all projects
  - I remember context about relationships over time
  - Your cofounder appears in Ventures AND in People
  - Family members have their own context that compounds

Who are the most important people in your life right now?

Think about:
  - Family (partner, parents, kids, siblings)
  - Close friends
  - Key work relationships (boss, cofounder, mentor)
  - Anyone you interact with regularly

Enter names (I'll create a file for each):
> ___

Format: "Sarah (partner), Mum, Ben (boss), Jake (cofounder)"
Or type "skip" to do this later.
```

**After people input:**

```
▸ creating people/

  sarah.md        partner
  mum.md          family
  ben.md          boss
  jake.md         cofounder

Each person gets a simple file. Over time, as you mention them in
conversations, their context builds. Meeting notes, decisions,
relationship history — all linked.

✓ 4 people created in 02_Life/people/
```

#### Step 11c: Life Goals (Optional)

```
LIFE GOALS
─────────────────────────────────────────────────────────────────────────

Do you have any big personal goals right now?
(Things outside of work ventures)

Examples:
  - "Run a marathon by end of year"
  - "Pay off credit card debt"
  - "Spend more quality time with family"
  - "Learn Spanish"

Enter any goals, or skip:
> ___

(These go into 02_Life/_brain/status.md as your personal north star)
```

**Implementation:**
Create `02_Life/_brain/` with status.md, tasks.md, insights.md, changelog.md, manifest.json from templates.
Create `02_Life/people/` folder and individual person files.
Create each life area entity with _brain/, _working/, _references/, .claude/CLAUDE.md.

---

### Step 12: Ventures Setup

```
╭─ VENTURES ─────────────────────────────────────────────────────────────╮
│                                                                        │
│  Now let's set up your work.                                           │
│                                                                        │
╰────────────────────────────────────────────────────────────────────────╯

VENTURES are projects with revenue intent.

This could be:
  - A business you run
  - Freelance/consulting work
  - A product you're building to sell
  - A side project that could make money

Do you have any active ventures?
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Do you have any active ventures?",
    header: "Ventures",
    options: [
      { label: "Yes", description: "I have ventures to set up" },
      { label: "No", description: "No revenue-generating projects right now" },
      { label: "Not sure", description: "Help me figure out what counts" }
    ],
    multiSelect: false
  }]
})
```

**If "Not sure":**

```
WHAT COUNTS AS A VENTURE?
─────────────────────────────────────────────────────────────────────────

Ask yourself: "Is this meant to make money, now or eventually?"

VENTURE examples:
  ✓ Your agency or consultancy
  ✓ An e-commerce store
  ✓ A SaaS product (even pre-revenue)
  ✓ Freelance work under a brand name
  ✓ A course or content business

NOT ventures (these are experiments):
  ✗ "I might start a newsletter"
  ✗ "I'm exploring this idea"
  ✗ "Playing around with a concept"

Experiments are for testing. Ventures are for building.
```

Then use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "So — any ventures?",
    header: "Ventures",
    options: [
      { label: "Yes", description: "I have ventures to set up" },
      { label: "No", description: "I'll start with experiments" },
      { label: "Skip both", description: "Just the core structure for now" }
    ],
    multiSelect: false
  }]
})
```

#### Step 12a: Per-Venture Setup

**For each venture, collect: name, TYPE, goal, phase**

The venture TYPE determines the folder structure (from `templates/domains/ventures.md`).

**Name** (conversational):
```
What's the name of your venture?
> ___
```

**Type** (use AskUserQuestion):
```
AskUserQuestion({
  questions: [{
    question: "What type of venture is this?",
    header: "Venture type",
    options: [
      { label: "Agency", description: "Client work, deliverables, retainers" },
      { label: "Creator", description: "Content, courses, community" },
      { label: "E-commerce", description: "Products, inventory, fulfillment" },
      { label: "Job", description: "Employment brought into ALIVE" }
    ],
    multiSelect: false
  }]
})
```

(User can select "Other" for custom/generic starting point)

**Goal** (conversational):
```
What's the one-sentence goal?
(What does success look like?)
> ___
```

**Phase** (use AskUserQuestion):
```
AskUserQuestion({
  questions: [{
    question: "What phase is it in?",
    header: "Phase",
    options: [
      { label: "Starting", description: "Idea stage, getting off the ground" },
      { label: "Building", description: "Actively developing, early traction" },
      { label: "Launching", description: "Going to market, finding customers" },
      { label: "Growing", description: "Scaling up, increasing revenue" }
    ],
    multiSelect: false
  }]
})
```

**Venture type creates different folder structures:**
- **Agency:** clients/, templates/, operations/, pipeline/
- **Creator:** content/, products/, community/, funnel/
- **E-commerce:** products/, suppliers/, marketing/, operations/
- **Job:** projects/, docs/, meetings/, growth/
- **Custom:** (minimal) .claude/, _brain/, _working/, _references/

```
✓ [Venture name] configured as [Type]
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Add another venture?",
    header: "More",
    options: [
      { label: "Yes", description: "I have more ventures" },
      { label: "No", description: "Continue to experiments" }
    ],
    multiSelect: false
  }]
})
```

---

### Step 13: Experiments Setup

```
╭─ EXPERIMENTS ──────────────────────────────────────────────────────────╮
│                                                                        │
│  Ideas you're testing — no commitment yet.                             │
│                                                                        │
╰────────────────────────────────────────────────────────────────────────╯

EXPERIMENTS are for exploration.

This is where ideas live before they become ventures:
  - A newsletter you might start
  - A product concept you're validating
  - A skill you're learning to potentially monetise
  - Anything with uncertainty

The pressure is off. Experiments can fail. That's the point.
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Do you have any active experiments?",
    header: "Experiments",
    options: [
      { label: "Yes", description: "I have ideas I'm testing" },
      { label: "No", description: "Nothing in exploration right now" },
      { label: "Maybe", description: "I have some vague ideas" }
    ],
    multiSelect: false
  }]
})
```

**If "Yes" or "Maybe":**

```
EXPERIMENT
─────────────────────────────────────────────────────────────────────────

What are you calling this experiment?
> ___

What's the hypothesis or question you're testing?
(What are you trying to learn?)
> ___

What would "success" look like?
(How will you know if this works?)
> ___

─────────────────────────────────────────────────────────────────────────
✓ [Experiment name] configured
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Add another experiment?",
    header: "More",
    options: [
      { label: "Yes", description: "I have more ideas" },
      { label: "No", description: "Continue" }
    ],
    multiSelect: false
  }]
})
```

---

### Step 14: Create Entity Structure

Create all entities configured in Steps 11-13.

```
╭─ CREATING YOUR ENTITIES ──────────────────────────────────────────────╮
│                                                                        │
│  Building your personal context infrastructure...                      │
│                                                                        │
╰────────────────────────────────────────────────────────────────────────╯
```

**For each entity (life area, venture, experiment), create:**
- `.claude/CLAUDE.md` (entity identity from template)
- `_brain/status.md` (from template, customised with user input)
- `_brain/tasks.md` (from template)
- `_brain/insights.md` (from template)
- `_brain/changelog.md` (from template)
- `_brain/manifest.json` (from template, customised)
- `_working/` (empty)
- `_references/` (empty)

**Also create:**
- `02_Life/_brain/` (Life-level status, tasks, insights, changelog)
- `02_Life/people/` with individual person files
- `.claude/state/session-index.jsonl` (empty)

**Display the tree:**

```
▸ creating entities...

02_Life/
├── _brain/              (Life focus + goals)
├── health/              (Your health tracking)
│   ├── _brain/
│   ├── _working/
│   └── _references/
├── finance/             (Your money stuff)
│   ├── _brain/
│   ├── _working/
│   └── _references/
└── people/
    ├── sarah.md
    └── ben.md

04_Ventures/
└── acme-agency/
    ├── .claude/CLAUDE.md  (Project identity)
    ├── _brain/            (Project memory)
    ├── _working/          (Drafts & WIP)
    ├── _references/       (Reference materials)
    └── clients/           (Agency-specific)

05_Experiments/
└── newsletter-idea/
    ├── .claude/CLAUDE.md
    ├── _brain/
    ├── _working/
    └── _references/

✓ All entities created
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Want to see what's inside the _brain/ files?",
    header: "Details",
    options: [
      { label: "Continue", description: "I'm good — keep going" },
      { label: "Show me", description: "I want to understand the _brain/ files" }
    ],
    multiSelect: false
  }]
})
```

**If "Show me":**

```
INSIDE _BRAIN/
─────────────────────────────────────────────────────────────────────────

Each entity's _brain/ folder contains:

STATUS.MD — "Where are we?"
  Current phase, focus, blockers, next milestone.
  I read this first to understand the project state.

TASKS.MD — "What needs doing?"
  Your to-do list. Urgent items, active work, backlog.
  I check this to know priorities.

INSIGHTS.MD — "What have we learned?"
  Key learnings, discoveries, things worth remembering.
  Compounds over time into institutional knowledge.

CHANGELOG.MD — "What happened?"
  Session-by-session history. Decisions made, work completed.
  The audit trail of your project's evolution.

Together, these give me complete context about any project
without you having to explain anything.
```

---

### Step 15: Quick Tour

```
╭─ QUICK TOUR ───────────────────────────────────────────────────────────╮
│                                                                        │
│  The key concepts you need to know.                                    │
│                                                                        │
╰────────────────────────────────────────────────────────────────────────╯

THE LEARNING LOOP

ALIVE works best with a daily rhythm:

  /alive:daily  → Start your day. See everything across all projects.
                  Urgent tasks, inputs to process, what needs attention.

  /alive:do     → Focus on ONE entity. Load its context, start working.
                  "work on acme" or "focus on health"

  /alive:save   → End your session. Log what happened, update context.
                  This is how memory persists.

That's the core loop: DAILY → DO → SAVE → REPEAT

Context compounds each cycle. Skip the save, lose the context.
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Continue or see other commands?",
    header: "Tour",
    options: [
      { label: "Continue", description: "I'll learn as I go" },
      { label: "Other commands", description: "What else can ALIVE do?" }
    ],
    multiSelect: false
  }]
})
```

**If "Other commands":**

```
OTHER USEFUL COMMANDS
─────────────────────────────────────────────────────────────────────────

/alive:capture-context  Capture context. Dump in anything — a decision,
                        transcript, email, article — I'll extract what
                        matters and route it to the right place.

/alive:recall   Search your history. "What did we decide about
                pricing?" — I'll find it.

/alive:new      Create a new entity (venture, experiment, life area).

/alive:archive  Move something to the archive when it's done.

/alive:sweep    Clean up. Find stale content, abandoned drafts.

/alive:help     Quick reference for all commands.
```

---

### Step 16: First Capture Exercise

```
╭─ YOUR FIRST CAPTURE ───────────────────────────────────────────────────╮
│                                                                        │
│  Let's make this real.                                                 │
│                                                                        │
╰────────────────────────────────────────────────────────────────────────╯

Tell me: What's the most important thing on your mind right now?

This could be:
  - Something you're working on
  - A decision you need to make
  - A task you keep forgetting
  - Anything occupying mental space

Just describe it:
> ___
```

**After user input:**

```
▸ processing capture...

This sounds like it belongs in [detected entity].

▸ adding to [entity]/_brain/status.md
  Focus: [extracted focus]

▸ adding to [entity]/_brain/tasks.md
  - [ ] [extracted task] @active

✓ Captured

That context is now saved. Tomorrow, when you ask "what am I working on?"
I'll know.
```

---

### Step 17: The Aha Moment

```
╭─ THE MAGIC ────────────────────────────────────────────────────────────╮
│                                                                        │
│  This is why ALIVE exists.                                             │
│                                                                        │
╰────────────────────────────────────────────────────────────────────────╯

Close this conversation.
Open a new one.
Ask me: "What am I working on?"

I'll read your _brain/ files and tell you exactly where you left off.

No re-explaining. No lost context. No starting from scratch.

This works because:
  - Your context lives in files (not my memory)
  - Files persist across sessions
  - I read them at the start of every conversation
  - Context compounds over time

The more you use ALIVE, the more I know.
The more I know, the more useful I become.
```

---

### Step 18: Verify Installation

```
▸ verifying installation...

DOMAINS
  ✓ 01_Archive/ exists
  ✓ 02_Life/ exists
  ✓ 03_Inputs/ exists
  ✓ 04_Ventures/ exists
  ✓ 05_Experiments/ exists

LIFE STRUCTURE
  ✓ 02_Life/_brain/ exists
  ✓ 02_Life/people/ exists ([N] people)
  ✓ [X] life areas configured

SYSTEM FILES
  ✓ .claude/CLAUDE.md exists
  ✓ .claude/rules/ exists (7 files)
  ✓ .claude/state/ exists
  ✓ .claude/alive.local.yaml exists

ENTITIES
  ✓ [venture]/_brain/ initialised
  ✓ [experiment]/_brain/ initialised

CONFIG
  ✓ system_version: 2.1.1
  ✓ alive_root: [path]
  ✓ timezone: [value]
  ✓ theme: [value]

─────────────────────────────────────────────────────────────────────────
All checks passed.
```

**If any check fails:**

```
✗ VERIFICATION FAILED

Missing:
  ✗ .claude/rules/ — rules not installed
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Fix the missing components?",
    header: "Fix",
    options: [
      { label: "Fix now", description: "Install missing components" },
      { label: "Cancel", description: "Cancel onboarding" }
    ],
    multiSelect: false
  }]
})
```

**Do NOT proceed to next step until all checks pass.**

---

### Step 19: Import Existing Content (Migrate Prompt)

```
╭─ IMPORT EXISTING CONTENT ──────────────────────────────────────────────╮
│                                                                        │
│  One more thing before we finish.                                      │
│                                                                        │
╰────────────────────────────────────────────────────────────────────────╯

Do you have existing content you'd like to bring into ALIVE?

This could be:
  - Meeting transcripts or notes
  - Documents from other systems (Notion, Obsidian, Google Docs)
  - Existing project folders
  - Old notes you want to preserve

ALIVE can import and organise this for you.
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Import existing content?",
    header: "Import",
    options: [
      { label: "Yes", description: "I have content to import (after setup)" },
      { label: "Maybe later", description: "Tell me how to import later" },
      { label: "No", description: "I'm starting fresh" }
    ],
    multiSelect: false
  }]
})
```

**If "Yes":**

```
After this setup finishes, run:

  /alive:migrate

This will walk you through importing your existing content.
I'll extract the relevant context and file it in the right places.
```

**If "Maybe later":**

```
No problem. Whenever you're ready, just say:

  "migrate my content" or /alive:migrate

I'll help you import from:
  - Meeting transcripts (I extract action items and decisions)
  - Notion exports
  - Markdown files
  - Any text content

Your existing knowledge doesn't have to start from zero.
```

---

### Step 20: Import AI Conversation History

```
╭─ AI CONVERSATION HISTORY ─────────────────────────────────────────────╮
│                                                                        │
│  One more thing — this one's optional but powerful.                    │
│                                                                        │
╰────────────────────────────────────────────────────────────────────────╯

You've probably had hundreds of conversations with AI assistants
before ALIVE. All that context — decisions, research, ideas,
problem-solving — is sitting in those chat histories.

ALIVE has a companion plugin that can import your previous AI
conversations, extract the valuable context, and route it into
your ALIVE system.

It works with any AI assistant that lets you export your data.
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Want to import your previous AI conversation history into ALIVE?",
    header: "AI history",
    options: [
      { label: "Yes — tell me how", description: "I want to bring in context from previous AI conversations" },
      { label: "Maybe later", description: "Sounds useful but not right now" },
      { label: "No thanks", description: "I'm starting fresh" }
    ],
    multiSelect: false
  }]
})
```

**If "Yes" or "Maybe later":**

```
CONTEXT IMPORT PLUGIN
─────────────────────────────────────────────────────────────────────────

To import AI conversation history, you'll need to install the
ALIVE Context Import plugin:

  aliveskills/alive-context-import

This is a separate plugin (not bundled with ALIVE) that handles:
  • Exporting your data from AI assistants
  • Extracting decisions, insights, and action items
  • Routing imported context into your ALIVE entities
  • Building your _references/ and _brain/ files from history

I've added a task to your Life tasks so you don't forget.
```

**Implementation:**

Add this task to `{alive-root}/02_Life/_brain/tasks.md` under the "To Do" section:

```markdown
- [ ] **Install alive-context-import plugin** — Import previous AI conversation history into ALIVE. Plugin: `aliveskills/alive-context-import`. Install via Claude Code plugin system, then run its import skill to extract context from your old conversations.
```

```
▸ adding task to 02_Life/_brain/tasks.md
  └─ "Install alive-context-import plugin"

✓ Task added — you can pick this up whenever you're ready.
```

**If "No thanks":**

```
No worries. If you change your mind later, the plugin is:

  aliveskills/alive-context-import

You can install it any time.
```

---

### Step 21: Complete + What's Next

**Update `alive.local.yaml`** — remove `onboarding_part`, add `onboarding_complete`:

Use the Edit tool to modify `{alive-root}/.claude/alive.local.yaml`:
- Remove the line `onboarding_part: 1`
- Add `onboarding_complete: true`

**Final alive.local.yaml should look like:**

```yaml
# ALIVE System Configuration
# Created by /alive:onboarding
# Location: {alive-root}/.claude/alive.local.yaml

version: 2
system_version: "2.1.1"
onboarding_complete: true
created: "2026-02-10"

# System paths
alive_root: "/Users/will/Desktop/alive"

# User preferences
timezone: "Australia/Sydney"
theme: "vibrant"
working_style: "solo"
```

**Display:**

```
╔══════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                      ║
║  [FULL LOGO]                                                                         ║
║                                                                                      ║
║    ✓ SETUP COMPLETE                                                                  ║
║  ════════════════════════════════════════════════════════════════════════════════    ║
║                                                                                      ║
║  WHAT YOU HAVE NOW:                                                                  ║
║    • 02_Life/ with [X] areas + [Y] people configured                                ║
║    • [N] ventures ready to track                                                     ║
║    • [N] experiments ready to explore                                                ║
║    • All rules and system files installed                                             ║
║    • System version: 2.1.1                                                           ║
║                                                                                      ║
║  THE LEARNING LOOP:                                                                  ║
║    /alive:daily   → See everything, start your day                                   ║
║    /alive:do      → Focus on one entity                                              ║
║    /alive:save    → End session, preserve context                                    ║
║                                                                                      ║
║  REMEMBER:                                                                           ║
║    • Save before closing (or context is lost)                                        ║
║    • Dump stuff in 03_Inputs/ when unsure where it goes                              ║
║    • Context compounds — the more you use it, the better it gets                     ║
║                                                                                      ║
║  ──────────────────────────────────────────────────────────────────────────────────  ║
║  Free: Join the ALIVE community → skool.com/aliveoperators                           ║
║  (Templates, guides, Q&A with other operators)                                       ║
║                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════╝
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "What's first?",
    header: "Next",
    options: [
      { label: "/alive:daily", description: "See my full dashboard" },
      { label: "Work on a venture", description: "Start with my main project" },
      { label: "/alive:migrate", description: "Import my existing content" },
      { label: "Explore", description: "Let me look around first" }
    ],
    multiSelect: false
  }]
})
```

---

## Returning Users

If `onboarding_complete: true` in alive.local.yaml:

```
You've already completed onboarding.
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "What would you like to do?",
    header: "Options",
    options: [
      { label: "Quick reference", description: "Show /alive:help" },
      { label: "Re-run setup", description: "Reset onboarding and start over" },
      { label: "Join community", description: "skool.com/aliveoperators" }
    ],
    multiSelect: false
  }]
})
```

---

## Skip Options

At any point during setup, if the user says "skip" or wants to jump ahead:

Create minimal structure (domain folders + .claude/ system files) and mark complete.

For Session 1: Create folders, install rules, create alive.local.yaml with `onboarding_complete: true` (skip Session 2).
For Session 2: Create minimal entities with default _brain/ files and mark complete.

---

## Edge Cases

**No ventures or experiments:**
```
That's fine — ALIVE works for any context.
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Want me to create a starting point?",
    header: "Starter",
    options: [
      { label: "Personal venture", description: "For side projects and freelance" },
      { label: "Experiment space", description: "For exploring ideas" },
      { label: "Core only", description: "Just 02_Life/ and 03_Inputs/" }
    ],
    multiSelect: false
  }]
})
```

**Existing content found:**
```
[!] Found existing structure in this folder.
```

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Existing content found. What do you want to do?",
    header: "Existing",
    options: [
      { label: "Add ALIVE on top", description: "Keep existing, add ALIVE structure" },
      { label: "Fresh start", description: "Archive existing, start clean" },
      { label: "Cancel", description: "Exit setup" }
    ],
    multiSelect: false
  }]
})
```

**alive.local.yaml exists but no onboarding fields:**
Treat as new user. Run Session 1 from Step 1 but preserve existing yaml fields.

**User runs onboarding while already in Session 2 location (cd'd into alive root):**
The rules are already loaded. Detect `onboarding_part: 1` and proceed to Session 2.

---

## alive.local.yaml Schema (Complete Reference)

### After Session 1

```yaml
# ALIVE System Configuration
# Created by /alive:onboarding — Session 1
# Location: {alive-root}/.claude/alive.local.yaml

version: 2
system_version: "2.1.1"
onboarding_part: 1
created: "2026-02-10"

# System paths
alive_root: "/Users/will/Desktop/alive"

# User preferences
timezone: "Australia/Sydney"
theme: "vibrant"
working_style: "solo"
```

### After Session 2 (Complete)

```yaml
# ALIVE System Configuration
# Created by /alive:onboarding
# Location: {alive-root}/.claude/alive.local.yaml

version: 2
system_version: "2.1.1"
onboarding_complete: true
created: "2026-02-10"

# System paths
alive_root: "/Users/will/Desktop/alive"

# User preferences
timezone: "Australia/Sydney"
theme: "vibrant"
working_style: "solo"
```

### Field Reference

| Field | Type | Set by | Purpose |
|-------|------|--------|---------|
| `version` | integer | Onboarding | ALIVE framework version (always 2) |
| `system_version` | string | Onboarding / Upgrade | Plugin version installed. Compared against `plugin_version` in skill frontmatter. |
| `onboarding_part` | integer | Session 1 | Tracks partial onboarding. Removed when complete. |
| `onboarding_complete` | boolean | Session 2 | True when full onboarding is done. |
| `created` | string (date) | Onboarding | Date ALIVE was first set up. |
| `alive_root` | string (path) | Onboarding | Absolute path to ALIVE root directory. |
| `timezone` | string | Onboarding | User's timezone for date calculations. |
| `theme` | string | Onboarding | Visual theme: vibrant, minimal, or loud. |
| `working_style` | string | Onboarding | solo, small_team, or larger_org. |

---

## File Templates

**02_Life/_brain/status.md:**
```markdown
# Life Status

**Updated:** [DATE]

## Current Focus
[From life goals input, or "Set your life focus"]

## Active Areas
[List of selected life areas]

## People
See people/ for all contacts.
```

**Person file template (e.g., 02_Life/people/sarah.md):**
```markdown
# [Name]

**Relationship:** [relationship type]
**Added:** [DATE]

## Context
[To be filled as context accumulates]

## Notes
[Auto-populated from conversations]
```

---

## Related Skills

- `/alive:daily` — Morning entry point (most common next step)
- `/alive:do` — Focus on one entity
- `/alive:help` — Quick reference
- `/alive:upgrade` — For v1 → v2 migration (not fresh setup). Also handles version bumps.
- `/alive:migrate` — Import existing content
