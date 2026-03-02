-- Init for integration tests: loads real LSP config with Mason binaries in PATH.
local lazy_data = vim.fn.stdpath("data") .. "/lazy"
local config_dir = vim.fn.stdpath("config")

-- Mason binaries must be in PATH so LSP servers can be found
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

vim.opt.rtp:prepend(lazy_data .. "/plenary.nvim")
vim.opt.rtp:prepend(lazy_data .. "/nvim-lspconfig")

vim.opt.swapfile = false
vim.opt.backup   = false

-- Stubs for unused deps
package.loaded['cmp_nvim_lsp'] = { default_capabilities = function() return {} end }
package.loaded['neodev']       = { setup = function() end }

-- Run the real LSP plugin config → sets up vim.lsp.config() + FileType autocmds
local spec = assert(loadfile(config_dir .. "/lua/plugins/lsp.lua"))()
spec.config(nil, {})
