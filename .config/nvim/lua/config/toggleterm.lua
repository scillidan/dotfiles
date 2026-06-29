require("toggleterm").setup({
	-- insert_mappings = false, -- Relevant
	-- terminal_mappings = false, --  Relevant
	shade_terminals = false,
	start_in_insert = true,
	size = vim.o.columns * 0.1,
	open_mapping = [[<c-\>]],
	shell = function()
		if vim.fn.has("unix") == 1 then
			return vim.o.shell
		elseif vim.fn.has("win32") == 1 then
			return "cmd.exe /k %USERHOME%/Share/dotfiles.win/Scoop/clink/init.cmd"
		end
	end,
})
