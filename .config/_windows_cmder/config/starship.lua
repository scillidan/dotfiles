-- %USERPROFILE% or Customize ENV path
local user = os.getenv("USERHOME") or os.getenv("USERPROFILE")
os.setenv("STARSHIP_CONFIG", user .. "\\Usr\\Git\\dotfiles\\.config\\starship_windows.toml")
os.setenv("STARSHIP_CACHE", user .. "\\Usr\\Data\\starship")

function starship_transient_prompt_func(prompt)
	return io.popen("starship module character" .. " --keymap=" .. rl.getvariable("keymap")):read("*a")
end

load(io.popen("starship init cmd"):read("*a"))()
