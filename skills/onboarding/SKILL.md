---
user-invocable: true
description: This skill should be used when the user says "set up ALIVE", "get started", "initialize", "new here", "how do I start", or when `/alive:daily` detects no ALIVE structure exists. Fresh v2 setup for new users.
---

# alive:onboarding

First-time setup wizard for ALIVE v2. Guide new users through complete configuration including Life setup, ventures, experiments, and migration prompts.

**Different from `/alive:upgrade`:** Onboarding is fresh setup. Upgrade migrates v1 → v2.

## When to Use

Invoke when:
- User is new to ALIVE
- User asks how to get started
- `onboarding_complete: false` in alive.local.yaml
- User explicitly requests setup

## UI Treatment

This skill uses **Tier 1: Entry Point** formatting.

**IMPORTANT:** Since rules aren't installed until Step 10, this skill must contain the full UI assets inline. Do not reference `rules/ui-standards.md` — use the assets below.

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

**Example — Step 1 welcome question:**

```
AskUserQuestion({
  questions: [{
    question: "Ready to set up ALIVE?",
    header: "Setup",
    options: [
      { label: "Let's do this", description: "Start the full setup (~10 minutes)" },
      { label: "Tell me more first", description: "I want to understand before committing" },
      { label: "I've used ALIVE before", description: "Skip to quick setup" }
    ],
    multiSelect: false
  }]
})
```

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
3. Onboarding completes successfully

**Do NOT:**
- Answer unrelated questions mid-onboarding
- Let the user "just quickly" do something else
- Abandon onboarding without explicit cancellation

This ensures users get the full benefit of proper setup rather than an incomplete, broken system.

---

## Onboarding Principles

1. **Assume zero knowledge** — User has never heard of ALIVE
2. **Explain before asking** — Tell them WHY before asking WHAT
3. **Life is the foundation** — Set it up first, properly
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

## Full Flow

```
1.  Welcome + What is ALIVE?
2.  How ALIVE Works (the mental model)
3.  The Five Domains (explained)
4.  User Preferences
5.  DIRECTORY LOCATION (where to create ALIVE)
6.  LIFE SETUP (the foundation)
    6a. Areas of life to track (from template: health, finance, relationships, growth, home)
    6b. Key people
    6c. Life goals (optional)
7.  VENTURES SETUP
    7a. Do you have ventures?
    7b. Per-venture: name, TYPE (Agency/Creator/E-commerce/Job/Custom), goal, phase
8.  EXPERIMENTS SETUP
    8a. Do you have experiments?
    8b. Per-experiment: name, hypothesis, status
9.  Create Structure (from templates)
10. INSTALL RULES & CLAUDE.MD (CRITICAL — system won't work without this)
11. CONFIGURE STATUSLINE (MANDATORY — essential for ALIVE experience)
12. Quick Tour of Key Concepts
13. First Capture Exercise
14. The Aha Moment
15. Verify Installation
16. Import Existing Content (migrate prompt)
17. Complete + What's Next
```

---

## Step 1: Welcome + What is ALIVE?

Use the full UI template from the "UI Treatment" section above. Display the full logo, double-line border, and community footer.

**Then use AskUserQuestion for the choice:**

```
AskUserQuestion({
  questions: [{
    question: "Ready to set up ALIVE?",
    header: "Setup",
    options: [
      { label: "Let's do this", description: "Start the full setup (~10 minutes)" },
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
This setup takes about 10 minutes. Worth it.
```

**If [2] Tell me more:**

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

─────────────────────────────────────────────────────────────────────────
[1] Got it — start setup
[2] Show me an example
```

**If [2] Show me an example:**

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

─────────────────────────────────────────────────────────────────────────
[1] I'm in — start setup
```

---

## Step 2: How ALIVE Works (The Mental Model)

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

─────────────────────────────────────────────────────────────────────────
[1] Makes sense — continue
[2] Why files instead of a database?
```

**If [2] Why files:**

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

─────────────────────────────────────────────────────────────────────────
[1] Continue
```

---

## Step 3: The Five Domains (Explained)

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

─────────────────────────────────────────────────────────────────────────
[1] Continue — let me set these up
[2] Tell me more about each domain
```

**If [2] Tell me more:**

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

─────────────────────────────────────────────────────────────────────────
[1] Got it — let's set up my system
```

