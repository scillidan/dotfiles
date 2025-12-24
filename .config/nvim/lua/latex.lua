-- https://github.com/WhiteBlackGoose/nvim-latex-preconfig/blob/master/init.lua
-- vim.cmd([[
-- :autocmd BufNewFile,BufRead *.tex VimtexCompile
-- ]])
-- vim.g.vimtex_compiler_latexmk = {
-- 	build_dir = ".out",
-- 	options = {
-- 		"-shell-escape",
-- 		"-verbose",
-- 		"-file-line-error",
-- 		"-interaction=nonstopmode",
-- 		"-synctex=1",
-- 	},
-- }
vim.g.vimtex_compiler_latexmk = {
	build_dir = ".out",
	options = {
		"-shell-escape",
		"-verbose",
		"-file-line-error",
		"-interaction=nonstopmode",
		"-synctex=1",
	},
}
vim.o.expandtab = true
vim.o.smartindent = false
vim.api.nvim_set_keymap("n", "<leader>j", "zc", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>k", "zo", { noremap = true, silent = true })
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.g.vimtex_fold_enabled = true
vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<space>", "<nop>", { noremap = true, silent = true })

-- https://jdhao.github.io/2019/03/26/nvim_latex_write_preview/
vim.g.vimtex_toc_config = {
	name = "TOC",
	layers = { "content", "todo", "include" },
	resize = 1,
	split_width = 50,
	todo_sorted = 0,
	show_help = 1,
	show_numbers = 1,
	mode = 2,
}

if vim.fn.has("unix") == 1 then
	-- vim.g.vimtex_compiler_progname = "nvr"
	vim.g.vimtex_view_general_viewer = "zathura"
	vim.g.vimtex_view_method = "zathura"
elseif vim.fn.has("win32") == 1 then
	-- vim.g.vimtex_view_general_viewer = "SumatraPDF"
	-- vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"
	vim.g.vimtex_view_general_viewer = "sioyek"
	vim.g.vimtex_view_method = "sioyek"
end
