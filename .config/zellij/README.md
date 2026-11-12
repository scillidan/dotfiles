# Zellij on Windows — notes

WezTerm stays the outer layer (workspace tabs); Zellij runs one session per
workspace. WezTerm keys are unchanged.

## Verified setup

- `config.kdl`: `default_shell "cmd.exe"`, `default_layout "default"`,
  `session_serialization true`, `serialize_pane_viewport false`,
  `tab_name_to_number false`, `mouse_mode false`.
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

## Pitfalls already paid for — do not retry these

### Tab names

- Zellij 0.46 names a tab after the focused pane's title, which Clink sets to
  `cmd.exe - ...zellij-autorun.cmd` via `SetConsoleTitleW`.
- `os.execute('title "x"')` from Clink quotes the value (`1:"Downloads"`) and
  sometimes mangles backslashes. Use `console.settitle(leaf)`.
- `clink.console` is nil in script context; the table is the global `console`.
- `clink lua -e ...` runs without Clink's interactive tables, so it cannot be
  used to probe `console`; probe from a `clink.onbeginedit` hook instead.
- Adding a pane to `default_tab_template` makes 0.46 rename the tab to `Tab #1`
  while `query-tab-names` still reports the authored name.

### Keys

- `Ctrl-Space` never arrives in a pane (outer ConPTY drops NUL). Verified with
  visible actions (`ToggleFocusFullscreen`), not just `Write`. Use `Alt-/`.
- `Ctrl-h/j/k/l` cannot be used for pane navigation: on a Windows console they
  are the same bytes as Backspace / Enter / Ctrl-L. neolij is bound to
  `Alt-h/j/k/l` for that reason.
- `Ctrl-g` is the prefix, so anything inside the tmux layer needs a second key.
  Direct bindings (`Alt-t`, `Alt-n`, `Alt-r`) are one keystroke.
- Zellij's keybind scopes are per-mode; `unbind` inside `"move"` alone does not
  remove a binding from `shared` or `normal`.

### Pane ids and CLI

- `zellij action list-panes` returns an empty table when run from a keybind's
  `Run` pane, so pane ids cannot be discovered that way.
- `new-pane --in-place` is rejected together with `--direction`.
- `zellij action ...` without `--session` fails when several sessions exist;
  this machine keeps resurrected `EXITED` entries around. Clean them with
  `zellij delete-session <name>` (they survive `kill-session`).
- `zellij --layout swap` is not a session layout: it only defines swap layouts
  and produces a session with no tabs.
- KDL does not accept `#` comments; use `//`. A `#` line fails with
  "Failed to deserialize KDL node".

### Mouse

- `HKCU\Console` has `QuickEdit = 1`. Clicking inside a console pauses output and
  a second click can kill the fullscreen program. Zellij's own mouse handling is
  off (`mouse_mode false`) because its right-click menu was unwanted; expect the
  terminal's selection, not Zellij's.

### Paste

- Multi-line paste is split into three separate `Write` actions (start marker,
  body, end marker); the ordering is not guaranteed, so nvim receives plain keys
  and shows garbage such as `+q4D73` in the first line. The file content stays
  correct.
- `t_BE`/`t_BR`/`t_PS`/`t_PE`/`t_BD` are empty for `xterm-256color` here, and
  setting them in `init.lua` did **not** fix it.
- A broken paste leaves nvim in a dangling-paste state (neovim#10865); `p`/`P`
  stop working in that instance only.
- Workaround: edit multi-line text in a WezTerm tab, then `:w` / `:r`.

### nvim

- `E1568: Terminal did not respond to DSR request for 'background' color`: nvim
  0.12.6 asks the terminal for its background, but the query has to cross cmd's
  ConPTY and Zellij, and neither answers. Fix by skipping the query inside Zellij
  rather than by changing Zellij.

## TODO

- Zellij `swap.kdl` / preset layouts were removed; re-add only if actually used.
- Re-evaluate dropping the WezTerm layer once upstream fixes the paste path on
  Windows (zellij #5333, #5335).
