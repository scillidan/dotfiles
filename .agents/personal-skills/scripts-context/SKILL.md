---
name: scripts-context
description: Use when working with POSIX sh batch-processing scripts in ~/scripts/context/. Not for Python helpers or translation tools.
---

# Shell SendTo Conventions

Last updated: 2026-07-07
Projects: ~/scripts/context/ (30+ .sh scripts)

## Rules

- **Shebang:** `#!/bin/sh`
- **Error tracking:** `error=0` → set to 1 on failure → `exit $error` at end. Always `continue` after error.
- **Pause logic:** Info scripts (print results to user) → always pause before exit so user can read output. Transform scripts (convert/modify files) → pause only on error (`if [ $error -ne 0 ]; then echo "..."; read; fi`).
- **File replacement:** temp file → validate `[ -s ]` → `mv` with rollback.
- **No-args check:** `if [ $# -eq 0 ]; then ...; echo "Press Enter to exit..."; read; exit 1; fi`. Info scripts always pause; transform scripts may skip pause if they auto-close anyway.
- **Python helpers:** When a task needs Python, put logic in `lib/<name>.py` (with PEP 723 `# /// script` header for dependencies) and wrap it in a thin `<name>.sh` that calls `python "$script_dir/lib/<name>.py" "$file"`. The .sh follows all shell conventions (error tracking, pause, no-args check); the .py handles the actual work.
- **Clipboard:** `clip.exe` (Windows) → `xclip` → `xsel`. Always `echo -n`.
- **Prompts:** `printf` (no trailing newline), default via `${var:-default}`.

## Key Decisions

- Process all files even if one fails — don't abort early.
- `2>/dev/null` on ffmpeg/magick calls, explicit error messages instead.

## Known Deviations

(None — all previously identified issues have been fixed.)
