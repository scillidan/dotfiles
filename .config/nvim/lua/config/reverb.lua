local env = require("env")
local sound_dir = env.home_dir .. "/Usr/Asset/sound/kenney_interface-sounds/Audio"

require("reverb").setup({
	player = "paplay",
	max_sounds = 20,
	sounds = {
		BufRead = { path = { sound_dir .. "start1.ogg", sound_dir .. "start2.ogg" }, volume = 0 - 100 },
		CursorMovedI = { path = sound_dir .. "click.ogg", volume = 0 - 100 },
		InsertLeave = { path = sound_dir .. "toggle.ogg", volume = 0 - 100 },
		ExitPre = { path = sound_dir .. "exit.ogg", volume = 0 - 100 },
		BufWrite = { path = sound_dir .. "save.ogg", volume = 0 - 100 },
	},
})
