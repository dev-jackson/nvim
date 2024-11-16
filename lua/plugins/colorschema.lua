return {
	"olimorris/onedarkpro.nvim",
  name = "onedark",
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd([[colorscheme onedark_dark]])
	end
}
