---
name: typst
description: Use ONLY when creating or modifying the marks-typ publishing pipeline — build scripts, justfile recipes, or Typst layout/templates. Does NOT apply to authoring content files (mark/, post/, receipt/).
---

# marks-typ Pipeline Conventions

## Architecture

A local Typst publishing pipeline: authored content → formatted PDF + JPG page images.

Two output formats:

| Format | Script | Input | Layout |
|--------|--------|-------|--------|
| A4 | `gen_a4.py` | `.md` | 2-column, optional bilingual side-by-side |
| A6 | `gen_a6.py` | `.md` | single-column |

## Directory Convention

```
marks-typ/
├── <content>/           # authored source files (.md or .typ)
├── _<content>/          # gitignored build output
│   ├── typs/            # generated .typ wrappers
│   ├── pdfs/            # compiled PDFs
│   └── *.jpg            # page images (density 150, quality 90)
└── scripts/
    ├── gen_a4.py
    └── gen_a6.py
```

- Output dir = underscore-prefixed content dir (`mark/` → `_mark/`).
- `.gitignore`: `_.*/`, `.env`, `__pycache__/`.

## Build System

### justfile

```justfile
set dotenv-load

a4 path size="" font="":
    uv run scripts/gen_a4.py "{{path}}" \
        {{ if size != "" { "--size " + size } else { "" } }} \
        {{ if font != "" { "--font \"" + font + "\"" } else { "" } }}

a4-two-column path1 path2 size="" font="":
    uv run scripts/gen_a4.py "{{path1}}" --two-column "{{path2}}" \
        {{ if size != "" { "--size " + size } else { "" } }} \
        {{ if font != "" { "--font \"" + font + "\"" } else { "" } }}

a6 path size="" font="":
    uv run scripts/gen_a6.py "{{path}}" \
        {{ if size != "" { "--size " + size } else { "" } }} \
        {{ if font != "" { "--font \"" + font + "\"" } else { "" } }}

clean dir:
    @python -c "import shutil; ..."

clean-all:
    @python -c "import shutil; ..."
```

- Runs Python scripts via `uv run` (PEP 723 inline metadata).
- Defaults: size=8pt, font="MonaspiceNe NFM, Sarasa Mono SC".

### Python Scripts Pattern

All scripts follow the same structure:

1. `check_dependencies()` — verify `typst` and `magick` on PATH, exit with install instructions if missing.
2. `generate_typ()` — produce a `.typ` wrapper file in `typs/`.
3. Compile: `typst compile --root <project_root> <typ> <pdf>`.
4. Convert: `magick -density 150 <pdf> -background white -alpha remove -quality 90 <stem>_p%02d.jpg`.
5. Cleanup temp files (processed markdown, cmarker images).

PEP 723 inline script metadata:

```python
# /// script
# requires-python = ">=3.12"
# dependencies = []
# ///
```

## A4 Pipeline Details

### Local Image Resolution

- Markdown references external images via URLs like `![](https://scillidan.github.io/cdn_image_post/<name>.ext)`. The `cdn` prefix is a naming convention meaning the resource lives on external/cloud storage.
- `MARK_IMAGES_SOURCE` env var (in `.env`) points to a local copy of those images.
- Script extracts image names from markdown, searches `MARK_IMAGES_SOURCE` for matching files (supports jpg/png/gif/svg/webp).
- Copies to `_*/images/`, then rewrites markdown to use local relative paths.
- Images also copied to cmarker package dir before compile, cleaned up after.

### Image Upscale

- When an image's width < 800px, upscale via `upscayl-bin` (model: `4xLSDIR`, target min-width: 800).
- Falls back to original if upscale fails.
- Requires Pillow for dimension check; only needed by scripts that do upscaling.

### Two-Column Comparison

`--two-column <path2>` generates a `#grid(columns: (1fr, 1fr))` with left/right markdown rendered via cmarker.

Smart stem generation: `article.md` + `article.zh-cn.md` → `article_zh-cn`. Contained stem logic handles `.en`/`.zh-cn` suffixes.

### cmarker Usage

```typst
#import "@preview/cmarker:0.1.8"

#set page(paper: "a4", margin: 2%, columns: 2)
#set text(font: ("MonaspiceNe NFM", "Sarasa Mono SC"), size: 8pt)
#set par(justify: true)
#show image: set align(center)
#set image(width: 100%)

#cmarker.render(read("<processed>.md"))
```

- `read()` path is relative to the `.typ` file location.
- `--root` must point to project root for path resolution.

## Key Dependencies

| Tool | Purpose |
|------|---------|
| `typst` | Compile .typ → PDF |
| `magick` (ImageMagick) | PDF → JPG pages |
| `uv` | Run Python scripts with inline deps |
| `upscayl-bin` | Optional image upscaling (Windows only) |
