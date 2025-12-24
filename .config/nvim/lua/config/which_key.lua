require("which-key").setup({
  win = {
    height = { min = 1, max = 10 },
    padding = { 0, 1 },
    title = false,
  },
  layout = {
    spacing = 1,
  },
  icons = {
    rules = false,
    mappings = false,
    breadcrumb = "·",
    separator = "",
    group = "+",
    ellipsis = "..",
    keys = {
      Up = "Up-",
      Down = "Down-",
      Left = "Left-",
      Right = "Right-",
      C = "C-",
      M = "M-", -- Meta
      D = "D-",
      S = "S-",
      CR = "CR-", -- Enter key (Carriage Return)
      Esc = "Esc-",
      ScrollWheelDown = "SWDown-",
      ScrollWheelUp = "SWUp-",
      NL = "NL-", -- New Line
      BS = "BS-",
      Space = "Spc-",
      Tab = "Tab-",
      F1 = "F1-",
      F2 = "F2-",
      F3 = "F3-",
      F4 = "F4-",
      F5 = "F5-",
      F6 = "F6-",
      F7 = "F7-",
      F8 = "F8-",
      F9 = "F9-",
      F10 = "F10-",
      F11 = "F11-",
      F12 = "F12-",
    },
  },
  show_help = false,
  show_keys = true,
  disable = {
    ft = {},
    bt = {},
  },
})