---

## Step 4: User Preferences

```
QUICK PREFERENCES
─────────────────────────────────────────────────────────────────────────

Before we build your system, a few quick preferences:

TIMEZONE
Where are you based? (Helps with "due this week" calculations)

[1] Australia (AEST/AEDT)
[2] US Pacific (PT)
[3] US Eastern (ET)
[4] UK (GMT/BST)
[5] Europe (CET)
[6] Asia Pacific
[7] Other — I'll specify
```

After timezone:

```
VISUAL STYLE
How do you like your interface?

[1] Vibrant — Full visual experience with boxes and formatting
    (Recommended for most users)

[2] Minimal — Clean and fast, less decoration
    (Good for quick interactions, saves context window)

[3] Loud — Emojis, emphasis, maximum clarity
    (ADHD-friendly, high engagement)
```

After style:

```
WORKING STYLE
How do you typically work?

[1] Solo operator — It's mostly just me
[2] Small team — A few collaborators
[3] Larger org — Multiple people, shared context needed

(This helps me know whether to track team members and handoffs)

─────────────────────────────────────────────────────────────────────────
Preferences saved.
```

---

## Step 5: Directory Location

**Ask where to create the ALIVE system BEFORE setting up Life.**

Use AskUserQuestion:
```
AskUserQuestion({
  questions: [{
    question: "Where do you want to create your ALIVE system?",
    header: "Location",
    options: [
      { label: "Desktop", description: "~/Desktop/alive — easy to find" },
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

[1] Confirm — continue with this location
[2] Change — pick a different location
```

---

## Step 6: Life Setup (THE FOUNDATION)

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

─────────────────────────────────────────────────────────────────────────
[1] Continue — set up my Life domain
[2] I just want to track work — skip this
```

**If [2] Skip:**

```
Are you sure?

Without Life setup, ALIVE becomes just another project tracker.
You'll miss:
  - Personal context that compounds over time
  - Relationship tracking across projects
  - Health/energy patterns that affect productivity
  - The foundation that makes everything else work

[1] You're right — let me set up Life
[2] Skip anyway — I'll add it later

(You can always run this setup later with /alive:new)
```

### Step 6a: Life Areas

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
      { label: "Growth", description: "Learning, skills, personal development" },
      { label: "Home", description: "Living space, maintenance, projects" }
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

**For each selected area, brief follow-up:**

```
HEALTH
─────────────────────────────────────────────────────────────────────────

What's your main health focus right now?
(This helps me understand what to track)

[1] Fitness — training, exercise, physical goals
[2] Medical — appointments, conditions, medications
[3] Mental wellness — stress, therapy, mindfulness
[4] Nutrition — diet, meal planning, weight
[5] Sleep — patterns, quality, improvement
[6] General — all of the above, I'll specify as I go

Selected: ___

Any current health goals?
(Optional — press Enter to skip)
> ___

✓ Health area configured
```

*(Repeat brief config for each selected area)*

### Step 5b: Key People

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

─────────────────────────────────────────────────────────────────────────
[1] Continue
[2] Add more people
```

### Step 5c: Life Goals (Optional)

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

---

## Step 7: Ventures Setup

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

[1] Yes — I have ventures to set up
[2] No — I don't have revenue-generating projects right now
[3] Not sure — help me figure out what counts
```

**If [3] Help me figure out:**

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

─────────────────────────────────────────────────────────────────────────
[1] Yes, I have ventures
[2] No, I'll start with experiments
[3] Skip both for now
```

### Step 7a: Per-Venture Setup

**For each venture, collect: name, TYPE, goal, phase**

The venture TYPE determines the folder structure (from `templates/domains/ventures.md`).

**Step 1: Name** (conversational)
```
What's the name of your venture?
> ___
```

**Step 2: Type** (use AskUserQuestion)
```
AskUserQuestion({
  questions: [{
    question: "What type of venture is this?",
    header: "Venture type",
    options: [
      { label: "Agency", description: "Client work, deliverables, retainers" },
      { label: "Creator", description: "Content, courses, community" },
      { label: "E-commerce", description: "Products, inventory, fulfillment" },
      { label: "Job", description: "Employment brought into ALIVE" },
      { label: "Custom", description: "Generic starting point" }
    ],
    multiSelect: false
  }]
})
```

