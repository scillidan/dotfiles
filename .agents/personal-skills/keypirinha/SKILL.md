---
name: keypirinha
description: Use ONLY when creating or modifying Keypirinha plugins. Provides plugin lifecycle patterns, file-based data loading, config handling, package build, and release pipeline.
---

# Keypirinha Plugin Conventions

## Project Scaffolding

```
keypirinha-pluginname/
├── .github/workflows/releases.yml
├── pluginname.py
├── pluginname.ini
├── LICENSE
├── Makefile
└── README.md
```

- Single Python file. No `lib/` or `src/`.
- Build via **Makefile** (not justfile).
- Package artifact: `.keypirinha-package` (just a zip renamed).

### README

```markdown
# keypirinha-pluginname

One-line description. Supports:

- Feature one
- Feature two

Authors: <AI-Name>🧙‍♂️, scillidan🤡.

## <Data> format

\```
## comment
<data examples>
\```

## Usage

Type `keyword` → Tab → `<query1> <query2> ...`
```

- Concrete AI name, human `scillidan🤡`.
- MIT, Copyright (c) 2026 scillidan.

## Plugin Lifecycle

```python
import keypirinha as kp
import keypirinha_util as kpu

class PluginName(kp.Plugin):
    def __init__(self):
        super().__init__()
        self._cache = []
        self._keyword = "default"

    def on_start(self):
        self._read_config()
        self._build_cache()

    def on_catalog(self):
        self.set_catalog([
            self.create_item(
                category=kp.ItemCategory.KEYWORD,
                label=self._keyword,
                short_desc="Search <stuff>",
                target=self._keyword,
                args_hint=kp.ItemArgsHint.ACCEPTED,
                hit_hint=kp.ItemHitHint.IGNORE,
            )
        ])

    def on_suggest(self, user_input, items_chain):
        if not items_chain or items_chain[0].target() != self._keyword:
            return
        query = user_input.strip().lower()
        words = [w for w in query.split() if w]
        matched = [item for item in self._cache if self._match(item, words)]
        self.set_suggestions(
            [self._to_suggestion(item) for item in matched],
            kp.Match.DEFAULT, kp.Sort.NONE
        )

    def on_execute(self, item, action=None):
        pass  # item.target() → do the thing

    def on_events(self, flags):
        if flags & kp.Events.PACKCONFIG:
            self._read_config()
            self._build_cache()
```

Key decisions:
- Cache built once in `on_start`, rebuilt on `PACKCONFIG` event.
- Multi-word search: split query, all words must match (AND logic).
- `on_suggest` checks `items_chain` target to ensure it's the right keyword.

## Config Pattern

```ini
[main]
keyword = cheat
comment_prefix = ##
max_desc_len = 35%
directories = 
    ${env:USERHOME}/cheatsheet;
    ${env:USERHOME}/shortcut
patterns = *.cht
ignore = *.txt;arch
```

- INI file lives beside `.py`, same stem.
- `directories`: semicolon-separated, supports `${env:VAR}` and `~` expansion.
- `patterns` / `ignore`: semicolon-separated globs, matched via `fnmatch`.
- `max_desc_len`: supports `%` suffix → calculated from screen width via `ctypes.windll.user32.GetSystemMetrics(0)`.

Reading config:

```python
def _read_config(self):
    settings = self.load_settings()
    self._keyword = settings.get("keyword", "main", "default")
    dirs_raw = settings.get("directories", "main", "")
    self._dirs = [
        os.path.expandvars(os.path.expanduser(p.strip()))
        for p in dirs_raw.replace(";", "\n").split("\n")
        if p.strip() and os.path.isdir(os.path.expandvars(os.path.expanduser(p.strip())))
    ]
    patterns_raw = settings.get("patterns", "main", "*.txt")
    self._patterns = [
        p.strip()
        for p in patterns_raw.replace(";", "\n").split("\n")
        if p.strip()
    ]
```

- Always provide hardcoded defaults as fallback.
- Split on both `;` and `\n` — user may use either delimiter.

## File-Based Data Loading

Both plugins scan directories recursively, filter by pattern/ignore, then parse each file.

