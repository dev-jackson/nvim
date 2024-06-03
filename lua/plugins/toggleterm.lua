return {
  "akinsho/toggleterm.nvim",
  event = "VeryLazy",
  config = true,
  keys = {
    {
      "<leader>tf",
      function()
        require("toggleterm").toggle(1, nil, nil, "float", "New Terminal")
      end
    }
  }
}
