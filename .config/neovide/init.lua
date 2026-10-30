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

	-- https://github.com/neovide/neovide/issues/1282
	vim.keymap.set("n", "<D-v>", '"+P')
	vim.keymap.set("v", "<D-v>", '"+P')
	vim.keymap.set("c", "<D-v>", "<C-R>+")
	vim.keymap.set("i", "<D-v>", "<C-R>+")
end