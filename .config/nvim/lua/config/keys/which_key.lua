local wk = require("which-key")
local oc = require("opencode")

wk.add({
  -- Theme
  {
    "<leader>sth",
    function()
      if vim.g.current_theme == "vanta" then
        vim.cmd("colorscheme lauds")
        vim.g.current_theme = "lauds"
      else
        vim.cmd("colorscheme vanta")
        vim.g.current_theme = "vanta"
      end
    end,
    desc = "Toggle theme",
    mode = "n",
  },

  -- Key
  { "<leader>!", '<Cmd>lua require("which-key").show({ global = false })<CR>', desc = "which-key.show", mode = "n" },
  -- Snippet
  --  { "<C-k>", '<Cmd>lua require("luasnip").expand()<CR>', desc = "luasnip expand", mode = { "i", "s" } },
  --  { "<C-h>", '<Cmd>lua require("luasnip").jump(-1)<CR>', desc = "luasnip jump(-1)", mode = { "i", "s" } },
  --  { "<C-l>", '<Cmd>lua require("luasnip").jump(1)<CR>', desc = "luasnip jump(1)", mode = { "i", "s" } },
  -- Treesitter
  { "K", require("ts-node-action").node_action, desc = "Trigger Node Action", mode = "n" },

  -- Markdown
  { "<leader>mh", "<Cmd>MDHeadersCurrent<CR>", desc = "MDHeadersCurrent", mode = "n" },
  -- LaTeX
  { "<leader>ci", "<Cmd>CiteInsert<CR>", desc = "CiteInsert" },
  { "<leader>cp", "<Cmd>CitePeek<CR>", desc = "CitePeek" },
  { "<leader>co", "<Cmd>CiteOpen<CR>", desc = "CiteOpen" },
  { "<leader>cn", "<Cmd>CiteNote<CR>", desc = "CiteNote" },

  -- Explorer
  { "<leader>-", "<Cmd>Yazi<CR>", desc = "Open yazi at the current file", mode = { "n", "v" } },
  { "<leader>cw", "<Cmd>Yazi cwd<CR>", desc = "Open the file manager in nvim's working directory" },
  { "<C-up>", "<Cmd>Yazi toggle<CR>", desc = "Resume the last yazi session" },
  -- Buffer
  { "<leader>gb", '<Cmd>lua require("snipe").open_buffer_menu()<CR>', desc = "Open Snipe buffer menu", mode = "n", group = "+buffer" },
  -- Window
  { "<C-w>m", "<Cmd>WinShift<CR>", desc = "WinShift" },
  { "<C-w>X", "<Cmd>WinShift swap<CR>", desc = "WinShift swap" },
  { "<C-M-h>", "<Cmd>WinShift left<CR>", desc = "WinShift left" },
  { "<C-M-j>", "<Cmd>WinShift down<CR>", desc = "WinShift down" },
  { "<C-M-k>", "<Cmd>WinShift up<CR>", desc = "WinShift up" },
  { "<C-M-l>", "<Cmd>WinShift right<CR>", desc = "WinShift right" },
  -- Session
  { "<leader>wr", "<Cmd>AutoSession search<CR>", desc = "AutoSession search" },
  { "<leader>ws", "<Cmd>AutoSession save<CR>", desc = "AutoSession save" },
  { "<leader>wa", "<Cmd>AutoSession toggle<CR>", desc = "AutoSession toggle" },
  { "<leader>wd", "<Cmd>AutoSession delete<CR>", desc = "AutoSession delete" },

  -- Bookmarks
  { "<leader>ba", "<Cmd>BookmarkAdd<CR>", desc = "Add Bookmark" },
  { "<leader>br", "<Cmd>BookmarkRemove<CR>", desc = "Remove Bookmark" },
  { "<leader>bj", desc = "Jump to Next Bookmark" },
  { "<leader>bk", desc = "Jump to Previous Bookmark" },
  { "<leader>bl", "<Cmd>Bookmarks<CR>", desc = "List Bookmarks" },
  { "<leader>bs", desc = "Switch Bookmark List" },
  -- Goto
  { "gR", "<Cmd>Glance references<CR>", desc = "Glance references", mode = "n" },
  { "gD", "<Cmd>Glance definitions<CR>", desc = "Glance definitions", mode = "n" },
  { "gY", "<Cmd>Glance type_definitions<CR>", desc = "Glance type_definitions", mode = "n" },
  { "gM", "<Cmd>Glance implementations<CR>", desc = "Glance implementations", mode = "n" },
  -- Replace
  { "<leader>gf", '<Cmd>lua require("grug-far").open({ engine = "astgrep" })<CR>', desc = "grug-far.open", mode = "n" },
  { "<leader>cr", function() require("config.scooter").open_scooter() end, desc = "Open scooter", mode = "n" },
  {
    "<leader>cR",
    function()
      local text = vim.fn.getreg("v")
      if text == "" then
        text = vim.fn.getreg("a")
      end
      require("config.scooter").open_scooter_with_text(text)
    end,
    desc = "Search selected text in scooter",
    mode = "v",
  },
  -- Sort
  { "<leader>ts", "<Cmd>TSSort list<CR>", desc = "TSSort list", mode = "n" },
  { "<leader>ts", "<Esc><Cmd>TSSort list<CR>", desc = "TSSort list", mode = "v" },
  -- Yank
  { "<leader>clp", "<Cmd>Telescope neoclip<CR>", desc = "Telescope neoclip" },

  -- telescope.nvim
  { "<leader>ft", "<Cmd>Telescope help_tags<CR>", desc = "Telescope help_tags", mode = "n" },
  { "<leader>fk", "<Cmd>Telescope keymaps<CR>", desc = "Telescope keymaps", mode = "n" },
  { "<leader>fb", "<Cmd>Telescope buffers<CR>", desc = "Telescope buffers", mode = "n" },
  -- { "<leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Telescope find_files", mode = "n" },
  -- { "<leader>fg", "<Cmd>Telescope live_grep<CR>", desc = "Telescope live_grep", mode = "n" },
  { "<leader>ff", "<Cmd>Seeker files<CR>", desc = "Seek Files" },
  { "<leader>sg", "<Cmd>Seeker git_files<CR>", desc = "Seek Git Files" },
  { "<leader>fg", "<Cmd>Seeker grep<CR>", desc = "Seek Grep" },
  { "<leader>sw", "<Cmd>Seeker grep_word<CR>", desc = "Seek Grep Word" },
  { "Q", "<Cmd>Telescope cmdline<CR>", desc = "Telescope cmdline", mode = "n" },
  { "<leader>lzy", "<Cmd>Telescope lazy<CR>", desc = "Telescope lazy", mode = "n" },
  { "<leader>lzp", "<Cmd>Telescope lazy_plugins<CR>", desc = "Telescope lazy_plugins", mode = "n" },
  { "<leader>R", "<Cmd>lua require('telescope').extensions.recent_files.pick()<CR>", desc = "Telescope recent_files", mode = "n" },
  { "<leader>U", "<Cmd>Telescope undo<CR>", desc = "Telescope undo" },
  { "<leader>zi", "<Cmd>Telescope zoxide list<CR>", desc = "Telescope zoxide list", mode = "n" },

  -- Debug
  { "<leader>xx", "<Cmd>Trouble diagnostics toggle<CR>", desc = "Trouble diagnostics toggle" },
  { "<leader>xX", "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Trouble diagnostics toggle filter.buf=0" },
  { "<leader>cs", "<Cmd>Trouble symbols toggle focus=false<CR>", desc = "Trouble symbols toggle" },
  { "<leader>cl", "<Cmd>Trouble lsp toggle focus=false win.position=right<CR>", desc = "Trouble lsp toggle" },
  { "<leader>xL", "<Cmd>Trouble loclist toggle<CR>", desc = "Trouble loclist toggle" },
  { "<leader>xQ", "<Cmd>Trouble qflist toggle<CR>", desc = "Trouble qflist toggle" },
  -- DAP
  { "<leader>du", function() require("dapui").toggle() end, desc = "DAP: Toggle UI", mode = "n" },
  { "<leader>ds", function() require("dap").continue() end, desc = "Start/Continue", mode = "n" },
  { "<F1>", function() require("dap").continue() end, desc = "Start/Continue", mode = "n" },
  { "<leader>di", function() require("dap").step_into() end, desc = "Step into", mode = "n" },
  { "<F2>", function() require("dap").step_into() end, desc = "Step into", mode = "n" },
  { "<leader>do", function() require("dap").step_over() end, desc = "Step over", mode = "n" },
  { "<F3>", function() require("dap").step_over() end, desc = "Step over", mode = "n" },
  { "<leader>dO", function() require("dap").step_out() end, desc = "Step out", mode = "n" },
  { "<F4>", function() require("dap").step_out() end, desc = "Step out", mode = "n" },
  { "<leader>dq", function() require("dap").close() end, desc = "DAP: Close session", mode = "n" },
  { "<leader>dQ", function() require("dap").terminate() end, desc = "Terminate session", mode = "n" },
  { "<leader>dr", function() require("dap").restart_frame() end, desc = "DAP: Restart", mode = "n" },
  { "<F5>", function() require("dap").restart_frame() end, desc = "DAP: Restart", mode = "n" },
  { "<leader>dc", function() require("dap").run_to_cursor() end, desc = "DAP: Run to Cursor", mode = "n" },
  { "<leader>dR", function() require("dap").repl.toggle() end, desc = "DAP: Toggle REPL", mode = "n" },
  { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "DAP: Hover", mode = "n" },
  { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP: Breakpoint", mode = "n" },
  { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition for breakpoint:")) end, desc = "DAP: Conditional BP", mode = "n" },
  { "<leader>dD", function() require("dap").clear_breakpoints() end, desc = "DAP: Clear Breakpoints", mode = "n" },
  -- Development
  { "<leader>vv", "<Cmd>LoveRun<CR>", desc = "Love Run" },
  { "<leader>vs", "<Cmd>LoveStop<CR>", desc = "Love Stop" },
  -- LLM
  -- https://github.com/nickjvandyke/opencode.nvim#-setup
  { "<leader>oa", function() oc.ask("@this: ", { submit = true }) end, desc = "Ask opencode", mode = { "n", "x" } },
  { "<leader>os", function() oc.select() end, desc = "Execute opencode action…", mode = { "n", "x" } },
  { "go", function() return oc.operator("@this ") end, expr = true, desc = "Add range to opencode", mode = { "n", "x" } },
  { "goo", function() return oc.operator("@this ") .. "_" end, expr = true, desc = "Add line to opencode", mode = "n" },
  { "<S-C-u>", function() oc.command("session.half.page.up") end, desc = "opencode half page up", mode = "n" },
  { "<S-C-d>", function() oc.command("session.half.page.down") end, desc = "opencode half page down", mode = "n" },

  -- Others
  { "<c-h>", "<Cmd><C-U>TmuxNavigateLeft<CR>", desc = "Tmux Navigate Left" },
  { "<c-j>", "<Cmd><C-U>TmuxNavigateDown<CR>", desc = "Tmux Navigate Down" },
  { "<c-k>", "<Cmd><C-U>TmuxNavigateUp<CR>", desc = "Tmux Navigate Up" },
  { "<c-l>", "<Cmd><C-U>TmuxNavigateRight<CR>", desc = "Tmux Navigate Right" },
  { "<c-\\>", "<Cmd><C-U>TmuxNavigatePrevious<CR>", desc = "Tmux Navigate Previous" },
})

