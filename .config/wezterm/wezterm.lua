local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()
local dark_scheme = "Builtin Dark"

-- terminal-theme-switch owns the shared theme state and the cycle key.
local theme
do
	local path_args
	if wezterm.target_triple == "x86_64-pc-windows-msvc" then
		path_args = { "cmd.exe", "/c", "terminal-theme-switch", "path" }
	else
		path_args = { "terminal-theme-switch", "path" }
	end
	local called, ok, out, err = pcall(wezterm.run_child_process, path_args)
	if not called then
		wezterm.log_error("terminal-theme-switch: " .. tostring(ok))
	elseif ok and out and out ~= "" then
		local loaded, chunk, load_err = pcall(loadfile, out:gsub("%s+$", "") .. "/integrations/wezterm.lua")
		if loaded and chunk then
			local ok_chunk, mod = pcall(chunk)
			if ok_chunk then
				theme = mod
			else
				wezterm.log_error("terminal-theme-switch: " .. tostring(mod))
			end
		else
			wezterm.log_error("terminal-theme-switch: " .. tostring(load_err))
		end
	elseif err and err ~= "" then
		wezterm.log_error("terminal-theme-switch: " .. tostring(err))
	end
end

-- QuickSelect patterns: tmux-thumbs replacement.
local quick_select_url_patterns = {
	[=[https?://[^\s"'<>]+]=],
}
local quick_select_path_patterns = {
	[=[[A-Za-z]:[\\/][^\s:]+(?::\d+){0,2}]=],
	[=[(?:~|\.{1,2})?/[^\s:]+(?::\d+){0,2}]=],
	[=[[\w./\\-]+\.[A-Za-z0-9]+(?::\d+){0,2}]=],
}
-- Add Windows paths and PDFs to WezTerm's built-in QuickSelect patterns.
config.quick_select_patterns = {
	[=[[A-Za-z]:[\\/][^\s:]+(?::\d+){0,2}]=],
	[=[\S+\.pdf]=],
}

config.color_scheme = dark_scheme
config.colors = {
	tab_bar = {
		active_tab = {
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
			fg_color = "#f8fafc",
			bg_color = "#000000",
		},
		inactive_tab_hover = { italic = false, fg_color = "#e2e8f0", bg_color = "#000000" },
		new_tab_hover = {	italic = false, fg_color = "#e2e8f0", bg_color = "#000000" }
	}
}
config.font = wezterm.font_with_fallback({ "Sarasa Term SC Nerd" })
config.font_size = 10.0
-- https://help.gnome.org/users/gnome-terminal/stable/app-terminal-sizes.html.en
config.initial_cols = 152
config.initial_rows = 42
config.window_background_opacity = 1
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "NONE"
config.window_frame = {
	font = wezterm.font_with_fallback({ "Sarasa Term SC Nerd" }),
	font_size = 9.0,
	active_titlebar_bg = "#000000",
	active_titlebar_fg = "#f8fafc",
	inactive_titlebar_bg = "#0f172a",
	inactive_titlebar_fg = "#f8fafc",
	active_titlebar_border_bottom = "#0000ff",
	inactive_titlebar_border_bottom = "#1e3a8a",
	button_bg = "#000000",
	button_fg = "#f8fafc",
	button_hover_bg = "#1a1a1a",
	button_hover_fg = "#f8fafc",
}
config.window_padding = {
	left = "1cell",
	right = "1cell",
	top = 0,
	bottom = 0,
}
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 25
config.unzoom_on_switch_pane = true
config.use_fancy_tab_bar = false
config.warn_about_missing_glyphs = false

config.disable_default_key_bindings = true
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 500 }
config.keys = {
	{ key = "f", mods = "LEADER|SHIFT", action = wezterm.action.ToggleFullScreen },
	{ key = "w", mods = "CTRL|SHIFT|ALT", action = wezterm.action.CloseCurrentTab({ confirm = false }) },
	{ key = "F", mods = "CTRL|SHIFT", action = act.Search("CurrentSelectionOrEmptyString") },
	{ key = "O", mods = "CTRL|SHIFT",
		action = act.QuickSelectArgs({
			label = "open url",
			patterns = quick_select_url_patterns,
			action = wezterm.action_callback(function(window, pane)
				local url = window:get_selection_text_for_pane(pane)
				if url and url ~= "" then
					wezterm.open_with(url)
				end
			end),
		}),
	},
	{ key = "P", mods = "CTRL|SHIFT",
		action = act.QuickSelectArgs({
			label = "copy path",
			patterns = quick_select_path_patterns,
			action = wezterm.action_callback(function(window, pane)
				window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
			end),
		}),
	},
	{ key = "S", mods = "CTRL|SHIFT", action = act.QuickSelect },
	{ key = "Space", mods = "CTRL|SHIFT", action = act.QuickSelect },
	{ key = "X", mods = "CTRL|SHIFT", action = act.ActivateCopyMode },
	{ key = "C", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
	{ key = "Insert", mods = "CTRL", action = wezterm.action.CopyTo("Clipboard") },
	{ key = "Insert", mods = "SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
	{ key = "v", mods = "CTRL", action = wezterm.action.PasteFrom("Clipboard") },
	{ key = "t", mods = "CTRL|SHIFT", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{ key = "n", mods = "CTRL|SHIFT", action = wezterm.action.SpawnWindow },
	{ key = "h", mods = "CTRL|ALT", action = wezterm.action.ActivateTabRelative(-1) },
	{ key = "l", mods = "CTRL|ALT", action = wezterm.action.ActivateTabRelative(1) },
	{ key = "H", mods = "CTRL|ALT", action = wezterm.action.MoveTabRelative(-1) },
	{ key = "L", mods = "CTRL|ALT", action = wezterm.action.MoveTabRelative(1) },
	{ key = "y", mods = "ALT", action = wezterm.action.SendString("yazi-cd\r") },
	{ key = "f", mods = "ALT", action = wezterm.action.SendString("bash fzf-files.sh\r") },
	{ key = "g", mods = "ALT", action = wezterm.action.SendString("bash fzf-ripgrep.sh\r") },
	{ key = "g", mods = "LEADER",	action = wezterm.action.SpawnCommandInNewTab({ args = { "lazygit" } }) },
	-- Shift+Enter -> CSI-u sequence so opencode can tell it apart from Enter
	{ key = "Enter", mods = "SHIFT", action = wezterm.action.SendString("\x1b[13;2u") },
	-- https://wezterm.org/config/lua/wezterm/on.html#example-opening-whole-scrollback-in-vim
	{ key = "E", mods = "CTRL|SHIFT", action = act.EmitEvent("trigger-vim-with-scrollback") },
	-- https://github.com/wezterm/wezterm/discussions/3779
	{ key = "l", mods = "CTRL|SHIFT|ALT",
		action = wezterm.action_callback(function(_, pane)
			local tab = pane:tab()
			local panes = tab:panes_with_info()
			if #panes == 1 then
				pane:split({
					direction = "Right",
					size = 0.5,
				})
			elseif not panes[1].is_zoomed then
				panes[1].pane:activate()
				tab:set_zoomed(true)
			elseif panes[1].is_zoomed then
				tab:set_zoomed(false)
				panes[2].pane:activate()
			end
		end),
	},
	-- https://gist.github.com/quangIO/556fa4abca46faf40092282d0c11a367
	{ key = "-", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "s", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "\\", mods = "LEADER", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "v", mods = "LEADER", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
	{ key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
	{ key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
	{ key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
	{ key = "h", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
	{ key = "j", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
	{ key = "k", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
	{ key = "l", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },
	{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
	{ key = "x", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
	{ key = "1", mods = "LEADER", action = wezterm.action({ ActivateTab = 0 }) },
	{ key = "2", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
	{ key = "3", mods = "LEADER", action = wezterm.action({ ActivateTab = 2 }) },
	{ key = "4", mods = "LEADER", action = wezterm.action({ ActivateTab = 3 }) },
	{ key = "5", mods = "LEADER", action = wezterm.action({ ActivateTab = 4 }) },
	{ key = "6", mods = "LEADER", action = wezterm.action({ ActivateTab = 5 }) },
	{ key = "7", mods = "LEADER", action = wezterm.action({ ActivateTab = 6 }) },
	{ key = "8", mods = "LEADER", action = wezterm.action({ ActivateTab = 7 }) },
	{ key = "9", mods = "LEADER", action = wezterm.action({ ActivateTab = 8 }) },
	{ key = "7", mods = "LEADER|SHIFT", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
	{ key = "a", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\x01" }) }
}

-- https://github.com/wezterm/wezterm/discussions/3541
config.mouse_bindings = {
	{	event = { Down = { streak = 1, button = "Right" } }, mods = "NONE",
		action = wezterm.action_callback(function(window, pane)
			local has_selection = window:get_selection_text_for_pane(pane) ~= ""
			if has_selection then
				window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
				window:perform_action(act.ClearSelection, pane)
			else
				window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
			end
		end),
	},
	{	event = { Up = { streak = 1, button = "Left" } },	mods = "NONE", action = act.CompleteSelection("ClipboardAndPrimarySelection") },
	{	event = { Up = { streak = 1, button = "Left" } }, mods = "CTRL", action = act.OpenLinkAtMouseCursor }
}

if wezterm.target_triple == "linux" then
	config.default_cwd = os.getenv("USERHOME") .. "/Downloads"
	table.insert(config.keys, { key = "c", mods = "ALT", action = wezterm.action.SendString("tere\r")	})
end

-- For Windows
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	local user = os.getenv("USERHOME") or os.getenv("USERPROFILE")
	config.default_cwd = user .. "\\Downloads"
	config.default_prog = {
		"cmd.exe",
		"/k",
		user .. "\\Share\\dotfiles.win\\Scoop\\clink\\init.cmd",
	}
	table.insert(config.keys, { key = "c", mods = "ALT", action = wezterm.action.SendString("tere.bat\r")	})
end

wezterm.on("trigger-vim-with-scrollback", function(window, pane)
	local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)
	local name = os.tmpname()
	local f = io.open(name, "w+")
	f:write(text)
	f:flush()
	f:close()
	window:perform_action(
		act.SpawnCommandInNewWindow({
			args = { "vim", name },
		}),
		pane
	)
	wezterm.sleep_ms(1000)
	os.remove(name)
end)

wezterm.on("format-tab-title", function(tab)
	local title = tab.active_pane.title
	if title:match("[\\/]") then
		title = title:gsub(".*[\\/]", "")
	end
	return title
end)

if theme then
	local ok, err = pcall(theme.setup, config)
	if not ok then
		wezterm.log_error("terminal-theme-switch: " .. tostring(err))
	end
end

return config
