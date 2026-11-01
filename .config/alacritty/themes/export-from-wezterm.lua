local wezterm = require("wezterm")

local function write_scheme(name, target)
  local scheme = wezterm.color.get_builtin_schemes()[name]
  if not scheme then
    error("missing scheme: " .. name)
  end

  local normal_names = { "black", "red", "green", "yellow", "blue", "magenta", "cyan", "white" }
  local lines = {
    "# Generated from WezTerm " .. wezterm.version .. " scheme: " .. name,
    "# Regenerate with: wezterm --config-file <this-file> start --always-new-process --no-auto-connect",
    "",
    "[colors.primary]",
    "foreground = " .. string.format("%q", scheme.foreground),
    "background = " .. string.format("%q", scheme.background),
    "",
    "[colors.cursor]",
    "text = " .. string.format("%q", scheme.cursor_fg or scheme.foreground),
    "cursor = " .. string.format("%q", scheme.cursor_bg or scheme.foreground),
    "",
    "[colors.selection]",
    "text = " .. string.format("%q", scheme.selection_fg or scheme.foreground),
    "background = " .. string.format("%q", scheme.selection_bg or scheme.background),
    "",
    "[colors.normal]",
  }
  for index, color_name in ipairs(normal_names) do
    table.insert(lines, color_name .. " = " .. string.format("%q", scheme.ansi[index]))
  end
  table.insert(lines, "")
  table.insert(lines, "[colors.bright]")
  for index, color_name in ipairs(normal_names) do
    table.insert(lines, color_name .. " = " .. string.format("%q", scheme.brights[index]))
  end
  table.insert(lines, "")

  local file = assert(io.open(target, "w"))
  file:write(table.concat(lines, "\n"))
  file:close()
end

wezterm.on("gui-startup", function()
  local root = os.getenv("USERPROFILE") or os.getenv("HOME")
  local dir = root .. "/Share/dotfiles/.config/alacritty/themes"
  write_scheme("Builtin Dark", dir .. "/builtin_dark.toml")
  write_scheme("One Light (Gogh)", dir .. "/one_light.toml")
  os.exit(0)
end)

return {}
