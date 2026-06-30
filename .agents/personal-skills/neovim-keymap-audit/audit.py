"""
nvim-keymap-audit.py — Scans Neovim config keymaps vs neovim.cht cheatsheet.
Usage: uv run nvim-keymap-audit.py
"""

import os, re, sys
from pathlib import Path
from collections import defaultdict


def find_nvim_config():
    home = os.environ.get("USERPROFILE", os.path.expanduser("~"))
    for c in [
        Path(home) / "Share/dotfiles/.config/nvim",
        Path(home) / ".config/nvim",
        Path(home) / "AppData/Local/nvim",
    ]:
        if (c / "lua").exists():
            return c
    return None


def extract_string(s):
    """Extract string content from a Lua string literal."""
    s = s.strip()
    if s.startswith("[["):
        return s[2:-2] if s.endswith("]]") else s[2:]
    if (s.startswith('"') and s.endswith('"')) or (
        s.startswith("'") and s.endswith("'")
    ):
        return s[1:-1]
    return s


def parse_vim_keymap_set(content, source):
    """Extract keymaps using simple regex on vim.keymap.set calls."""
    maps = []
    # Match: vim.keymap.set(modes, lhs, rhs, {opts})
    # This regex handles multi-line by matching up to the closing )
    for m in re.finditer(
        r"""vim\.keymap\.set\s*\(\s*
            ((?:["'][nvoixct]["']\s*,\s*)*["'][nvoixct]["']|[{]\s*["'][nvoixct]["'](?:\s*,\s*["'][nvoixct]["'])*\s*[}])  # modes
            \s*,\s*
            (["'](?:[^"']+)["']|[^,]+?)  # lhs
            \s*,\s*
            (.+?)  # rhs + opts (greedy until last ) before end of line or comma)
            \s*\)""",
        content,
        re.VERBOSE | re.DOTALL,
    ):
        modes_raw = m.group(1)
        lhs_raw = m.group(2)
        rest = m.group(3)

        # Parse modes
        modes = re.findall(r"['\"]([nvoixct])['\"]", modes_raw) or ["?"]

        # Parse lhs
        lhs = extract_string(lhs_raw)

        # Parse desc from rest
        desc = None
        dm = re.search(r"""desc\s*=\s*["']([^"']+)["']""", rest)
        if dm:
            desc = dm.group(1)

        # Clean rhs
        rhs_clean = rest.strip().rstrip(",")
        # Remove trailing opts table
        bm = re.search(r"""^(.+?)\s*,\s*[{]""", rhs_clean)
        if bm:
            rhs_clean = bm.group(1).rstrip(",")
        if "function" in rhs_clean and len(rhs_clean) > 30:
            rhs_clean = "<lua function>"
        else:
            rhs_clean = extract_string(rhs_clean)

        maps.append(
            {
                "lhs": lhs,
                "rhs": rhs_clean,
                "desc": desc or "",
                "modes": modes,
                "source": source,
                "type": "vim.keymap.set",
            }
        )
    return maps


def parse_lazy_keys(content, source):
    """Extract keymaps from lazy.nvim keys = { ... } specs."""
    maps = []
    for m in re.finditer(
        r"""["'](<[^"']+>)["']\s*,\s*["']([^"']*)["']\s*,\s*desc\s*=\s*["']([^"']+)["']""",
        content,
    ):
        maps.append(
            {
                "lhs": m.group(1),
                "rhs": m.group(2),
                "desc": m.group(3),
                "modes": ["n"],
                "source": source,
                "type": "lazy.keys",
            }
        )
    return maps


def parse_which_key(content, source):
    """Extract keymaps from which-key wk.add() blocks."""
    maps = []
    for m in re.finditer(
        r"""["'](<[^"']+>|[gQ\-+])["']\s*,\s*
            (["'][^"']*["']|function\(\)[^}]*end)
            \s*,\s*
            desc\s*=\s*["']([^"']+)["']""",
        content,
        re.VERBOSE | re.DOTALL,
    ):
        lhs = m.group(1)
        rhs_raw = m.group(2)
        desc = m.group(3)

        rhs = rhs_raw.strip()
        if rhs.startswith("function"):
            rhs = "<lua function>"
        elif rhs.startswith(('"', "'")):
            rhs = rhs[1:-1]

        maps.append(
            {
                "lhs": lhs,
                "rhs": rhs,
                "desc": desc,
                "modes": ["n"],
                "source": source,
                "type": "which-key",
            }
        )
    return maps


def parse_cheatsheet(filepath):
    entries = []
    if not os.path.exists(filepath):
        return entries
    section = ""
    with open(filepath, encoding="utf-8") as f:
        for line in f:
            line = line.rstrip()
            if line.startswith("## "):
                section = line[3:].split("::")[0].strip()
            elif " | " in line:
                parts = [p.strip() for p in line.split(" | ")]
                if len(parts) >= 3 and parts[2]:
                    entries.append(
                        {"key": parts[2], "desc": parts[1], "section": section}
                    )
    return entries


def normalize(k):
    return (
        k.replace("<Leader>", "<leader>")
        .replace("<Space>", " ")
        .replace("<CR>", "<CR>")
        .replace("<Esc>", "<esc>")
    )


