# Anti-Patterns

9 rules. Don't break them.

---

## 1. No Orphan Files

Every file belongs in a folder with a README or `_brain/`. If you create a file, it lives inside a structure — never floating at root or in an unnamed directory.

## 2. No Work in 03_Inputs/

`03_Inputs/` is a buffer. Content arrives, gets triaged, gets routed OUT. Never create files, extract content, or do work inside `03_Inputs/`. Route to the correct project first.

## 3. Always Archive, Never Delete

Move to `01_Archive/` mirroring the original path. No exceptions.

```
# Wrong
rm -rf 04_Ventures/old-project/

# Right
mv 04_Ventures/old-project/ 01_Archive/04_Ventures/old-project/
```

## 4. Manifest After Create

Every new file gets a manifest entry immediately. No "I'll update the manifest later." If you created the file, update `_brain/manifest.json` in the same operation.

## 5. Handoffs Go to _working/sessions/

Pattern: `handoff-{session-id}-{date}.md`

Never put handoffs in `_brain/`, root, or random folders.

## 6. One Spec, Many References

Shared specs live in `rules/conventions.md`. Skills reference the spec — they don't duplicate it. If you find the same pattern described in 4 skills, extract it to conventions and point to it.

## 7. Don't Rename User Files

When processing external content (emails, transcripts, screenshots), keep the original in `raw/`. Create a summary `.md` alongside it. Never rename or modify the original file.

## 8. Working Files Have Context in Name

Pattern: `[project]_[context]_[name].ext`

Anyone reading the filename should know where it belongs without opening it.

## 9. Update Status on Phase Change

Don't leave "Starting" when you're "Building." Don't leave "Building" when you've launched. `_brain/status.md` reflects reality, not history.

