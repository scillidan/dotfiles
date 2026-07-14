return {
    setup = function(mc, wk)
        wk.add({
            { "<up>", function() mc.lineAddCursor(-1) end, mode = { "n", "x" }, desc = "Add cursor up" },
            { "<down>", function() mc.lineAddCursor(1) end, mode = { "n", "x" }, desc = "Add cursor down" },
            { "<leader><up>", function() mc.lineSkipCursor(-1) end, mode = { "n", "x" }, desc = "Skip cursor up" },
            { "<leader><down>", function() mc.lineSkipCursor(1) end, mode = { "n", "x" }, desc = "Skip cursor down" },
            { "<leader>n", function() mc.matchAddCursor(1) end, mode = { "n", "x" }, desc = "Add cursor (next match)" },
            { "<leader>s", function() mc.matchSkipCursor(1) end, mode = { "n", "x" }, desc = "Skip cursor (next match)" },
            { "<leader>N", function() mc.matchAddCursor(-1) end, mode = { "n", "x" }, desc = "Add cursor (prev match)" },
            { "<leader>S", function() mc.matchSkipCursor(-1) end, mode = { "n", "x" }, desc = "Skip cursor (prev match)" },
            { "<c-q>", mc.toggleCursor, mode = { "n", "x" }, desc = "Toggle cursor" },
            { "<c-leftmouse>", mc.handleMouse, mode = "n", desc = "Add cursor (mouse)" },
            { "<c-leftdrag>", mc.handleMouseDrag, mode = "n", desc = "Drag cursor (mouse)" },
            { "<c-leftrelease>", mc.handleMouseRelease, mode = "n", desc = "Release cursor (mouse)" },
            -- Advanced multicursor keybindings
            { "ga", mc.addCursorOperator, mode = { "n", "x" }, desc = "Add cursor operator (e.g. gaip)" },
            { "<leader><c-q>", mc.duplicateCursors, mode = { "n", "x" }, desc = "Clone every cursor" },
            { "<leader>a", mc.alignCursors, mode = "n", desc = "Align cursor columns" },
            { "S", mc.splitCursors, mode = "x", desc = "Split visual selections by regex" },
            { "M", mc.matchCursors, mode = "x", desc = "Match cursors by regex" },
            { "<leader>gv", mc.restoreCursors, mode = "n", desc = "Restore cursors" },
            { "<leader>A", mc.matchAllAddCursors, mode = { "n", "x" }, desc = "Add cursor for all matches" },
            { "<leader>t", function() mc.transposeCursors(1) end, mode = "x", desc = "Rotate cursors forward" },
            { "<leader>T", function() mc.transposeCursors(-1) end, mode = "x", desc = "Rotate cursors backward" },
            { "I", mc.insertVisual, mode = "x", desc = "Insert at each cursor (multiline)" },
            { "A", mc.appendVisual, mode = "x", desc = "Append at each cursor (multiline)" },
            { "g<c-a>", mc.sequenceIncrement, mode = { "n", "x" }, desc = "Increment sequence" },
            { "g<c-x>", mc.sequenceDecrement, mode = { "n", "x" }, desc = "Decrement sequence" },
            { "<leader>/n", function() mc.searchAddCursor(1) end, mode = "n", desc = "Search: add cursor next" },
            { "<leader>/N", function() mc.searchAddCursor(-1) end, mode = "n", desc = "Search: add cursor prev" },
            { "<leader>/s", function() mc.searchSkipCursor(1) end, mode = "n", desc = "Search: skip cursor next" },
            { "<leader>/S", function() mc.searchSkipCursor(-1) end, mode = "n", desc = "Search: skip cursor prev" },
            { "<leader>/A", mc.searchAllAddCursors, mode = "n", desc = "Search: add cursor to all" },
            { "<leader>m", mc.operator, mode = { "n", "x" }, desc = "Match operator (e.g. <leader>miw)" },
            { "]d", function() mc.diagnosticAddCursor(1) end, mode = { "n", "x" }, desc = "Diagnostic: add cursor next" },
            { "[d", function() mc.diagnosticAddCursor(-1) end, mode = { "n", "x" }, desc = "Diagnostic: add cursor prev" },
            { "]s", function() mc.diagnosticSkipCursor(1) end, mode = { "n", "x" }, desc = "Diagnostic: skip cursor next" },
            { "[S", function() mc.diagnosticSkipCursor(-1) end, mode = { "n", "x" }, desc = "Diagnostic: skip cursor prev" },
            { "md", function()
                mc.diagnosticMatchCursors({ severity = vim.diagnostic.severity.ERROR })
            end, mode = { "n", "x" }, desc = "Match error diagnostics (e.g. mdip)" },
        })

        mc.addKeymapLayer(function(layerSet)
            wk.add({
                { "<left>",  mc.prevCursor, mode = { "n", "x" }, desc = "Prev cursor" },
                { "<right>", mc.nextCursor, mode = { "n", "x" }, desc = "Next cursor" },
                { "<leader>x", mc.deleteCursor, mode = { "n", "x" }, desc = "Delete cursor" },
                { "<esc>", function()
                    if not mc.cursorsEnabled() then
                        mc.enableCursors()
                    else
                        mc.clearCursors()
                    end
                end, mode = "n", desc = "Clear / Enable cursors" },
            })
        end)
    end,
}