**Step 3: Goal** (conversational)
```
What's the one-sentence goal?
(What does success look like?)
> ___
```

**Step 4: Phase** (use AskUserQuestion)
```
AskUserQuestion({
  questions: [{
    question: "What phase is it in?",
    header: "Phase",
    options: [
      { label: "Starting", description: "Idea stage, getting off the ground" },
      { label: "Building", description: "Actively developing, early traction" },
      { label: "Launching", description: "Going to market, finding customers" },
      { label: "Growing", description: "Scaling up, increasing revenue" },
      { label: "Maintaining", description: "Mature and stable, optimising" }
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
- **Custom:** (minimal) .claude/, _brain/, _working/

```
✓ [Venture name] configured as [Type]

Add another venture?
[1] Yes — I have more
[2] No — continue to experiments
```

---

## Step 8: Experiments Setup

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

Do you have any active experiments?

[1] Yes — I have ideas I'm testing
[2] No — nothing in exploration right now
[3] Maybe — I have some vague ideas
```

**If [1] Yes:**

```
EXPERIMENT 1
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

Add another experiment?
[1] Yes
[2] No — continue
```

---

## Step 9: Create Structure

```
╭─ CREATING YOUR ALIVE SYSTEM ───────────────────────────────────────────╮
│                                                                        │
│  Building your personal context infrastructure...                      │
│                                                                        │
╰────────────────────────────────────────────────────────────────────────╯

▸ creating domain folders...

ALIVE/
├── 01_Archive/           ← Completed items rest here
├── 02_Life/              ← Your foundation
│   ├── _brain/
│   │   ├── status.md     (Your life focus + goals)
│   │   ├── tasks.md      (Personal to-dos)
│   │   ├── insights.md   (Life learnings)
│   │   └── changelog.md  (Personal history)
│   ├── health/           ← Your health tracking
│   ├── finance/          ← Your money stuff
│   ├── career-growth/    ← Your development
│   ├── events/           ← Your calendar/dates
│   └── people/           ← Everyone you know
│       ├── sarah.md
│       ├── mum.md
│       ├── ben.md
│       └── jake.md
├── 03_Inputs/            ← Your inbox (dump stuff here)
├── 04_Ventures/
│   ├── acme-agency/
│   │   ├── _brain/       (Project memory)
│   │   ├── _working/     (Drafts & WIP)
│   │   └── CLAUDE.md     (Project identity)
│   └── saas-product/
│       ├── _brain/
│       ├── _working/
│       └── CLAUDE.md
└── 05_Experiments/
    └── newsletter-idea/
        ├── _brain/
        ├── _working/
        └── CLAUDE.md

✓ Structure created

─────────────────────────────────────────────────────────────────────────
[1] Continue
[2] Show me what's in the _brain/ files
```

**If [2] Show me:**

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

─────────────────────────────────────────────────────────────────────────
[1] Continue
```

**Implementation Notes:**

1. Create domain folders (01_Archive/, 02_Life/, 03_Inputs/, 04_Ventures/, 05_Experiments/)
2. Create 02_Life/_brain/ with status.md, tasks.md, insights.md, changelog.md
3. Create life area subfolders based on user selections
4. Create people/ folder and individual person files
5. Create each venture/experiment entity with _brain/, _working/, CLAUDE.md
6. Create v2 system files:
   - `.claude/state/session-index.jsonl` (empty)
7. Create `alive.local.yaml` with user preferences

---

## Step 10: Install Rules & CLAUDE.md (CRITICAL)

**This step is MANDATORY. ALIVE will not work without it.**

**IMPORTANT:** These files are installed INSIDE the ALIVE directory (the location chosen in Step 5), NOT in the user's home `~/.claude/` folder.

Example: If user chose `~/Desktop/alive/` as their ALIVE location:
- Rules go to: `~/Desktop/alive/.claude/rules/`
- CLAUDE.md goes to: `~/Desktop/alive/.claude/CLAUDE.md`
- State goes to: `~/Desktop/alive/.claude/state/`

### 1. Rules (behaviour files)

```bash
# Source: Plugin rules directory
~/.claude/plugins/cache/aliveskills/alive/*/rules/

# Destination: INSIDE the ALIVE installation directory
{alive-install-location}/.claude/rules/
```

**Files to copy:**
- `behaviors.md` — How Claude reads and updates context
- `conventions.md` — File naming, folder structure
- `intent.md` — Understanding user commands
- `learning-loop.md` — The daily/do/save rhythm
- `ui-standards.md` — Visual formatting
- `voice.md` — How Claude communicates
- `working-folder-evolution.md` — When drafts become projects

### 2. CLAUDE.md (system identity + user preferences)

Create `{alive-install-location}/.claude/CLAUDE.md` with the ALIVE system identity.

This file tells Claude:
- What ALIVE is
- How to read _brain/ folders
- The session protocol
- The five domains
- **User preferences** (timezone, theme, working style)

**Template location:** `~/.claude/plugins/cache/aliveskills/alive/*/CLAUDE.md` (the plugin's root CLAUDE.md)

**After copying, add the User Preferences section:**
```markdown
## User Preferences

