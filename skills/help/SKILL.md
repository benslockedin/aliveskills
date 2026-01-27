---
name: help
user_invocable: true
description: This skill should be used when the user asks for "help", "show commands", "what can you do", "list skills", "how does X work", "what's the command for X", "how do I X", "I'm confused", "explain", or needs quick reference for ALIVE system capabilities.
---

# alive:help

Quick reference for ALIVE. Show available skills, explain concepts, guide usage.

## When to Use

Invoke when the user:
- Asks for help
- Wants to see available commands
- Doesn't know how to do something
- Is confused about ALIVE concepts

## Help Modes

| Mode | Trigger | Shows |
|------|---------|-------|
| Overview | "help" | All skills + quick reference |
| Specific | "help with X" | Detailed help for X |
| Contextual | "how do I X" | Relevant skill for task |

## Quick Reference

```
╭─ ALIVE ────────────────────────────────────────────────────────────────╮
│  help                                                                  │
╰────────────────────────────────────────────────────────────────────────╯

ALIVE — The operating system for your context.

CORE SKILLS
─────────────────────────────────────────────────────────────────────────
/alive:do        Start work, load context from a subdomain
/alive:save      End session, log to changelog
/alive:new       Create subdomain or area

CAPTURE & FIND
─────────────────────────────────────────────────────────────────────────
/alive:capture   Quick context grab from conversation
/alive:recall    Search past context, decisions, sessions
/alive:migrate   Bulk import content into ALIVE

MANAGE
─────────────────────────────────────────────────────────────────────────
/alive:archive   Move completed items to archive
/alive:digest    Process inbox items
/alive:sweep     Audit system, clean up stale content

HELP
─────────────────────────────────────────────────────────────────────────
/alive:help      This reference (you're here)
/alive:onboarding   First-time setup wizard

─────────────────────────────────────────────────────────────────────────
[#] Skill details    [c] Concepts    [e] Examples

What do you need help with?

Free: Join the ALIVE community on Skool → skool.com/aliveoperators
```

## Concept Help

### The ALIVE Framework

```
User: "What does ALIVE stand for?"

ALIVE Framework
─────────────────────────────────────────────────────────────────────────
A — Archive    Inactive items, preserved forever
L — Life       Personal responsibilities (always first)
I — Inbox      Universal input, triage point
V — Ventures   Businesses with revenue intent
E — Experiments Testing grounds, no model yet

Life first, always.
```

### Subdomains vs Areas

```
User: "What's the difference between subdomain and area?"

SUBDOMAIN vs AREA
─────────────────────────────────────────────────────────────────────────
                    Subdomain           Area
Has _brain/         Yes                 No
Has .claude/        Yes                 No
Has _working/       Yes                 No
Identity file       .claude/CLAUDE.md   README.md
Example             ventures/acme/      ventures/acme/clients/

Subdomains are projects with their own state.
Areas are organizational folders within subdomains.
```

### _brain/ Files

```
User: "What goes in _brain/?"

_brain/ FILES
─────────────────────────────────────────────────────────────────────────
status.md       Current phase and focus
tasks.md        Work queue (urgent, to do, done)
insights.md     Learnings worth remembering
changelog.md    Session history + decisions
manifest.json   Structure map with file summaries

This is the subdomain's "brain" — its persistent memory.
```

### Themes

```
User: "How do I change the theme?"

THEMES
─────────────────────────────────────────────────────────────────────────
Edit alive.local.yaml:

  theme: vibrant    # Full visual experience (default)
  theme: minimal    # Clean, token-efficient
  theme: loud       # ADHD-friendly, emojis

Restart session after changing.
```

## Contextual Help

Match user question to relevant skill:

```
User: "How do I save my work?"

To save your work, use /alive:save

This will:
- Log what you did to changelog
- Record any decisions
- Note next steps
- Update manifest

Just say "save" or "wrap up" when ready.
```

```
User: "How do I find old decisions?"

To find past decisions, use /alive:recall

Say things like:
- "What did we decide about pricing?"
- "Find decisions about AWS"
- "When did we discuss the launch?"

I'll search across all subdomains and show what I find.
```

## Skill Details

When user asks about specific skill:

```
User: "Tell me more about /alive:digest"

/alive:digest
─────────────────────────────────────────────────────────────────────────
Process inbox items. Triage, extract, and route content.

TRIGGERS:
- "process inbox", "digest", "triage"
- "what's in inbox", "handle inbox"

FLOW:
1. Survey inbox (prioritized list)
2. Select items to process
3. Triage each (simple route vs full extraction)
4. Execute (route and extract)

For complex items (transcripts), spawns specialized agents.

Example: "digest" → shows inbox, lets you pick what to process
```

## Common Questions

### "How do I get started?"

```
New to ALIVE? Run /alive:onboarding for the setup wizard.

Or start with:
1. /alive:new — Create your first venture
2. /alive:do — Load it and start working
3. /alive:save — Log your progress when done
```

### "Where do files go?"

```
FILE ROUTING
─────────────────────────────────────────────────────────────────────────
Drafts              →  _working/
Final files         →  Area folders (clients/, content/, etc.)
Context to process  →  inbox/
Completed projects  →  archive/
People info         →  life/people/
```

### "How do I capture things?"

```
CAPTURE METHODS
─────────────────────────────────────────────────────────────────────────
Quick:    "FYI we decided X" → I'll offer to capture
Direct:   /alive:capture → Prompts for content
Inline:   "capture: [content]" → Captures immediately
Session:  /alive:save → Logs whole session
```

## Error Help

When something goes wrong:

```
User: "It says subdomain not found"

TROUBLESHOOTING: Subdomain not found
─────────────────────────────────────────────────────────────────────────
The subdomain you referenced doesn't exist.

Check:
1. Spelling — Names are lowercase with hyphens
2. Location — Is it in ventures/, experiments/, or life/?
3. Archive — May have been archived

List available:
  ventures/acme, ventures/beta
  experiments/test-idea

Create new subdomain with /alive:new
```

## Related Resources

```
LEARN MORE
─────────────────────────────────────────────────────────────────────────
Community: skool.com/aliveoperators
  - Templates and guides
  - Q&A with other operators
  - Tips and workflows

Rules: Check .claude/rules/ for detailed behaviors
```

## Related Skills

- `/alive:onboarding` — First-time setup
- `/alive:do` — Start working (most common next step)
