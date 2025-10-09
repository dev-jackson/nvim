return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    signs = true,
    sign_priority = 8,
    keywords = {
      FIX = {
        icon = " ",
        color = "error",
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
      },
      TODO = { icon = " ", color = "info" },
      HACK = { icon = " ", color = "warning" },
      WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
      TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
    },
    gui_style = {
      fg = "NONE",
      bg = "BOLD",
    },
    merge_keywords = true,
    highlight = {
      multiline = true,
      multiline_pattern = "^.",
      multiline_context = 10,
      before = "",
      keyword = "wide",
      after = "fg",
      pattern = [[.*<(KEYWORDS)\s*:]],
      comments_only = true,
      max_line_len = 400,
      exclude = {},
    },
    colors = {
      error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
      warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
      info = { "DiagnosticInfo", "#2563EB" },
      hint = { "DiagnosticHint", "#10B981" },
      default = { "Identifier", "#7C3AED" },
      test = { "Identifier", "#FF00FF" }
    },
    search = {
      command = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
      },
      pattern = [[\b(KEYWORDS):]],
    },
  },
  keys = {
    -- Navigation
    {
      "]t",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Next todo comment"
    },
    {
      "[t",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Previous todo comment"
    },
    -- Navigate only errors/warnings
    {
      "]e",
      function()
        require("todo-comments").jump_next({keywords = { "ERROR", "FIX", "FIXME", "BUG" }})
      end,
      desc = "Next error todo"
    },
    {
      "[e",
      function()
        require("todo-comments").jump_prev({keywords = { "ERROR", "FIX", "FIXME", "BUG" }})
      end,
      desc = "Previous error todo"
    },
    -- Telescope search
    {
      "<leader>st",
      "<cmd>TodoTelescope<cr>",
      desc = "Todo comments (Telescope)"
    },
    {
      "<leader>sT",
      "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",
      desc = "Todo/Fix/Fixme (Telescope)"
    },
    -- Trouble integration (if you have trouble.nvim)
    {
      "<leader>xt",
      "<cmd>TodoTrouble<cr>",
      desc = "Todo (Trouble)"
    },
    {
      "<leader>xT",
      "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",
      desc = "Todo/Fix/Fixme (Trouble)"
    },
  }
}
