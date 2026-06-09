---
name: ahk
description: Use ONLY when creating or modifying AutoHotkey v1 projects. Provides project scaffolding, evolved coding conventions, tray menu boilerplate, INI handling patterns, build pipeline, and Scoop distribution.
---

# AHK v1 Personal Conventions

## Project Scaffolding

```
AHK-ProjectName/
├── .github/workflows/releases.yml
├── assets/
│   ├── icon.ico
│   └── icon.png
├── .justfile
├── ProjectName.ahk
├── ProjectName.ini
├── LICENSE
└── README.md
```

- Single-file scripts. No `lib/` or `src/`.
- `assets/` always has both `.ico` and `.png`.
- No `.gitignore`.

### README

```markdown
<div align="center">
  <img src="assets/icon.png" alt="icon" width="32" />
</div>

# Project Name

One-line description.

Authors: <AI-Name>🧙‍♂️, scillidan🤡.

Icon source (if applicable).

## Usage
1. Step one
2. Step two
```

- Use concrete AI name (e.g. `GLM-5🧙‍♂️`), never generic `AI🧙‍♂️`.
- Human always `scillidan🤡`.
- MIT, Copyright (c) 2026 scillidan.

## Evolved Style Decisions

### Minimal Header

Early projects carried full boilerplate (`#NoEnv`, `#Persistent`, `SendMode Input`, `SetWorkingDir`). Newer projects dropped all of them. Current convention:

```autohotkey
scriptDir := A_ScriptDir
iniPath := scriptDir . "\ProjectName.ini"
trayIcon := scriptDir . "\assets\icon.ico"

if (!FileExist(iniPath)) {
    MsgBox, 0x10, Error, Configuration file not found:`n%iniPath%
    ExitApp
}
```

- Start with path variables, nothing else.
- Validate iniPath at startup. Fail loud with `0x10` icon + `ExitApp`.
- `#Persistent` only when timers need it, placed inline right before `SetTimer`.
- `#SingleInstance, Force` only when hotkeys exist and relaunch is possible.

### INI Handling

Always read with defaults. For optional keys, use `__MISSING__` sentinel:

```autohotkey
IniRead, key, %iniPath%, Section, OptionalKey, __MISSING__
if (key != "__MISSING__" && key != "") {
    ; use key
}
```

Write-back immediately on toggle changes:

```autohotkey
IniWrite, %newValue%, %iniPath%, Section, Key
```

### Startup Toggle

```autohotkey
shortcutPath := A_StartMenu . "\Programs\Startup" . "\Display Name.lnk"
isStartup := FileExist(shortcutPath)
```

### Tray Menu (copy-paste boilerplate)

Fixed structure — project-specific items first, then standard items:

```
[Project-specific toggles/actions]
Start with Windows    (checked if active)
Suspend Hotkeys
Pause Script
Exit
```

Full implementation:

```autohotkey
Menu, Tray, NoStandard
Menu, Tray, DeleteAll

; ← Insert project-specific items here

if (isStartup) {
    Menu, Tray, Add, Start with Windows, ToggleStartup
    Menu, Tray, Check, Start with Windows
} else {
    Menu, Tray, Add, Start with Windows, ToggleStartup
}
Menu, Tray, Add, Suspend Hotkeys, SuspendHotkeys
Menu, Tray, Add, Pause Script, PauseScript
Menu, Tray, Add, Exit, ExitScript
Menu, Tray, Tip, %trayTipText%
if (FileExist(trayIcon))
    Menu, Tray, Icon, %trayIcon%
return

ToggleStartup:
    global shortcutPath
    if (FileExist(shortcutPath)) {
        FileDelete, %shortcutPath%
        if !ErrorLevel
            Menu, Tray, Uncheck, Start with Windows
    } else {
        FileCreateShortcut, %A_ScriptFullPath%, %shortcutPath%, %A_ScriptDir%
        if !ErrorLevel
            Menu, Tray, Check, Start with Windows
    }
return

SuspendHotkeys:
    Suspend, Toggle
    if (A_IsSuspended)
        Menu, Tray, Check, Suspend Hotkeys
    else
        Menu, Tray, Uncheck, Suspend Hotkeys
return

PauseScript:
    Pause, Toggle
    if (A_IsPaused)
        Menu, Tray, Check, Pause Script
    else
        Menu, Tray, Uncheck, Pause Script
return

ExitScript:
    ExitApp
return
```

### Tray Tip Convention

- Use `>` prefix to mark active item.
- Update on state change via `SetTimer, UpdateTrayTip, -N`.

