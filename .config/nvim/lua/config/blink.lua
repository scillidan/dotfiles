return {
  completion = {
    -- ghost_text = {
    --   enabled = true,
    -- },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    },
    list = {
      selection = {
        preselect = function(ctx)
          return not require("blink.cmp").snippet_active({ direction = 1 })
        end,
      },
    },
    menu = {
      border = "none",
      draw = {
        padding = 0,
        gap = 1,
        columns = {
          { "label", "label_description", gap = 1 },
          { "kind_icon", "kind", "source_name", gap = 1 },
        },
        components = {
          label = {
            text = function(ctx)
              return require("colorful-menu").blink_components_text(ctx)
            end,
            highlight = function(ctx)
              return require("colorful-menu").blink_components_highlight(ctx)
            end,
          },
        },
      },
    },
  },
  snippets = {
    preset = "luasnip",
  },
  sources = {
    default = function()
      local result = {
        "lazydev",
        "lsp",
        "path",
        "snippets",
        "buffer",
        "conventional_commits",
        "ripgrep",
        "zellij",
        "tmux",
        "spell"
      }

      if vim.tbl_contains({ "gitcommit", "jj" }, vim.bo.filetype) then
        table.insert(result, "gitmoji")
      end
      if vim.tbl_contains({ "gitcommit", "markdown", "text" }, vim.bo.filetype) then
        table.insert(result, "emoji")
      end
      if vim.tbl_contains({ "markdown", "text" }, vim.bo.filetype) or inside_comment_block() then
        table.insert(result, "dictionary")
      end
      if vim.bo.filetype == "markdown" then
        table.insert(result, "mdlink")
      end
      if vim.bo.filetype == "tex" then
        table.insert(result, "latex")
      end
      if vim.tbl_contains({ "javascript", "typescript", "javascriptreact", "typescriptreact" }, vim.bo.filetype) then
        table.insert(result, "npm")
      end
      if vim.tbl_contains({ "css", "scss", "less", "javascript", "typescript" }, vim.bo.filetype) then
        table.insert(result, "css_vars")
      end

      return result
    end,

    per_filetype = {
      opencode_ask = { "lsp", "buffer" }
    },

    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
      },
      --https://linkarzu.com/posts/neovim/blink-cmp-updates/#disabled-lsp-fallbcks
      lsp = {
        name = "LSP",
        module = "blink.cmp.sources.lsp",
        fallbacks = {}
      },
      snippets = {
        name = "snippets",
        module = "blink.cmp.sources.snippets",
        should_show_items = function()
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
          return before_cursor:match("s%w*$") ~= nil -- Simplified trigger check
        end,
        transform_items = function(_, items)
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
          local trigger_pos = before_cursor:find("s[^s]*$")
          if trigger_pos then
            for _, item in ipairs(items) do
              item.textEdit = {
                newText = item.insertText or item.label,
                range = {
                  start = { line = vim.fn.line(".") - 1, character = trigger_pos - 1 },
                  ["end"] = { line = vim.fn.line(".") - 1, character = col },
                },
              }
            end
          end
          return items
        end,
      },
      buffer = {
        opts = {
          get_bufnrs = function()
            return vim.tbl_filter(function(bufnr)
              return vim.bo[bufnr].buftype == ""
            end, vim.api.nvim_list_bufs())
          end,
        },
      },
      conventional_commits = {
          name = 'Conventional Commits',
          module = 'blink-cmp-conventional-commits',
          enabled = function()
              return vim.bo.filetype == 'gitcommit'
          end,
          ---@module 'blink-cmp-conventional-commits'
          ---@type blink-cmp-conventional-commits.Options
          -- https://github.com/disrupted/blink-cmp-conventional-commits#configuration
          opts = {},
      },
      gitmoji = {
        name = "Gitmoji",
        module = "gitmoji.blink",
        opts = {
          filetypes = { "gitcommit", "jj" },
        },
      },
      mdlink = {
        name = "mdlink",
        module = "blink.compat.source",
      },
      latex = {
        name = "LaTeX",
        module = "blink-cmp-latex",
        opts = {
        	-- https://github.com/disrupted/blink-cmp-conventional-commits#configuration
          insert_command = function(ctx)
            local ft = vim.api.nvim_get_option_value("filetype", {
              scope = "local",
              buf = ctx.bufnr,
            })
            if ft == "tex" then
              return true
            end
            return false
          end,
        },
      },
      npm = {
        name = "NPM",
        module = "blink-cmp-npm",
        async = true,
        ---@module "blink-cmp-npm"
        ---@type blink-cmp-npm.Options
        opts = {
          ignore = {},
          only_semantic_versions = true,
          only_latest_version = false,
        },
      },
      css_vars = {
        name = "CssVars",
        module = "css-vars.blink",
        opts = {
          search_extensions = { ".js", ".ts", ".jsx", ".tsx" },
        },
      },
      emoji = {
        module = "blink-emoji",
        name = "Emoji",
        opts = {
          insert = true,
          ---@type string|table|fun():table
          trigger = function()
            return { ":" }
          end,
        },
        should_show_items = function()
          return vim.tbl_contains(
          	{ "gitcommit", "markdown", "text" },
          	vim.o.filetype
          )
        end,
      },
			dictionary = {
				name = "blink-cmp-words",
				module = "blink-cmp-words.dictionary",
				opts = {}
			},
      spell = {
        name = "Spell",
        module = "blink-cmp-spell",
        score_offset = 40,
        opts = {
          enable_in_context = function()
            local spelllang = vim.opt_local.spelllang:get()
            local has_en = false
            for _, l in ipairs(spelllang) do
              if l:match("^en") then has_en = true; break end
            end
            if not has_en then return false end

            local curpos = vim.api.nvim_win_get_cursor(0)
            local captures = vim.treesitter.get_captures_at_pos(0, curpos[1] - 1, curpos[2] - 1)
            local in_spell_capture = false
            for _, cap in ipairs(captures) do
              if cap.capture == "spell" then
                in_spell_capture = true
              elseif cap.capture == "nospell" then
                return false
              end
            end
            return in_spell_capture
          end,
        },
      },
      ripgrep = {
        module = "blink-ripgrep",
        name = "Ripgrep",
        opts = {
          prefix_min_len = 7,
          backend = {
            context_size = 5,
            ripgrep = {
              max_filesize = "1M",
              project_root_fallback = true,
              search_casing = "--ignore-case",
              additional_rg_options = {},
              ignore_paths = {},
              additional_paths = {},
            },
          },
          toggles = {
            on_off = nil,
            debug = nil,
          },
          future_features = {
            backend = {
              use = "ripgrep",
            },
          },
          debug = false,
        },
        transform_items = function(_, items)
          for _, item in ipairs(items) do
            item.labelDetails = {
              description = "(rg)",
            }
          end
          return items
        end,
      },
      zellij = {
        module = "blink-cmp-zellij",
        name = "zellij",
        -- https://github.com/dynamotn/blink-cmp-zellij#installation--configuration
        opts = {},
      },
      tmux = {
        module = "blink-cmp-tmux",
        name = "tmux",
        --https://github.com/mgalliou/blink-cmp-tmux?tab=readme-ov-file#installation--configuration
        opts = {},
      },
    },
  },
  fuzzy = {
    implementation = "lua",
    sorts = {
      function(a, b)
        local sort = require("blink.cmp.fuzzy.sort")
        if a.source_id == "spell" and b.source_id == "spell" then
          return sort.label(a, b)
        end
      end,
      "score",
      "kind",
      "label",
    },
  },
  cmdline = {
    keymap = {
      preset = "none",
      ["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        "snippet_forward",
        "fallback",
      },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
    },
    completion = {
      menu = {
        auto_show = true,
        draw = {
          columns = {
            { "label" },
          },
        },
      },
    },
  },
  signature = {
    enabled = true,
  },
  keymap = {
    preset = "super-tab",
    ["<C-g>"] = {
      function()
        require("blink-cmp").show({ providers = { "ripgrep" } })
      end,
    },
  },
}
