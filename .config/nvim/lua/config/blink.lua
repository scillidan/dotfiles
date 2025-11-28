--nvim-mdlink
-- local has_mdlink, mdlink = pcall(require, "nvim-mdlink.cmp")
-- if has_mdlink then
-- 	require("cmp").register_source("mdlink", mdlink.new())
-- end

--blink-cmp-dictionary
local function inside_comment_block()
	if vim.api.nvim_get_mode().mode ~= "i" then
		return false
	end
	local node_under_cursor = vim.treesitter.get_node()
	local parser = vim.treesitter.get_parser(nil, nil, { error = false })
	local query = vim.treesitter.query.get(vim.bo.filetype, "highlights")
	if not parser or not node_under_cursor or not query then
		return false
	end
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1
	for id, node, _ in query:iter_captures(node_under_cursor, 0, row, row + 1) do
		if query.captures[id]:find("comment") then
			local start_row, start_col, end_row, end_col = node:range()
			if start_row <= row and row <= end_row then
				if start_row == row and end_row == row then
					if start_col <= col and col <= end_col then
						return true
					end
				elseif start_row == row then
					if start_col <= col then
						return true
					end
				elseif end_row == row then
					if col <= end_col then
						return true
					end
				else
					return true
				end
			end
		end
	end
	return false
end

return {
	completion = {
		-- ghost_text = {
		-- 	enabled = true,
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
				"latex",
				-- "npm",
				-- "css_vars",
				-- "mdlink",
				"buffer",
				"csc",
				"gitmoji",
				"emoji",
				"ripgrep",
				"tmux",
				"spell",
			}
			if vim.tbl_contains({ "markdown", "text" }, vim.bo.filetype) or inside_comment_block() then
				table.insert(result, "dictionary")
			end
			return result
		end,
		providers = {
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				score_offset = 100,
			},
			--https://linkarzu.com/posts/neovim/blink-cmp-updates/#disabled-lsp-fallbcks
			-- lsp = {
			-- 	name = "lsp",
			-- 	enabled = true,
			-- 	module = "blink.cmp.sources.lsp",
			-- 	kind = "LSP",
			-- 	min_keyword_length = 3,
			-- 	score_offset = 90,
			-- },
			-- snippets = {
			-- 	name = "snippets",
			-- 	enabled = true,
			-- 	max_items = 15,
			-- 	min_keyword_length = 2,
			-- 	module = "blink.cmp.sources.snippets",
			-- 	score_offset = 85,
			-- 	should_show_items = function()
			-- 		local col = vim.api.nvim_win_get_cursor(0)[2]
			-- 		local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
			-- 		return before_cursor:match(trigger_text .. "%w*$") ~= nil
			-- 	end,
			-- 	transform_items = function(_, items)
			-- 		local col = vim.api.nvim_win_get_cursor(0)[2]
			-- 		local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
			-- 		local trigger_pos = before_cursor:find(trigger_text .. "[^" .. trigger_text .. "]*$")
			-- 		if trigger_pos then
			-- 			for _, item in ipairs(items) do
			-- 				item.textEdit = {
			-- 					newText = item.insertText or item.label,
			-- 					range = {
			-- 						start = { line = vim.fn.line(".") - 1, character = trigger_pos - 1 },
			-- 						["end"] = { line = vim.fn.line(".") - 1, character = col },
			-- 					},
			-- 				}
			-- 			end
			-- 		end
			-- 		vim.schedule(function()
			-- 			require("blink.cmp").reload("snippets")
			-- 		end)
			-- 		return items
			-- 	end,
			-- },
			latex = {
				name = "LaTeX",
				module = "blink-cmp-latex",
				opts = {
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
			-- css_vars = {
			-- 	name = "CssVars",
			-- 	module = "css-vars.blink",
			-- 	opts = {
			-- 		search_extensions = { ".js", ".ts", ".jsx", ".tsx" },
			-- 	},
			-- },
			-- npm = {
			-- 	name = "NPM",
			-- 	module = "blink-cmp-npm",
			-- 	async = true,
			-- 	score_offset = 100,
			-- 	---@module "blink-cmp-npm"
			-- 	---@type blink-cmp-npm.Options
			-- 	opts = {
			-- 		ignore = {},
			-- 		only_semantic_versions = true,
			-- 		only_latest_version = false,
			-- 	},
			-- },
			mdlink = {
				name = "mdlink",
				module = "blink.compat.source",
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
			gitmoji = {
				name = "Gitmoji",
				module = "gitmoji.blink",
				opts = {
					filetypes = { "gitcommit", "jj" },
				},
			},
			emoji = {
				module = "blink-emoji",
				name = "Emoji",
				score_offset = 15,
				opts = {
					insert = true,
					---@type string|table|fun():table
					trigger = function()
						return { ":" }
					end,
				},
				should_show_items = function()
					return vim.tbl_contains({ "gitcommit", "markdown", "text" }, vim.o.filetype)
				end,
			},
			dictionary = {
				module = "blink-cmp-dictionary",
				name = "Dict",
				min_keyword_length = 4,
				opts = {
					-- dictionary_files = { vim.fn.expand('~/.config/nvim/dictionary/words.dict') },
					dictionary_directories = { vim.fn.expand("~/.config/nvim/dictionary") },
				},
			},
			spell = {
				name = "Spell",
				module = "blink-cmp-spell",
				opts = {
					enable_in_context = function()
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
					-- future_features = {
					-- 	backend = {
					-- 		use = "ripgrep",
					-- 	},
					-- },
					debug = false,
				},
				-- transform_items = function(_, items)
				-- 	for _, item in ipairs(items) do
				-- 		item.labelDetails = {
				-- 			description = "(rg)",
				-- 		}
				-- 	end
				-- 	return items
				-- end,
			},
			tmux = {
				--https://github.com/mgalliou/blink-cmp-tmux?tab=readme-ov-file#installation--configuration
				module = "blink-cmp-tmux",
				name = "tmux",
				opts = {
					all_panes = false,
					capture_history = false,
					triggered_only = false,
					trigger_chars = { "." },
				},
			},
		},
	},
	-- fuzzy = {
	-- 	sorts = {
	-- 		function(a, b)
	-- 			local sort = require("blink.cmp.fuzzy.sort")
	-- 			if a.source_id == "spell" and b.source_id == "spell" then
	-- 				return sort.label(a, b)
	-- 			end
	-- 		end,
	-- 		"score",
	-- 		"kind",
	-- 		"label",
	-- 	},
	-- },
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
	--https://github.com/Saghen/blink.cmp/issues/1222
	config = function(_, opts)
		local original = require("blink.cmp.completion.list").show
		---@diagnostic disable-next-line: duplicate-set-field
		require("blink.cmp.completion.list").show = function(ctx, items_by_source)
			local seen = {}
			local function filter(item)
				if seen[item.label] then
					return false
				end
				seen[item.label] = true
				return true
			end
			for id in vim.iter(opts.sources.priority) do
				items_by_source[id] = items_by_source[id] and vim.iter(items_by_source[id]):filter(filter):totable()
			end
			return original(ctx, items_by_source)
		end
		require("blink.cmp").setup(opts)
	end,
}
