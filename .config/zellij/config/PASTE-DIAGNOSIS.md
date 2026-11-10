# P6 / paste diagnosis: reproduce Zellij's real client-side paste path.

Zellij 0.45.1 turns one terminal paste into **three** `Action::Write` messages
(start marker, text, end marker) with **no ordering guarantee** between them.
The probe below replays exactly that, so we can see whether the corruption in
nvim comes from the split itself or from something else.

## How to run

In a Zellij pane:

```bat
cls
```

Then from any other terminal, three times in a row:

```bat
zellij --session <SESSION> action write 27 91 50 48 48 126
zellij --session <SESSION> action write 65 65 65 13 10 66 66 66 13 10
zellij --session <SESSION> action write 27 91 50 48 49 126
```

(`27 91 50 48 48 126` = `ESC[200~`, `65 65 65 13 10 66 66 66 13 10` = `AAA\r\nBBB\r\n`,
`27 91 50 48 49 126` = `ESC[201~`.)

Then dump the pane and compare with the expected 3 lines `AAA` / `BBB` / `AAA`.

## Reference

- `zellij-client/src/input_handler.rs` (`InputEvent::Paste` -> three `dispatch_action(Action::Write ...)`).
- Upstream: #5333 (Windows multi-line paste ordering/junk), #5840 (still lists
  Windows multi-line bracketed paste as not fixed).
