<!-- cq:start -->
## CQ

Before starting any implementation task, load the `cq` skill and follow its Core Protocol.

This runtime has no cq MCP server.
The cq skill and `/cq-*` commands describe the protocol using MCP-tool wording; in this runtime,
perform every cq action by running the cq CLI through your shell.
Parse `--format json` output for the commands that support it (query, propose, status); confirm and
flag return plain text.
The cq binary is: `E:\Scoop\apps\cq\current\cq.exe`.

### E:\Scoop\apps\cq\current\cq.exe query

```
      --domain stringArray      Domain tags to search (required, repeatable)
      --format string           Output format: text or json (default "text")
      --framework stringArray   Filter by framework (repeatable)
      --language stringArray    Filter by programming language (repeatable)
      --limit int               Maximum results (default 5)
      --pattern string          Filter by pattern
```

### E:\Scoop\apps\cq\current\cq.exe propose

```
      --action string           Recommended action (required)
      --detail string           Detailed explanation (required)
      --domain stringArray      Domain tags (required, repeatable)
      --format string           Output format: text or json (default "text")
      --framework stringArray   Framework context (repeatable)
      --language stringArray    Programming language context (repeatable)
      --pattern string          Pattern context
      --summary string          Brief summary of the insight (required)
```

### E:\Scoop\apps\cq\current\cq.exe confirm <unit_id>

### E:\Scoop\apps\cq\current\cq.exe flag <unit_id>

```
      --detail string         Optional detail for why the unit was flagged
      --duplicate-of string   Original unit ID when reason is duplicate
      --reason reason         Flag reason (one of: duplicate, incorrect, stale)
```

### E:\Scoop\apps\cq\current\cq.exe status

```
      --format string   Output format: text or json (default "text")
```

<!-- cq:end -->
