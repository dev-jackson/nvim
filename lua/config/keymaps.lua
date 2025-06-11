-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Helper function for setting keymaps
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Buffer management
map('n', '<leader>bd', ':bd!<cr>', { desc = "Close current buffer" })
map('n', '<leader>bn', ':bnext<cr>', { desc = "Next buffer" })
map('n', '<leader>bp', ':bprevious<cr>', { desc = "Previous buffer" })
map('n', '<leader>ba', ':bufdo bd<cr>', { desc = "Close all buffers" })

-- File operations
map('n', '<C-s>', ':w<cr>', { desc = "Save current file" })
map('n', '<leader>w', ':w<cr>', { desc = "Save current file" })
map('n', '<leader>wa', ':wa<cr>', { desc = "Save all files" })
map('n', '<leader>q', ':q<cr>', { desc = "Quit current window" })
map('n', '<leader>qa', ':qa<cr>', { desc = "Quit all windows" })

-- Source/reload configuration
map('n', '<leader>rr', ':source %<cr>', { desc = "Source the current file" })
map('n', '<leader>rc', ':source ~/.config/nvim/init.lua<cr>', { desc = "Reload Neovim config" })

-- Window navigation
map('n', '<C-h>', '<C-w>h', { desc = "Move to left window" })
map('n', '<C-j>', '<C-w>j', { desc = "Move to bottom window" })
map('n', '<C-k>', '<C-w>k', { desc = "Move to top window" })
map('n', '<C-l>', '<C-w>l', { desc = "Move to right window" })

-- Window resizing
map('n', '<C-Up>', ':resize +2<cr>', { desc = "Increase window height" })
map('n', '<C-Down>', ':resize -2<cr>', { desc = "Decrease window height" })
map('n', '<C-Left>', ':vertical resize -2<cr>', { desc = "Decrease window width" })
map('n', '<C-Right>', ':vertical resize +2<cr>', { desc = "Increase window width" })

-- Visual mode improvements
map('v', '>', '>gv', { desc = "Indent and re-select" })
map('v', '<', '<gv', { desc = "Un-indent and re-select" })
map('v', 'J', ":m '>+1<cr>gv=gv", { desc = "Move selected lines down" })
map('v', 'K', ":m '<-2<cr>gv=gv", { desc = "Move selected lines up" })

-- Search improvements
map('n', 'n', 'nzzzv', { desc = "Next search result (centered)" })
map('n', 'N', 'Nzzzv', { desc = "Previous search result (centered)" })
map('n', '<leader>nh', ':nohlsearch<cr>', { desc = "Clear search highlights" })

-- Text manipulation
map('n', 'J', 'mzJ`z', { desc = "Join lines and keep cursor position" })
map('n', '<C-d>', '<C-d>zz', { desc = "Scroll down and center" })
map('n', '<C-u>', '<C-u>zz', { desc = "Scroll up and center" })

-- Better paste (don't lose register)
map('x', '<leader>p', [["_dP]], { desc = "Paste without losing register" })

-- Copy to system clipboard
map({ 'n', 'v' }, '<leader>y', [["+y]], { desc = "Copy to system clipboard" })
map('n', '<leader>Y', [["+Y]], { desc = "Copy line to system clipboard" })

-- Delete without yanking
map({ 'n', 'v' }, '<leader>d', [["_d]], { desc = "Delete without yanking" })

-- Terminal mappings
map('t', '<Esc>', '<C-\\><C-n>', { desc = "Exit terminal mode" })

-- File explorer (nvim-tree)
map('n', '<leader>e', ':NvimTreeToggle<cr>', { desc = "Toggle file explorer" })
map('n', '<leader>ef', ':NvimTreeFindFile<cr>', { desc = "Find current file in tree" })

-- Telescope mappings
map('n', '<leader>ff', ':Telescope find_files<cr>', { desc = "Find files" })
map('n', '<leader>fg', ':Telescope live_grep<cr>', { desc = "Live grep" })
map('n', '<leader>fb', ':Telescope buffers<cr>', { desc = "Find buffers" })
map('n', '<leader>fh', ':Telescope help_tags<cr>', { desc = "Find help" })
map('n', '<leader>fr', ':Telescope oldfiles<cr>', { desc = "Recent files" })
map('n', '<leader>fc', ':Telescope commands<cr>', { desc = "Find commands" })
map('n', '<leader>fk', ':Telescope keymaps<cr>', { desc = "Find keymaps" })

-- Git mappings (if fugitive is loaded)
map('n', '<leader>gs', ':Git<cr>', { desc = "Git status" })
map('n', '<leader>gc', ':Git commit<cr>', { desc = "Git commit" })
map('n', '<leader>gp', ':Git push<cr>', { desc = "Git push" })
map('n', '<leader>gl', ':Git pull<cr>', { desc = "Git pull" })
map('n', '<leader>gb', ':Git blame<cr>', { desc = "Git blame" })

-- LSP mappings (these will be overridden by LSP config if LSP is active)
map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "Code actions" })
map('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename symbol" })
map('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, { desc = "Format code" })

-- Diagnostic mappings
map('n', '<leader>dd', vim.diagnostic.open_float, { desc = "Show diagnostic" })
map('n', '<leader>dl', vim.diagnostic.setloclist, { desc = "Diagnostic list" })
map('n', '[d', vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map('n', ']d', vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- Toggle mappings
map('n', '<leader>tw', ':set wrap!<cr>', { desc = "Toggle word wrap" })
map('n', '<leader>tn', ':set number!<cr>', { desc = "Toggle line numbers" })
map('n', '<leader>tr', ':set relativenumber!<cr>', { desc = "Toggle relative numbers" })
map('n', '<leader>ts', ':set spell!<cr>', { desc = "Toggle spell check" })

-- Quick fixes
map('n', '<leader>cx', ':cclose<cr>', { desc = "Close quickfix list" })
map('n', '<leader>co', ':copen<cr>', { desc = "Open quickfix list" })
map('n', '[q', ':cprev<cr>', { desc = "Previous quickfix item" })
map('n', ']q', ':cnext<cr>', { desc = "Next quickfix item" })

-- Tab management
map('n', '<leader>to', ':tabnew<cr>', { desc = "New tab" })
map('n', '<leader>tc', ':tabclose<cr>', { desc = "Close tab" })
map('n', '<leader>tn', ':tabnext<cr>', { desc = "Next tab" })
map('n', '<leader>tp', ':tabprevious<cr>', { desc = "Previous tab" })

-- Useful shortcuts
map('n', '<leader>x', ':!chmod +x %<cr>', { desc = "Make file executable" })
map('n', '<leader>so', ':so<cr>', { desc = "Source current file" })

-- Clear trailing whitespace
map('n', '<leader>tw', ':%s/\\s\\+$//<cr>:noh<cr>', { desc = "Remove trailing whitespace" })
