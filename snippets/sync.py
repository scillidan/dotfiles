#!/usr/bin/env python3
"""Sync snippets from src/ into Sublime Text and nvim (LuaSnip) targets.

  src/sublime-text/*.sublime-snippet  -> copied to Sublime, converted for nvim
  src/neovim/<ft>.json|.lua           -> nvim only (copied verbatim; ft = filename stem)
  src/neovim/*.sublime-snippet        -> nvim only (converted)
  src/scope-map.toml                  -> sublime <scope> -> vim filetype

Targets are generated, do not edit them. Usage: sync.py [sync|list|init]
"""

import json
import shutil
import sys
import tomllib
import xml.etree.ElementTree as ET
from pathlib import Path

ROOT = Path(__file__).resolve().parent
SRC = ROOT / "src"
SUB_DIR = ROOT.parent / ".config" / "sublime-text" / "Packages" / "User" / "Snippets"
NVIM_DIR = ROOT.parent / ".config" / "nvim" / "snippets"
GROUPS = ("sublime-text", "neovim")


def die(msg):
    sys.exit(f"sync: {msg}")


def load_map():
    with open(SRC / "scope-map.toml", "rb") as f:
        return tomllib.load(f)["map"]


def parse_snippet(path, scope_map):
    root = ET.parse(path).getroot()
    content = root.find("content")
    trigger = root.findtext("tabTrigger")
    if content is None or not trigger:
        die(f"{path.name}: missing <content> or <tabTrigger>")
    scope = root.findtext("scope")
    if not scope:
        die(f"{path.name}: missing <scope> (needed for the nvim side)")
    sel = scope.split()[0]  # first selector only; ignore "- exclusions"
    ft = scope_map.get(sel)
    if ft is None:
        die(f"{path.name}: scope '{sel}' not in scope-map.toml — add it")
    return {
        "prefix": trigger.strip(),
        "body": (content.text or "").replace("$SELECTION", "$TM_SELECTED_TEXT"),
        "description": (root.findtext("description") or "").strip(),
        "ft": ft,
    }


def collect_converted(scope_map):
    by_ft = {}
    for group in GROUPS:
        for f in sorted((SRC / group).glob("*.sublime-snippet")):
            snip = parse_snippet(f, scope_map)
            entry = {"prefix": snip["prefix"], "body": snip["body"]}
            if snip["description"]:
                entry["description"] = snip["description"]
            bucket = by_ft.setdefault(snip["ft"], {})
            if snip["prefix"] in bucket:
                print(
                    f"note: '{snip['prefix']}' in {snip['ft']} overwritten by {f.name}"
                )
            bucket[snip["prefix"]] = entry
    return by_ft


