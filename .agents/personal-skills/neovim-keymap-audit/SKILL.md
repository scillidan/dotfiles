---
name: neovim-keymap-audit
description: Use when auditing, reviewing, or suggesting changes to Neovim keymaps. Run the audit tool to detect conflicts, stale cheatsheet entries, missing documentation, and leader prefix allocation. Also use when planning new keymaps to avoid collisions.
---

# Neovim Keymap Audit

## Tool

`~/.agents/personal-skills/neovim-keymap-audit/audit.py`

```bash
python ~/.agents/personal-skills/neovim-keymap-audit/audit.py
```

Config path auto-detected. Output: `keymap-audit.txt` next to the script.

1. **Leader prefix allocation** — which plugins own which `<leader>` prefixes
2. **Conflicts** — same key defined in multiple source files
3. **Stale cht entries** — in `neovim.cht` but not found in code
4. **Missing cht entries** — in code but not documented in `neovim.cht`
5. **All keymaps by source** — complete inventory

## Key sources

| Source | Location | What it contains |
|---|---|---|
| `vim.keymap.set` | `lua/config/*.lua`, `lua/config/keys/*.lua` | Plugin-specific keymaps (DAP, toggleterm, opencode, etc.) |
| `keys = {}` in lazy specs | `lua/config_lazy.lua` | Lazy-loaded plugin keymaps (bookmarks, buffer-sticks) |
| `wk.add({})` | `lua/config/keys/which_key.lua` | which-key registered keymaps with `group` |
| `neovim.cht` | `~/Share/files/cheatsheets/shortcut/neovim.cht` | Authoritative human-maintained cheatsheet |

## Keymap rules

### When adding new keymaps

1. **Check leader prefix allocation first.** Run the audit tool and consult the leader prefix table below.
2. **Avoid conflicts.** Same key in multiple sources = unpredictable behavior.
3. **Document in neovim.cht.** Every new keymap must have a corresponding entry in the cheatsheet.
4. **Use which-key groups.** Add `group = "+name"` to help with discoverability.

### Leader prefix allocation (established)

| Prefix | Plugin/Owner | Notes |
|---|---|---|
| `<leader>!` | which-key | Show all keymaps |
| `<leader>-` | yazi.nvim | File explorer |
| `<leader>a` | multiple-cursors | Add matches |
| `<leader>b` | buffer-sticks + bookmarks | `bb` = buffer-sticks, `bm` = bookmarks |
| `<leader>c` | bibcite + trouble | `ci/cp/co/cn` = cite, `cs/cl` = trouble |
| `<leader>d` | nvim-dap/dap-ui | Debug adapter protocol |
| `<leader>f` | telescope | `ff` find files, `fg` live grep, `fb` buffers, `fa` adjacent |
| `<leader>g` | grug-far + snipe | `gf` = grug-far, `gb` = snipe buffer menu |
| `<leader>h` | gitsigns + telescope | `hs/hr/hp/...` = gitsigns, `ht` = telescope help |
| `<leader>k` | telescope | `kk` = keymaps |
| `<leader>l` | telescope-lazy + lazygit | `lzy/lzp` = lazy plugins, `lg` = lazygit |
| `<leader>m` | md-headers | `mh` = MDHeaders |
| `<leader>n` | neoclip | Yank history |
| `<leader>q` | which-key | Quit |
| `<leader>r` | flash (visual) | Remote flash (visual mode) |
| `<leader>s` | flash + scooter | `s/S` = flash jump, `sc` = open scooter, `sr` = scooter search |
| `<leader>t` | toggleterm + tssorter | `t0-t4` = terminals, `ts` = sort |
| `<leader>u` | telescope-undo | `und` = undo history |
| `<leader>v` | love2d | `vv` run, `vs` stop |
| `<leader>w` | auto-session | `wr/ws/wa/wd` = session management |
| `<leader>x` | trouble | `xx/xX/xL/xQ` = diagnostics |
| `<leader>y` | oil.nvim | Yank (within oil buffer) |
| `<leader>z` | telescope-zoxide | `zi` = zoxide list |

### When the audit finds issues

1. **Stale cht entries** → Remove from `neovim.cht` if the keymap was intentionally removed, or add the keymap back if it was accidentally deleted.
2. **Missing cht entries** → Add to `neovim.cht` under the appropriate section.
3. **Conflicts** → Rename one of the conflicting keys. Prefer: more specific prefix (e.g. `bm` for bookmarks over `b`), or match existing convention.
4. **Unallocated prefix** → If a new plugin needs a leader prefix, pick an unused letter. Update this skill file and the which_key.lua group.

## Cheatsheet format

`neovim.cht` uses pipe-delimited format:

```
## Section Name
Neovim:: plugin: description | key
```

- `##` starts a section
- `::` separates source from section name
- `|` separates description from key

### Key notation style

In `neovim.cht`, key notation is **compact and human-readable**, NOT the same as Neovim's `<C-x>` notation:

| Neovim notation | cht notation | Rule |
|---|---|---|
| `<C-h>` | `C-H` | Modifier prefix + uppercase key |
| `<C-up>` | `C-Up` | Modifier + capital first letter |
| `<S-Tab>` | `S-Tab` | Shift + Tab |
| `<M-j>` | `A-J` | Alt = A (not M) |
| `<leader>s` | `<leader>s` | leader kept as-is |
| `<Space>` | `Spc` | Space → Spc |
| `<CR>` | `CR` | Enter → CR |
| `<Esc>` | `Esc` | Escape → Esc |
| `<BS>` | `BS` | Backspace → BS |
| `<Left>` | `Lt` | Left → Lt |
| `<Right>` | `Rt` | Right → Rt |
| `<Down>` | `Dn` | Down → Dn |
| `<Up>` | `Up` | Up stays Up |

**Rules:**
- `C-`, `S-`, `A-` are reserved for modifier keys (Ctrl, Shift, Alt)
- Single letter after modifier is **uppercase**: `C-H` means Ctrl+h, `C-h` would mean Ctrl+Shift+h
- Don't change existing entries — they were already manually reviewed
- Only apply this style to newly added entries

## Tool limitations

The audit tool's regex parsing is **best-effort**. Known false positives in "missing" report:

- Keymaps with `function()` rhs where `desc` isn't extracted (opencode, toggleterm send_lines)
- Keymaps with nerd font icons in desc string that break regex (dapui)
- Terminal-local keymaps that shouldn't be in cht anyway (`<C-h/j/k/l>` in toggleterm terminal buffer)

**When reviewing audit output:** cross-check "missing" entries against the actual cht file before adding. Many are already documented — the tool just couldn't match them.

## Practical experience

### Conflict resolution priority

1. **Plugin buffer-local > global.** Oil's `-` in which-key was global but only makes sense in Oil buffer → removed from global which-key, kept as buffer-local (Oil defines it internally).
2. **More specific prefix wins.** When `b` is shared by buffer-sticks and bookmarks, give each a sub-prefix: `bb` and `bm`.
3. **Check cht manually.** The tool can miss entries that use your compact notation (e.g. `C-Up` vs `<C-up>`). When adding new cht entries, use the compact style.
