local wk = require("which-key")

wk.add({
  -- Theme
  {
    "<leader>sth",
    function()
      if vim.g.current_theme == "vanta" then
        vim.cmd("colorscheme github_light_colorblind")
        vim.g.current_theme = "github_light_colorblind"
      else
        vim.cmd("colorscheme vanta")
        vim.g.current_theme = "vanta"
      end
    end,
    desc = "Toggle theme",
    mode = "n",
    group = "+theme",
  },

  -- scooter
  { "<leader>sc", function() require("config.scooter").open_scooter() end, desc = "Open scooter", mode = "n", group = "+scooter" },
  { "<leader>sr", group = "+scooter" },

  -- Key
  { "<leader>!", '<Cmd>lua require("which-key").show({ global = false })<CR>', desc = "which-key.show", mode = "n", group = "+key" },

  -- Markdown
  { "<leader>mh", "<Cmd>MDHeadersCurrent<CR>", desc = "MDHeadersCurrent", mode = "n", group = "+markdown" },

  -- LaTeX
  { "<leader>ci", "<Cmd>CiteInsert<CR>", desc = "CiteInsert", group = "+latex/cite" },
  { "<leader>cp", "<Cmd>CitePeek<CR>", desc = "CitePeek", group = "+latex/cite" },
  { "<leader>co", "<Cmd>CiteOpen<CR>", desc = "CiteOpen", group = "+latex/cite" },
  { "<leader>cn", "<Cmd>CiteNote<CR>", desc = "CiteNote", group = "+latex/cite" },

  -- Explorer
  { "<leader>-", "<Cmd>Yazi<CR>", desc = "Open yazi at the current file", mode = { "n", "v" }, group = "+explorer" },
  { "<leader>cw", "<Cmd>Yazi cwd<CR>", desc = "Open the file manager in nvim's working directory", group = "+explorer" },
  { "<C-up>", "<Cmd>Yazi toggle<CR>", desc = "Resume the last yazi session", group = "+explorer" },

  -- Buffer
  { "<leader>gb", '<Cmd>lua require("snipe").open_buffer_menu()<CR>', desc = "Open Snipe buffer menu", mode = "n", group = "+buffer" },
  { "<leader>bb", group = "+buffer/sticks" },

  -- Window
  { "<leader>w", group = "+window" },

  -- Session
  { "<leader>wr", "<Cmd>AutoSession search<CR>", desc = "AutoSession search", group = "+session" },
  { "<leader>ws", "<Cmd>AutoSession save<CR>", desc = "AutoSession save", group = "+session" },
  { "<leader>wa", "<Cmd>AutoSession toggle<CR>", desc = "AutoSession toggle", group = "+session" },
  { "<leader>wd", "<Cmd>AutoSession delete<CR>", desc = "AutoSession delete", group = "+session" },

  -- Goto
  { "gR", "<Cmd>Glance references<CR>", desc = "Glance references<CR>", mode = "n", group = "+goto" },
  { "gD", "<Cmd>Glance definitions<CR>", desc = "Glance definitions<CR>", mode = "n", group = "+goto" },
  { "gY", "<Cmd>Glance type_definitions<CR>", desc = "Glance type_definitions<CR>", mode = "n", group = "+goto" },
  { "gM", "<Cmd>Glance implementations<CR>", desc = "Glance implementations<CR>", mode = "n", group = "+goto" },

  -- Jump (flash)
  { "<leader>s", group = "+flash" },
  { "<leader>r", group = "+flash" },
  { "<leader>R", group = "+flash" },

  -- Multiple-cursor
  { "<leader>a", "<Cmd>MultipleCursorsAddMatches<CR>", mode = { "n", "x" }, desc = "MultipleCursorsAddMatches", group = "+cursor" },

  -- Replace
  { "<leader>gf", '<Cmd>lua require("grug-far").open({ engine = "astgrep" })<CR>', desc = "grug-far.open", mode = "n", group = "+replace" },

  -- Sort
  { "<leader>ts", "<Cmd>TSSort list<CR>", desc = "TSSort list", mode = "n", group = "+sort" },
  { "<leader>ts", "<Esc><Cmd>TSSort list<CR>", desc = "TSSort list", mode = "v", group = "+sort" },

  -- Yank
  { "<leader>n", "<Cmd>Telescope neoclip<CR>", desc = "Telescope neoclip", group = "+yank" },

  -- telescope.nvim
  { "<leader>k", group = "+telescope" },
  { "<leader>f", group = "+telescope" },
  { "<leader>ht", "<Cmd>Telescope help_tags<CR>", desc = "Telescope help_tags", mode = "n", group = "+telescope" },
  { "Q", "<Cmd>Telescope cmdline<CR>", desc = "Telescope cmdline", mode = "n", group = "+telescope" },
  { "<leader>dfg", "<Cmd>Telescope dir live_grep<CR>", desc = "Telescope dir live_grep", mode = "n", group = "+telescope" },
  { "<leader>dff", "<Cmd>Telescope dir find_files<CR>", desc = "Telescope dir find_files", mode = "n", group = "+telescope" },
  { "<leader>lzy", "<Cmd>Telescope lazy<CR>", desc = "Telescope lazy", mode = "n", group = "+telescope" },
  { "<leader>lzp", "<Cmd>Telescope lazy_plugins<CR>", desc = "Telescope lazy_plugins", mode = "n", group = "+telescope" },
  { "<leader>R", "<Cmd>lua require('telescope').extensions.recent_files.pick()<CR>", desc = "Telescope recent_files", mode = "n", group = "+telescope" },
  { "<leader>und", "<Cmd>Telescope undo<CR>", desc = "Telescope undo", group = "+telescope" },
  { "<leader>zi", "<Cmd>Telescope zoxide list<CR>", desc = "Telescope zoxide list", mode = "n", group = "+telescope" },

  -- Debug
  { "<leader>x", group = "+trouble" },
  { "<leader>cs", "<Cmd>Trouble symbols toggle focus=false<CR>", desc = "Trouble symbols toggle", group = "+trouble" },
  { "<leader>cl", "<Cmd>Trouble lsp toggle focus=false win.position=right<CR>", desc = "Trouble lsp toggle", group = "+trouble" },

  -- DAP
  { "<leader>d", group = "+dap" },

  -- Development
  { "<leader>v", group = "+love2d" },

  -- Git
  { "<leader>h", group = "+gitsigns" },

  -- Terminal
  { "<leader>t", group = "+terminal" },

  -- Console
  { "<leader>lg", group = "+console" },
})
