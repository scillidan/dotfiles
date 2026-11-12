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

tmux had `vim-tmux-navigator`: `Ctrl-h/j/k/l` moved between panes and Neovim
splits seamlessly, decided by checking whether the pane's foreground process is
vim.

### Zellij options

1. **`neolij.nvim`** — the maintained equivalent; it talks to Zellij and turns
   the same keys into pane moves at the edges of a Neovim window. Needs a
   Lua plugin entry and a keymap in Neovim.
2. **Shell-side detection** (what tmux used) — run `ps` on the pane's tty to see
   if nvim owns it, then decide. Fragile on Windows: CIM/tasklist lookups are
   slow and the tty mapping is not exposed.
3. **Static split** — keep Neovim's own `Ctrl-h/j/k/l` for splits and use
   `Ctrl-g h/j/k/l` for Zellij panes. No plugin, no ambiguity, but two different
   keys.

Recommended: option 1. Option 3 as the fallback if the plugin misbehaves.

### Prerequisites

- Confirm which Neovim plugin manager owns the config (`lazy` vs `vim-plug`).
- Check whether `blink-cmp` is in use; it needs `blink-cmp-zellij` for the same
  reason.
- Verify the keys inside a Zellij pane: `Ctrl-h` currently reaches Neovim fine,
  so the plugin only has to handle the "no split left" case.
