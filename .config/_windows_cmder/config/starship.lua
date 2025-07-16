os.setenv("STARSHIP_CONFIG", "C:\\Users\\User\\Usr\\Git\\dotfiles\\.config\\starship_windows.toml")
os.setenv("STARSHIP_CACHE", "C:\\Users\\User\\Usr\\Data\\starship")

function starship_transient_prompt_func(prompt)
	return io.popen("starship module character" .. " --keymap=" .. rl.getvariable("keymap")):read("*a")
end

load(io.popen("starship init cmd"):read("*a"))()
