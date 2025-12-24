local is_unix = (package.config:sub(1, 1) == "/")
local is_windows = (package.config:sub(1, 1) == "\\")
local is_termux = os.getenv("TERMUX_VERSION") ~= nil

require("custom-shell"):setup({
	history_path = "default",
	save_history = true,
})

if is_unix then
	if not is_termux then
		require("recycle-bin"):setup()
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
	end
elseif is_windows then
	---
end
