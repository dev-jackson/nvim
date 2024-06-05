return {
	"numToStr/Comment.nvim",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring"
	},
	event = "VeryLazy",
	config = function()
		require("Comment").setup({
			pre_hook = function(c)
				local U = require("Comment.utils")

				local location = nil
				if c.ctype == U.ctype.blockwise then
				location = require("ts_context_commentstring.utils").get_cursor_location()
				elseif c.cmotion == U.cmotion.v or c.cmotion == U.cmotion.V then
					location = require("ts_context_commentstring.utils").get_visual_end_location()
				end

				return require("ts_context_commentstring.internal").calculate_commentstring({
					key = c.ctype == U.ctype.linewise and '__default' or '__multiline',
					location = location,
				})
			end
		})
		require("nvim-treesitter.configs").setup({
			context_commentstring = {
				enalbe = true,
				enable_autocmd = false,
				config = {
					typescript = {
						__default = '// %s',
						tsx_element = '{/* %s */}',
						tsx_fragment = '{/* %s */}',
						tsx_attribute = '// %s',
						comment = '// %s'
					},
					javascript = {
						__default = '// %s',
						jsx_element = '{/* %s */}',
						jsx_fragment = '{/* %s */}',
						jsx_attribute = '// %s',
						comment = '// %s'
					},
				}
			}
		})
	end
}
