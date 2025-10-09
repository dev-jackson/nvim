# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Neovim configuration for multi-language development: TypeScript/JavaScript (React), Python, C#/.NET, Lua, HTML/CSS/Tailwind. Uses Lazy.nvim for plugin management with modular configuration structure.

## Architecture

### Configuration Loading Order

1. `init.lua` - Sets leader keys THEN loads `config` module (critical order!)
2. `lua/config/init.lua` - Loads settings, lazy, keymaps
3. `lua/config/lazy.lua` - Bootstraps Lazy.nvim, imports plugins from `lua/plugins/`
4. Plugin configs in `lua/plugins/*.lua` - Each returns table with setup

**Important**: `vim.g.mapleader` and `vim.g.maplocalleader` MUST be set in `init.lua` before loading any plugins

### Key Patterns

**Plugin Structure**: Each plugin file returns table with URL, dependencies, config function

**LSP Setup**: `lua/plugins/lsp.lua` uses Neovim 0.11+ modern API with `vim.lsp.config()` for configuration and `vim.lsp.enable()` to activate servers. Global config via `vim.lsp.config('*', {...})` applies `on_attach` and `capabilities` to all servers

**Formatters**: `lua/plugins/conform.lua` manages format-on-save by filetype. Enabled by default, disable with `:FormatDisable` (buffer) or `:FormatDisable!` (global)

**Tree-sitter**: Auto-installs parsers on buffer enter. Provides syntax highlighting, text objects, auto-tagging for HTML/JSX

## Language Support

### TypeScript/JavaScript/React
- **LSP**: ts_ls (typescript-language-server)
- **Linter**: eslint (auto-fix on save)
- **Formatter**: prettier
- **Install**: `:MasonInstall typescript-language-server eslint-lsp prettier`

### Python
- **LSP**: pylsp (python-lsp-server)
- **Linter**: flake8
- **Formatter**: black, isort
- **Install**: `:MasonInstall python-lsp-server flake8 black isort`
- **Better option**: pyright + ruff (faster, modern)
  - `:MasonInstall pyright ruff ruff-lsp`
  - Update lsp.lua to use pyright, conform.lua to use ruff

### C# / .NET
- **LSP**: omnisharp-roslyn
- **Formatter**: csharpier (opinionated like prettier)
- **Install**: `:MasonInstall omnisharp csharpier`
- **Tree-sitter**: `:TSInstall c_sharp`
- **Setup**: Add to lsp.lua:
  ```lua
  lspconfig.omnisharp.setup({
    on_attach = on_attach,
    capabilities = lsp_capabilities,
  })
  ```
- **Formatter**: Add to conform.lua formatters_by_ft:
  ```lua
  cs = { "csharpier" }
  ```

### HTML/CSS/Tailwind
- **LSP**: tailwindcss, cssls, html
- **Formatter**: prettier
- **Install**: `:MasonInstall tailwindcss-language-server css-lsp html-lsp`
- **Note**: tailwind-tools.nvim removed (archived, caused deprecation warnings)

### Lua (Neovim config)
- **LSP**: lua_ls
- **Formatter**: stylua
- **Install**: `:MasonInstall lua-language-server stylua`

## Common Commands

### First Time Setup

**Run this once to install system dependencies:**
```bash
cd ~/.config/nvim
./install.sh
```
This installs required npm, pip3, and dotnet packages that LSP servers need.

### Check Status
```vim
:Lazy                " Plugin manager UI
:Mason               " LSP/formatter installer UI
:LspInfo             " Active LSP servers
:ConformInfo         " Formatter config
:TSUpdate            " Update tree-sitter parsers
:checkhealth         " Run health checks
:SmearCursorToggle   " Toggle animated cursor
```

### Auto-Installation

Mason automatically installs LSP servers and tools on startup via:
- `mason-tool-installer.nvim` - LSP servers, formatters, and linters
- Note: Uses Neovim 0.11+ native `vim.lsp.config()` (no mason-lspconfig needed)

Manual install (if needed):
```vim
:MasonInstall <package-name>
```

### Reload Config
```vim
:source ~/.config/nvim/init.lua
```
Or keymap: `<leader>rc`

## Key Mappings

Leader: `<Space>`

### Essential
- `<leader>e` - Toggle file explorer (nvim-tree)
- `<leader>ff` - Find files (Telescope)
- `<leader>fg` - Live grep
- `<leader>fb` - Find buffers

### LSP (when active)
- `gd` - Go to definition
- `gD` - Go to declaration
- `gr` - Find references
- `K` - Hover documentation
- `<space>rn` - Rename
- `<space>ca` - Code actions
- `<space>f` - Format file
- `[d` / `]d` - Navigate diagnostics

### Git
- `<leader>gs` - Git status
- `<leader>gc` - Git commit
- `<leader>gp` - Git push

### Format Control
- `:FormatDisable` - Disable format-on-save (buffer)
- `:FormatDisable!` - Disable format-on-save (global)
- `:FormatEnable` - Re-enable format-on-save
- `<leader>mp` - Manual format

## Adding New Language

1. **Add LSP** in `lua/plugins/lsp.lua`:
   ```lua
   -- Configure the server
   vim.lsp.config('your_lsp', {
     settings = { ... }  -- optional server-specific settings
   })

   -- Add to the vim.lsp.enable() list
   vim.lsp.enable({
     'lua_ls', 'ts_ls', ... 'your_lsp'
   })
   ```

2. **Add formatter** in `lua/plugins/conform.lua`:
   ```lua
   formatters_by_ft = {
     your_filetype = { "your_formatter" },
   }
   ```

3. **Install tools**: `:MasonInstall your-lsp your-formatter`

4. **Add parser**: `:TSInstall your_language`

## Troubleshooting

### LSP not working
```vim
:LspInfo       " Check if server attached
:LspRestart    " Restart LSP servers
:Mason         " Verify tool installed
```

### Formatting not working
```vim
:ConformInfo   " Check formatter config
:Mason         " Verify formatter installed
```

### Tree-sitter issues
```vim
:TSUpdate      " Update parsers
:checkhealth nvim-treesitter
```

## Important Notes

- **System dependencies required**: Run `./install.sh` first to install npm/pip3/dotnet packages
- **Auto-installation**: Mason automatically installs LSP servers/formatters on startup
- **Modern LSP API**: Uses Neovim 0.11+ `vim.lsp.config()` and `vim.lsp.enable()` (no deprecation warnings)
- **ESLint auto-fixes** on save for JS/TS files (configured in lsp.lua)
- **Format-on-save** enabled by default, 500ms timeout
- **Tree-sitter auto-install** enabled, will download parsers as needed
- **File-type settings** in `ftplugin/*.lua` for language-specific configs
- **Global LSP config** via `vim.lsp.config('*', {...})` applies to all servers
- **Smear cursor**: Animated cursor effect enabled (toggle with `:SmearCursorToggle`)
- **Alpha dashboard**: Custom start screen with quick actions (find files, recent, config, etc.)
