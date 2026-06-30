---
name: scripts-context
description: Use when working with POSIX sh batch-processing scripts in ~/scripts/context/. Not for Python helpers or translation tools.
---

# Shell SendTo Conventions

Last updated: 2026-06-30
Projects: ~/scripts/context/ (30 .sh scripts)

## Rules

- **Shebang:** `#!/bin/sh`
- **Error tracking:** `error=0` → set to 1 on failure → `exit $error` at end. Always `continue` after error.
- **Pause on error only:** `if [ $error -ne 0 ]; then echo "..."; read; fi`. Never unconditional.
- **File replacement:** temp file → validate `[ -s ]` → `mv` with rollback.
- **No-args check:** `if [ $# -eq 0 ]; then ...; exit 1; fi`
- **Clipboard:** `clip.exe` (Windows) → `xclip` → `xsel`. Always `echo -n`.
- **Prompts:** `printf` (no trailing newline), default via `${var:-default}`.

## Key Decisions

- Process all files even if one fails — don't abort early.
- `2>/dev/null` on ffmpeg/magick calls, explicit error messages instead.

## Known Deviations

(None — all previously identified issues have been fixed.)
