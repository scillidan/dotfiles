return {
	{
		"<leader>bj",
		function()
			BufferSticks.jump()
		end,
		desc = "Jump to buffer",
	},
	{
		"<leader>bq",
		function()
			BufferSticks.close()
		end,
		desc = "Close buffer",
	},
	{
		"<leader>bp",
		function()
			BufferSticks.list({
				action = function(buffer, leave)
					print("Selected: " .. buffer.name)
					leave()
				end,
			})
		end,
		desc = "Buffer picker",
	},
}
