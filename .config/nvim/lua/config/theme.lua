local M = {}

local function plugin_path()
  local ok, result = pcall(function()
    return vim.system({ "terminal-theme-switch", "path" }, { text = true }):wait()
  end)
  if ok and result.code == 0 then
    return vim.trim(result.stdout)
  end
end

local integration
local path = plugin_path()
if path and path ~= "" then
  local ok, mod = pcall(dofile, path .. "/integrations/nvim.lua")
  if ok then
    integration = mod
  else
    vim.notify("terminal-theme-switch: " .. tostring(mod), vim.log.levels.ERROR)
  end
end

function M.cycle()
  if integration then
    integration.cycle()
  end
end

function M.setup()
  if integration then
    integration.setup()
  end
end

return M
