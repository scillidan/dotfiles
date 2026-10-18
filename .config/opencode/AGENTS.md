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

<!-- context7 -->
Use Context7 MCP to fetch current documentation whenever the user asks about a library, framework, SDK, API, CLI tool, or cloud service — even well-known ones like React, Next.js, Prisma, Express, Tailwind, Django, or Spring Boot. This includes API syntax, configuration, version migration, library-specific debugging, setup instructions, and CLI tool usage. Use even when you think you know the answer — your training data may not reflect recent changes. Prefer this over web search for library docs.

Do not use for: refactoring, writing scripts from scratch, debugging business logic, code review, or general programming concepts.

## Steps

1. Always start with `resolve-library-id` using the library name and what to look up in the library's documentation, unless the user provides an exact library ID in `/org/project` format
2. Pick the best match (ID format: `/org/project`) by: exact name match, description relevance, code snippet count, source reputation (High/Medium preferred), and benchmark score (higher is better). If results don't look right, try alternate names or queries (e.g., "next.js" not "nextjs", or rephrase the question). Use version-specific IDs when the user mentions a version
3. `query-docs` with the selected library ID and what to look up in the library's documentation (not single words), scoped to a single concept. If the question spans multiple distinct concepts (e.g. routing and auth and caching), make a separate `query-docs` call per concept with the same library ID, unless the question is about how the concepts interact — combined queries dilute ranking and return shallow results for each topic
4. Answer using the fetched docs
<!-- context7 -->
