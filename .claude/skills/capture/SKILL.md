---
name: capture
description: This skill should be used when the user asks to "capture this", "grab that", "note this", "remember this", "save this context", "FYI", "for context", "I learned", "had a call with", "just decided", "quick note", "btw", or wants to capture context from conversation without ending the full session.
---

# alive:capture

Quick context grab. Capture information from conversation and route it to the appropriate state file.

## When to Use

Invoke when the user:
- Shares context that should be preserved
- Mentions a decision, insight, or task
- Says "FYI", "note this", "remember"
- Wants to log something without ending the session

**Different from `/alive:save`:** Capture grabs specific context. Save ends a full session.

## Flow

```
1. Parse the context provided
2. Classify type (decision, insight, task, reference)
3. Determine destination subdomain
4. Suggest destination file
5. Confirm with user
6. Write to file
7. Log to commit-log.jsonl
```

## Context Types

| Type | Destination | Example |
|------|-------------|---------|
| **Decision** | `_brain/changelog.md` | "Decided to use Stripe" |
| **Insight** | `_brain/insights.md` | "Learned that X works better" |
| **Task** | `_brain/tasks.md` | "Need to follow up with John" |
| **Status update** | `_brain/status.md` | "Now in launch phase" |
| **Reference** | `_working/` or area | "Here's the contract" |
| **Person** | `life/people/` | "Met Sarah at conference" |

## Step-by-Step

### Step 1: Parse Context

User says:
```
"FYI we decided to go with Stripe because PayPal fees are too high in AU"
```

Extract:
- **Type:** Decision
- **Content:** Use Stripe over PayPal
- **Rationale:** PayPal fees too high in AU
- **Related to:** Payment processing

### Step 2: Determine Destination

If subdomain is active (from `/alive:do`):
```
Active: ventures/acme
→ Route to ventures/acme/_brain/changelog.md
```

If no active subdomain:
```
This looks like a decision about payments.

Which subdomain?
[1] ventures/acme
[2] ventures/beta
[3] Other
```

### Step 3: Confirm and Write

```
▸ capturing decision

**Decision:** Use Stripe over PayPal
**Rationale:** PayPal fees too high in AU

Route to: ventures/acme/_brain/changelog.md

[1] Confirm
[2] Edit
[3] Different destination
```

### Step 4: Write to File

For decisions, append to changelog:
```markdown
## 2026-01-23 — Decision Captured

### Decisions
- **Payment processor:** Chose Stripe over PayPal. Rationale: PayPal fees too high in AU.

---
```

For insights, append to insights.md:
```markdown
## 2026-01-23 — Insight

**Category:** process
**Learning:** PayPal fees are prohibitively high in AU market
**Evidence:** Checked actual rates, 3% higher than Stripe
**Applies to:** Any AU-based payment processing

---
```

For tasks, add to tasks.md:
```markdown
## To Do
- [ ] Implement Stripe integration @payments
```

### Step 5: Confirm

```
✓ Captured to ventures/acme/_brain/changelog.md

Decision logged with rationale.
```

## Quick Capture Modes

### Inline Capture

```
User: "/capture Had a call with John about the partnership"

▸ capturing

Type: Reference (meeting note)
Person: John (checking life/people/john.md...)
Related: Partnership discussion

Route to: ventures/acme/_brain/changelog.md
Also update: life/people/john.md (last contact)

[1] Confirm
[2] Edit
```

### FYI Mode

Short context that just needs logging:

```
User: "FYI the deadline moved to Friday"

▸ quick capture

✓ Logged to ventures/acme/_brain/changelog.md
  └─ "Deadline moved to Friday"
```

### Person Capture

When context involves a person:

```
User: "Met Sarah at the conference, she's the CEO of TechCo"

▸ capturing person

Check life/people/sarah.md... not found

Create new person file?
[1] Yes, create life/people/sarah.md
[2] No, just log the meeting
```

If creating:
```markdown
# Sarah

**Role:** CEO, TechCo
**Context:** Met at conference
**Met:** 2026-01-23

---

## Notes
- Works in tech/SaaS space
```

## Classification Signals

| Signal | Type | Destination |
|--------|------|-------------|
| "decided", "chose", "going with" | Decision | changelog.md |
| "learned", "realized", "found out" | Insight | insights.md |
| "need to", "should", "follow up" | Task | tasks.md |
| "now in", "phase", "focus" | Status | status.md |
| "met", "talked to", "call with" | Person | life/people/ + changelog |
| "here's", "document", "file" | Reference | _working/ or area |

## Edge Cases

**Ambiguous type:**
```
"John mentioned we should reconsider the pricing"

This could be:
[1] Task — "Reconsider pricing"
[2] Insight — "Pricing concern raised"
[3] Decision context — Log for future decision

Which fits best?
```

**Multiple captures:**
```
"We decided X, learned Y, and need to do Z"

Capturing multiple items:
1. Decision: X → changelog.md
2. Insight: Y → insights.md
3. Task: Z → tasks.md

Confirm all three?
```

**No subdomain context:**
```
[?] No active subdomain.

Where does this belong?
[1] ventures/acme
[2] ventures/beta
[3] life/[area]
[4] inbox/ (triage later)
```

## Commit Log Entry

Every capture logs to `.claude/state/commit-log.jsonl`:

```json
{
  "ts": "2026-01-23T14:30:00Z",
  "type": "DECISION",
  "content": "Use Stripe over PayPal - AU fees",
  "domain": "ventures/acme",
  "file": "_brain/changelog.md",
  "session_id": "abc123"
}
```

## Related Skills

- `/alive:save` — End full session (not quick capture)
- `/alive:digest` — Process inbox items (bulk capture)
- `/alive:do` — Load subdomain context first
