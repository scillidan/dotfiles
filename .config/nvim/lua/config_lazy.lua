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
    -- Dependency
    {
      "nvim-tree/nvim-web-devicons",
      config = function()
        require("config.nvim_web_devicons")
      end,
    },
    -- Theme
    {
      "f-person/auto-dark-mode.nvim",
      opts = {},
    },
    {
      "emanuel2718/vanta.nvim",
      priority = 1000,
      config = function()
        require("config.vanta")
        vim.cmd.colorscheme("vanta")
      end,
    },
    {
      "projekt0n/github-nvim-theme",
      name = "github-theme",
      lazy = false,
      priority = 1000,
    },
    -- Visual
    {
      "rachartier/tiny-glimmer.nvim",
      event = "VeryLazy",
      priority = 10,
      config = function()
        require("tiny-glimmer").setup()
      end,
    },
    {
      "b0o/incline.nvim",
      event = "VeryLazy",
      dependencies = {
        { "nvim-tree/nvim-web-devicons" },
      },
      config = function()
        require("config.incline")
      end,
    },
    {
      "lewis6991/satellite.nvim",
      config = function()
        require("config.satellite")
      end,
    },
    {
      "tadaa/vimade",
      config = function()
        require("vimade").setup({
          fadelevel = 0.8,
        })
      end,
    },
    {
      "folke/twilight.nvim",
      config = function()
        require("config.twilight")
      end,
    },
    {
      "catgoose/nvim-colorizer.lua",
      event = "BufReadPre",
      config = function()
        require("colorizer").setup()
      end,
    },
    {
      "saghen/filler-begone.nvim",
    },
    -- Key
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      dependencies = { "echasnovski/mini.icons", opts = {} },
      config = function()
        require("config.which_key")
        require("config.keys.which_key")
      end,
    },

    -- treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "master",
      lazy = false,
      dependencies = { "Hdoc1509/gh-actions.nvim" },
      config = function()
        require("gh-actions.tree-sitter").setup()
        require("config.treesitter")
      end,
    },
    { "nvim-treesitter/nvim-treesitter-context" },
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      ---@module "ibl"
      ---@type ibl.config
      config = function()
        require("config.ibl")
      end,
    },
    {
      "alexmozaidze/tree-comment.nvim",
      dependencies = "nvim-treesitter/nvim-treesitter",
      opts = require("config.tree_comment"),
    },
    -- LSP
    {
      "folke/lazydev.nvim",
      ft = "lua",
      dependencies = {
        { "DrKJeff16/wezterm-types", lazy = true },
      },
      config = function()
        require("config.lazydev")
      end,
    },
    { "neovim/nvim-lspconfig" },
    {
      "mason-org/mason.nvim",
      config = function()
        require("config.mason")
      end,
    },
    {
      "mason-org/mason-lspconfig.nvim",
      config = function()
        require("config.mason_lspconfig")
      end,
    },
    {
      "junnplus/lsp-setup.nvim",
      lazy = true,
      config = function()
        require("config.lsp_setup")
      end,
    },
    -- Linter
    {
      "mfussenegger/nvim-lint",
      config = function()
        require("config.lint")
      end,
    },
    {
      "rshkarin/mason-nvim-lint",
      dependencies = { "mfussenegger/nvim-lint" },
      config = function()
        require("mason-nvim-lint").setup({
          automatic_installation = true,
        })
      end,
    },
    ---- Formatter
    {
      "stevearc/conform.nvim",
      config = function()
        require("config.conform")
      end,
    },
    {
      "zapling/mason-conform.nvim",
      config = function()
        require("mason-conform").setup()
      end,
    },
    -- CMP
    {
      "saghen/blink.cmp",
      event = { "BufReadPost", "BufNewFile" },
      version = "1.*",
      -- build = "cargo build --release",
      dependencies = {
        { "xzbdmw/colorful-menu.nvim", opt = {} },
        { "saghen/blink.compat" },
        { "rafamadriz/friendly-snippets", version = "v2.*" },
        { "erooke/blink-cmp-latex" },
        -- { "jdrupal-dev/css-vars.nvim" },
        -- { "alexandre-abrioux/blink-cmp-npm.nvim" },
        { "yus-works/csc.nvim", opts = {} },
        {
          "Dynge/gitmoji.nvim",
          ft = "gitcommit",
          config = function()
            require("gitmoji").setup({})
          end,
        },
        { "moyiz/blink-emoji.nvim" },
        {
          "Kaiser-Yang/blink-cmp-dictionary",
          dependencies = { "nvim-lua/plenary.nvim" },
        },
        { "ribru17/blink-cmp-spell" },
        { "mikavilpas/blink-ripgrep.nvim" },
        { "mgalliou/blink-cmp-tmux" },
      },
      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = require("config.blink"),
      config = function(_, opts)
        require("blink.cmp").setup(opts)
        vim.api.nvim_set_hl(0, "BlinkCmpKindDict", { default = false, fg = "#92FFB8" })
      end,
    },
    -- Snippet
    {
      "L3MON4D3/LuaSnip",
      build = vim.fn.has("win32") ~= 0 and "make install_jsregexp" or nil,
      dependencies = {
        "rafamadriz/friendly-snippets",
        "benfowler/telescope-luasnip.nvim",
      },
      config = require("config.luasnip"),
    },

    -- Markdown
    {
      "Nedra1998/nvim-mdlink",
      config = function()
        require("config.nvim_mdlink")
      end,
    },
    {
      "tttol/md-outline.nvim",
      config = function()
        require("md-outline").setup({
          auto_open = false,
        })
      end,
    },
    {
      "AntonVanAssche/md-headers.nvim",
      version = "*",
      ft = { "markdown" },
      config = function()
        require("config.md_headers")
      end,
    },
    -- CSV
    {
      "hat0uma/csvview.nvim",
      ---@module "csvview"
      ---@type CsvView.Options
      config = function()
        require("config.csvview")
      end,
      cmd = {
        "CsvViewEnable",
        "CsvViewDisable",
        "CsvViewToggle",
      },
    },
    -- Typst
    {
      "chomosuke/typst-preview.nvim",
      ft = "typst",
      version = "1.*",
      config = function()
        require("typst-preview").setup()
      end,
    },
    -- LaTeX
    {
      "iurimateus/luasnip-latex-snippets.nvim",
      dependencies = {
        { "L3MON4D3/LuaSnip" },
        { "lervag/vimtex", lazy = false },
      },
      config = function()
        require("luasnip-latex-snippets").setup() -- setup({ use_treesitter = true })
        require("luasnip").config.setup({ enable_autosnippets = false })
      end,
    },
    {
      "aidavdw/bibcite.nvim",
      cmd = {
        "CiteOpen",
        "CiteInsert",
        "CitePeek",
        "CiteNote",
      },
      config = function()
        require("config.bibcite")
      end,
    },


    -- Explorer
    {
      "stevearc/oil.nvim",
      -- dependencies = { "echasnovski/mini.icons", opts = {} },
      lazy = false,
      config = function()
        require("config.oil")
      end,
    },
    {
      "refractalize/oil-git-status.nvim",
      dependencies = {
        "stevearc/oil.nvim",
      },
      config = function()
        require("config.oil_git_status")
      end,
    },
    {
      "mikavilpas/yazi.nvim",
      version = "*", -- use the latest stable version
      event = "VeryLazy",
      dependencies = {
        { "nvim-lua/plenary.nvim", lazy = true },
      },
      ---@type YaziConfig | {}
      opts = require("config.yazi"),
      init = function()
        vim.g.loaded_netrwPlugin = 1
      end,
    },
    -- Buffer
    {
      "leath-dub/snipe.nvim",
      opts = {},
    },
    {
      "ahkohd/buffer-sticks.nvim",
      event = "VeryLazy",
      config = function()
        require("config.buffer_sticks")
      end,
      keys = require("config.keys.buffer_sticks"),
    },
    {
      "lewis6991/gitsigns.nvim",
      config = function()
        require("config.gitsigns")
      end,
    },
    -- Window
    {
      "sindrets/winshift.nvim",
      config = function()
        require("winshift").setup()
      end,
    },
    -- Session
    {
      "rmagatti/auto-session",
      lazy = false,
      config = function()
        require("config.auto_session")
      end,
      init = function()
        vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
      end,
    },
    {
      "natecraddock/workspaces.nvim",
      config = function()
        require("config.workspaces")
      end,
    },

    -- Bookmark
    {
      "otavioschwanck/arrow.nvim",
      dependencies = {
        -- { "nvim-tree/nvim-web-devicons" },
        { "echasnovski/mini.icons" },
      },
      opts = require("config.arrow"),
    },
    {
      "crusj/bookmarks.nvim",
      branch = "main",
      dependencies = { "nvim-web-devicons" },
      config = function()
        require("config.bookmarks").setup()
        require("telescope").load_extension("bookmarks")
      end,
      keys = require("config.keys.bookmarks"),
    },
    -- Fold
    {
      "chrisgrieser/nvim-origami",
      event = "VeryLazy",
      dependencies = { "lewis6991/gitsigns.nvim" },
      config = function()
        require("config.origami")
      end,
      init = function()
        vim.opt.foldlevel = 99
        vim.opt.foldlevelstart = 99
      end,
    },
    -- Goto
    {
      "dnlhc/glance.nvim",
      config = function()
        require("config.glance")
      end,
      cmd = "Glance",
    },
    -- Jump
    {
      "folke/flash.nvim",
      event = "VeryLazy",
      ---@type Flash.Config
      config = function()
        require("flash")
      end,
      -- stylua: ignore
    },
    -- Multiple-cursor
    {
      "brenton-leighton/multiple-cursors.nvim",
      version = "*",
      config = function()
        require("config.multiple_cursors")
      end,
    },
    -- Replace
    {
      "MagicDuck/grug-far.nvim",
      config = function()
        require("grug-far").setup()
      end,
    },
    -- Save
    {
      "Pocco81/auto-save.nvim",
      config = function()
        require("config.auto_save")
        if require("luasnip").in_snippet() then
          return false
        end
      end,
    },
    {
      "vladdoster/remember.nvim",
      config = function()
        require("remember").setup({
          open_folds = true,
        })
      end,
    },
    -- Sort
    {
      "mtrajano/tssorter.nvim",
      version = "*",
      ---@module "tssorter"
      ---@type TssorterOpts
      config = function()
        require("config.tssorter")
      end,
    },
    -- Yank
    {
      "AckslD/nvim-neoclip.lua",
      dependencies = {
        { "kkharji/sqlite.lua", module = "sqlite" },
      },
      config = function()
        require("config.neoclip")
      end,
      opts = { keys = require("config.keys.neoclip") },
    },

    -- mini.nvim
    {
      "echasnovski/mini.icons",
      version = "*",
      config = function()
        require("mini.icons").setup()
      end,
    },
    {
      "echasnovski/mini.statusline",
      version = "*",
      config = function()
        require("config.mini_statusline")
      end,
    },
    {
      "echasnovski/mini.cursorword",
      version = "*",
      config = function()
        require("mini.cursorword").setup()
      end,
    },
    {
      "echasnovski/mini.pairs",
      version = "*",
      config = function()
        require("config.mini_pairs")
      end,
    },
    {
      "echasnovski/mini.move",
      version = "*",
      config = function()
        require("config.mini_move")
      end,
    },
    {
      "echasnovski/mini.align",
      version = "*",
      config = function()
        require("mini.align").setup()
      end,
    },
    {
      "echasnovski/mini.surround",
      version = "*",
      config = function()
        require("mini.surround").setup()
      end,
    },
    {
      "echasnovski/mini.comment",
      version = "*",
      config = function()
        require("mini.comment").setup()
      end,
    },
    {
      "echasnovski/mini.trailspace",
      version = "*",
      config = function()
        require("mini.trailspace").setup()
        vim.api.nvim_create_user_command("TrimSpaces", function()
          require("mini.trailspace").trim()
        end, { desc = "Trim trailing spaces" })
        vim.api.nvim_create_user_command("TrimLastLines", function()
          require("mini.trailspace").trim_last_lines()
        end, { desc = "Trim last lines" })
      end,
    },
    {
      "echasnovski/mini.splitjoin",
      version = "*",
      config = function()
        require("config.mini_splitjoin")
      end,
    },
    {
      "echasnovski/mini.diff",
      version = "*",
      config = function()
        require("mini.diff").setup()
      end,
    },
    {
      "echasnovski/mini-git",
      version = "*",
      main = "mini.git",
      config = function()
        require("mini.git").setup()
      end,
    },

    -- telescope.nvim
    {
      "nvim-telescope/telescope.nvim",
      branch = "0.1.x",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("config.telescope")
      end,
    },
    { "MaximilianLloyd/adjacent.nvim" },
    { "jonarrien/telescope-cmdline.nvim" },
    { "princejoogie/dir-telescope.nvim" },
    { "tsakirist/telescope-lazy.nvim" },
    { "polirritmico/telescope-lazy-plugins.nvim" },
    { "smartpde/telescope-recent-files" },
    {
      "debugloop/telescope-undo.nvim",
    {
      "jvgrootveld/telescope-zoxide",
      dependencies = {
        { "nvim-lua/popup.nvim" },
      },
    },
    },

    -- Console
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      config = function()
        require("config.toggleterm")
        require("config.keys.toggleterm")
      end,
    },
    -- DAP
    {
      "mfussenegger/nvim-dap",
      dependencies = { "jbyuki/one-small-step-for-vimkind" },
      lazy = VaryLazy,
      config = function()
        require("config.dap")
      end,
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      config = function()
        require("nvim-dap-virtual-text").setup()
      end,
    },
    {
      "rcarriga/nvim-dap-ui",
      dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
      },
      config = function()
        require("config.dapui")
      end,
    },
    -- Debug
    {
      "folke/trouble.nvim",
      opts = {},
      cmd = "Trouble",
    },
    {
      "mfussenegger/nvim-dap-python",
      cond = vim.fn.has("unix") == 1,
      dependencies = {
        "mfussenegger/nvim-dap",
        "rcarriga/nvim-dap-ui",
      },
      ft = { "python" },
      config = function()
        local python_path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
        require("dap-python").setup(python_path)
      end,
    },
    -- Development
    {
      "S1M0N38/love2d.nvim",
      event = "VeryLazy",
      opts = {},
    },
    {
      "Mathijs-Bakker/godotdev.nvim",
      dependencies = {
        "nvim-lspconfig",
        "nvim-dap",
        "nvim-dap-ui",
        "nvim-treesitter",
      },
    },

    -- Others
    {
      "vodchella/hodur.nvim",
      config = function()
        require("config.keys.hodur")
      end,
    },
    {
      "ZWindL/orphans.nvim",
      config = function()
        require("orphans").setup({})
      end,
    },
    {
      "nickjvandyke/opencode.nvim",
      config = function()
        require("config.opencode")
        require("config.keys.opencode")
      end,
    },
    {
      "christoomey/vim-tmux-navigator",
      cond = vim.fn.has("unix") == 1,
      cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
        "TmuxNavigatorProcessList",
      },
      keys = {
        { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
        { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
        { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
        { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
        { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
      },
    },
  },
  {
      rocks = { enabled = false }
  }
)
