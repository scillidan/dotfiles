# PLAN — follow-ups from the tmux → Zellij migration

## Pane translation — dropped

Tried and abandoned: `zellij action list-panes` returns an empty table when run
from a keybind's `Run` pane, and `new-pane --in-place` cannot take `--direction`,
so the translation pane had no reliable way to find the source pane id. Golendict
already covers the one-off lookup case.

## nvim ↔ Zellij pane navigation — already in place

| Key | Command |
|---|---|
| `Ctrl-h` | `:NeolijLeftTab` |
| `Ctrl-j` | `:NeolijDown` |
| `Ctrl-k` | `:NeolijUp` |
| `Ctrl-l` | `:NeolijRightTab` |

`LeftTab`/`RightTab` (rather than `Left`/`Right`) is what makes the boundary
cross into the neighbouring Zellij tab as well as the pane.

Verify inside a Zellij pane: with a single Neovim window, `Ctrl-h/l` should move
focus to the neighbouring Zellij pane; with a Neovim split open, it should stay
inside Neovim.

No shell-side process detection is needed (the tmux approach) because the plugin
only acts when Neovim cannot move any further.

### Not configured

- `Ctrl-h/j/k/l` for anything else (`Ctrl-k` is Neovim's built-in `gk` there, now
  taken).
- Wide-character panes: `Ctrl-\` (the tmux `select-pane -l` equivalent) is free.