```autohotkey
tip := "Project Name"
tip .= "`n> " . currentItem
tip .= "`n  " . otherItem
Menu, Tray, Tip, %tip%
```

## Integration Patterns

### External Tool via CLI

Prefer CLI subprocess over COM/DDE. Store executable name and parameters in INI. Build `Run` command from config values at runtime.

Example — GoldenDict integration (2 projects use this):
- INI: `[GoldenDict] Executable=goldendict`, `DefaultWindowMode=popup`, `DefaultGroupName=default`
- Window mode → different CLI flag (`--popup-group-name` vs `--group-name`)
- Primary use case: dictionary lookup on selection/double-click

### Keyboard Layout Switching

Prefer `PostMessage 0x50` over `Send` for layout switching — avoids focus race conditions. Use `DllCall("GetKeyboardLayout")` with `& 0xFFFF` to extract language ID rather than comparing full HKL values.

Display name: read from `HKLM\...\Keyboard Layouts\<KLID>\Layout Text`, fall back to raw KLID.

### Clipboard

Save `ClipboardAll` → clear → `Send ^c` → `ClipWait` → process → restore. Always `Trim()` and skip empty/oversized results.

### Notification Tooltip

Center in active window via `WinGetPos`, not screen center. Auto-dismiss with `SetTimer, RemoveToolTip, -1500`.

### Double-Click Detection

Threshold 300ms, track via `A_TickCount` delta on `~LButton Up`.

## Naming

| Type | Style | Example |
|------|-------|---------|
| Project dir | `AHK-` + PascalCase | `AHK-GoldenDictAutoSearch` |
| Main script | PascalCase.ahk | `GoldenDictAutoSearch.ahk` |
| Variables | camelCase | `iniPath`, `trayIcon` |
| Booleans | is/has prefix | `isStartup` |
| Functions | PascalCase verb | `ToggleBind()`, `GetLayout()` |
| Global constants | UPPER_SNAKE | `GD_Executable` |
| Git commits | Conventional | `feat:`, `fix:`, `ci:`, `doc:`, `refactor:` |

## Build & Release

### Justfile

```justfile
set shell := ["pwsh", "-NoLogo", "-Command"]

dist:
	Ahk2Exe /in "ProjectName.ahk" /icon "assets/icon.ico" /out "ProjectName.exe"

clean:
	rm ProjectName.exe
```

### Releases.yml

```yaml
name: Create release

on:
  push:
    tags:
      - "*"
  workflow_dispatch:
    inputs:
      version:
        description: 'Release version (e.g., v1.0.0)'
        required: true
        type: string

permissions:
  contents: write

jobs:
  build:
    runs-on: windows-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v6

      - name: Install 7zip
        run: choco install 7zip.install -y

      - name: Install AutoHotkey v1
        run: |
          choco install autohotkey_l.install -y
          echo "C:\Program Files\AutoHotkey\Compiler" >> $GITHUB_PATH

      - name: Compile AHK to EXE
        run: |
          & "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" `
            /in "ProjectName.ahk" `
            /icon "assets/icon.ico" `
            /out "ProjectName.exe"

      - name: ZIP
        run: 7z a -tzip ProjectName.zip ProjectName.exe ProjectName.ini assets/icon.ico LICENSE

      - name: Generate SHA256
        run: sha256sum ProjectName.zip > ProjectName.zip.sha256

      - name: Release
        uses: softprops/action-gh-release@v3
        with:
          tag_name: ${{ github.event_name == 'workflow_dispatch' && inputs.version || github.ref_name }}
          name: ${{ github.event_name == 'workflow_dispatch' && inputs.version || github.ref_name }}
          files: |
            ProjectName.zip
```

- SHA256 file: `.zip.sha256` (hashes the zip, not the exe)
- ZIP: `.exe` + `.ini` + `assets/icon.ico` + `LICENSE` (drop what doesn't exist)
- `generate_release_notes: true` optional

## Scoop Distribution

Published to `scoop-pile`. Manifest:

```json
{
    "version": "0.0.1",
    "description": "One-line description",
    "homepage": "https://github.com/scillidan/AHK-ProjectName",
    "license": "MIT",
    "url": "https://github.com/scillidan/AHK-ProjectName/releases/download/$version/ProjectName.zip",
    "hash": "",
    "shortcuts": [["ProjectName.exe", "Project Name"]],
    "persist": "ProjectName.ini",
    "checkver": "github",
    "autoupdate": {
        "url": "https://github.com/scillidan/AHK-ProjectName/releases/download/$version/ProjectName.zip"
    },
    "post_install": [
        "if (!(Test-Path \"$dir\\startup.reg\")) {",
        "    $content = @\"",
        "Windows Registry Editor Version 5.00",
        "",
        "[HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Run]",
        "\\\"ProjectName\\\"=\\\"$dir\\\\ProjectName.exe\\\"",
        "\"@",
        "    Set-Content -Path \"$dir\\startup.reg\" -Value $content -Encoding ASCII",
        "}",
        "$regFile = Get-Content \"$dir\\startup.reg\" -Raw",
        "$regFile = $regFile -replace '\\$dir', \"$dir\".Replace('\\', '\\\\')",
        "Set-Content -Path \"$dir\\startup.reg\" -Value $regFile -Encoding ASCII"
    ],
    "post_uninstall": [
        "Remove-ItemProperty -Path 'HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Run' -Name 'ProjectName' -ErrorAction SilentlyContinue"
    ]
}
```

- `persist` for `.ini` — survives updates.
- Two startup mechanisms coexist: `.lnk` in Startup folder (AHK side) vs registry Run key (Scoop side).
