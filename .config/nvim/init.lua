-- For Termux
if vim.env.TERMUX_VERSION ~= nil then
	is_termux = true
else
	is_termux = false
end

-- For Windows 10
if vim.fn.has("win32") == 1 then
	-- https://github.com/nvim-lualine/lualine.nvim/issues/1253
	-- vim.o.shell = fn.executable("pwsh") and "pwsh" or "powershell"
	-- vim.opt.shellcmdflag = "-NonInteractive -NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;$PSStyle.OutputRendering = [System.Management.Automation.OutputRendering]::PlainText;"
	-- vim.o.shell = "cmd.exe"
	-- vim.o.shellcmdflag = "/k" .. os.getenv("USER") .. "/Usr/Opt/cmder_mini/vendor/init.bat"
	vim.opt.shellpipe = '2>&1 | %{ "$_" } | Tee-Object %s; exit $LastExitCode'
	vim.opt.shellquote = ""
	vim.opt.shellredir = '2>&1 | %{ "$_" } | Out-File %s; exit $LastExitCode'
	vim.opt.shellxquote = ""
	vim.g.plenary_curl_bin_path = os.getenv("SCOOP") .. "/apps/git/current/mingw64/bin/curl.exe"
	vim.g.python3_host_prog = os.getenv("SCOOP") .. "/apps/python310/current/python.exe"
	vim.g.sqlite_clib_path = os.getenv("USER") .. "/Usr/Lib/sqlite-dll/sqlite3.dll"
end

-- For Neovide
if vim.g.neovide then
	vim.g.neovide_cursor_animation_length = 0
	vim.g.neovide_cursor_trail_size = 0
	vim.g.neovide_floating_blur_amount_x = 1.0
	vim.g.neovide_floating_blur_amount_y = 1.0
	vim.g.neovide_hide_mouse_when_typing = true
	vim.g.neovide_padding_bottom = 0
	vim.g.neovide_padding_left = 0
	vim.g.neovide_padding_right = 0
	vim.g.neovide_padding_top = 0
	vim.g.neovide_remember_window_size = true
	vim.g.neovide_opacity = 1
	vim.g.transparency = 1
	-- https://github.com/neovide/neovide/issues/1282
	vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
	vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
	vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
	vim.keymap.set("i", "<D-v>", "<C-R>+") -- Paste insert mode
end

vim.api.nvim_command("language en_US.UTF-8")
vim.o.clipboard = "unnamedplus"
vim.o.cmdheight = 1
vim.o.cursorline = false
vim.o.foldenable = true
vim.o.list = true
vim.o.listchars = "tab:··,trail:-,nbsp:+"
vim.o.modeline = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.sessionoptions = "localoptions"
vim.o.shiftwidth = 2
vim.o.signcolumn = "yes:1"
-- vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.timeout = true
vim.o.timeoutlen = 300
vim.lsp.set_log_level("debug")

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "yaml" },
	callback = function()
		vim.opt.expandtab = true
	end,
})

-- blink-cmp-dictionary
vim.api.nvim_set_hl(0, "BlinkCmpKindDict", { default = false, fg = "#92FFB8" })

vim.api.nvim_create_augroup("MarkdownRstText", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "MarkdownRstText",
	pattern = { "markdown", "rst", "text" },
	callback = function()
		vim.wo.list = true
		vim.wo.listchars = "tab:··,trail:-,nbsp:+,eol:¬"
	end,
})

-- godotdev.nvim
vim.api.nvim_create_augroup("GodotIndent", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "GodotIndent",
	pattern = { "gdscript", "cs" },
	callback = function()
		vim.bo.tabstop = 4
		vim.bo.shiftwidth = 4
		vim.bo.expandtab = true
	end,
})

-- time-machine.nvim
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath("data") .. "/undodir"

require("config_lazy")
require("latex")
require("user_command")
require("autocmd")
