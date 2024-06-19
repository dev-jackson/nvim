return {
	"akinsho/toggleterm.nvim",
	event = "VeryLazy",
	config = function()
		require("toggleterm").setup({
			shell = nil,
			start_in_insert = true,
			float_opts = {
				border = "rounded",
				winblend = 0,
				highlights = {
					border = "Normal",
					background = "Normal",
				},
			},
			on_open = function(term)
				if term.direction == "float" then
					vim.api.nvim_buf_set_keymap(term.bufnr, 't', '<Esc>', [[<C-\><C-n><cmd>ToggleTermToggleAll<CR>]],
						{ noremap = true, silent = true })
					vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>ToggleTermToggleAll<CR>',
						{ noremap = true, silent = true })
				end
			end
		})
	end,
	version = "*",
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
