return {
  "akinsho/toggleterm.nvim",
  event = "VeryLazy",
  config = true,
  tag = "*",
  keys = {
    {
      "<leader>tf",
      "<cmd>ToggleTerm direction=float<cr>",
      desc = "Open terminal"
    },
    {
      "<leader>th",
      "<cmd>ToggleTerm direction=horizontal<cr>",
      desc = "Open terminal"
    }

  }
}