def cmd_sync():
    by_ft = collect_converted(load_map())
    lua_files = []
    for f in sorted((SRC / "neovim").iterdir()):
        if f.suffix == ".json":
            try:
                data = json.loads(f.read_text(encoding="utf-8"))
            except json.JSONDecodeError as e:
                die(f"{f.name}: invalid JSON: {e}")
            bucket = by_ft.setdefault(f.stem, {})
            for key, entry in data.items():
                if key in bucket:
                    print(
                        f"note: neovim/{f.name} overrides converted '{key}' ({f.stem})"
                    )
                bucket[key] = entry
        elif f.suffix == ".lua":
            lua_files.append(f)
        elif f.suffix == ".sublime-snippet":
            pass  # already handled by collect_converted
        elif f.is_file() and f.name != ".gitkeep":
            die(f"neovim/{f.name}: unknown type (use .sublime-snippet/.json/.lua)")

    user_dir = NVIM_DIR / "user"
    lua_dir = NVIM_DIR / "lua"
    if user_dir.exists():
        shutil.rmtree(user_dir)
    if lua_dir.exists():
        shutil.rmtree(lua_dir)
    user_dir.mkdir(parents=True)
    lua_dir.mkdir(parents=True)
    for ft, bucket in sorted(by_ft.items()):
        (user_dir / f"{ft}.json").write_text(
            json.dumps(bucket, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
        )
    for f in lua_files:
        shutil.copy2(f, lua_dir / f.name)
    if not lua_files:
        (lua_dir / ".gitkeep").write_text("", encoding="utf-8")

    pkg = {"name": "user-snippets", "contributes": {"snippets": []}}
    for ft in sorted(by_ft, key=lambda x: (x != "all", x)):
        pkg["contributes"]["snippets"].append(
            {"language": [ft], "path": f"./user/{ft}.json"}
        )
    (NVIM_DIR / "package.json").write_text(
        json.dumps(pkg, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )

    sources = {
        f.name: f for f in sorted((SRC / "sublime-text").glob("*.sublime-snippet"))
    }
    SUB_DIR.mkdir(parents=True, exist_ok=True)
    for old in SUB_DIR.glob("*.sublime-snippet"):
        if old.name not in sources:
            old.unlink()
            print(f"remove: {old.name}")
    for name, f in sources.items():
        shutil.copy2(f, SUB_DIR / name)

    print(
        f"nvim:  {sum(len(b) for b in by_ft.values())} snippets, "
        f"{len(by_ft)} filetypes, {len(lua_files)} lua -> {NVIM_DIR}"
    )
    print(f"sublime: {len(sources)} snippets -> {SUB_DIR}")


def cmd_list():
    scope_map = load_map()
    for group in GROUPS:
        files = sorted((SRC / group).iterdir()) if (SRC / group).exists() else []
        files = [f for f in files if f.is_file() and f.name != ".gitkeep"]
        print(f"[{group}] ({len(files)})")
        for f in files:
            if f.suffix == ".sublime-snippet":
                snip = parse_snippet(f, scope_map)
                print(f"  {snip['prefix']:<20} {f.name}  -> {snip['ft']}")
            else:
                print(f"  {'':<20} {f.name}  -> {f.stem}")


def cmd_init():
    """Adopt existing snippets from the two target dirs into src/ (run once)."""
    n_sub = 0
    for f in sorted(SUB_DIR.glob("*.sublime-snippet")):
        dst = SRC / "sublime-text" / f.name
        if dst.exists():
            print(f"skip (already in src): {f.name}")
            continue
        shutil.copy2(f, dst)
        n_sub += 1

    by_ft = collect_converted(load_map())
    global_prefixes = {e["prefix"] for b in by_ft.values() for e in b.values()}

    for f in sorted((NVIM_DIR / "user").glob("*.json")):
        ft = f.stem
        data = json.loads(f.read_text(encoding="utf-8"))
        kept, dropped = {}, {}
        for key, entry in data.items():
            prefs = entry.get("prefix", "")
            prefs = prefs if isinstance(prefs, list) else [prefs]
            dup = any(p in by_ft.get(ft, {}) for p in prefs) or (
                ft == "all" and any(p in global_prefixes for p in prefs)
            )
            (dropped if dup else kept)[key] = entry
        if kept:
            dst = SRC / "neovim" / f.name
            if dst.exists():
                print(f"skip (already in src): {f.name}")
            else:
                dst.write_text(
                    json.dumps(kept, ensure_ascii=False, indent=2) + "\n",
                    encoding="utf-8",
                )
                print(
                    f"import: neovim/{f.name} ({len(kept)} kept, {len(dropped)} dropped)"
                )
        else:
            print(f"import: {f.name} fully duplicate ({len(dropped)} dropped)")
    for f in sorted((NVIM_DIR / "lua").glob("*.lua")):
        dst = SRC / "neovim" / f.name
        if not dst.exists():
            shutil.copy2(f, dst)
            print(f"import: neovim/{f.name}")
    print(f"\ninit done: {n_sub} sublime -> sublime-text/. Review, then run: just sync")


if __name__ == "__main__":
    for group in GROUPS:  # ensure src layout exists
        (SRC / group).mkdir(parents=True, exist_ok=True)
    match sys.argv[1] if len(sys.argv) > 1 else "sync":
        case "sync":
            cmd_sync()
        case "list":
            cmd_list()
        case "init":
            cmd_init()
        case _:
            die("usage: sync.py [sync|list|init]")
