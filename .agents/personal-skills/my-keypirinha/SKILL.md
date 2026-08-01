---
name: keypirinha
description: Use when working with Keypirinha plugins, .py plugin files, or plugin packaging.
---

# Keypirinha Plugin Conventions

Last updated: 2026-06-30
Projects: keypirinha-cheatsheet, keypirinha-bookmark-txt

## Rules

- **Single `.py` file.** `.py` and `.ini` share the same stem.
- **Build:** Makefile (not justfile), `7z` → `.keypirinha-package`. Releases: ubuntu-latest.
- **Lifecycle:** `on_start` → read config + build cache. `on_events(PACKCONFIG)` → rebuild.
- **on_suggest:** check `items_chain[0].target() == self._keyword` first. Multi-word AND search.
- **ItemCategory:** `USER_BASE + 1` for non-URL, `URL` for bookmarks (enables built-in URL handling).
- **Config:** INI beside `.py`. `directories` semicolon-separated, `${env:VAR}` expansion. `patterns`/`ignore` via `fnmatch`. Split on both `;` and `\n`. Hardcoded defaults as fallback.
- **File scanning:** `os.walk` with `dirs[:]` mutation for ignore pruning.
- **`max_desc_len`:** `%` suffix → `ctypes.windll.user32.GetSystemMetrics(0)` × percent / 100 / 8.
- **README:** `Authors: <AI>🧙‍♂️, scillidan🤡`, data format section, usage with keyword → Tab → query. MIT.

## Key Decisions

- Cache once at startup, not per-query.
- `fnmatch` for both include and ignore patterns.
- Escape sequences in data: `\t` → tab, `\n` → newline, `\\` → backslash.

## Known Deviations

| Project | Deviation |
|---|---|
| bookmark-txt | `.py` = `bookmark_txt.py`, `.ini` = `bookmarktxt.ini` (stem mismatch) |
| bookmark-txt | Uses `USER_BASE + 1` for URLs instead of `ItemCategory.URL` |
