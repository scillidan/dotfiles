# Terminal theme

Shared `system` / `dark` / `light` mode for WezTerm, OpenCode, yazi, Neovim and Zellij. The default is `system`; no preference file needs to be committed.

## Switch

- Any terminal app: WezTerm `Ctrl+A`, then `Shift+C`.
- Neovim: `<leader>sth`.
- Zellij: `Ctrl+Space`, then `T`.
- Shell: `terminal-theme cycle` (wrappers in `Share/scripts/win` and `Share/scripts/arch`).

The cycle is `system → dark → light → system`. Set an exact mode with:

```sh
terminal-theme dark
terminal-theme light
terminal-theme system
```

On Windows, use the same script path under `%USERPROFILE%\.config`, or run `python E:\Share\dotfiles\.config\terminal-theme\terminal-theme.py ...` from this checkout.

## How it works

- `system` reads Windows `AppsUseLightTheme`; on Linux it reads the freedesktop appearance portal. Unknown or unsupported systems fall back to dark.
- WezTerm checks its native OS appearance and applies the shared mode to every window. yazi and OpenCode follow the terminal background.
- Neovim uses `vanta` / `lauds`; Zellij uses `vesper` / `everforest-light`. The script also updates running Zellij sessions for terminals without appearance notifications.
- Runtime state is stored outside the repositories in `%LOCALAPPDATA%\terminal-theme\state` or `$XDG_STATE_HOME/terminal-theme/state` (`~/.local/state` by default).

Existing color schemes and flavors are unchanged. OpenCode uses its built-in `system` theme so it inherits WezTerm's palette.
