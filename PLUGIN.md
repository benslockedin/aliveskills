---
name: alive
version: 3.0.1
description: The operating system for your context. Persistent memory for Claude across sessions.
author: Ben Flint
homepage: https://skool.com/aliveoperators
---

# ALIVE

Context infrastructure for Claude Code. Your life, ventures, and experiments — organized, searchable, and always available.

## What This Does

- Gives Claude persistent memory across sessions
- Organizes your context into domains (Life, Ventures, Experiments)
- Provides skills for capturing, recalling, and managing context
- Logs all changes for full traceability

## Installation

```
claude plugin marketplace add SuperSystemsAdmin/alive-context
claude plugin install alive@alive-local
```

Restart Claude Code, then run `/alive:onboarding` in your ALIVE folder.

## Skills Included

| Skill | Purpose |
|-------|---------|
| `/alive:work` | Start a work session |
| `/alive:save` | End session, log progress |
| `/alive:new` | Create venture, experiment, life area, or nested unit |
| `/alive:capture` | Capture context into ALIVE |
| `/alive:recall` | Search past context |
| `/alive:migrate` | Bulk import content |
| `/alive:archive` | Move completed items to archive |
| `/alive:digest` | Process inputs |
| `/alive:sweep` | Audit and clean stale content |
| `/alive:help` | Get guidance |
| `/alive:onboarding` | First-time setup wizard |

## Community

Free: Join the ALIVE community → skool.com/aliveoperators

## License

MIT
