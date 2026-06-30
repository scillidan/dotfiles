-- https://github.com/thomasschafer/scooter#neovim

-- Ensure NVIM env var is set for scooter's --remote-send
do
  local pipe = "\\\\.\\pipe\\nvim-scooter"
  vim.fn.serverstart(pipe)
  vim.env.NVIM = pipe
end

local M = {}

local scooter_term = nil

-- Called by scooter to open the selected file at the correct line from the scooter search list
_G.EditLineFromScooter = function(file_path, line)
    if scooter_term and scooter_term:is_open() then
        scooter_term:close()
    end

    local current_path = vim.fn.expand("%:p")
    local target_path = vim.fn.fnamemodify(file_path, ":p")

    if current_path ~= target_path then
        vim.cmd.edit(vim.fn.fnameescape(file_path))
    end

    vim.api.nvim_win_set_cursor(0, { line, 0 })
end

function M.open_scooter()
    if scooter_term and scooter_term:is_open() then
        scooter_term:close()
    end
    scooter_term = nil
    scooter_term = require("toggleterm.terminal").Terminal:new({
        cmd = "scooter",
        direction = "float",
        close_on_exit = true,
        shellcmdflag = "/c",
        on_exit = function()
            scooter_term = nil
        end
    })
    scooter_term:open()
end

function M.open_scooter_with_text(search_text)
    if scooter_term and scooter_term:is_open() then
        scooter_term:close()
    end

    local escaped_text = vim.fn.shellescape(search_text:gsub("\r?\n", " "))
    scooter_term = require("toggleterm.terminal").Terminal:new({
        cmd = "scooter --fixed-strings --search-text " .. escaped_text,
        direction = "float",
        close_on_exit = true,
        shellcmdflag = "/c",
        on_exit = function()
            scooter_term = nil
        end
    })
    scooter_term:open()
end

return M
