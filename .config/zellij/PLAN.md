# PLAN — pane translation and nvim/pane navigation

Two follow-ups from the tmux → Zellij migration. Neither is implemented yet.

## 1. Translate the neighbouring pane in place

Goal: read pane A, show the translation in pane B side by side, keeping the
line structure of the original. Panel placement should be selectable: right,
bottom, floating, or a new tab.

### Mechanism

`zellij action dump-screen` writes the focused pane's viewport to a file. That
keeps line breaks and drops ANSI styling, which is what a side-by-side read
needs:

```bat
zellij action dump-screen --full %TEMP%\pane.txt
```

`--full` includes scrollback; omit it for the visible viewport only.

Then translate:

```bat
bash %USERHOME%\Share\scripts\llm-translate-stdin.sh < %TEMP%\pane.txt
```

`llm-translate.sh` calls `lib/llm_translate.py` against the local llama.cpp
server at `127.0.0.1:8010` with `gemma-3-4b-it-qat`. If the server is not
running the pane will sit on an error; the wrapper should print a one-line hint
instead of a stack trace.

### Placement

| Variant | How |
|---|---|
| right | `zellij action new-pane --direction right -- bash translate-pane.sh` |
| bottom | `zellij action new-pane --direction down -- bash translate-pane.sh` |
| floating | add `--floating` |
| new tab | `zellij action new-tab --layout` with a two-pane layout |

One key with a fixed direction is the simplest starting point; a menu key
(`Ctrl-g` then a letter) can pick the direction later.

### Open questions

- `dump-screen` reads the **focused** pane. Translating the pane next to the
  cursor needs focus to move first, or `--pane-id` if 0.46 supports it.
- Long output: cap at N lines, or the LLM call takes minutes.
- Reuse for `llm-summarize.sh`, `llm-explain.sh`, `llm-comment.sh` — same
  plumbing, different script.

## 2. nvim ↔ Zellij pane navigation

**Already configured** — `neolij.nvim` is in `dotfiles/.config/nvim/lua/config_lazy.lua`
(lazy-loaded, only when `$ZELLIJ` is set) with keys from
`lua/config/keys/neolij.lua`:

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

