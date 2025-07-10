require("lsp-setup").setup({
	servers = {
		lua_ls = {
			-- settings = {
			-- 	Lua = {
			-- 		diagnostics = { "vim" },
			-- 		workspace = {
			-- 			library = vim.api.nvim_get_runtime_file("", true),
			-- 			checkThirdParty = false,
			-- 		},
			-- 		telemetry = {
			-- 			enable = false,
			-- 		},
			-- 	},
			-- },
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
		jsonls = {},
		-- eslint = {},
		-- tailwindcss = {},
		-- emmet_language_server = {},
		-- nextls = {},
	},
})
