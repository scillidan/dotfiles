-- mini.trailspace
vim.api.nvim_create_user_command("TrimSpaces", function()
	require("mini.trailspace").trim()
end, { desc = "Trim trailing spaces" })

vim.api.nvim_create_user_command("TrimLastLines", function()
	require("mini.trailspace").trim_last_lines()
end, { desc = "Trim last lines" })
