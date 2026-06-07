require("lsp-setup").setup({
	servers = {
		bashls = {},
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
		html = {},
		jdtls = {},
		jsonls = {},
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
		yamlls = {},
		-- emmet_language_server = {},
		-- eslint = {},
		-- nextls = {},
		-- tailwindcss = {},
	},
})
