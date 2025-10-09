return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = "VeryLazy",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"windwp/nvim-ts-autotag",
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,
			
			-- Automatically install missing parsers when entering buffer
			auto_install = true,
			
			-- Ensure these parsers are installed
			ensure_installed = {
				-- Core languages
				"lua",
				"vim",
				"vimdoc",
				"query",
				
				-- Web development
				"html",
				"css",
				"scss",
				"javascript",
				"typescript",
				"tsx",
				-- Note: jsx is handled by javascript parser
				"json",
				"yaml",
				"toml",

				-- Python
				"python",

				-- C# / .NET
				"c_sharp",
				
				-- Markdown and documentation
				"markdown",
				"markdown_inline",
				
				-- Configuration files
				"gitignore",
				"gitcommit",
				"git_rebase",
				"dockerfile",
				
				-- Other useful parsers
				"regex",
				"comment",
			},
			
			-- Highlight configuration
			highlight = {
				enable = true,
				-- Disable for large files
				disable = function(lang, buf)
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
				
				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				additional_vim_regex_highlighting = false,
			},
			
			-- Incremental selection
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "gnn",
					node_incremental = "grn",
					scope_incremental = "grc",
					node_decremental = "grm",
				},
			},
			
			-- Indentation
			indent = {
				enable = true,
				-- Disable for problematic languages
				disable = { "python", "yaml" },
			},
			
			-- Auto-tagging for HTML/JSX
			autotag = {
				enable = true,
				enable_rename = true,
				enable_close = true,
				enable_close_on_slash = true,
			},
			
			-- Context-aware commenting
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
			
			-- Text objects
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						-- Functions
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						
						-- Classes
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						
						-- Parameters
						["ap"] = "@parameter.outer",
						["ip"] = "@parameter.inner",
						
						-- Conditionals
						["ai"] = "@conditional.outer",
						["ii"] = "@conditional.inner",
						
						-- Loops
						["al"] = "@loop.outer",
						["il"] = "@loop.inner",
						
						-- Comments
						["a/"] = "@comment.outer",
						["i/"] = "@comment.inner",
					},
				},
				
				-- Move to next/previous text object
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
					},
					goto_next_end = {
						["]F"] = "@function.outer",
						["]C"] = "@class.outer",
					},
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
					},
					goto_previous_end = {
						["[F"] = "@function.outer",
						["[C"] = "@class.outer",
					},
				},
				
				-- Swap text objects
				swap = {
					enable = true,
					swap_next = {
						["<leader>sn"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>sp"] = "@parameter.inner",
					},
				},
			},
		})
	end,
}
