---
name: shell-sendto
description: Use ONLY when creating or modifying SendTo shell scripts — POSIX sh scripts that batch-process selected files via Windows Explorer's right-click Send To menu or Linux Thunar custom actions. Does NOT apply to lib/ Python helpers or translation tools.
---

## Script Template

```sh
#!/bin/sh

# <One-line description of what this script does>
#
# Usage:
#   Windows:
#     Create a .lnk shortcut to this script in the SendTo folder, then:
#     Select files > Right-click > Send To > <script_name>
#
#   Linux (Thunar):
#     Edit > Configure custom actions > Add action with command: /path/to/script.sh %F
#
#   Command line:
#     ./script.sh <file1> <file2> ...

error=0

for file in "$@"; do
    # ... process file ...
    # on failure: error=1; continue
done

if [ $error -ne 0 ]; then
    echo "Press Enter to exit..."
    read
fi

exit $error
```

Key decisions:
- Track success with `error=0`, set to 1 on any failure.
- **Pause on error only** — `echo "Press Enter to exit..."; read` inside the final `if`, never unconditionally. This lets the window close instantly on success but keeps it open when something went wrong.
- Exit with `$error` so callers can detect failure.
- Some scripts exit early if no args: `if [ $# -eq 0 ]; then echo "Error: No files selected"; ...; exit 1; fi`

## Error Handling Pattern

```sh
if ! tool "$file"; then
    echo "Error: Failed to <verb> $file"
    error=1
    continue
fi
```

- Always `continue` after setting error — process remaining files rather than aborting.
- For file-replacement operations (convert then delete original), use a temp file + safety check:

```sh
temp="$dir/${name}_tmp.mp3"
if ! ffmpeg -y -i "$file" ... "$temp" 2>/dev/null; then
    echo "Error: FFmpeg failed for $file"
    rm -f "$temp"
    error=1
    continue
fi
if [ ! -s "$temp" ]; then
    echo "Error: Output file is empty"
    rm -f "$temp"
    error=1
    continue
fi
mv "$file" "$backup" && mv "$temp" "$file" || { mv "$backup" "$file"; error=1; }
```

## Common Patterns

### Interactive Mode Selection

Some scripts offer a mode choice before the loop:

```sh
echo "1. Just optimize"
echo "2. Resize to 1080px height if needed"
printf "Select (Default 1): "
read mode
mode=${mode:-1}
```

- Use `printf` for prompts without trailing newline.
- Default via `${mode:-1}`.

### Clipboard (Cross-Platform)

```sh
if command -v clip.exe >/dev/null 2>&1; then
    echo -n "$text" | clip.exe
elif command -v xclip >/dev/null 2>&1; then
    echo -n "$text" | xclip -selection clipboard
elif command -v xsel >/dev/null 2>&1; then
    echo -n "$text" | xsel --clipboard --input
fi
```

- `clip.exe` for Windows (Git Bash / MSYS2), `xclip`/`xsel` for Linux.
- Always `echo -n` to avoid trailing newline in clipboard.
