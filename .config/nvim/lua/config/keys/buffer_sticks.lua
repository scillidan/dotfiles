return {
  {
    "<leader>bbj",
    function()
      BufferSticks.jump()
    end,
    desc = "Jump to buffer",
  },
  {
    "<leader>bbq",
    function()
      BufferSticks.close()
    end,
    desc = "Close buffer",
  },
  {
    "<leader>bbp",
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
