# Paste diagnosis log (Zellij 0.45.1 + WezTerm + cmd/Clink on Windows)

## Established facts

1. `C:\Users\User\Downloads\_temp2.txt` was saved as **CRLF** (`od -c`: `A A \r \n B B B \r \n`).
2. Injecting one bracketed paste via three CLI writes into a Zellij pane:
   `ESC[200~` / `AAA\r\nBBB\r\n` / `ESC[201~`
   - in **cmd**: `AAA` and `BBB` each ran as a command ("not recognized")
   - in **nvim**: first line showed `AA D73` garbage, file content stayed correct
   => the markers do not put the pane into paste mode; text reaches the child as plain keys.
3. `nvim --clean -l` (no UI, no plugins): `t_BE`, `t_BR`, `t_PS`, `t_PE`, `t_BD` are all **empty**
   on this machine for `TERM=xterm-256color`.
4. nvim 0.12.6's TUI enables bracketed paste by emitting the terminfo string
   `kTermModeBracketedPaste` (= `t_BE`), not a hardcoded CSI; with `t_BE` empty nvim emits nothing,
   so the host terminal never wraps pastes.
5. nvim's input parser (`src/nvim/tui/input.c`, `handle_bracketed_paste`) recognises
   `ESC[200~`/`ESC[201~` on its own and calls `nvim_paste`, so *receiving* a bracketed paste
   would work even with an empty `t_BE`.
6. Setting `t_BE`/`t_PS`/`t_PE` in `init.lua` **did not fix it** (tested, then reverted).

## Interpretation

The chain WezTerm -> Zellij -> cmd(ConPTY) -> nvim loses the mode negotiation: a
`ESC[?2004h` issued by nvim has to travel back through cmd's ConPTY before WezTerm sees it.
The remaining question is whether ConPTY or Zellij drops it. Unknown, and not fixable from
the Zellij/nvim config side within this migration's scope.

## Decision

Treat multi-line paste as a known limitation of running under Zellij on this platform.
Keep multi-line editing in a WezTerm tab (outside Zellij) and move content into a file with
`:w`, or use `:r file` inside nvim. Revisit when Zellij ships the VT-input/mouse fixes that
currently live only on `main` (PR #5335, issue #5333).

## Out of scope but observed

- In a Zellij pane, nvim's `p`/`P` can become unusable after a broken paste (dangling paste,
  neovim#10865). Only that nvim instance is affected; kill it, do not reuse it.
- `Ctrl-\` inside nvim is taken by the user's toggleterm config, so the usual
  `<C-\><C-n>:set paste<CR>` recovery is not available.
