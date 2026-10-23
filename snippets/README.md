# snippets

Single source of truth for editor snippets, synced into both editors.

- `src/sublime-text/*.sublime-snippet` — Sublime format sources: copied to Sublime, auto-converted for nvim
- `src/neovim/` — nvim only: `<ft>.json` (VSCode format, copied verbatim), `<ft>.lua` (LuaSnip lua format, copied verbatim), or `.sublime-snippet` (converted)
- `src/scope-map.toml` — sublime `<scope>` → vim filetype; a missing scope is a hard error

Generated targets (do not edit, `just sync` overwrites):

- `../.config/sublime-text/Packages/User/Snippets/`
- `../.config/nvim/snippets/` (`package.json` + `user/<ft>.json` + `lua/<ft>.lua`, LuaSnip `from_vscode`/`from_lua` loaders)

Commands:

```sh
just          # sync src/ -> both targets
just list     # show what lives where
just watch    # re-sync on every change
just init     # one-time: adopt snippets already sitting in the target dirs
```
