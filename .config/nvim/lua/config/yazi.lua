local is_windows = package.config:sub(1, 1) == "\\"

return {
	open_for_directories = false,
	keymaps = {
		show_help = "<f1>",
	},
	yazi_floating_window_border = "none",
	-- https://github.com/jstkdng/ueberzugpp
	floating_window_scaling_factor = is_windows and 1 or nil,
}
