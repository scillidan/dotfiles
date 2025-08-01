local dap = require("dap")
local dapui = require("dapui")

dapui.setup({
  icons = {
    collapsed = "-",
    current_frame = "-",
    expanded = "+",
  },
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.25 },
        { id = "breakpoints", size = 0.25 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 0.25 },
      },
      position = "left",
      size = 40,
    },
    {
      elements = {
        {
          id = "repl",
          size = 0.5,
        },
        {
          id = "console",
          size = 0.5,
        },
      },
      position = "bottom",
      size = 10,
    },
  },
})

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

vim.fn.sign_define("DapBreakpoint", { text = "·", texthl = "DapBreakpoint", linehl = "", numhl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointCondition", {
  text = "·",
  texthl = "DapBreakpointCondition",
  linehl = "DapBreakpointCondition",
  numhl = "DapBreakpointCondition",
})
vim.fn.sign_define("DapStopped", { text = "-", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "DAP: Toggle UI" })
vim.keymap.set("n", "<leader>ds", dap.continue, { desc = " Start/Continue" })
vim.keymap.set("n", "<leader>ds", dap.continue, { desc = " Start/Continue" })
vim.keymap.set("n", "<F1>", dap.continue, { desc = " Start/Continue" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = " Step into" })
vim.keymap.set("n", "<F2>", dap.step_into, { desc = " Step into" })
vim.keymap.set("n", "<leader>do", dap.step_over, { desc = " Step over" })
vim.keymap.set("n", "<F3>", dap.step_over, { desc = " Step over" })
vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = " Step out" })
vim.keymap.set("n", "<F4>", dap.step_out, { desc = " Step out" })
vim.keymap.set("n", "<leader>dq", dap.close, { desc = "DAP: Close session" })
vim.keymap.set("n", "<leader>dQ", dap.terminate, { desc = " Terminate session" })
vim.keymap.set("n", "<leader>dr", dap.restart_frame, { desc = "DAP: Restart" })
vim.keymap.set("n", "<F5>", dap.restart_frame, { desc = "DAP: Restart" })
vim.keymap.set("n", "<leader>dc", dap.run_to_cursor, { desc = "DAP: Run to Cursor" })
vim.keymap.set("n", "<leader>dR", dap.repl.toggle, { desc = "DAP: Toggle REPL" })
vim.keymap.set("n", "<leader>dh", require("dap.ui.widgets").hover, { desc = "DAP: Hover" })
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Breakpoint" })
vim.keymap.set("n", "<leader>dB", function()
  local input = vim.fn.input("Condition for breakpoint:")
  dap.set_breakpoint(input)
end, { desc = "DAP: Conditional Breakpoint" })
vim.keymap.set("n", "<leader>dD", dap.clear_breakpoints, { desc = "DAP: Clear Breakpoints" })
