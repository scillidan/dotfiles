local env = require("env")

require("toggleterm").setup({
	-- insert_mappings = false, -- Relevant
	-- terminal_mappings = false, --  Relevant
	shade_terminals = false,
	start_in_insert = true,
	size = vim.o.columns * 0.1,
	open_mapping = [[<c-\>]],
	shell = function()
		if env.is_windows then
			-- return vim.o.shell .. vim.o.shellcmdflag
			return "cmd.exe /k C:/Users/User/Usr/Opt/cmder_mini/vendor/init.bat"
		else
			return vim.o.shell
		end
	end,
})
