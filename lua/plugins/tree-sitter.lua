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
		-- Fix deprecation warning: setup ts_context_commentstring separately
		vim.g.skip_ts_context_commentstring_module = true
		require('ts_context_commentstring').setup({
			enable_autocmd = false,
		})

		-- Setup nvim-ts-autotag for auto-closing tags
		require('nvim-ts-autotag').setup({
			opts = {
				-- Defaults
				enable_close = true, -- Auto close tags
				enable_rename = true, -- Auto rename pairs of tags
				enable_close_on_slash = true -- Auto close on trailing </
			},
			-- Also override individual filetype configs, these take priority.
			-- Empty by default, useful if one of the "opts" global settings
			-- doesn't work well in a specific filetype
			per_filetype = {
				["html"] = {
					enable_close = true
				},
				["javascript"] = {
					enable_close = true
				},
				["typescript"] = {
					enable_close = true
				},
				["javascriptreact"] = {
					enable_close = true
				},
				["typescriptreact"] = {
					enable_close = true
				},
				["jsx"] = {
					enable_close = true
				},
				["tsx"] = {
					enable_close = true
				},
			}
		})

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

				-- Kotlin / Android
				"kotlin",

				-- Swift / iOS
				"swift",

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
				-- Disable for large files or projects
				disable = function(lang, buf)
					local max_filesize = 200 * 1024 -- 200 KB (increased from 100KB)
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end

					-- Disable for files with too many lines
					local line_count = vim.api.nvim_buf_line_count(buf)
					if line_count > 5000 then
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
			
			-- Text objects
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					-- Disable for large files
					disable = function(lang, buf)
						local line_count = vim.api.nvim_buf_line_count(buf)
						return line_count > 3000
					end,
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
