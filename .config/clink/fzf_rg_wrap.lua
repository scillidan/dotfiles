-- Wrapper for clink-gizmos' fzf_rg.lua: standalone `clink lua` ignores
-- clink_settings, so fzf_rg.show_preview / fzf_rg.height are injected here
-- (override via FZF_RG_SHOW_PREVIEW / FZF_RG_HEIGHT env vars).
local home = os.getenv("USERHOME")
local real = os.getenv("FZF_RG_LUA")
if not real or real == "" then
	real = home..[[/Local/Source/clink/clink-gizmos/fzf_rg.lua]]
end

if arg[1] == "--fromcmdline" then
	local real_get = settings.get
	local overrides = {
		["fzf_rg.show_preview"] = os.getenv("FZF_RG_SHOW_PREVIEW") or "bottom",
		["fzf_rg.height"] = os.getenv("FZF_RG_HEIGHT") or "99%",
	}
	settings.get = function(name, ...)
		local value = overrides[name]
		if value == nil or value == "" then
			value = real_get(name, ...)
		end
		return value
	end
end

dofile(real)
