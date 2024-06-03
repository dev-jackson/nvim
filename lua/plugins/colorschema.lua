return {
	"catppuccin/nvim",
  name = "catppuccin-mocha",
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd([[colorscheme catppuccin]])
	end
}
