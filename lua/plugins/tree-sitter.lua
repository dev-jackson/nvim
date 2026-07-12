-- ============================================================================
-- NVIM-TREESITTER (rama main, requiere Neovim 0.12+)
-- La rama master fue archivada (abril 2026). La API nueva:
--   - require("nvim-treesitter").setup() + install() para parsers
--   - highlight: vim.treesitter.start() por buffer (autocmd FileType)
--   - textobjects: rama main de nvim-treesitter-textobjects (keymaps propios)
--   - incremental_selection (gnn/grn/grc/grm) YA NO EXISTE en main;
--     grn ahora es el rename LSP nativo de nvim
-- ============================================================================

-- Parsers a instalar (mismos lenguajes que la config anterior)
local ensure_installed = {
	-- Core
	"lua", "vim", "vimdoc", "query",
	-- Web
	"html", "css", "scss", "javascript", "typescript", "tsx",
	"json", "yaml", "toml",
	-- Python
	"python",
	-- C# / .NET
	"c_sharp",
	-- Kotlin / Android
	"kotlin",
	-- Swift / iOS
	"swift",
	-- Markdown y documentación
	"markdown", "markdown_inline",
	-- Archivos de configuración
	"gitignore", "gitcommit", "git_rebase", "dockerfile",
	-- Otros
	"regex", "comment",
}

-- Guarda de rendimiento: no activar treesitter en archivos grandes
local function is_large_file(buf)
	local max_filesize = 200 * 1024 -- 200 KB
	local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
	if ok and stats and stats.size > max_filesize then
		return true
	end
	return vim.api.nvim_buf_line_count(buf) > 5000
end

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	-- lazy=false: los autocmds FileType deben existir antes de abrir el primer buffer
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
		"windwp/nvim-ts-autotag",
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	config = function()
		-- Fix deprecation warning: setup ts_context_commentstring separately
		vim.g.skip_ts_context_commentstring_module = true
		require('ts_context_commentstring').setup({
			enable_autocmd = false,
		})

		-- Setup nvim-ts-autotag for auto-closing tags (standalone, no depende de configs)
		require('nvim-ts-autotag').setup({
			opts = {
				enable_close = true, -- Auto close tags
				enable_rename = true, -- Auto rename pairs of tags
				enable_close_on_slash = true -- Auto close on trailing </
			},
		})

		local ts = require("nvim-treesitter")
		ts.setup({})

		-- Instalar parsers faltantes en segundo plano (async)
		ts.install(ensure_installed)

		-- ── Highlight + indent por buffer ────────────────────────────────
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter_setup", { clear = true }),
			callback = function(ev)
				local buf = ev.buf
				local lang = vim.treesitter.language.get_lang(ev.match)
				if not lang or is_large_file(buf) then
					return
				end

				-- Sin parser instalado: intentar instalarlo (async, aplica al reabrir)
				if not pcall(vim.treesitter.language.add, lang) then
					pcall(ts.install, lang)
					return
				end

				pcall(vim.treesitter.start, buf, lang)

				-- Indent experimental de la rama main (python/yaml excluidos: problemáticos)
				if ev.match ~= "python" and ev.match ~= "yaml" then
					vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})

		-- ── Textobjects (rama main: keymaps explícitos) ──────────────────
		require("nvim-treesitter-textobjects").setup({
			select = {
				lookahead = true,
			},
			move = {
				set_jumps = true,
			},
		})

		local ts_select = require("nvim-treesitter-textobjects.select")
		local ts_move   = require("nvim-treesitter-textobjects.move")
		local ts_swap   = require("nvim-treesitter-textobjects.swap")

		-- Select: mismos keymaps que la config anterior
		local select_maps = {
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
		}
		for lhs, query in pairs(select_maps) do
			vim.keymap.set({ "x", "o" }, lhs, function()
				-- Guarda: desactivar en archivos muy grandes
				if vim.api.nvim_buf_line_count(0) > 3000 then return end
				ts_select.select_textobject(query, "textobjects")
			end, { desc = "TS select " .. query })
		end

		-- Move: next/previous function/class
		local move_maps = {
			{ "]f", ts_move.goto_next_start,     "@function.outer" },
			{ "]c", ts_move.goto_next_start,     "@class.outer" },
			{ "]F", ts_move.goto_next_end,       "@function.outer" },
			{ "]C", ts_move.goto_next_end,       "@class.outer" },
			{ "[f", ts_move.goto_previous_start, "@function.outer" },
			{ "[c", ts_move.goto_previous_start, "@class.outer" },
			{ "[F", ts_move.goto_previous_end,   "@function.outer" },
			{ "[C", ts_move.goto_previous_end,   "@class.outer" },
		}
		for _, m in ipairs(move_maps) do
			vim.keymap.set({ "n", "x", "o" }, m[1], function()
				m[2](m[3], "textobjects")
			end, { desc = "TS move " .. m[3] })
		end

		-- Swap de parámetros
		vim.keymap.set("n", "<leader>sn", function()
			ts_swap.swap_next("@parameter.inner")
		end, { desc = "TS swap next parameter" })
		vim.keymap.set("n", "<leader>sp", function()
			ts_swap.swap_previous("@parameter.inner")
		end, { desc = "TS swap previous parameter" })
	end,
}
