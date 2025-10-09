-- Leader keys are set in init.lua before loading plugins
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.tabstop = 4
-- Increased from 100ms to reduce CPU usage and interruptions in large projects
vim.opt.updatetime = 300  -- 300ms is a good balance between responsiveness and performance
-- vim.o.showtabline = 4
-- vim.o.shiftwidth = 4
-- Shared clipboard with system
vim.o.clipboard = "unnamedplus"
