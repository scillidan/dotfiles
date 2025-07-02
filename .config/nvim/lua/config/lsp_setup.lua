require("lsp-setup").setup({
	servers = {
		lua_ls = {
			--https://github.com/LuaLS/lua-language-server/issues/2975
			-- 	cmd = { "lua-language-server", "--force-accept-workspace" },
			-- 	filetypes = { "lua" },
			-- 	root_markers = { ".luarc.json", ".luarc.jsonc" },
			-- 	settings = {
			-- 		lua = {
			-- 			runtime = {
			-- 				version = "LuaJIT",
			-- 			},
			-- 			diagnostics = {
			-- 				globals = { "nvim" },
			-- 			},
			-- 			{
			-- 				workspace = {
			-- 					library = {
			-- 						vim.fn.expand("$VIMRUNTIME/lua"),
			-- 						vim.fn.expand("$XDG_CONFIG_HOME") .. "/nvim/lua",
			-- 					},
			-- 				},
			-- 			},
			-- 		},
			-- 	},
		},
		pylsp = {},
		tinymist = {
			cmd = { "tinymist" },
			filetypes = { "typst" },
		},
		bashls = {},
		yamlls = {},
		html = {},
		cssls = {},
		harper_ls = {
			userDictPath = "",
			fileDictPath = "",
			linters = {
				SpellCheck = false,
				SpelledNumbers = false,
				AnA = true,
				SentenceCapitalization = false,
				UnclosedQuotes = true,
				WrongQuotes = false,
				LongSentences = true,
				RepeatedWords = true,
				Spaces = true,
				Matcher = true,
				CorrectNumberSuffix = true,
			},
			codeActions = {
				ForceStable = false,
			},
			markdown = {
				IgnoreLinkTitle = true,
			},
			diagnosticSeverity = "hint",
			dialect = "American",
		},
		-- eslint = {},
		-- tailwindcss = {},
		-- emmet_language_server = {},
		-- nextls = {},
	},
})