def collect_all_maps(config_root):
    all_maps = []
    keys_dir = config_root / "lua/config/keys"
    config_dir = config_root / "lua/config"
    lazy_config = config_root / "lua/config_lazy.lua"

    if keys_dir.exists():
        for fp in sorted(keys_dir.glob("*.lua")):
            src = f"keys/{fp.name}"
            content = fp.read_text(encoding="utf-8", errors="ignore")
            if fp.name == "which_key.lua":
                all_maps.extend(parse_which_key(content, src))
            else:
                all_maps.extend(parse_vim_keymap_set(content, src))

    if config_dir.exists():
        for fp in sorted(config_dir.glob("*.lua")):
            content = fp.read_text(encoding="utf-8", errors="ignore")
            all_maps.extend(parse_vim_keymap_set(content, fp.name))

    if lazy_config.exists():
        content = lazy_config.read_text(encoding="utf-8", errors="ignore")
        all_maps.extend(parse_lazy_keys(content, "config_lazy.lua"))

    return all_maps


def generate_report(all_maps, cht_entries):
    lines = []
    p = lines.append
    p("=" * 70)
    p("  NEOVIM KEYMAP AUDIT")
    p("=" * 70)

    # ── Leader prefix allocation ──
    p("")
    p("## Leader prefix allocation")
    p("")
    prefix_usage = defaultdict(list)
    for m in all_maps:
        l = normalize(m["lhs"])
        if re.match(r"^<leader>\S", l):
            prefix = re.match(r"^(<leader>\S)", l).group(1)
            prefix_usage[prefix].append(m)
    for prefix in sorted(prefix_usage.keys()):
        items = prefix_usage[prefix]
        sources = sorted(
            set(m["source"].replace(".lua", "").split("/")[-1] for m in items)
        )
        p(f"  {prefix:<14} {len(items):>2} maps  ({', '.join(sources)})")

    # ── Conflicts ──
    p("")
    p("## Conflicts (same key in multiple sources)")
    p("")
    key_defs = defaultdict(list)
    for m in all_maps:
        key_defs[normalize(m["lhs"])].append(m)
    found = False
    for k in sorted(key_defs.keys()):
        defs = key_defs[k]
        if len(defs) > 1 and len(set(d["source"] for d in defs)) > 1:
            found = True
            p(f"  {k}")
            for d in defs:
                p(f"    {d['source']:<30} -> {d.get('desc', '(no desc)')}")
            p("")
    if not found:
        p("  No conflicts.")

    # ── Stale cht ──
    p("")
    p("## In cheatsheet but NOT in code (stale)")
    p("")
    code_keys = set(normalize(m["lhs"]) for m in all_maps)
    stale = [e for e in cht_entries if normalize(e["key"]) not in code_keys]
    if stale:
        for e in stale:
            p(f"  {e['key']:<20} {e['desc']:<40} [{e['section']}]")
        p(f"\n  ({len(stale)} stale)")
    else:
        p("  All cht entries have code matches.")

    # ── Missing cht ──
    p("")
    p("## In code but NOT in cheatsheet (missing)")
    p("")
    cht_keys = set(normalize(e["key"]) for e in cht_entries)
    seen = set()
    missing = []
    for m in all_maps:
        nk = normalize(m["lhs"])
        if nk not in cht_keys and nk not in seen:
            seen.add(nk)
            if re.match(r"^(<leader>|g[A-Z]|<[CFS]-)", nk):
                missing.append(m)
    if missing:
        for m in sorted(missing, key=lambda x: x["lhs"]):
            p(f"  {m['lhs']:<20} {m.get('desc', '(no desc)'):<30} {m['source']}")
        p(f"\n  ({len(missing)} missing)")
    else:
        p("  All code keymaps are documented.")

    # ── By source ──
    p("")
    p("## All keymaps by source")
    p("")
    by_source = defaultdict(list)
    for m in all_maps:
        by_source[m["source"]].append(m)
    for src in sorted(by_source.keys()):
        p(f"  [{src}] ({len(by_source[src])} maps)")
        for m in sorted(by_source[src], key=lambda x: x["lhs"]):
            d = m.get("desc", "") or m.get("rhs", "")
            p(f"    {m['lhs']:<20} -> {d}")
        p("")
    p("=" * 70)
    return "\n".join(lines)


def main():
    config_root = find_nvim_config()
    if not config_root:
        print("ERROR: config not found.")
        sys.exit(1)
    cht_path = os.path.expanduser("~/Share/files/cheatsheets/shortcut/neovim.cht")
    all_maps = collect_all_maps(config_root)
    cht_entries = parse_cheatsheet(cht_path) if os.path.exists(cht_path) else []
    report = generate_report(all_maps, cht_entries)
    out_path = Path(__file__).parent / "keymap-audit.txt"
    out_path.write_text(report, encoding="utf-8")
    try:
        print(report)
    except UnicodeEncodeError:
        print(report.encode("ascii", errors="replace").decode("ascii"))
    print(f"\nSaved: {out_path}")


if __name__ == "__main__":
    main()
