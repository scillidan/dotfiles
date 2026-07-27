local userhome = os.getenv("USERHOME")

require("auto-session").setup({
  ---@module "auto-session"
  ---@type AutoSession.Config
  suppress_dirs = { userhome },
  -- log_level = "debug"
  session_lens = {
    picker = telescope,
    picker_opts = {
      border = false
    }
  }
})
