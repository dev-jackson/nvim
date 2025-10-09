return {
	"numToStr/Comment.nvim",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring"
	},
	event = "VeryLazy",
	config = function()
		require("Comment").setup({
			-- Integrate with ts_context_commentstring for context-aware commenting
			pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
		})
	end
}
