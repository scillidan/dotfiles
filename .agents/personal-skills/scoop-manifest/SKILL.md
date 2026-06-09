---
name: scoop-manifest
description: Use when creating, editing, or debugging Scoop bucket manifests (JSON). Covers post_install, pre_install, installer/uninstaller scripts, checkver, and autoupdate (including jsonpath/regex/captured variables). Also use when the user asks about Scoop manifest structure, autoupdate configuration, or version checking. Trigger on mentions of scoop manifest, scoop bucket, checkver, autoupdate, scoop json, or when creating .json files inside a bucket/ directory.
---

# Scoop Manifest Creation Assistant

When helping users write or fix Scoop manifests, follow the conventions and patterns below. The hardest parts — scripting hooks, checkver, and autoupdate — get the most detail.

## Search Strategy Priority

1. **fff MCP tools** — If `ffgrep`, `fffind`, or `fff-multi-grep` are available, prefer them for searching local bucket repos and documentation. They are dramatically faster than grep/find for repeated searches.
2. **Built-in Grep/Glob** — Fall back to `Grep`/`Glob` tools when fff is not installed.
3. **Web fetch** — For upstream release pages, GitHub APIs, or hash endpoints.

To install fff MCP server on Windows:

```powershell
irm https://raw.githubusercontent.com/dmtrKovalenko/fff.nvim/main/install-mcp.ps1 | iex
```

Then wire it into your agent config (OpenCode example):

```json
{
  "mcp": {
    "fff": {
      "type": "local",
      "command": ["fff-mcp"],
      "enabled": true
    }
  }
}
```

Add to your project's `CLAUDE.md` or equivalent:

```markdown
For any file search or grep in the current git-indexed directory, use fff tools.
```

## Manifest Skeleton

```json
{
    "version": "1.0.0",
    "description": "One-line description without the app name.",
    "homepage": "https://example.com",
    "license": "MIT",
    "architecture": {
        "64bit": {
            "url": "https://example.com/app-1.0.0-x64.zip",
            "hash": "sha256:..."
        },
        "32bit": {
            "url": "https://example.com/app-1.0.0-x86.zip",
            "hash": "sha256:..."
        }
    },
    "extract_dir": "app-1.0.0",
    "bin": "app.exe",
    "shortcuts": [["app.exe", "App Name"]],
    "checkver": {
        "github": "https://github.com/user/repo"
    },
    "autoupdate": {
        "architecture": {
            "64bit": {
                "url": "https://example.com/app-$version-x64.zip"
            },
            "32bit": {
                "url": "https://example.com/app-$version-x86.zip"
            }
        },
        "hash": {
            "url": "$baseurl/SHA256SUMS"
        }
    }
}
```

## Required / Important Properties

| Property | Notes |
|---|---|
| `version` | Must match the actual release version string |
| `description` | One line, no app name prefix |
| `homepage` | App's website |
| `license` | SPDX identifier string, or `{"identifier": "...", "url": "..."}`. Use `Freeware`, `Proprietary`, `Public Domain`, `Shareware`, or `Unknown` when no SPDX match. Dual license: separate with `\|`. Multiple licenses: separate with `,`. |
| `url` | Download URL. Append `#/dl.7z` fragment to trick exe/msi installers into being extracted by 7-Zip |
| `hash` | SHA256 by default. Prefix with `sha512:`, `sha1:`, `md5:` for other types |
| `bin` | String or array. Shim format: `["real.exe", "alias", "--args"]`. Single alias must be double-wrapped: `"bin": [["app.exe", "alias"]]` |

## pre_install / post_install Scripts

These are PowerShell scripts run before/after extraction. They can be a single string or an array of strings.

### Available Variables

| Variable | Example | Description |
|---|---|---|
| `$app` | `exampleapp` | Manifest filename (no extension) |
| `$version` | `1.2.3` | Version being installed |
| `$architecture` | `64bit` / `32bit` / `arm64` | Current arch context |
| `$dir` | `...\apps\app\current` (post_install) / `...\apps\app\1.2.3` (pre_install) | Install directory |
| `$persist_dir` | `...\persist\app` | Persistent data directory |
| `$global` | `$true` / `$false` | Whether global install |
| `$bucketsdir` | `...\buckets` | Buckets root |
| `$manifest` | PS object | Deserialized manifest |
| `$cmd` | `install` / `update` / `uninstall` | Current subcommand |
| `$fname` | Last downloaded filename | Available in `installer`/`args` context |

### Common Patterns

**Copy persisted config file before install:**

```json
"pre_install": "if (Test-Path \"$persist_dir\\config.ini\") { Copy-Item \"$persist_dir\\config.ini\" \"$dir\\\" }"
```

**Template replacement in .reg files (context menu, file associations):**

