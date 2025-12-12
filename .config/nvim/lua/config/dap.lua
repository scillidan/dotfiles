local dap = require("dap")

-- Lua
-- dap.configurations.lua = {
--   {
--     type = "nlua",
--     request = "attach",
--     name = "Attach to running Neovim instance",
--   },
-- }

-- dap.adapters.nlua = function(callback, config)
--   callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
-- end

-- Python
dap.configurations.python = {
	{
		type = "python",
		request = "launch",
		-- name = "file:args (cwd)",
		program = "${file}",
		args = function()
			local args_string = vim.fn.input("Arguments: ")
			local utils = require("dap.utils")
			if utils.splitstr and vim.fn.has("nvim-0.10") == 1 then
				return utils.splitstr(args_string)
			end
			return vim.split(args_string, " +")
		end,
		console = "integratedTerminal",
		cwd = vim.fn.getcwd(),
	},
}