```python
def _scan_files(self):
    files = []
    for d in self._dirs:
        for root, dirs, filenames in os.walk(d):
            dirs[:] = [dn for dn in dirs if not self._is_ignored(dn)]
            for fn in filenames:
                if self._is_ignored(fn):
                    continue
                if any(fnmatch.fnmatch(fn, p) for p in self._patterns):
                    files.append(os.path.join(root, fn))
    return sorted(files)

def _is_ignored(self, name):
    return any(fnmatch.fnmatch(name, p) for p in self._ignores)
```

- `os.walk` with `dirs[:]` mutation to prune ignored subdirectories.
- `fnmatch` for glob matching on both patterns and ignore list.

## Data Format Conventions

### Cheatsheet format (pipe-delimited)

```
## comment (URL or note)
description | shortcut
description | shortcut | extra
```

- `|` splits into description + shortcut; extra segments re-joined with ` | `.
- Escape sequences: `\t` → tab, `\n` → newline, `\\` → backslash.
- `#` lines (not starting with `##`) are also skipped — INI comment convention.

### Bookmark format (URL-first)

```
## comment (URL or note)
https://example.com
https://example.com/page  Title Here
```

- Regex `^(https?://\S+)` extracts URL, remainder is title.
- Fallback title: strip protocol from URL.

## Execute Actions

Two patterns observed:

**Copy to clipboard** (cheatsheet):
```python
def on_execute(self, item, action=None):
    target = item.target()
    if target.startswith("line:"):
        kpu.set_clipboard(target[5:])
```

**Open URL in browser** (bookmarks):
```python
def on_execute(self, item, action=None):
    url = item.target()
    if self.browser_args:
        kpu.shell_execute(self.browser_args, [url])
    else:
        kpu.web_open_url(url)
```

- `browser_args` from config allows custom browser (e.g. `brave`).

## Item Categories

- **Custom category** for non-URL items: `kp.ItemCategory.USER_BASE + 1`
- **URL category** for web bookmarks: `kp.ItemCategory.URL` (enables kp's built-in URL handling)

## Responsive Truncation

```python
def _calc_desc_len(self, percent):
    try:
        screen_width = ctypes.windll.user32.GetSystemMetrics(0)
        return max(20, int(screen_width * percent / 100 / 8))
    except Exception:
        return 50
```

- `%`-based: adapts to screen resolution.
- Fallback: hardcoded 50 chars.

## Build

```makefile
PACKAGE_NAME = PluginName
VERSION = 0.0.1
DIST_DIR = dist
FILES = pluginname.py pluginname.ini README.md LICENSE

.PHONY: all clean dist

all: dist

dist:
	@mkdir -p $(DIST_DIR)
	7z a -tzip "$(DIST_DIR)/$(PACKAGE_NAME).keypirinha-package" $(FILES)

clean:
	@rm -rf $(DIST_DIR)
```

- Uses `7z` (not zip) — consistent with AHK projects.
- Output: `.keypirinha-package` in `dist/`.

## Releases.yml

```yaml
name: Create Releases

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

jobs:
  release:
    runs-on: ubuntu-latest
    permissions:
      contents: write

    steps:
    - name: Checkout repository
      uses: actions/checkout@v6

    - name: Install p7zip
      run: |
        sudo apt-get update
        sudo apt-get install -y p7zip-full

    - name: Build package
      run: make

    - name: Generate SHA256 checksums
      run: sha256sum dist/PackageName.keypirinha-package > dist/PackageName.keypirinha-package.sha256

    - name: Release
      uses: softprops/action-gh-release@v3
      with:
        tag_name: ${{ github.event_name == 'workflow_dispatch' && inputs.version || github.ref_name }}
        name: ${{ github.event_name == 'workflow_dispatch' && inputs.version || github.ref_name }}
        files: |
          dist/PackageName.keypirinha-package
```

- Runs on **ubuntu-latest** (not windows) — Keypirinha packages are pure Python, no compilation needed.
- `p7zip-full` for the `7z` command.
- SHA256 on `.keypirinha-package` file.
