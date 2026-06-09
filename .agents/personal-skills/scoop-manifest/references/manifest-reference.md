# Scoop Manifest Complete Reference

## Table of Contents

1. [All Manifest Properties](#all-manifest-properties)
2. [Script Variables](#script-variables)
3. [checkver Deep Dive](#checkver-deep-dive)
4. [autoupdate Deep Dive](#autoupdate-deep-dive)
5. [Hash Autoupdate Modes](#hash-autoupdate-modes)
6. [Internal Substitutable Variables](#internal-substitutable-variables)
7. [Example Manifests](#example-manifests)

## All Manifest Properties

### Required

| Property | Type | Description |
|---|---|---|
| `version` | string | App version this manifest installs |

### Strongly Recommended

| Property | Type | Description |
|---|---|---|
| `description` | string | One-line description (no app name) |
| `homepage` | string | App homepage URL |
| `license` | string or object | SPDX identifier, or `{"identifier": "...", "url": "..."}` |

### Optional

| Property | Type | Description |
|---|---|---|
| `##` | string or array | Comments (replaces deprecated `_comment`) |
| `architecture` | object | Per-arch overrides: `32bit`, `64bit`, `arm64` |
| `autoupdate` | object | Autoupdate definition |
| `bin` | string or array | Executables to shim onto PATH |
| `checkver` | string or object | Version check definition |
| `depends` | string or array | Runtime deps (auto-installed) |
| `env_add_path` | string or array | Subdirectories to add to PATH |
| `env_set` | object | Env vars to set (`{"KEY": "value"}`) |
| `extract_dir` | string or array | Directory to extract from archive |
| `extract_to` | string or array | Directory to extract contents into |
| `hash` | string or array | File hashes (SHA256 default) |
| `innosetup` | boolean | `true` for InnoSetup installers |
| `installer` | object | Installer instructions |
| `notes` | string or array | Post-install messages |
| `persist` | string or array | Dirs/files to persist across updates |
| `post_install` | string or array | Scripts after install |
| `pre_install` | string or array | Scripts before install |
| `pre_uninstall` | string or array | Scripts before uninstall |
| `post_uninstall` | string or array | Scripts after uninstall |
| `psmodule` | object | `{"name": "ModuleName"}` for PS modules |
| `shortcuts` | array | Start menu shortcuts: `[[exe, name, args, icon]]` |
| `suggest` | object | Optional companion apps |
| `uninstaller` | object | Uninstaller instructions |
| `url` | string or array | Download URL(s). Append `#/filename` to rename |

### Architecture Object Structure

```json
"architecture": {
    "64bit": { "...per-arch overrides..." },
    "32bit": { "...per-arch overrides..." },
    "arm64": { "...per-arch overrides..." }
}
```

Per-arch properties: `bin`, `checkver`, `extract_dir`, `hash`, `installer`, `pre_install`, `post_install`, `shortcuts`, `uninstaller`, `url`.

### installer / uninstaller Object

| Property | Type | Description |
|---|---|---|
| `file` | string | Installer exe (defaults to last downloaded URL for `installer`) |
| `script` | string or array | PowerShell script(s) to run |
| `args` | array | Arguments for `file` |
| `keep` | boolean | Keep installer after running (for future uninstall) |

### License Formats

```json
"license": "MIT"
"license": "MIT|Apache-2.0"
"license": "Freeware"
"license": {
    "identifier": "GPL-3.0-only",
    "url": "https://example.com/LICENSE"
}
```

## Script Variables

### Non-Path Variables

| Variable | Example | Available In |
|---|---|---|
| `$app` | `exampleapp` | All hooks |
| `$architecture` | `64bit` / `32bit` / `arm64` | All hooks |
| `$cmd` | `install` / `update` / `uninstall` | All hooks |
| `$global` | `$true` / `$false` | All hooks |
| `$version` | `1.2.3` | All hooks |
| `$manifest` | PS object | All hooks |
| `$cfg` | PS object | All hooks |

### Path Variables

| Variable | Example |
|---|---|
| `$dir` | `apps\$app\current` (post_install) or `apps\$app\$version` (pre_install) |
| `$persist_dir` | `persist\$app` |
| `$bucketsdir` | `buckets` |
| `$cachedir` | `cache` |
| `$scoopdir` | Base Scoop dir |
| `$globaldir` | `C:\ProgramData\scoop` |
| `$original_dir` | `apps\$app\$version` |
| `$fname` | Last downloaded filename (installer context) |

### The `$dir` Variable Difference

- **`pre_install`**, **`installer.script`**, **`pre_uninstall`**, **`uninstaller.script`**, **`post_uninstall`**: `$dir` → versioned path (`apps\app\1.2.3`)
- **`post_install`**: `$dir` → `current` junction (`apps\app\current`)

### Helper Functions

- `appdir <appname>` — Get path to another Scoop app's directory
- `info "message"` — User-visible info output
- `warn "message"` — Warning output
- `error "message"` — Error output
- `Add-Path -Path "..." -Global:$global` — Add to PATH
- `Remove-Path -Path "..." -Global:$global` — Remove from PATH
- `Set-EnvVar -Name "KEY" -Value "val" -Global:$global` — Set env var
- `Get-EnvVar -Name "KEY" -Global:$global` — Get env var
- `shim "<exe>" $global "<alias>" "<args>"` — Create a shim
- `rm_shim "<name>" $(shimdir $global) $app` — Remove a shim
- `Expand-DarkArchive "<msi_exe>" "<dest>"` — WiX Dark decompiler
- `Expand-MsiArchive "<msi>" "<dest>"` — Extract MSI
- `Invoke-ExternalCommand "<exe>" @("args")` — Run external command with error handling
- `ensure "<dir>"` — Create directory if missing

## checkver Deep Dive

### Properties

| Property | Alias | Type | Description |
|---|---|---|---|
| (root string) | — | regex | Match version on homepage |
| `github` | — | uri | GitHub repo URL (auto-matches release tag) |
| `url` | — | uri | Page to check for version |
| `regex` | `re` | regex | Regex to match version |
| `jsonpath` | `jp` | jsonpath | JSONPath to extract version |
| `xpath` | — | string | XPath to extract version |
| `reverse` | — | boolean | Match last occurrence |
| `replace` | — | string | Transform matched value |
| `useragent` | — | string | Custom User-Agent header |
| `script` | — | string or array | PowerShell for complex logic |

### Simple Patterns

**Homepage regex:**
```json
"checkver": "Version ([\\d.]+)"
```

**Different URL:**
```json
"checkver": {
    "url": "https://www.7-zip.org/download.html",
    "regex": "Download 7-Zip ([\\d.]+)"
}
```

**GitHub shortcut:**
```json
"checkver": {
    "github": "https://github.com/user/repo"
}
```
Matches `/releases/tag/(?:v|V)?([\d.]+)`, pre-releases ignored.

### JSONPath Patterns

**Simple extraction:**
```json
"checkver": {
    "url": "https://api.example.com/releases",
    "jsonpath": "$[0].version"
}
```

**JSONPath with regex filter (Newtonsoft syntax):**
```json
"checkver": {
    "url": "https://dist.nuget.org/index.json",
    "jp": "$..versions[?(@.displayName == 'nuget.exe - recommended latest')].version"
}
```

**JSONPath + Regex combined:**
```json
"checkver": {
    "url": "https://nwjs.io/versions.json",
    "jsonpath": "$.stable",
    "regex": "v([\\d.]+)"
}
```
JSONPath extracts `"v3.7.1"`, then regex strips the `v`.

### Captured Variables from checkver

Named groups: `(?<name>...)` → `$matchName`

Unnamed groups: `(...)` → `$match1`, `$match2`, ...

**Example:**
```json
"checkver": {
    "regex": "/v(?<tag>[\\d.]+)/clink\\.([\\d.]+)\\.(?<commit>[\\w.]+)\\.zip"
}
```
Creates: `$matchTag`, `$match2` (version), `$matchCommit`.

### replace in checkver

When version needs composition from multiple captures:

```json
"checkver": {
    "regex": "ghidra_([\\d.]+)_PUBLIC_(?<date>\\d+)\\.zip",
    "replace": "${1}-${2}"
}
```
Result: `12.1.2-20260605`

### Custom script in checkver

For multi-step or POST-based version checks:

```json
"checkver": {
    "script": [
        "$Body = '<?xml version=\"1.0\"?><request protocol=\"3.0\">...</request>'",
        "$Response = Invoke-RestMethod -Uri 'https://update.googleapis.com/service/update2' -Method Post -Body $Body",
        "$Version = $Response.response.app.updatecheck.manifest.version",
        "Write-Output \"$Version,$Url64,$Url86,$UrlArm\""
    ],
    "regex": "(?<version>[\\d.]+),(?<archx64>[^,]+),(?<archx86>[^,]+),(?<archarm64>[^,]+)"
}
```

## autoupdate Deep Dive

### Structure

All properties except `hash` support `$version` and `$matchX` variables. Properties can be set globally or per-architecture:

```json
"autoupdate": {
    "url": "https://example.com/app-$version.zip",
    "extract_dir": "app-$version",
    "bin": "app.exe",
    "architecture": {
        "64bit": {
            "url": "https://example.com/app-$version-x64.zip",
            "extract_dir": "app-$version-x64"
        }
    }
}
```

### Autoupdateable Properties

`url`, `hash`, `bin`, `extract_dir`, `extract_to`, `env_add_path`, `env_set`, `installer`, `license`, `notes`, `persist`, `post_install`, `psmodule`, `shortcuts`.

### Version Variables Reference

| Variable | Input `3.7.1-rc.1` | Input `1.2.3.4` |
|---|---|---|
| `$version` | `3.7.1-rc.1` | `1.2.3.4` |
| `$underscoreVersion` | `3_7_1-rc_1` | `1_2_3_4` |
| `$dashVersion` | `3-7-1-rc-1` | `1-2-3-4` |
| `$cleanVersion` | `371` | `1234` |
| `$majorVersion` | `3` | `1` |
| `$minorVersion` | `7` | `2` |
| `$patchVersion` | `1` | `3` |
| `$buildVersion` | — | `4` |
| `$matchHead` | `3.7.1` | `1.2.3` |
| `$matchTail` | `-rc.1` | `.4` |
| `$preReleaseVersion` | `rc.1` | — |

## Hash Autoupdate Modes

### Mode: extract (default)

```json
"hash": {
    "url": "$baseurl/SHA256SUMS"
}
```

Built-in regex patterns (no `find` needed):
- `^([a-fA-F0-9]+)$` — hash on its own line
- `([a-fA-F0-9]{32,128})[\x20\t]+.*$basename(?:[\x20\t]+\d+)?` — hash + filename

Custom regex with `find`:
```json
"hash": {
    "url": "$baseurl/hashes.txt",
    "find": "SHA256\\($basename\\)=\\s+([a-fA-F\\d]{64})"
}
```

Hash variables in `find`:
- `$md5` → `([a-fA-F0-9]{32})`
- `$sha1` → `([a-fA-F0-9]{40})`
- `$sha256` → `([a-fA-F0-9]{64})`
- `$sha512` → `([a-fA-F0-9]{128})`
- `$checksum` → `([a-fA-F0-9]{32,128})`
- `$base64` → `([a-zA-Z0-9+\/=]{24,88})`

```json
"hash": {
    "url": "https://example.com/downloads/",
    "find": "$basename[\\S\\s]+?$sha256"
}
```

### Mode: json

```json
"hash": {
    "mode": "json",
    "jp": "$.files.['$basename'].sha256",
    "url": "$baseurl/hashes.json"
}
```

With filter expression (the `$basename` is replaced before evaluation):
```json
"hash": {
    "mode": "json",
    "jsonpath": "$..[?(@.path == '$basename')].sha256",
    "url": "https://example.com/releases.json"
}
```

### Mode: xpath

```json
"hash": {
    "url": "https://example.com/update.xml",
    "xpath": "/chrome/stable64[version=\"$version\"]/sha256"
}
```

### Mode: rdf

```json
"hash": {
    "mode": "rdf",
    "url": "https://example.com/digest.rdf"
}
```

### Mode: metalink

```json
"hash": {
    "mode": "metalink"
}
```

### Mode: fosshub / sourceforge (automatic)

When `autoupdate.url` matches FossHub or SourceForge patterns, hash mode is set automatically — no `hash` property needed:

**FossHub** URL pattern: `^(?:.*fosshub.com\/).*(?:\/|\?dwl=)(?<filename>.*)$`
**SourceForge** URL pattern: `(?:downloads\.)?sourceforge.net\/projects?\/(?<project>[^\/]+)\/(?:files\/)?(?<file>.*)`

### Mode: download (fallback)

Downloads the file and hashes locally. Used automatically when no `hash` property is defined or when other modes fail.

### Per-Architecture Hash

```json
"autoupdate": {
    "architecture": {
        "64bit": {
            "url": "https://example.com/app-$version-x64.zip",
            "hash": {
                "url": "https://api.example.com/$version/x64",
                "jsonpath": "$.sha256"
            }
        },
        "arm64": {
            "url": "https://example.com/app-$version-arm64.zip",
            "hash": {
                "url": "https://api.example.com/$version/arm64",
                "jsonpath": "$.sha256"
            }
        }
    }
}
```

## Internal Substitutable Variables

### Captured Variables

In `checkver.replace`:
- `${1}`, `${2}`, `${3}`... — unnamed groups
- `${name1}`, `${Name2}`... — named groups

In `autoupdate`:
- `$match1`, `$match2`, `$match3`... — unnamed groups
- `$matchName1`, `$matchName2`... — named groups (note: first char uppercase after `$match`)

### URL Variables

| Variable | Example | Derived From |
|---|---|---|
| `$url` | `http://example.com/path/file.exe` | autoupdate URL without fragment |
| `$baseurl` | `http://example.com/path` | autoupdate URL without filename/fragment |
| `$basename` | `file.exe` | filename from autoupdate URL (ignores `#/...` fragment) |

## Example Manifests

### Simple GitHub App

```json
{
    "version": "1.2.3",
    "description": "A simple tool.",
    "homepage": "https://github.com/user/repo",
    "license": "MIT",
    "architecture": {
        "64bit": {
            "url": "https://github.com/user/repo/releases/download/v1.2.3/tool-1.2.3-x64.zip",
            "hash": "sha256:abcdef..."
        }
    },
    "bin": "tool.exe",
    "checkver": {
        "github": "https://github.com/user/repo"
    },
    "autoupdate": {
        "architecture": {
            "64bit": {
                "url": "https://github.com/user/repo/releases/download/v$version/tool-$version-x64.zip"
            }
        },
        "hash": {
            "url": "$baseurl/tool-$version-x64.zip.sha256"
        }
    }
}
```

### App with JSON API Version Check + JSON Hash

```json
{
    "version": "1.123.0",
    "description": "Visual Studio Code",
    "homepage": "https://code.visualstudio.com/",
    "license": "Freeware",
    "architecture": {
        "64bit": {
            "url": "https://update.code.visualstudio.com/1.123.0/win32-x64-archive/stable#/dl.7z",
            "hash": "sha256:abcdef..."
        },
        "arm64": {
            "url": "https://update.code.visualstudio.com/1.123.0/win32-arm64-archive/stable#/dl.7z",
            "hash": "sha256:123456..."
        }
    },
    "bin": "bin\\code.cmd",
    "shortcuts": [["code.exe", "Visual Studio Code"]],
    "post_install": [
        "$dirpath = $dir.Replace('\\', '\\\\')",
        "$exepath = \"$dir\\Code.exe\".Replace('\\', '\\\\')",
        "'install-context', 'uninstall-context' | ForEach-Object {",
        "    $content = Get-Content \"$bucketsdir\\extras\\scripts\\vscode\\$_.reg\"",
        "    $content = $content.Replace('$codedir', $dirpath).Replace('$code', $exepath)",
        "    if ($global) { $content = $content.Replace('HKEY_CURRENT_USER', 'HKEY_LOCAL_MACHINE') }",
        "    $content | Set-Content \"$dir\\$_.reg\"",
        "}"
    ],
    "persist": "data",
    "checkver": {
        "url": "https://update.code.visualstudio.com/api/update/win32-x64-archive/stable/latest",
        "jsonpath": "$.name"
    },
    "autoupdate": {
        "architecture": {
            "64bit": {
                "url": "https://update.code.visualstudio.com/$version/win32-x64-archive/stable#/dl.7z",
                "hash": {
                    "url": "https://update.code.visualstudio.com/api/versions/$version/win32-x64-archive/stable",
                    "jsonpath": "$.sha256hash"
                }
            },
            "arm64": {
                "url": "https://update.code.visualstudio.com/$version/win32-arm64-archive/stable#/dl.7z",
                "hash": {
                    "url": "https://update.code.visualstudio.com/api/versions/$version/win32-arm64-archive/stable",
                    "jsonpath": "$.sha256hash"
                }
            }
        }
    }
}
```

### App with Named Captures + replace in checkver

```json
{
    "version": "12.1.2-20260605",
    "description": "Software reverse engineering framework",
    "homepage": "https://ghidra-sre.org",
    "license": "Apache-2.0",
    "extract_dir": "ghidra_12.1.2_PUBLIC",
    "architecture": {
        "64bit": {
            "url": "https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_12.1.2_build/ghidra_12.1.2_PUBLIC_20260605.zip",
            "hash": "sha256:abcdef..."
        }
    },
    "bin": "ghidraRun.bat",
    "checkver": {
        "github": "https://api.github.com/repos/NationalSecurityAgency/ghidra/releases/latest",
        "jsonpath": "$.assets[*].browser_download_url",
        "regex": "ghidra_([\\d.]+)_PUBLIC_(?<releasedate>\\d+)\\.zip",
        "replace": "${1}-${2}"
    },
    "autoupdate": {
        "architecture": {
            "64bit": {
                "url": "https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_$matchHead_build/ghidra_$matchHead_PUBLIC_$matchReleasedate.zip"
            }
        },
        "hash": {
            "url": "https://github.com/NationalSecurityAgency/ghidra/releases/tag/Ghidra_$matchHead_build",
            "regex": "<code>$sha256</code>"
        },
        "extract_dir": "ghidra_$matchHead_PUBLIC"
    }
}
```

### App with checkver.script (Custom PowerShell)

```json
{
    "checkver": {
        "script": [
            "$ArchParams = @{'x64'='x64-stable'; 'x86'='x86-stable'; 'arm64'='arm64-stable'}",
            "$BodyTemplate = '<?xml version=\"1.0\"?><request protocol=\"3.0\"><os platform=\"win\" arch=\"{0}\"/><app appid=\"{1}\" ap=\"{2}\"><updatecheck/></app></request>'",
            "$ArchURLs = @{}",
            "$Version = $null",
            "forEach ($Arch in $ArchParams.Keys) {",
            "    $Body = $BodyTemplate -f $Arch, '{APP_ID}', $ArchParams[$Arch]",
            "    $Response = Invoke-RestMethod -Uri 'https://update.googleapis.com/service/update2' -Method Post -Body $Body",
            "    if ($Arch -eq 'x64') { $Version = $Response.response.app.updatecheck.manifest.version }",
            "    $ArchURLs[$Arch] = $Response.SelectSingleNode('//url').GetAttribute('codebase') -replace '^.*/(?<u>[^/]+)/$', '${u}'",
            "}",
            "Write-Output \"$Version,$($ArchURLs['x64']),$($ArchURLs['x86']),$($ArchURLs['arm64'])\""
        ],
        "regex": "(?<version>[\\d.]+),(?<archx64>[^,]+),(?<archx86>[^,]+),(?<archarm64>[^,]+)"
    },
    "autoupdate": {
        "architecture": {
            "64bit": { "url": "https://dl.google.com/.../chrome/$matchArchx64#/dl.7z" },
            "32bit": { "url": "https://dl.google.com/.../chrome/$matchArchx86#/dl.7z" },
            "arm64": { "url": "https://dl.google.com/.../chrome/$matchArcharm64#/dl.7z" }
        }
    }
}
```
