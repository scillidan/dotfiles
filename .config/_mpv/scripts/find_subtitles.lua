require("os")
require("io")
require("string")
mputils = require("mp.utils")

-- "find_subtitles" tries to do two simple things:
-- 1. use python's subliminal for downloading subtitles
-- 2. load any subtitles found within movie folder
-- (this script binds letter "s")

-- helper function for capturing cli response
-- Reference: http://stackoverflow.com/questions/132397
function os.capture(cmd, raw)
	local f = assert(io.popen(cmd, "r"))
	local s = assert(f:read("*a"))
	f:close()
	return string.sub(s, 0, -2)
end

-- helper function for getting file (adress) info
-- (works regardless cwd path)
function fileadressinfo()
	local fpath = mp.get_property("path", " ")
	local dir = mputils.split_path(fpath)
	if dir == "." then
		dir = mp.get_property("working-directory")
	end
	return fpath, dir
end

-- function find_subtitles()
-- 	local fp, dr = fileadressinfo()

-- 	-- use subliminal to fetch english subtitles from all providers (change en to your preference if needed)
-- 	mp.msg.info("Searching for subtitles..")
-- 	local ss =
-- 		os.capture(
-- 		"subliminal download --provider opensubtitles --provider podnapisi --provider thesubdb --provider tvsubtitles -l en -v '" ..
-- 			fp .. "'"
-- 	)
-- 	-- you can also use this if you join addict7d (replace user and pass with yours; use no quotes just the strings)
-- 	-- local ss = os.capture("subliminal --addic7ed user pass download --provider addic7ed --provider opensubtitles --provider podnapisi --provider thesubdb --provider tvsubtitles -l en -v '" .. fp .. "'")

-- 	-- strip unnecessary info (as of subliminal version 1.0.1 the string matchings below are working ... dont know for how long though
-- 	ss = string.gsub(ss, "(Collecting videos)", "")
-- 	ss = string.gsub(ss, "(Downloading subtitles)", "")
-- 	ss = string.gsub(ss, "(1 video collected / 0 video ignored / 0 error)", ".")
-- 	ss = string.gsub(ss, "\n", "")
-- 	if string.match(ss, "0 video collected / 1 video ignored / 0 error") then
-- 		ss = "Subtitle already in path.. "
-- 	end

-- 	-- Possible messages to display:
-- 	-- "1 subtitle downloaded for <FILENAME>", if subliminal returned without errors
-- 	-- "Subtitle already in path..", if there are already subtitles in the folder
-- 	--  <captured errors>, if something has gone wrong
-- 	mp.osd_message(string.format(" %s", ss), 4)

-- 	-- no matter what happened, try to load *.srt files (if any)
-- 	mp.commandv("rescan_external_files", "reselect")
-- end

function find_subtitles()
	local fp, dr = fileadressinfo()
	mp.msg.info("Searching for subtitles..")
	local command
	if package.config:sub(1, 1) == "\\" then
		-- Windows
		command = string.format('subliminal download --provider opensubtitles -l en -v "%s"', fp)
	else
		-- Linux
		command =
			string.format("/home/scillidan/.local/bin/subliminal download --provider opensubtitles -l en -v '%s'", fp)
	end
	local ss = os.capture(command)
	ss = string.gsub(ss, "(Collecting videos)", "")
	ss = string.gsub(ss, "(Downloading subtitles)", "")
	ss = string.gsub(ss, "(1 video collected / 0 video ignored / 0 error)", ".")
	ss = string.gsub(ss, "\n", "")
	if string.match(ss, "0 video collected / 1 video ignored / 0 error") then
		ss = "Subtitle already in path.. "
	end
	mp.osd_message(string.format(" %s", ss), 4)
	mp.commandv("rescan_external_files", "reselect")
end

mp.add_key_binding("alt+s", "subtitles", find_subtitles)
-- mp.register_event("start-file", find_subtitles)
