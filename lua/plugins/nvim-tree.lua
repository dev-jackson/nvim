return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("nvim-tree").setup {
			update_focused_file = {
				enable = true,
			}
		}
	end,
	keys = {
		{
			"<leader>e",
			function()
				require("nvim-tree.api").tree.toggle()
			end,
			desc = "Toggle tree"
		}
	},
}