```json
"post_install": [
    "$appdir = $dir -replace '\\\\', '\\\\'",
    "Get-ChildItem \"$bucketsdir\\$bucket\\scripts\\$app\\*.reg\" | ForEach-Object {",
    "    $content = Get-Content $_.FullName -Encoding utf8",
    "    if ($global) { $content = $content -replace 'HKEY_CURRENT_USER', 'HKEY_LOCAL_MACHINE' }",
    "    $content -replace '{{APP_DIR}}', $appdir | Set-Content \"$dir\\$($_.Name)\" -Encoding unicode",
    "}"
]
```

**Set npm/pip config for persistence:**

```json
"post_install": "Set-Content -Value \"prefix=$persist_dir\\bin`ncache=$persist_dir\\cache\" -Path \"$dir\\node_modules\\npm\\npmrc\""
```

**Create default config if missing:**

```json
"pre_install": [
    "if (!(Test-Path \"$dir\\cli\\conf.d\")) { New-Item -Type directory \"$dir\\cli\\conf.d\" | Out-Null }"
]
```

**Modify ini/php config after extraction:**

```json
"post_install": [
    "(Get-Content \"$dir\\cli\\php.ini\") | % { $_ -replace ';\\s?(extension_dir = \"ext\")', '$1' } | Set-Content \"$dir\\cli\\php.ini\""
]
```

**Run ensurepip after Python install:**

```json
"post_install": "python -E -s -m ensurepip -U --default-pip | Out-Null"
```

### Key Rules

- `pre_install`: `$dir` points to versioned path (`apps\app\1.2.3`)
- `post_install`: `$dir` points to `current` junction — this is when shims are already created
- `$global` — always check this when writing registry entries to pick HKLM vs HKCU
- Use `info "message"` for user-visible output, not `Write-Host`
- For registry import in notes, guide users to `reg import "$dir\install-context.reg"`

## installer / uninstaller

### Structure

```json
"installer": {
    "file": "setup.exe",
    "args": ["/S", "/D=$dir"],
    "keep": false,
    "script": ["...powershell..."]
}
```

Use `file` + `args` for standard installers, or `script` for custom logic. `keep: true` preserves the installer exe for future uninstall.

### Variables in installer context

`$fname` (last downloaded file), `$manifest`, `$architecture`, `$dir`.

### Common Installer Patterns

**InnoSetup uninstaller (set `"innosetup": true` at top level for automatic handling):**

```json
"innosetup": true
```

**MSI extraction (no msiexec, just extract like a zip):**

Just provide the `.msi` URL without any `msi` property — Scoop extracts it automatically.

**WiX/MSI decompile with Dark then MsiArchive (Python pattern):**

```json
"installer": {
    "script": [
        "Expand-DarkArchive \"$dir\\setup.exe\" \"$dir\\_tmp\"",
        "(Get-ChildItem \"$dir\\_tmp\\AttachedContainer\\*.msi\").FullName | ForEach-Object {",
        "    if($((Get-Item $_).Basename) -eq 'appendpath') { return }",
        "    Expand-MsiArchive $_ \"$dir\"",
        "}",
        "Remove-Item \"$dir\\_tmp\", \"$dir\\setup.exe\" -Force -Recurse"
    ]
}
```

**Run portable installer, move results:**

```json
"installer": {
    "script": [
        "Start-Process -FilePath \"$dir\\$fname\" -ArgumentList @($env:PUBLIC) -Wait",
        "Move-Item -Path \"$env:PUBLIC\\App Portable\\*\" -Destination $dir -Force",
        "Remove-Item -Path \"$dir\\$fname\", \"$env:PUBLIC\\App Portable\" -Recurse -Force"
    ]
}
```

**Add PATH for GOPATH:**

```json
"installer": {
    "script": [
        "$envgopath = \"$env:USERPROFILE\\go\"",
        "if ($env:GOPATH) { $envgopath = $env:GOPATH }",
        "Add-Path -Path \"$envgopath\\bin\" -Global:$global -Force"
    ]
}
```

## checkver — Finding the Latest Version

### Simple Regex on Homepage

```json
"checkver": "Version ([\\d.]+)"
```

Matches against the `homepage` HTML.

### Regex on Different URL

```json
"checkver": {
    "url": "https://example.com/downloads",
    "regex": "Latest: ([\\d.]+)"
}
```

### GitHub Releases (Most Common)

```json
"checkver": {
    "github": "https://github.com/user/repo"
}
```

Matches `/releases/tag/(?:v|V)?([\d.]+)`. Pre-releases are ignored.

### JSONPath from JSON API

```json
"checkver": {
    "url": "https://api.example.com/releases",
    "jsonpath": "$[0].version"
}
```

### JSONPath + Regex Combined

Use `jsonpath` to extract a string, then `regex` to parse it. This is very common when a JSON API returns `"v1.2.3"` and you need just `1.2.3`:

```json
"checkver": {
    "url": "https://nodejs.org/dist/index.json",
    "jsonpath": "$[0].version",
    "regex": "v([\\d.]+)"
}
```

### GitHub API with JSONPath Filter

```json
"checkver": {
    "github": "https://api.github.com/repos/git-for-windows/git/releases/latest",
    "jsonpath": "$.assets[?(@.name =~ /Portable/i)].browser_download_url",
    "regex": "download/(?<tag>v?[\\d.]+windows[\\d.]+)/PortableGit-([\\d.]+)"
}
```

### Custom PowerShell Script

For complex scenarios (multi-step API calls, POST requests, custom logic):

```json
"checkver": {
    "script": [
        "$Body = '<?xml version=\"1.0\"?><request protocol=\"3.0\">...</request>'",
        "$Response = Invoke-RestMethod -Uri 'https://update.example.com/service' -Method Post -Body $Body",
        "$Version = $Response.response.app.updatecheck.manifest.version",
        "$URL64 = $Response.SelectSingleNode('//url[@codebase]').GetAttribute('codebase') -replace '^.*/(?<u>[^/]+)/$', '${u}'",
        "Write-Output \"$Version,$URL64\""
    ],
    "regex": "(?<version>[\\d.]+),(?<archx64>[^,]+)"
}
```

### Named Capture Groups → $match Variables

Named groups in `checkver.regex` become `$matchName` variables usable in `autoupdate`:

```json
"checkver": {
    "regex": "/v(?<tag>[\\d.]+)/clink\\.([\\d.]+)\\.(?<commit>[\\w.]+)\\.zip"
}
```

This creates: `$matchTag`, `$match2` (version), `$matchCommit`.

### `replace` in checkver

When the version string needs transformation:

```json
"checkver": {
    "regex": "ghidra_([\\d.]+)_PUBLIC_(?<date>\\d+)\\.zip",
    "replace": "${1}-${2}"
}
```

This composes the final `version` field from captured groups.

### `reverse: true`

Match the **last** occurrence instead of the first:

```json
"checkver": {
    "url": "https://example.com/downloads/",
    "regex": "file-(?<version>[\\d]+)-(?<commit>[a-f0-9]{7})\\.zip",
    "reverse": true
}
```

## autoupdate — Automatic Manifest Updating

Autoupdate needs `checkver` to find the latest version first.

### Version Variables

| Variable | Example (`3.7.1`) |
|---|---|
| `$version` | `3.7.1` |
| `$underscoreVersion` | `3_7_1` |
| `$dashVersion` | `3-7-1` |
| `$cleanVersion` | `371` |
| `$majorVersion` | `3` |
| `$minorVersion` | `7` |
| `$patchVersion` | `1` |
| `$buildVersion` | (4th segment, e.g. `2` from `3.7.1.2`) |
| `$matchHead` | `3.7.1` (first 2-3 dot-separated digits) |
| `$matchTail` | `-rc.1` (rest after matchHead) |
| `$preReleaseVersion` | `rc.1` (after last `-`) |

### Captured Variables (`$matchX`)

Every named capture group in `checkver.regex` creates a `$matchName` variable. Unnamed groups create `$match1`, `$match2`, etc.

### URL Variables

| Variable | Example |
|---|---|
| `$url` | Full autoupdate URL without fragment (`#/dl.7z`) |
| `$baseurl` | URL without filename and fragment |
| `$basename` | Filename from autoupdate URL (ignores fragment) |

