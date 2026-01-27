# Archive Domain Template

**Domain:** archive/
**Purpose:** Completed work, preserved forever

---

## Structure

```
archive/
├── ventures/         # Mirrors ventures/
│   └── [name]/       # Archived venture (full structure)
├── experiments/      # Mirrors experiments/
│   └── [name]/       # Archived experiment
├── life/             # Mirrors life/
│   └── [area]/       # Archived life area
└── inbox/            # Processed inbox items
    └── [file]        # Ephemeral items worth keeping
```

---

## Archive Principles

1. **Preserve paths** — Archive mirrors active structure exactly
2. **Nothing is deleted** — Archive is permanent storage
3. **Searchable** — Content can be found via `/alive:recall`
4. **Reversible** — Can restore if needed

---

## Path Preservation

When archiving, the full path is preserved:

```
Active:   ventures/acme/clients/globex/
Archived: archive/ventures/acme/clients/globex/
```

This makes restoration straightforward and keeps context intact.

---

## What Gets Archived

| Content | When to Archive |
|---------|-----------------|
| Venture | Project complete or abandoned |
| Experiment | Graduated to venture or abandoned |
| Life area | No longer relevant |
| Client project | Work complete |
| Area | Contents obsolete |
| Inbox item | Processed, ephemeral but worth keeping |

---

## Using /alive:archive

Archive content with the archive skill:

```
/alive:archive [path]
```

This will:
1. Verify the content is ready (no pending tasks)
2. Create the archive path
3. Move content
4. Update manifests
5. Confirm archive

---

## Archive Metadata

Archived content includes metadata:

```markdown
<!-- Archived: 2026-01-23 from ventures/acme/clients/globex/ -->
```

This helps with context when reviewing archived items.

---

## Restoring from Archive

Content can be restored:

```
User: "Restore ventures/acme/clients/globex"

ALIVE: Found in archive. Restore to original location?
```

Restoration moves content back to active location and updates manifests.

---

## Archive vs Delete

| Action | When to Use |
|--------|-------------|
| **Archive** | Project complete, client done, experiment concluded |
| **Delete** | Never (use archive instead) |

**Exception:** Temporary files in `_working/` can be deleted after promotion.

---

## Searching Archives

Use `/alive:recall` to find archived content:

```
User: "Find the Globex contract"

ALIVE: Found: archive/ventures/acme/clients/globex/contract.pdf
       Archived: 2026-01-23

       [1] View content
       [2] Restore from archive
```

---

## Best Practices

### Archive Complete Work

Only archive when work is truly done:
- No pending tasks
- No active dependencies
- Clear end state

### Preserve Insights First

Before archiving experiments:
- Extract valuable insights
- Copy to other subdomains if relevant
- Document why it ended

### Regular Cleanup

Use `/alive:sweep` to identify archive candidates:
- Stale subdomains (not updated >4 weeks)
- Completed projects
- Abandoned experiments

---

## Notes

- Archive preserves, never destroys
- Archived content remains searchable
- Use archive liberally to keep active domains clean
- Restoration is always possible
