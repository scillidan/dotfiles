---
name: ahk
description: Use when working with AutoHotkey v1 scripts, .ahk files, or AHK projects.
---

# AHK v1 Conventions

Last updated: 2026-06-30
Projects: AHK-KeyboardAutoSwitchBack, AHK-KeyboardSwitch, AHK-GoldenDictAutoSearch, AHK-GoldenDictSearchInGroup, AHK-ScreenOCR

## Rules

- **Single-file.** No `lib/` or `src/`. One `.ahk` + one `.ini`.
- **Header:** `scriptDir`/`iniPath`/`trayIcon` first, validate iniPath with `MsgBox 0x10` + `ExitApp`. No `#NoEnv`/`SendMode`/`SetWorkingDir`.
- **Naming:** camelCase vars, PascalCase functions, `is`/`has` prefix for bools, UPPER_SNAKE for globals.
- **INI:** read with defaults, `__MISSING__` sentinel for optional keys, write-back on toggle.
- **Tray:** `NoStandard` → `DeleteAll` → project items → Startup toggle → Exit. `>` prefix marks active in tray tip.
- **Build:** justfile with `dist` (Ahk2Exe) + `clean`. Releases: windows-latest, 7z (exe+ini+icon.ico+LICENSE), sha256 on zip.
- **Scoop:** `persist` on `.ini`. `.lnk` in Startup (AHK side) + registry Run key (Scoop side) coexist.
- **README:** icon div, one-liner, `Authors: <AI>🧙‍♂️, scillidan🤡`, Usage section. MIT.

## Key Decisions

- **PostMessage 0x50** over `Send` for layout switching — no focus race.
- **DllCall("GetKeyboardLayout") & 0xFFFF** for language ID, not full HKL.
- **CLI subprocess** over COM/DDE for external tools. Config in INI.
- **Clipboard:** `ClipboardAll` save → clear → `Send ^c` → `ClipWait` → process → restore. Trim empty/oversized.
- **Tooltip:** center in active window (`WinGetPos`), auto-dismiss 1500ms.
- **Double-click:** 300ms threshold via `A_TickCount`.

## Known Deviations

(None — all previously identified issues have been fixed.)