### Basic URL Pattern

```json
"autoupdate": {
    "url": "https://example.com/app-$version.zip"
}
```

### Per-Architecture URLs

```json
"autoupdate": {
    "architecture": {
        "64bit": {
            "url": "https://example.com/app-$version-x64.zip",
            "extract_dir": "app-$version-x64"
        },
        "32bit": {
            "url": "https://example.com/app-$version-x86.zip",
            "extract_dir": "app-$version-x86"
        }
    }
}
```

### Hash Autoupdate — The Critical Part

If no `hash` property is defined, Scoop downloads files and hashes locally (slow, unreliable). Always try to find a published hash source.

#### Mode: extract (default) — Regex on webpage/textfile

```json
"hash": {
    "url": "$baseurl/SHA256SUMS"
}
```

Scoop uses built-in regex: `([a-fA-F0-9]{32,128})[\x20\t]+.*$basename`. Override with `find`:

```json
"hash": {
    "url": "$baseurl/hashes.txt",
    "find": "SHA256\\($basename\\)=\\s+([a-fA-F\\d]{64})"
}
```

#### Mode: json — JSONPath on JSON endpoint

```json
"hash": {
    "mode": "json",
    "jp": "$.files.['$basename'].sha512",
    "url": "$baseurl/hashes.json"
}
```

