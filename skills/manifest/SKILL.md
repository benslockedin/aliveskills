---
user-invocable: false
description: Internal skill for maintaining entity manifests. Called by save, new, archive, and digest to ensure manifest consistency. Not user-invocable.
---

# alive:manifest

Internal skill for updating `_brain/manifest.json`. Called by other skills, not directly by users.

## The Manifest Rule

**The manifest is a complete semantic sitemap.**

- Every folder → listed in `folders`
- Every area → has entry in `areas` with description AND files list
- Every file in an area → listed with one-line description
- Every WIP file → listed in `working_files` with description
- Every important file → listed in `key_files` with description
- Every non-`_brain` file → has `session_id` of session that last modified it

**No file exists without a manifest entry. No entry exists without a description.**

## When Called

| Caller | Trigger |
|--------|---------|
| `/alive:save` | Session end — update working_files, session timestamps |
| `/alive:new` | Entity/area created — add to folders/areas |
| `/alive:archive` | Item archived — remove from manifest |
| `/alive:digest` | Files routed — add to areas |
| `/alive:input` | Content added — add to working_files or areas |

## Manifest Format

```json
{
  "name": "entity-name",
  "description": "One sentence describing this entity",
  "updated": "2026-01-30",
  "session_id": "241fb8e4",
  "folders": ["_brain", "_working", "docs", "clients"],
  "areas": [
    {
      "path": "docs/",
      "description": "Reference documentation",
      "files": [
        {
          "path": "README.md",
          "description": "Index of documentation",
          "session_id": "abc123"
        },
        {
          "path": "architecture.md",
          "description": "System architecture overview",
          "session_id": "xyz789"
        }
      ]
    },
    {
      "path": "clients/",
      "description": "Client projects",
      "has_entities": true,
      "entities": ["acme", "bigco"]
    }
  ],
  "working_files": [
    {
      "path": "_working/draft-v0.md",
      "description": "Landing page draft in progress",
      "session_id": "abc123"
    }
  ],
  "key_files": [
    {
      "path": "CLAUDE.md",
      "description": "Entity identity and navigation"
    }
  ]
}
```

## Field Definitions

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Entity name (lowercase, hyphens) |
| `description` | Yes | One sentence describing entity purpose |
| `updated` | Yes | Date of last update (YYYY-MM-DD) |
| `session_id` | Yes | ID of session that last updated manifest |
| `folders` | Yes | Array of top-level folders |
| `areas` | No | Array of organizational areas with contents |
| `working_files` | No | Array of WIP files in `_working/` |
| `key_files` | No | Array of important reference files |

## Area Entry Format

```json
{
  "path": "docs/",
  "description": "What this area contains",
  "files": [
    {"path": "file.md", "description": "What this file is", "session_id": "xxx"}
  ]
}
```

**If area contains nested entities:**
```json
{
  "path": "clients/",
  "description": "Client projects",
  "has_entities": true,
  "entities": ["acme", "bigco"]
}
```

## Update Operations

### Adding a File

1. Identify which area the file belongs to
2. Add file entry with description and session_id
3. Update manifest `updated` date and `session_id`

```json
// Before
"areas": [{"path": "docs/", "files": [...]}]

// After adding docs/new-guide.md
"areas": [{
  "path": "docs/",
  "files": [
    ...,
    {"path": "new-guide.md", "description": "Setup guide for new users", "session_id": "current"}
  ]
}]
```

### Adding a Working File

```json
// Add to working_files
"working_files": [
  ...,
  {"path": "_working/proposal-v1.md", "description": "Client proposal draft", "session_id": "current"}
]
```

### Promoting a Working File

When a `_working/` file is finalized:

1. Remove from `working_files`
2. Add to appropriate `areas` or `key_files`
3. Update session_id

### Adding a Folder/Area

```json
// Add folder name
"folders": [..., "new-folder"]

// Add area entry
"areas": [
  ...,
  {"path": "new-folder/", "description": "What this area is for", "files": []}
]
```

### Removing (Archive)

1. Remove file from its area's `files` array
2. Remove folder from `folders` if now empty
3. Remove area from `areas` if empty
4. Update manifest timestamps

## The Closest Entity Rule

**Always update the manifest of the CLOSEST entity to where work happened.**

```
ventures/agency/                    ← Parent entity
├── _brain/manifest.json            ← Update for agency-level work
├── clients/                        ← Area (no manifest)
│   └── acme/                       ← Nested entity
│       └── _brain/manifest.json    ← Update for acme-specific work
```

**How to identify closest entity:**
1. Look at which files were edited
2. Find the nearest parent folder with `_brain/`
3. Update THAT manifest

## Cascade Logic

After updating closest entity, check if parent needs update:

```
Changes to nested entity (acme)?
    ↓
Update acme/_brain/manifest.json
    ↓
Does parent (agency) need to know?
    ├── New entity created? → Add to parent's areas[].entities
    ├── Entity archived? → Remove from parent's areas[].entities
    └── No structural change? → Done (parent doesn't track child files)
```

## Verification After Update

After any manifest update, verify:

- [ ] `updated` date is current
- [ ] `session_id` matches current session
- [ ] Every file in area folders has an entry
- [ ] Every entry has a description (not empty)
- [ ] No orphaned entries (files that don't exist)
- [ ] JSON is valid

## Session ID Tracking

The `session_id` field tracks which session last touched each item:

- **Manifest level:** `session_id` = session that last updated the manifest
- **File level:** `session_id` = session that last modified that specific file

**Only track session_id on non-`_brain` files.** The `_brain/` files are always updated together so don't need individual tracking.

## Common Patterns

### Save Session → Update Manifest

```
1. Get list of files modified this session
2. For each file:
   - Find its area in manifest
   - Update file's session_id
3. Check _working/ for new/changed files
4. Update manifest-level session_id and updated date
```

### New Entity → Update Parent Manifest

```
1. Create new entity with its own manifest
2. Find parent entity
3. Add new entity to parent's areas[].entities array
4. Update parent manifest timestamps
```

### Archive → Clean Manifest

```
1. Remove file/folder from manifest
2. If area is now empty, remove area
3. If folder is now empty, remove from folders
4. Update timestamps
```

## Callers Must Provide

When calling this skill, provide:

- `entity_path`: Path to entity (e.g., `ventures/acme`)
- `operation`: `add_file`, `add_folder`, `add_working`, `promote`, `remove`, `update_timestamps`
- `file_path`: Path to file being added/removed (if applicable)
- `description`: Description for new entries (required for add operations)
- `session_id`: Current session ID
