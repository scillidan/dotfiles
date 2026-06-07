local toggle_term = require("toggleterm")
toggle_term.setup(opts)
vim.keymap.set("n", "<leader>t1", "<CMD>:1ToggleTerm direction=horizontal<CR>", { desc = "ToggleTerm: Horizontal 1" })
vim.keymap.set("n", "<leader>t2", "<CMD>:2ToggleTerm direction=horizontal<CR>", { desc = "ToggleTerm: Horizontal 2" })
vim.keymap.set("n", "<leader>t3", "<CMD>:3ToggleTerm direction=horizontal<CR>", { desc = "ToggleTerm: Horizontal 3" })
vim.keymap.set("n", "<leader>t4", "<CMD>:4ToggleTerm direction=horizontal<CR>", { desc = "ToggleTerm: Horizontal 4" })
vim.keymap.set("n", "<leader>t0", "<CMD>:ToggleTermToggleAll<CR>", { desc = "ToggleTerm: Toggle All" })

function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
end
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

-- Sending lines to the terminal
local trim_spaces = true
vim.keymap.set("n", "<space>e", function()
	require("toggleterm").send_lines_to_terminal("single_line", trim_spaces, { args = vim.v.count })
end)
vim.keymap.set("v", "<space>e", function()
	require("toggleterm").send_lines_to_terminal("visual_selection", trim_spaces, { args = vim.v.count })
end)

-- Custom terminal usage
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
	cmd = "lazygit",
	dir = ".",
	direction = "float",
	float_opts = {
		border = "single_line",
	},
	on_open = function(term)
		vim.cmd("startinsert!")
		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
	end,
	on_close = function(term)
		vim.cmd("startinsert!")
	end,
})
function _lazygit_toggle()
	lazygit:toggle()
end
vim.api.nvim_set_keymap("n", "<leader>lg", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
