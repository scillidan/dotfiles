local is_unix = (package.config:sub(1, 1) == "/")
local is_windows = (package.config:sub(1, 1) == "\\")
local is_termux = os.getenv("TERMUX_VERSION") ~= nil

require("close-and-restore-tab"):setup()
require("responsive-layout"):setup {
	wide_min = 90,
	split    = 0.5,
	divider  = "─",
}
require("relative-path").setup()
require("copy-file-contents"):setup({
	append_char = "\n",
	notification = true,
})
require("initial-cwd"):setup()
require("zoxide-add"):setup()
require("bookmarks"):setup({
	last_directory = { enable = false, persist = false, mode = "dir" },
	persist = "none",
	desc_format = "full",
	file_pick_mode = "hover",
	custom_desc_input = false,
	show_keys = false,
	notify = {
		enable = false,
		timeout = 1,
		message = {
			new = "New bookmark '<key>' -> '<folder>'",
			delete = "Deleted bookmark in '<key>'",
			delete_all = "Deleted all bookmarks",
		},
	},
})
require("custom-shell"):setup({
	history_path = "default",
	save_history = true,
})
require("git"):setup({
	order = 1500,
})
require("font-sample"):setup({
	text = 'ABCDEF abcdef\n0123456789 \noO08 iIlL1 g9qCGQ\n8%& <([{}])>\n.,;: @#$-_="\n== <= >= != ffi\nâéùïøçÃĒÆœ\n및개요これ直楽糸',
	canvas_size = "750x800",
	font_size = 80,
	bg = "white",
	fg = "black",
})

if is_unix then
	if not is_termux then
		require("autosession"):setup()
		require("recycle-bin"):setup()
		require("sshfs"):setup()
	end
elseif is_windows then
end
