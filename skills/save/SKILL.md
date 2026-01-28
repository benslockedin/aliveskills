---
name: save
user-invocable: true
description: End the session and log progress to the changelog. Use when the user says "save", "wrap up", "end session", "done for now", "I'm done", "brb", or "stepping away".
---

# alive:save

End a work session. Log changes, decisions, and next steps to the subdomain's changelog.

## When to Use

Invoke when the user wants to:
- Wrap up a work session
- Save progress before stepping away
- Log what was accomplished
- Create a resume point for next session

## Flow

```
1. Identify what was done this session
2. Identify any decisions made
3. Identify next steps
4. Write to _brain/changelog.md
5. Update _brain/status.md if needed
6. Update _brain/manifest.json
7. Confirm save
```

## Step-by-Step

### Step 1: Gather Session Summary

Review the session to identify:

**Changes:** What was done
- Files created/edited
- Tasks completed
- Progress made

**Decisions:** Choices that were made
- What was decided
- Why (rationale)
- What was rejected

**Next:** What's coming
- Immediate next steps
- Blockers identified
- Follow-ups needed

### Step 2: Draft Changelog Entry

Create a changelog entry following the format:

```markdown
## 2026-01-23 — Session Summary
**Session:** [session-id]

### Changes
- Completed landing page design
- Fixed payment webhook bug
- Updated documentation

### Decisions
- **Pricing model:** Chose $97/mo. Rejected $47 (too cheap, wrong positioning) and $197 (barrier too high).

### Next
- Launch by Friday
- Follow up with beta users
- Create demo video

---
```

### Step 3: Confirm with User

Show the draft and confirm:

```
▸ saving to ventures/acme/_brain/changelog.md

## 2026-01-23 — Session Summary

### Changes
- Completed landing page design
- Fixed payment webhook bug

### Decisions
- **Pricing model:** Chose $97/mo based on competitor analysis.

### Next
- Launch by Friday

─────────────────────────────────────────────────────────────────────────
[1] Save as-is
[2] Edit before saving
[3] Cancel

Confirm?
```

### Step 4: Write to Files

After confirmation:

1. **Append to changelog.md:**
   - Prepend new entry (most recent first)
   - Include session ID

2. **Update status.md if phase changed:**
   - Only if explicitly discussed
   - Don't change phase without reason

3. **Update manifest.json:**
   - Update `session_id`
   - Update `modified` dates
   - Add/update file summaries

4. **Log to commit-log.jsonl:**
   ```json
   {
     "ts": "2026-01-23T15:30:00Z",
     "type": "CHANGELOG",
     "content": "Session wrap-up: landing page, webhook fix",
     "domain": "ventures/acme",
     "file": "_brain/changelog.md",
     "session_id": "abc123"
   }
   ```

### Step 5: Confirm Success

```
✓ Saved to ventures/acme/_brain/changelog.md
✓ Updated manifest.json
✓ Logged to commit-log.jsonl

Session complete. Pick up anytime with /alive:do.
```

## Zero-Context Standard

Before saving, verify the entry passes the zero-context test:

> "If I came to this project with no memory, would this changelog entry tell me what happened and why?"

**Check:**
- Decisions include rationale (not just "decided X")
- Changes are specific (not just "worked on stuff")
- Next steps are actionable (not just "continue")

If the entry is too vague, prompt for more detail.

## Multi-Domain Sessions

If a session touched multiple subdomains:

1. Identify which changes belong to which subdomain
2. Write separate changelog entries for each
3. Cross-reference if needed

```
This session touched:
[1] ventures/acme — landing page work
[2] ventures/beta — quick bug fix

Save to both?
```

## Edge Cases

**No subdomain loaded:**
```
[?] No active subdomain context.

What did you work on?
[1] ventures/acme
[2] ventures/beta
[3] Other (specify)
```

**Nothing to save:**
```
No changes detected this session.

Still want to log a checkpoint?
[1] Yes, log anyway
[2] No, cancel
```

**Session includes infrastructure work:**
Write to `.claude/state/changelog.md` for system-level changes:
- Hook updates
- Rule changes
- Plugin modifications

## BRB Mode

For quick save when stepping away:

```
User: "brb"

▸ quick save

✓ Checkpoint saved to ventures/acme/_brain/changelog.md
  └─ "Work in progress: landing page, webhook"

Resume anytime with /alive:do.
```

## Related Skills

- `/alive:do` — Start a work session
- `/alive:capture` — Quick context grab (not full session save)
