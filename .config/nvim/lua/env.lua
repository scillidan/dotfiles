local M = {}

M.is_linux = vim.fn.has("unix") == 1
M.is_windows = vim.fn.has("win32") == 1
M.home_dir = M.is_windows and "C:/Users/User" or os.getenv("HOME")

return M
