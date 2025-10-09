-- Theme selector with multiple colorschemes
return {
  -- Gruvbox theme
  {
    "morhetz/gruvbox",
    lazy = false,
    priority = 1000,
  },

  -- Tokyo Night theme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
  },

  -- Catppuccin theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
  },

  -- OneDark theme
  {
    "joshdick/onedark.vim",
    lazy = false,
    priority = 1000,
  },
}
