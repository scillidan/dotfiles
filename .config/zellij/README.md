# Zellij config

Migrated from tmux. WezTerm stays the terminal layer; Zellij owns sessions,
tabs, panes and layouts.

## First launch

Click the bottom status bar once and press `y`. This grants zjstatus
`ReadApplicationState`, `ChangeApplicationState` and `RunCommands`.
Zellij 0.45 cannot keyboard-focus a 1-row permission prompt (upstream #4749).
The choice is cached after that.

## Layouts

- `layouts/default.kdl` — one `~` tab, used by plain `zellij`.
- `layouts/user.kdl` — tmuxp replacement: home / dotfiles / Share / Downloads.
- `layouts/project.kdl` — `edit` (nvim) + `shell`, cwd inherited from launcher.
- `layouts/swap.kdl` — tiled swap layouts.

## Keys

`Alt+*` acts directly. `Ctrl+Space` opens the tmux-compatible mode.

| Keys | Action |
|---|---|
| `Ctrl+Space` | tmux mode (then `c` new tab, `%` / `"` split, `h/j/k/l` focus, `x` close pane, `z` fullscreen, `d` detach, `[` scroll, `g` lazygit floating, `s` sessionizer, `T` toggle theme) |
| `Alt-s` | sessionizer (fzf over zoxide dirs, switch/create project session) |
| `Alt-%` / `Alt-"` | split right / down |
| `Alt-q` | close pane |
| `Alt-Shift-w` | close tab |
| `Alt-Shift-k/j` | move pane up/down |
| `Alt-Shift-h/l` | move tab left/right |
| `Alt-w` | floating panes |
| `Alt-z` | fullscreen |
| `Alt-1..9` | go to tab |
| `Alt-\` / `Ctrl-\` | last focused pane |
| `Alt-f` | passes through to bash `fzf_files` |

`Ctrl-h/p/n/o/t/b/q` are unbound in normal mode, so readline and Neovim keep
them. `Ctrl-s` remains Zellij scroll; `Ctrl-g` remains locked.

## Sessions

Use the launcher from `Share/scripts`:

```text
zellij-session                 # session "session", layout user (tmuxp replacement)
zellij-session dotfiles        # project session, layout project
zellij-session C:\path\to\repo # session named after the directory, cwd = repo

zellij-sessionizer             # fzf over zoxide dirs, switch/create project session
zellij-sessionizer --dir PATH  # skip fzf
```

Inside Zellij, `Alt-s` (or `Ctrl-Space s`) opens the sessionizer in a floating
pane. It uses `zellij action switch-session`, so the current client switches
instead of nesting a new session.

Recommended model: **session = directory, tab = activity in that directory**.
Detach with `Ctrl-Space d`; reattach with the same command. Delete a finished
session with `zellij delete-session <name>`.

## Shell

`default_shell` is `zellij-shell.cmd` on both platforms:

- Windows: `Share/scripts/win/zellij-shell.cmd` → `zellij_shell.py` → `cmd.exe /k clink init.cmd`
- Linux: `Share/scripts/arch/zellij-shell.cmd` (shell script) → `zellij_shell.py` → `$SHELL`

The `.cmd` suffix is used on Linux because Zellij cannot pass arguments to
`default_shell` and Windows needs the extension; the Linux file is a normal
shell script with a shebang.

`sysstat.py` feeds CPU / RAM / GPU / host to zjstatus every 5 seconds. It uses
`psutil` when available, then `nvidia-smi` when present.

## WezTerm layer

WezTerm handles terminal-level text actions, so they also work inside Zellij:

| Keys | Action |
|---|---|
| `Ctrl-Shift-O` | QuickSelect URLs, open in browser |
| `Ctrl-Shift-P` | QuickSelect paths/files, copy |
| `Ctrl-Shift-S` / `Ctrl-Shift-Space` | QuickSelect all (tmux-thumbs), lowercase copies, uppercase pastes |
| `Ctrl-Shift-X` | copy mode (`v` cell, `V` line, `Ctrl-V` block, `y` copy) |
| `Ctrl-Shift-F` | search |
| `Ctrl-click` | open hyperlink |

WezTerm no longer injects `tere.bat`, `fzf-files.sh` or `lazygit` into the
focused pane: inside Zellij that text lands in Neovim. Use `Alt-f` in a bash
pane for `fzf_files`, and `Ctrl-Space g` for lazygit in a floating pane.
`Alt-c` (tere) is left for the app; run it manually.

## Neovim

`neolij.nvim` replaces `vim-tmux-navigator`. `Ctrl-h/j/k/l` moves between
Neovim splits and falls back to Zellij panes/tabs at the edge. It loads only
when `$ZELLIJ` is set. `blink-cmp-tmux` was removed; `blink-cmp-zellij` stays.

## Not migrated yet

- Zellij has no keyboard range selection in scrollback; use mouse, `e` (edit
  scrollback), or WezTerm copy mode for the visible screen.
- `tmux-fzf-links` history scanning, `tmux-translator`, and the custom
  copy-mode plugin are deferred.
