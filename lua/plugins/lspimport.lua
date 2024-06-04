return {
  "stevanmilic/nvim-lspimport",
  event = "VeryLazy",
  config = function()
    vim.keymap.set("n", "<leader>a", require("lspimport").import, { noremap = true })
  end
}
