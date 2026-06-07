local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()
local light_scheme = "One Light (Gogh)"
local is_light = false

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
		inactive_tab_hover = {
			italic = false,
			fg_color = "#e2e8f0",
			bg_color = "#000000",
		},
		new_tab_hover = {
			italic = false,
			fg_color = "#e2e8f0",
			bg_color = "#000000",
		},
	},
}
config.font = wezterm.font_with_fallback({
	"Sarasa Term SC Nerd",
})
config.font_size = 10.0
config.initial_cols = 152
config.initial_rows = 42
config.window_background_opacity = 1
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "NONE"
config.window_frame = {
	font = wezterm.font_with_fallback({
		"Sarasa Term SC Nerd",
	}),
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
config.hide_tab_bar_if_only_one_tab = false
config.show_tab_index_in_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 25
config.unzoom_on_switch_pane = true
config.use_fancy_tab_bar = false
config.warn_about_missing_glyphs = false

-- Key
config.disable_default_key_bindings = true
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{
		key = "C",
		mods = "LEADER|SHIFT",
		action = wezterm.action_callback(function(window, pane)
			if is_light then
				window:set_config_overrides(nil)
				is_light = false
			else
				window:set_config_overrides({
					color_scheme = light_scheme,
				})
				is_light = true
			end
		end),
	},
	{
		key = "f",
		mods = "LEADER|SHIFT",
		action = wezterm.action.ToggleFullScreen,
	},
	{
		key = "w",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.CloseCurrentTab({ confirm = false }),
	},
	{
		key = "p",
		mods = "CTRL|SHIFT",
		action = wezterm.action.Search("CurrentSelectionOrEmptyString"),
	},
	{
		key = "Insert",
		mods = "CTRL",
		action = wezterm.action.CopyTo("Clipboard"),
	},
	{
		key = "Insert",
		mods = "SHIFT",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
	{
		key = "v",
		mods = "CTRL",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
	{
		key = "t",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "n",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SpawnWindow,
	},
	{
		key = "E",
		mods = "CTRL|SHIFT",
		-- https://wezterm.org/config/lua/wezterm/on.html#example-opening-whole-scrollback-in-vim
		action = act.EmitEvent("trigger-vim-with-scrollback"),
	},
	---- https://github.com/wezterm/wezterm/discussions/3779
	{
		key = "l",
		mods = "CTRL|SHIFT|ALT",
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
	{ key = "a", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\x01" }) },
}

-- Mouse
---- https://github.com/wezterm/wezterm/discussions/3541
config.mouse_bindings = {
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
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
	{
		event = {
			Up = { streak = 1, button = "Left" },
		},
		mods = "NONE",
		action = act.CompleteSelection("ClipboardAndPrimarySelection"),
	},
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
}

-- For Windows
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	local user = os.getenv("USERHOME") or os.getenv("USERPROFILE")
	config.default_cwd = user .. "\\Downloads"
	config.default_prog = {
		"cmd.exe",
		"/k",
		user .. "\\Share\\dotfiles.win\\Scoop\\clink\\init.cmd",
	}
	table.insert(config.keys, {
		key = "h",
		mods = "CTRL|ALT",
		action = wezterm.action.ActivateTabRelative(-1),
	})
	table.insert(config.keys, {
		key = "l",
		mods = "CTRL|ALT",
		action = wezterm.action.ActivateTabRelative(1),
	})
	table.insert(config.keys, {
		key = "H",
		mods = "CTRL|ALT",
		action = wezterm.action.MoveTabRelative(-1),
	})
	table.insert(config.keys, {
		key = "L",
		mods = "CTRL|ALT",
		action = wezterm.action.MoveTabRelative(1),
	})
	table.insert(config.keys, {
		key = "c",
		mods = "ALT",
		action = wezterm.action.SendString("tere.bat\r"),
	})
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

return config
