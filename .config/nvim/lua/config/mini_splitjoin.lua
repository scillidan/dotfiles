require("mini.splitjoin").setup({
  {
    -- Created for both Normal and Visual modes.
    mappings = {
      toggle = "gS",
      split = "",
      join = "",
    },
    -- Detection options: where split/join should be done
    detect = {
      -- Array of Lua patterns to detect region with arguments.
      -- Default: { '%b()', '%b[]', '%b{}' }
      brackets = nil,
      -- String Lua pattern defining argument separator
      separator = ",",
      -- Array of Lua patterns for sub-regions to exclude separators from.
      -- Enables correct detection in presence of nested brackets and quotes.
      -- Default: { '%b()', '%b[]', '%b{}', '%b""', "%b''" }
      exclude_regions = nil,
    },
    split = {
      hooks_pre = {},
      hooks_post = {},
    },
    join = {
      hooks_pre = {},
      hooks_post = {},
    },
  },
})
