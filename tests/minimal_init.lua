-- Minimal init for running plenary tests in headless Neovim.
-- Only loads what's needed for the specs to run.
local lazy_data = vim.fn.stdpath("data") .. "/lazy"

-- Plenary (test runner)
vim.opt.rtp:prepend(lazy_data .. "/plenary.nvim")

-- nvim-lspconfig (needed for require('lspconfig.util') inside root_dir functions)
vim.opt.rtp:prepend(lazy_data .. "/nvim-lspconfig")

-- Suppress swap file prompts during tests
vim.opt.swapfile = false
