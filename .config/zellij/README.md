# Zellij on Windows — notes

WezTerm stays the outer layer (workspace tabs); Zellij runs one session per
workspace. WezTerm keys are unchanged.

## Verified setup

- `config.kdl`: `default_shell "cmd.exe"`, `default_layout "default"`,
  `session_serialization true`, `serialize_pane_viewport false`,
  `tab_name_to_number false`.
- Clink is injected inside Zellij panes by cmd's AutoRun value, which points at
  `dotfiles.win/Scoop/clink/zellij-autorun.cmd`. Install/remove it with
  `scripts/win/registry/clink-autorun_{install,uninstall}.reg`.
- `dotfiles.win/Scoop/clink/zellij.lua` clears the cmd banner once and renames
  the tab to the cwd leaf via `console.settitle()` (global table, not
  `clink.console`). Do not use `os.execute('title ...')`: Clink's builtin wraps
  the value in quotes and the tab shows `1:"Downloads"`.
- Keys: `Ctrl-g` is the Zellij prefix, `Ctrl-a` stays WezTerm's leader.

## Entry points

| Command | Use |
|---|---|
| `zellij` | default layout, one shell in `~/Downloads` |
| `zellij --layout minimal` | same, plus the zjstatus bar |
| `zellij-session .` | session named after the current directory |

`zellij --session X` only attaches; it never creates a session on Windows.
Creating one needs a real interactive terminal.

## Windows limitations

- `Ctrl-Space` never reaches a Zellij pane (the outer ConPTY drops NUL). Clink's
  fzf completion is bound to `Alt-/` as well.
- Multi-line paste is split into plain keystrokes, so paste into nvim corrupts
  the screen. Edit multi-line text in a WezTerm tab instead.

## TODO

- Zellij `swap.kdl` / preset layouts were removed; re-add only if actually used.
- Re-evaluate dropping the WezTerm layer once upstream fixes the paste path on
  Windows (zellij #5333, #5335).
