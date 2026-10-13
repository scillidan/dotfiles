vim.keymap.set("n", "<leader>t1", "<Cmd>:1ToggleTerm direction=horizontal<CR>", { desc = "ToggleTerm: Horizontal 1" })
vim.keymap.set("n", "<leader>t2", "<Cmd>:2ToggleTerm direction=horizontal<CR>", { desc = "ToggleTerm: Horizontal 2" })
vim.keymap.set("n", "<leader>t3", "<Cmd>:3ToggleTerm direction=horizontal<CR>", { desc = "ToggleTerm: Horizontal 3" })
vim.keymap.set("n", "<leader>t4", "<Cmd>:4ToggleTerm direction=horizontal<CR>", { desc = "ToggleTerm: Horizontal 4" })
vim.keymap.set("n", "<leader>t0", "<Cmd>:ToggleTermToggleAll<CR>", { desc = "ToggleTerm: Toggle All" })

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
end
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

-- Sending lines to the terminal
local trim_spaces = true
vim.keymap.set("n", "<space>e", function()
  require("toggleterm").send_lines_to_terminal("single_line", trim_spaces, { args = vim.v.count })
end)
vim.keymap.set("v", "<space>e", function()
  require("toggleterm").send_lines_to_terminal("visual_selection", trim_spaces, { args = vim.v.count })
end)

-- Custom terminal usage
local Terminal = require("toggleterm.terminal").Terminal

-- lazygit
local lazygit = Terminal:new({
  cmd = "lazygit",
  dir = ".",
  direction = "float",
  float_opts = {
    border = "single",
  },
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<Cmd>close<CR>", { noremap = true, silent = true })
  end,
  on_close = function(term)
    vim.cmd("startinsert!")
  end,
})
function _lazygit_toggle()
  lazygit:toggle()
end
vim.api.nvim_set_keymap("n", "<leader>lg", "<Cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })

-- tere
local tere = Terminal:new({
  cmd = "tere",
  direction = "float",
  shellcmdflag = "/c",
  close_on_exit = true,
  on_open = function(term)
    -- Let Esc reach tere (quit) instead of leaving terminal-mode
    pcall(vim.keymap.del, "t", "<esc>", { buffer = term.bufnr })
  end,
  on_exit = function(term, _, exit_code)
    if exit_code ~= 0 then return end -- tere cancelled (Esc) without a selection
    if not vim.api.nvim_buf_is_valid(term.bufnr) then return end
    local lines = vim.api.nvim_buf_get_lines(term.bufnr, 0, -1, false)
    for i = #lines, 1, -1 do
      local dir = vim.trim(lines[i])
      if dir ~= "" and vim.fn.isdirectory(dir) == 1 then
        -- Defer until toggleterm has closed the float and focus is back
        vim.schedule(function()
          if vim.api.nvim_buf_get_name(0):match("^oil://") then
            -- oil buffers show the dir encoded in the buffer name, not the cwd
            require("oil").open(dir)
          else
            vim.cmd.lcd(vim.fn.fnameescape(dir))
          end
        end)
        break
      end
    end
  end,
})
function _tere_toggle()
  tere:toggle()
end
vim.api.nvim_set_keymap("n", "<leader>tr", "<Cmd>lua _tere_toggle()<CR>", { noremap = true, silent = true })

-- tuicr
local tuicr = Terminal:new({
  cmd = "tuicr",
  direction = "float",
  shellcmdflag = "/c",
  close_on_exit = true,
  on_open = function(term)
    pcall(vim.keymap.del, "t", "<esc>", { buffer = term.bufnr })
    pcall(vim.keymap.del, "t", "jk", { buffer = term.bufnr })
  end,
})
function _tuicr_toggle()
  tuicr:toggle()
end
vim.api.nvim_set_keymap("n", "<leader>tc", "<Cmd>lua _tuicr_toggle()<CR>", { noremap = true, silent = true })
