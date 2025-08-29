require("recycle-bin"):setup()

-- require("duckdb"):setup()

require("custom-shell"):setup({
	history_path = "default",
	save_history = true,
})

require("fr"):setup({
	fzf = [[--info-command='echo -e "$FZF_INFO 💛"' --no-scrollbar]],
	rg = "--colors 'line:fg:red' --colors 'match:style:nobold'",
	bat = "--style 'header,grid'",
	rga = {
		"--follow",
		"--hidden",
		"--no-ignore",
		"--glob",
		"'!.git'",
		"--glob",
		"!'.venv'",
		"--glob",
		"'!node_modules'",
		"--glob",
		"'!.history'",
		"--glob",
		"'!.Rproj.user'",
		"--glob",
		"'!.ipynb_checkpoints'",
	},
	rga_preview = {
		"--colors 'line:fg:red'"
			.. " --colors 'match:fg:blue'"
			.. " --colors 'match:bg:black'"
			.. " --colors 'match:style:nobold'",
	},
})

local bookmarks = {
	{ tag = "Downloads", path = "~/Downloads", key = { "d", "d" } },
	{ tag = "Usr", path = "~/Usr", key = { "d", "u" } },
	{ tag = "nvme1n1p1", path = "/mnt/nvme1n1p1", key = { "d", "n" } },
	{ tag = "sda2", path = "/mnt/sda2", key = { "d", "s" } },
}

-- Windows
if ya.target_family() == "windows" then
	local home_path = os.getenv("USERPROFILE")
	table.insert(bookmarks, {
		tag = "Scoop Local",
		path = os.getenv("SCOOP") or (home_path .. "\\scoop"),
		key = "p",
	})
end

require("whoosh"):setup({
	bookmarks = bookmarks,
	jump_notify = false,
	keys = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
	path = (ya.target_family() == "windows" and os.getenv("APPDATA") .. "\\yazi\\config\\bookmark")
		or (os.getenv("HOME") .. "/.config/yazi/bookmark"),
	path_truncate_enabled = false,
	path_max_depth = 3,
	fzf_path_truncate_enabled = false,
	fzf_path_max_depth = 5,
	path_truncate_long_names_enabled = false,
	fzf_path_truncate_long_names_enabled = false,
	path_max_folder_name_length = 20,
	fzf_path_max_folder_name_length = 20,
	history_size = 10,
	history_fzf_path_truncate_enabled = false,
	history_fzf_path_max_depth = 5,
	history_fzf_path_truncate_long_names_enabled = false,
	history_fzf_path_max_folder_name_length = 30,
})