**Timezone:** [from Step 4]
**Theme:** [from Step 4]
**Working Style:** [from Step 4]
```

This ensures Claude reads user preferences automatically every session.

### Implementation

```bash
# Using the ALIVE install location from Step 5 (e.g., ~/Desktop/alive)
ALIVE_ROOT="{user-chosen-location}"

# Create .claude directory structure INSIDE the ALIVE directory
mkdir -p "$ALIVE_ROOT/.claude/rules"
mkdir -p "$ALIVE_ROOT/.claude/state"

# Copy rules from plugin to ALIVE directory
cp -r ~/.claude/plugins/cache/aliveskills/alive/*/rules/* "$ALIVE_ROOT/.claude/rules/"

# Copy CLAUDE.md from plugin to ALIVE directory
cp ~/.claude/plugins/cache/aliveskills/alive/*/CLAUDE.md "$ALIVE_ROOT/.claude/CLAUDE.md"
```

### Display to user

```
▸ installing ALIVE system files to {alive-install-location}/.claude/

  └─ .claude/CLAUDE.md        (System identity)
  └─ .claude/rules/           (7 behaviour files)
  └─ .claude/state/           (Session tracking)

✓ System files installed

These enable Claude to understand your ALIVE system automatically.
When you cd into this directory, Claude reads these files.
```

**Do NOT skip this step. Without these files, ALIVE skills will not function correctly.**

---

## Step 11: Configure Statusline (MANDATORY)

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

[1] Set it up
[2] Skip for now
```

**If yes, implementation:**
1. Copy `.claude/templates/config/statusline-command.sh` to `~/.claude/statusline-command.sh`
2. Add to `~/.claude/settings.json`:
   ```json
   {
     "statusline": {
       "command": "~/.claude/statusline-command.sh"
     }
   }
   ```

---

## Step 12: Quick Tour

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

─────────────────────────────────────────────────────────────────────────
[1] Continue
[2] Tell me about other commands
```

**If [2] Other commands:**

```
OTHER USEFUL COMMANDS
─────────────────────────────────────────────────────────────────────────

/alive:capture  Quick capture. Grab a decision, insight, or task
                without interrupting flow.

/alive:input    Process external content. Meeting transcript?
                Article? Dump it here, I'll extract and route it.

/alive:recall   Search your history. "What did we decide about
                pricing?" — I'll find it.

/alive:new      Create a new entity (venture, experiment, life area).

/alive:archive  Move something to the archive when it's done.

/alive:sweep    Clean up. Find stale content, abandoned drafts.

/alive:help     Quick reference for all commands.

─────────────────────────────────────────────────────────────────────────
[1] Continue
```

---

## Step 13: First Capture Exercise

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

─────────────────────────────────────────────────────────────────────────
[1] Continue
[2] Capture something else
```

---

## Step 14: The Aha Moment

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

─────────────────────────────────────────────────────────────────────────
[1] Got it — finish setup
[2] Show me more examples
```

---

## Step 15: Verify Installation

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
  ✓ alive.local.yaml exists

ENTITIES
  ✓ [venture]/_brain/ initialised
  ✓ [experiment]/_brain/ initialised

─────────────────────────────────────────────────────────────────────────
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

**Do NOT proceed to next step until all checks pass.**

---

## Step 16: Import Existing Content (Migrate Prompt)

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

[1] Yes — I have content to import
[2] Maybe later — tell me how
[3] No — I'm starting fresh
```

