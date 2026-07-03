local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup(
  {
    -- Theme
    { "f-person/auto-dark-mode.nvim", opts = {} },
    { "emanuel2718/vanta.nvim", priority = 1000,
      config = function()
        require("config.vanta")
        vim.cmd.colorscheme("vanta")
      end },
    { "projekt0n/github-nvim-theme", name = "github-theme", lazy = false, priority = 1000 },
    -- Visual
    {"rachartier/tiny-glimmer.nvim", event = "VeryLazy", priority = 10, opts= {} },
    { "b0o/incline.nvim", event = "VeryLazy", opts = {} },
    { "tadaa/vimade", opts = { fadelevel = 0.8} },
    { "folke/twilight.nvim", opts = { dimming = { color = {}, alpha = 0.8 } } },
    { "catgoose/nvim-colorizer.lua", event = "BufReadPre", opts = {} },
    { "saghen/filler-begone.nvim" },
    -- Key
    { "folke/which-key.nvim", event = "VeryLazy",
      dependencies = { "echasnovski/mini.icons", opts = {} },
      config = function()
        require("config.which_key")
        require("config.keys.which_key")
      end },

    -- Treesitter
    { "nvim-treesitter/nvim-treesitter", branch = "master", lazy = false,
      dependencies = { "Hdoc1509/gh-actions.nvim" },
      config = function()
        require("gh-actions.tree-sitter").setup()
        require("config.treesitter")
      end  },
    { "nvim-treesitter/nvim-treesitter-context",
      dependencies = { "nvim-treesitter/nvim-treesitter" } },
    { "ckolkey/ts-node-action", opts = {} },
    -- LSP
    { "folke/lazydev.nvim", ft = "lua",
      dependencies = { { "DrKJeff16/wezterm-types", lazy = true } },
      config = function()
        require("config.lazydev")
      end },
    { "neovim/nvim-lspconfig" },
    { "mason-org/mason.nvim",
      config = function()
        require("config.mason")
      end },
    { "mason-org/mason-lspconfig.nvim", opts = { ensure_installed = {} } },
    { "junnplus/lsp-setup.nvim", lazy = true,
      config = function()
        require("config.lsp_setup")
      end },
    -- Linter
    { "mfussenegger/nvim-lint",
      config = function()
        require("config.lint")
      end },
    { "rshkarin/mason-nvim-lint",
      dependencies = { "mfussenegger/nvim-lint" },
      opts = { automatic_installation = true } },
    -- Formatter
    { "stevearc/conform.nvim",
      config = function()
        require("config.conform")
      end  },
    { "zapling/mason-conform.nvim", opts = {} },
    -- CMP
    { "saghen/blink.cmp", event = { "BufReadPost", "BufNewFile" }, version = "1.*",
      -- build = "cargo build --release",
      dependencies = {
        { "xzbdmw/colorful-menu.nvim", opt = {} },
        { "saghen/blink.compat" },
        { "rafamadriz/friendly-snippets", version = "v2.*" },
        { "erooke/blink-cmp-latex" },
        { "alexandre-abrioux/blink-cmp-npm.nvim" },
        { "jdrupal-dev/css-vars.nvim" },
        { "disrupted/blink-cmp-conventional-commits" },
        { "Dynge/gitmoji.nvim", ft = "gitcommit",
          config = function()
            require("gitmoji").setup({})
          end },
        { "moyiz/blink-emoji.nvim" },
        { "archie-judd/blink-cmp-words" },
        { "ribru17/blink-cmp-spell" },
        { "mikavilpas/blink-ripgrep.nvim" },
        { "dynamotn/blink-cmp-zellij" },
        { "mgalliou/blink-cmp-tmux" }
      },
      config = function()
        require("config.blink")
      end,
      config = function(_, opts)
        require("blink.cmp").setup(opts)
        vim.api.nvim_set_hl(0, "BlinkCmpKindDict", { default = false, fg = "#92FFB8" })
      end },
    -- Snippet
    { "L3MON4D3/LuaSnip",
      build = "make install_jsregexp",
      dependencies = { "rafamadriz/friendly-snippets", "benfowler/telescope-luasnip.nvim" },
      config = require("config.luasnip") },

    -- Markdown
    { "rogue-87/inlyne.nvim", opts = {} },
    { "Nedra1998/nvim-mdlink", opts = { keymap = true, cmp = true } },
    { "tttol/md-outline.nvim", opts = { auto_open = false} },
    { "AntonVanAssche/md-headers.nvim", version = "*", ft = { "markdown" },
      config = function()
        require("config.md_headers")
      end },
    -- CSV
    { "hat0uma/csvview.nvim",
      opts = {
	      parser = { comments = { "#", "//" } },
        keymaps = require("config.keys.csvview") },
      cmd = require("config.cmd.csvview") },
    -- Typst
    { "chomosuke/typst-preview.nvim", version = "1.*", ft = "typst",
      config = function()
        require("typst-preview").setup()
      end },
    -- LaTeX
    { "iurimateus/luasnip-latex-snippets.nvim",
      dependencies = { { "L3MON4D3/LuaSnip" }, { "lervag/vimtex", lazy = false } },
      config = function()
        require("luasnip-latex-snippets").setup() -- setup({ use_treesitter = true })
        require("luasnip").config.setup({ enable_autosnippets = false })
      end },
    { "aidavdw/bibcite.nvim",
      cmd = require("config.cmd.bibcite") },

    -- Explorer
    { "stevearc/oil.nvim", lazy = false,
      config = function()
        require("config.oil")
      end },
    { "refractalize/oil-git-status.nvim",
      dependencies = { "stevearc/oil.nvim" },
      config = function()
        require("config.oil_git_status")
      end },
    { "mikavilpas/yazi.nvim", version = "*", event = "VeryLazy",
      dependencies = { { "nvim-lua/plenary.nvim", lazy = true } },
      config = function()
        require("config.yazi")
      end,
      init = function()
        vim.g.loaded_netrwPlugin = 1
      end  },
    -- Buffer
    { "leath-dub/snipe.nvim", opts = {} },
    { "lewis6991/gitsigns.nvim", opts = {} },
    -- Window
    { "sindrets/winshift.nvim", opts = {} },
    -- Session
    { "rmagatti/auto-session", lazy = false,
      config = function()
        require("config.auto_session")
      end,
      init = function()
        vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
      end },
    { "natecraddock/workspaces.nvim", opts = { hooks = { open = { "Telescope find_files" } } } },

    -- Bookmark
    { "otavioschwanck/arrow.nvim",
      dependencies = { "echasnovski/mini.icons" },
      config = function()
        require("config.arrow")
      end },
    { "heilgar/bookmarks.nvim",
      dependencies = { "kkharji/sqlite.lua", "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
      config = function()
        require("bookmarks").setup({
          default_mappings = true,
          db_path = vim.fn.stdpath("data") .. "/bookmarks.db"
        })
        require("telescope").load_extension("bookmarks")
      end,
      cmd = require("config.cmd.bookmarks") },
    -- Diff
    { "esmuellert/codediff.nvim", cmd = "CodeDiff", opts={} },
    -- Fold
    { "chrisgrieser/nvim-origami", event = "VeryLazy",
      dependencies = { "lewis6991/gitsigns.nvim" },
      config = function()
        require("config.origami")
      end,
      init = function()
        vim.opt.foldlevel = 99
        vim.opt.foldlevelstart = 99
      end },
    -- Goto
    { "dnlhc/glance.nvim", cmd = "Glance",
      config = function()
        require("config.glance")
      end },
    -- Jump
    { "folke/flash.nvim", event = "VeryLazy", opts = {} },
    -- Multiple-cursor
    { "brenton-leighton/multiple-cursors.nvim", version = "*",
      config = function()
        require("config.multiple_cursors")
      end },
    -- Replace
    { "MagicDuck/grug-far.nvim", opts = {} },
    -- Save
    { "Pocco81/auto-save.nvim",
      config = function()
        require("auto-save").setup({
          enabled = false,
        })
        if require("luasnip").in_snippet() then
          return false
        end
      end },
    { "vladdoster/remember.nvim", opts = { open_folds = true } },
    -- Sort
    { "mtrajano/tssorter.nvim", version = "*", opts = {} },
    -- Yank
    { "nemanjamalesija/smart-paste.nvim", event = "VeryLazy", opts = {} },
    { "AckslD/nvim-neoclip.lua",
      dependencies = { { "kkharji/sqlite.lua", module = "sqlite" } },
      config = function()
        require("config.neoclip")
      end },

    -- mini.nvim
    { "echasnovski/mini.icons", version = "*", opts = {} },
    { "echasnovski/mini.statusline", version = "*",
      config = function()
        require("config.mini_statusline")
      end },
    { "echasnovski/mini.cursorword", version = "*", opts = {} },
    { "echasnovski/mini.pairs", version = "*",
      config = function()
        require("config.mini_pairs")
      end },
    { "echasnovski/mini.move", version = "*",
      opts = {
      	mappings = require("config.keys.mini_move"),
        options = { reindent_linewise = true } } },
    { "echasnovski/mini.align", version = "*",
      config = function()
        require("mini.align").setup()
      end },
    { "echasnovski/mini.surround", version = "*",
      config = function()
        require("mini.surround").setup()
      end },
    { "echasnovski/mini.comment", version = "*",
      config = function()
        require("mini.comment").setup()
      end },
    { "echasnovski/mini.trailspace", version = "*",
      config = function()
        require("mini.trailspace").setup()
        vim.api.nvim_create_user_command("TrimSpaces", function()
          require("mini.trailspace").trim()
        end, { desc = "Trim trailing spaces" })
        vim.api.nvim_create_user_command("TrimLastLines", function()
          require("mini.trailspace").trim_last_lines()
        end, { desc = "Trim last lines" })
      end },
    { "echasnovski/mini.splitjoin", version = "*",
      opts = { mappings = require("config.keys.mini_splitjoin") } },
    { "echasnovski/mini.diff", version = "*",
      config = function()
        require("mini.diff").setup()
      end },
    { "echasnovski/mini-git", version = "*", main = "mini.git",
      config = function()
        require("mini.git").setup()
      end },

    -- telescope.nvim
    { "nvim-telescope/telescope.nvim", branch = "0.1.x",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("config.telescope")
      end },
    { "2kabhishek/seeker.nvim", cmd = { "Seeker" },
        opts = { picker_provider = "telescope" } },
    { "jonarrien/telescope-cmdline.nvim" },
    { "princejoogie/dir-telescope.nvim" },
    { "tsakirist/telescope-lazy.nvim" },
    { "polirritmico/telescope-lazy-plugins.nvim" },
    { "smartpde/telescope-recent-files" },
    { "debugloop/telescope-undo.nvim" },
    { "jvgrootveld/telescope-zoxide",
    	dependencies = { "nvim-lua/popup.nvim" } },
    -- Console
    { "akinsho/toggleterm.nvim", version = "*",
      config = function()
        require("config.toggleterm")
        require("config.keys.toggleterm")
        require("config.scooter")
      end },
    -- DAP
    { "mfussenegger/nvim-dap", lazy = VaryLazy,
    	dependencies = { "jbyuki/one-small-step-for-vimkind" },
      config = function()
        require("config.dap")
      end },
    { "theHamsta/nvim-dap-virtual-text", opts = {} },
    { "rcarriga/nvim-dap-ui",
      dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
      config = function()
        require("config.dapui")
      end },
    -- Debug
    { "folke/trouble.nvim", opts = {}, cmd = "Trouble" },
    { "mfussenegger/nvim-dap-python", ft = { "python" },
      cond = vim.fn.has("unix") == 1,
      dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" },
      config = function()
        local python_path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
        require("dap-python").setup(python_path)
      end },
    -- Development
    { "S1M0N38/love2d.nvim", enabled = false, event = "VeryLazy", opts = {} },
    { "Mathijs-Bakker/godotdev.nvim",
      dependencies = { "nvim-lspconfig", "nvim-dap", "nvim-dap-ui", "nvim-treesitter" } },
    -- LLM
    { "nickjvandyke/opencode.nvim",
      config = function()
        vim.g.opencode_opts = {}
        vim.o.autoread = true
      end },
    { "TabbyML/vim-tabby", enabled = false, lazy = false,
      dependencies = { "neovim/nvim-lspconfig" },
      init = function()
        -- bun add -g tabby-agent@latest
        vim.g.tabby_agent_start_command = {"tabby-agent", "--stdio"}
        vim.g.tabby_inline_completion_trigger = "auto"
      end },

    -- Others
    { "vodchella/hodur.nvim",
      config = function()
        require("config.keys.hodur")
      end },
    { "ZWindL/orphans.nvim", opts = {} },
    { "christoomey/vim-tmux-navigator",
      cond = vim.fn.has("unix") == 1,
      cmd = require("config.cmd.vim_tmux_navigator"),
      keys = function()
        return require("config.keys.vim_tmux_navigator")
      end },
    rocks = { enabled = true }
  }
)
