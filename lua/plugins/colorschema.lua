return {
	"wojciechkepka/vim-github-dark",
  name = "ghdark",
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd([[colorscheme ghdark]])
	end
}