**If [1] Yes:**

```
Great! After this setup finishes, run:

  /alive:migrate

This will walk you through importing your existing content.
I'll extract the relevant context and file it in the right places.

─────────────────────────────────────────────────────────────────────────
[1] Continue to finish setup
```

**If [2] Maybe later:**

```
No problem. Whenever you're ready, just say:

  "migrate my content" or /alive:migrate

I'll help you import from:
  - Meeting transcripts (I extract action items and decisions)
  - Notion exports
  - Markdown files
  - Any text content

Your existing knowledge doesn't have to start from zero.

─────────────────────────────────────────────────────────────────────────
[1] Continue to finish setup
```

---

## Step 17: Complete + What's Next

```
╭────────────────────────────────────────────────────────────────────────╮
│                                                                        │
│  ✓ SETUP COMPLETE                                                      │
│                                                                        │
│  Your ALIVE system is ready.                                           │
│                                                                        │
╰────────────────────────────────────────────────────────────────────────╯

WHAT YOU HAVE NOW:
  • 02_Life/ with [X] areas + [Y] people configured
  • [N] ventures ready to track
  • [N] experiments ready to explore
  • All rules and system files installed

THE LEARNING LOOP:
  /alive:daily   → See everything, start your day
  /alive:do      → Focus on one entity
  /alive:save    → End session, preserve context

REMEMBER:
  • Save before closing (or context is lost)
  • Dump stuff in 03_Inputs/ when unsure where it goes
  • Context compounds — the more you use it, the better it gets

─────────────────────────────────────────────────────────────────────────

What's first?

[1] /alive:daily — See my full dashboard
[2] Work on [first venture] — Start with my main project
[3] /alive:migrate — Import my existing content
[4] Explore — Let me look around first

─────────────────────────────────────────────────────────────────────────

Free: Join the ALIVE community → skool.com/aliveoperators
(Templates, guides, Q&A with other operators)
```

**Implementation:**

1. Update `alive.local.yaml` (flag only):
```yaml
version: 2
onboarding_complete: true
created: "[today's date]"
```

2. Add User Preferences to `{alive-root}/.claude/CLAUDE.md`:
```markdown
## User Preferences

**Timezone:** [user selection]
**Theme:** [user selection]
**Working Style:** [user selection]
```

This ensures Claude reads the preferences automatically every session.

---

## Returning Users

If `onboarding_complete: true` in alive.local.yaml:

```
You've already completed onboarding.

[1] Show quick reference (/alive:help)
[2] Re-run setup (reset onboarding)
[3] Join the community (skool.com/aliveoperators)
```

---

## Skip Options

At any point during setup:

```
[s] Skip to end — I know what I'm doing
```

If selected, create minimal structure and mark complete.

---

## Edge Cases

**No ventures or experiments:**
```
That's fine — ALIVE works for any context.

Want me to create:
[1] A "personal" venture (for side projects)
[2] An experiment space (for exploring ideas)
[3] Just the core structure (02_Life/, 03_Inputs/)
```

**Existing content found:**
```
[!] Found existing structure in this folder.

[1] Continue — add ALIVE on top
[2] Fresh start — archive existing, start clean
[3] Cancel — exit setup
```

---

## File Templates

**alive.local.yaml** (simple flag file):
```yaml
version: 2
onboarding_complete: true
created: 2026-02-05
```

**User preferences go in `.claude/CLAUDE.md`** (so Claude reads them every session):

The CLAUDE.md at the ALIVE root should include a User Preferences section:

```markdown
# ALIVE

[... standard ALIVE identity content ...]

---

## User Preferences

**Timezone:** Australia/Sydney (AEST)
**Theme:** vibrant
**Working Style:** solo

---

[... rest of CLAUDE.md ...]
```

This ensures preferences are read automatically when Claude enters the ALIVE directory.

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
- `/alive:upgrade` — For v1 → v2 migration (not fresh setup)
- `/alive:migrate` — Import existing content