The `$basename` is replaced at runtime before evaluating JSONPath. This enables filter expressions:

```json
"hash": {
    "mode": "json",
    "jsonpath": "$..[?(@.path == '$basename')].sha256",
    "url": "https://example.com/releases.json"
}
```

#### Mode: xpath — XPath on XML

```json
"hash": {
    "url": "https://example.com/chrome.min.xml",
    "xpath": "/chromechecker/stable64[version=\"$version\"]/sha256"
}
```

#### Mode: rdf — RDF digest file

```json
"hash": {
    "mode": "rdf",
    "url": "https://example.com/digest.rdf"
}
```

#### Mode: metalink — Metalink header or .meta4

```json
"hash": {
    "mode": "metalink"
}
```

#### Mode: fosshub / sourceforge — Automatic

No `hash` property needed — Scoop auto-detects FossHub and SourceForge URLs and extracts hashes.

#### Common Hash URL Patterns

| Pattern | Example |
|---|---|
| `$url.sha256` | Google Go |
| `$baseurl/SHASUMS256.txt` | Node.js |
| `$baseurl/SHA256SUM` | BusyBox |
| Separate API per arch | VS Code (`$.sha256hash`) |
| Hash in release page HTML | Git (`<code>$sha256</code>`) |

### Using `$matchX` in autoupdate

This is where `checkver` and `autoupdate` connect. Named captures flow from `checkver.regex` into `autoupdate` URLs:

```json
"checkver": {
    "github": "https://github.com/NationalSecurityAgency/ghidra",
    "jsonpath": "$.assets[*].browser_download_url",
    "regex": "ghidra_([\\d.]+)_PUBLIC_(?<releasedate>\\d+)\\.zip",
    "replace": "${1}-${2}"
},
"autoupdate": {
    "architecture": {
        "64bit": {
            "url": "https://github.com/.../ghidra_$matchHead_PUBLIC_$matchReleasedate.zip"
        }
    },
    "hash": {
        "url": "https://github.com/.../tag/Ghidra_$matchHead_build",
        "regex": "<code>$sha256</code>"
    },
    "extract_dir": "ghidra_$matchHead_PUBLIC"
}
```

### Other Autoupdateable Properties

`bin`, `extract_dir`, `extract_to`, `env_add_path`, `env_set`, `installer`, `license`, `notes`, `persist`, `post_install`, `psmodule`, `shortcuts` — all support `$version` and `$matchX` variables.

## Testing Your Manifest

```powershell
cd <bucket repo>
scoop config debug $true
.\bin\checkver.ps1 <app>          # Check current version
.\bin\checkver.ps1 <app> -u       # Auto-update manifest
.\bin\checkver.ps1 <app> -f       # Force update even if version matches
scoop install bucket\<app>.json   # Test install
scoop uninstall <app>             # Test uninstall
```

## Checklist Before Submitting

- [ ] `version` matches upstream
- [ ] `url` downloads successfully
- [ ] `hash` is correct (SHA256 unless upstream provides other)
- [ ] `bin` shims work when run
- [ ] `checkver` returns the latest version
- [ ] `autoupdate` produces correct URLs/hashes when run with `-u`
- [ ] `pre_install` / `post_install` scripts handle both global and non-global installs
- [ ] `installer` / `uninstaller` clean up temp files
- [ ] `persist` entries survive updates
- [ ] No `_comment` — use `##` instead
- [ ] `license` uses SPDX identifiers
- [ ] `description` does not repeat the app name

## Common Mistakes

1. **Wrong hash source**: Using `$baseurl` when the hash file lives at a different path — always verify the hash URL resolves.
2. **Missing `extract_dir`**: Multi-version archives often nest files in a versioned directory; check the actual zip structure.
3. **`#/dl.7z` without InnoSetup**: The `#/dl.7z` fragment tells Scoop to treat an `.exe` as a 7z archive. Only works if the exe is actually an archive or InnoSetup installer.
4. **Version prefix mismatch**: If upstream tags are `v1.2.3` but `checkver` captures `1.2.3`, the `autoupdate` URL must use `$version` (without `v`) or `$matchTag` (with `v`), depending on the URL pattern.
5. **Single alias shim**: `"bin": ["app.exe", "alias"]` creates TWO shims. Use `"bin": [["app.exe", "alias"]]` for one alias shim.
6. **`innosetup: true` with `#/dl.7z`**: Don't use both — `innosetup: true` already handles InnoSetup extraction; `#/dl.7z` converts exe to generic 7z extraction which may miss InnoSetup-specific file layout.

## Reference

For complete property documentation and more patterns, read `references/manifest-reference.md`.
