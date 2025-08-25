local M = {}

function M.setup(opts)
	if opts then
		require("luasnip").config.setup(opts)
	end

	vim.tbl_map(function(type)
		require("luasnip.loaders.from_" .. type).lazy_load()
	end, {
		"vscode",
		-- "snipmate",
		-- "lua",
	})

	-- https://github.com/rafamadriz/friendly-snippets/wiki#extending-via-lazynvim
	-- require("luasnip").filetype_extend("sh", { "shelldoc" })
	-- require("luasnip").filetype_extend("lua", { "luadoc" })
	-- require("luasnip").filetype_extend("python", { "pydoc" })
	-- require("luasnip").filetype_extend("typescript", { "tsdoc" })
	-- require("luasnip").filetype_extend("javascript", { "jsdoc" })

	-- require("luasnip.loaders.from_vscode").lazy_load()
	-- require("luasnip.loaders.from_vscode").lazy_load({ include = { "latex" } })
	require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })
end

return M.setup
