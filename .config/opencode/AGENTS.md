<!-- cq:start -->
## CQ

Before starting any implementation task, load the `cq` skill and follow its Core Protocol.
<!-- cq:end -->

## Windows shell: never use `find`

On Windows the bare `find` is `find.exe` (the file-find utility), NOT GNU find,
and its flags/behavior are incompatible with the search tasks you'll be asked
to do. **Never run `find` on this machine.**

Use these instead:
- Content search → the `rg`/`grep` tools or `fff_grep` / `fff_multi_grep`.
- Finding files by name → `fff_find_files` or `glob`.
- Counting / filtering shell output → use `rg -c` or pipe to `rg`, not `find`.
- Listing a directory → `read` on the directory path, or `rg` with the
  appropriate glob, never `dir /s`.
