-- Init para smoke tests: LSP real + treesitter real sobre los fixtures.
-- Carga las configs reales de lsp.lua y tree-sitter.lua (sin lazy.nvim),
-- con las dependencias necesarias en el runtimepath.
local lazy_data  = vim.fn.stdpath("data") .. "/lazy"
local config_dir = vim.fn.stdpath("config")

-- Binarios de Mason en PATH para que los LSP se encuentren
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

vim.opt.rtp:prepend(lazy_data .. "/plenary.nvim")
vim.opt.rtp:prepend(lazy_data .. "/nvim-lspconfig")
vim.opt.rtp:prepend(lazy_data .. "/nvim-treesitter")
vim.opt.rtp:prepend(lazy_data .. "/nvim-treesitter-textobjects")
vim.opt.rtp:prepend(lazy_data .. "/nvim-ts-autotag")
vim.opt.rtp:prepend(lazy_data .. "/nvim-ts-context-commentstring")

vim.opt.swapfile = false
vim.opt.backup   = false

-- Stubs de deps que no participan en el smoke
package.loaded['cmp_nvim_lsp'] = { default_capabilities = function() return {} end }

-- Config LSP real (vim.lsp.config + vim.lsp.enable)
local lsp_spec = assert(loadfile(config_dir .. "/lua/plugins/lsp.lua"))()
lsp_spec.config(nil, {})

-- Config treesitter real (setup + autocmd de highlight + textobjects)
local ts_spec = assert(loadfile(config_dir .. "/lua/plugins/tree-sitter.lua"))()
ts_spec.config(nil, {})
