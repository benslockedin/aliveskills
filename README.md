# ALIVE

> The operating system for your context.

You're not just chatting with AI — you're building with it. ALIVE gives Claude persistent memory across sessions. Your decisions, tasks, insights — they survive context resets.

## Quick Start

**1. Install the plugin**
```
claude plugin marketplace add SuperSystemsAdmin/alive-context
claude plugin install alive@alive-local
```

**2. Restart Claude Code** (plugins need a fresh session to load)

**3. Create your ALIVE folder**

Pick a spot that syncs across devices:
- **iCloud:** `~/Library/Mobile Documents/com~apple~CloudDocs/alive`
- **Dropbox:** `~/Dropbox/alive`
- **Local:** `~/alive` or `~/Documents/alive`

Create the folder however you like — Finder, terminal, whatever works.

**4. Open Claude Code in that folder**

Either:
- Right-click the folder → "New Terminal at Folder" → type `claude`
- Or in terminal: `cd /path/to/your/alive && claude`

**5. Run setup**
```
/alive:onboarding
```

**6. Start working**
```
/alive:do
```

That's it. Your AI now has persistent memory.

## The Framework

| Letter | Domain | Purpose |
|--------|--------|---------|
| **A** | archive/ | Inactive items, preserved |
| **L** | life/ | Personal — plans, people, patterns |
| **I** | inbox/ | Incoming context, triage |
| **V** | ventures/ | Businesses with revenue intent |
| **E** | experiments/ | Testing grounds |

**Life first, always.** Ventures and experiments are expressions of life.

## How It Works

Every subdomain has a `_brain/` folder:

```
ventures/mycompany/_brain/
├── status.md      # Current phase + goal
├── tasks.md       # What needs doing
├── changelog.md   # What happened + decisions
├── insights.md    # Learnings
└── manifest.json  # Structure map
```

Claude reads these files to understand your context. Updates them as you work. Everything persists.

## Core Skills

| Skill | When to Use |
|-------|-------------|
| `/alive:do` | "Let's work on X" — loads context, starts session |
| `/alive:save` | "We're done" — logs progress, cleans up |
| `/alive:new` | "Create a venture/experiment" — scaffolds structure |
| `/alive:capture` | "Remember this" — quick context grab |
| `/alive:recall` | "What did we decide about X?" — searches history |
| `/alive:digest` | "Process my inbox" — triages incoming context |
| `/alive:help` | "What should I do?" — contextual guidance |

## Community

Join 500+ operators building with AI:
**skool.com/aliveoperators**

- Templates for every business type
- Live Q&A and support
- Courses on terminal mastery
- Case studies from real operators

## Philosophy

1. **Life first, always** — Life is the foundation, not a category
2. **File-based everything** — Portable, grep-able, yours
3. **Zero-context documentation** — Anyone can understand with no prior knowledge
4. **Don't confabulate** — Query before answering, read before assuming
5. **Show the work** — Make retrieval visible, build trust

## Support

- Community: skool.com/aliveoperators
- Issues: github.com/SuperSystemsAdmin/alive-context

---

MIT License
