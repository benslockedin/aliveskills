# UI Standards

Themes, symbols, and output formatting for ALIVE.

---

## Themes

User preference stored in `alive.local.yaml`:

```yaml
theme: vibrant  # vibrant | minimal | loud
```

Read this file at session start to determine output style.

---

## Theme: Vibrant (Default)

Full visual experience. ASCII art, box drawing, retrieval paths.

**Dashboard header:** Full ASCII logo
**Skill headers:** Box-drawn `╭─ ALIVE ───╮` style
**Retrieval paths:** Always shown (`▸ scanning...`)
**Separators:** Full-width lines
**Symbols:** Unicode (✓ ✗ → •)

**Example:**
```
╭─ ALIVE ────────────────────────────────────────────────────────────────╮
│  04_Ventures                                                           │
╰────────────────────────────────────────────────────────────────────────╯

▸ scanning 04_Ventures/
  └─ acme/_brain/status.md      Building
  └─ beta/_brain/status.md      Paused [!]

VENTURES
─────────────────────────────────────────────────────────────────────────
[1] acme                Building                 7 tasks
[2] beta                Paused                   [!] stale

─────────────────────────────────────────────────────────────────────────
[n] new  [s] search  [b] back
```

---

## Theme: Minimal

Clean output. No ASCII art, shorter lines. Saves context window.

**Dashboard header:** Simple `ALIVE v2.0`
**Skill headers:** Markdown `## Ventures`
**Retrieval paths:** Hidden unless error
**Separators:** Short `---`
**Symbols:** Simple text

**Example:**
```
## Ventures

[1] acme — Building (7 tasks)
[2] beta — Paused [!]

---
[n] new  [s] search  [b] back
```

---

## Theme: Loud

ADHD-friendly. Emojis, emphasis, maximum clarity.

**Dashboard header:** Emoji-enhanced
**Skill headers:** Emoji prefix
**Retrieval paths:** Shown with emojis
**Separators:** Emoji dividers
**Symbols:** Emojis (see glossary)

**Example:**
```
🎯 VENTURES

👀 Scanning...
  └─ acme: Building
  └─ beta: Paused ⚠️

[1] 🔥 acme — Building (7 tasks)
[2] ⚠️ beta — Paused (stale!)

───────────────────────────────
[n] ➕ new  [s] 🔍 search  [b] ⬅️ back
```

---

## Emoji Glossary (Loud Theme)

| Emoji | Meaning |
|-------|---------|
| ✅ | Done, success |
| ❌ | Failed |
| 🚫 | Blocked |
| 🔥 | Urgent, priority |
| 👀 | Attention needed |
| 🎯 | Current focus |
| 💡 | Insight |
| 📝 | Task |
| 🤝 | Decision |
| 👤 | Person |
| 📅 | Event, date |

---

## Symbols (Vibrant/Minimal)

| Symbol | Meaning |
|--------|---------|
| `✓` | Success, done |
| `✗` | Failed, blocked |
| `→` | Next, leads to |
| `•` | Separator |
| `▸` | Actionable item |
| `┃` | Vertical connector |
| `[!]` | Attention needed, stale |
| `[OK]` | Current, fresh |
| `[?]` | Unknown, not loaded |

---

## Chinese Menu

**Everything actionable gets a number.** Not just footer — every item on screen.

```
VENTURES
─────────────────────────────────────────────────────────────────────────
[1] acme                Building                 7 tasks
[2] beta                Paused                   [!] stale
[3] gamma               Starting                 0 tasks

─────────────────────────────────────────────────────────────────────────
[n] new venture    [s] search    [b] back

Pick a number or command:
```

User can say `1` or `acme` or `new` or `n`.

---

## Retrieval Paths

Show what you're accessing. Make the system visible.

```
▸ scanning 04_Ventures/
  └─ acme/_brain/status.md      Building
  └─ beta/_brain/status.md      Paused [!]

▸ reading 04_Ventures/acme/_brain/tasks.md
  └─ 7 tasks, 2 @urgent
```

When searching:
```
▸ searching "contract"...
  └─ 04_Ventures/acme/clients/globex/contract.md    ✓ match
  └─ _brain/changelog.md                         2 mentions
```

---

## Skill Headers

**Vibrant:**
```
╭─ ALIVE ────────────────────────────────────────────────────────────────╮
│  do                                                                    │
╰────────────────────────────────────────────────────────────────────────╯
```

**Minimal:**
```
## Do
```

**Loud:**
```
🎯 DO — Let's work!
```

---

## Status Lines

Fixed-width columns for alignment (vibrant theme):

```
[#] [Name 20ch]         [Status 24ch]           [Flag]
```

**Example:**
```
[1] acme                Building                 7 tasks
[2] beta                Paused                   [!] stale
```

---

## Box Drawing

Characters for structure (vibrant theme):

```
╭─────────────────────────────────────────────────────────────╮
│  Content here                                               │
├─────────────────────────────────────────────────────────────┤
│  Section two                                                │
╰─────────────────────────────────────────────────────────────╯
```

Characters: `╭ ╮ ╰ ╯ │ ─ ├ ┤ ┬ ┴ ┼`

---

## Confirmations

**Success:**
```
✓ Saved to 04_Ventures/acme/_brain/changelog.md
```

**Error:**
```
✗ Cannot find venture: [name]
  └─ Check 04_Ventures/ folder
```

**Warning:**
```
[!] 04_Ventures/beta/_brain/status.md is 3 weeks old
    └─ May need refresh
```

---

## Date Format

Use em dash separator in changelog:

```markdown
## 2026-01-23 — Session Summary
```

ISO dates everywhere else: `2026-01-23`

---

## Footer (Vibrant Only)

Include community reference:

```
Free: Join the ALIVE community on Skool → skool.com/aliveoperators
```
