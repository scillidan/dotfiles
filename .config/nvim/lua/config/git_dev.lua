require("git-dev").setup({
	cd_type = "tab",
	opener = function(dir, _, selected_path)
		vim.cmd("tabnew")
		vim.cmd("Neotree " .. dir)
		if selected_path then
			vim.cmd("edit " .. selected_path)
		end
	end,
})
