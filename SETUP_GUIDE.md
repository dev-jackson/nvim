# Neovim Setup Guide 2025

## 🚀 Quick Setup

After installing this configuration, follow these steps to set up all development tools:

### 1. 📦 Install LSP Servers via Mason

Open Neovim and run these commands to install LSP servers:

```vim
:MasonInstall lua-language-server
:MasonInstall typescript-language-server
:MasonInstall eslint-lsp
:MasonInstall tailwindcss-language-server
:MasonInstall python-lsp-server
:MasonInstall css-lsp
:MasonInstall html-lsp
:MasonInstall json-lsp
```

### 2. 🎨 Install Formatters via Mason

```vim
:MasonInstall prettier
:MasonInstall stylua
:MasonInstall black
:MasonInstall isort
```

### 3. 🔍 Install Linters via Mason

```vim
:MasonInstall flake8
:MasonInstall shellcheck
:MasonInstall markdownlint
```

### 4. 🍎 Swift Development Tools (macOS only)

Install Swift tools via Homebrew (recommended over Mason):

```bash
# Install Xcode Command Line Tools (if not already installed)
xcode-select --install

# Install Swift development tools
brew install swiftlint
brew install swift-format

# Verify sourcekit-lsp is available
which sourcekit-lsp
```

### 5. 🧪 Test Your Setup

#### Test Swift Development:

1. Open a Swift file: `nvim Package.swift`
2. Test LSP: Place cursor on a Swift keyword and press `K`
3. Test building: `:XcodebuildBuild` (in a Swift project)

#### Test Web Development:

1. Open a TypeScript file: `nvim app.ts`
2. Test auto-completion with `<C-Space>`
3. Test formatting with `<leader>f`

#### Test Python Development:

1. Open a Python file: `nvim script.py`
2. Test LSP hover with `K`
3. Test formatting on save

### 6. 🔧 Quick Commands Reference

Once setup is complete, you can use:

#### Mason Management:

- `:Mason` - Open Mason UI
- `:MasonUpdate` - Update all installed packages
- `:MasonLog` - View installation logs

#### Swift/Xcode Integration:

- `<leader>xb` - Build project
- `<leader>xr` - Run project
- `<leader>xt` - Run tests
- `<leader>xs` - Select scheme
- `<leader>xd` - Select device

#### LSP Commands:

- `gd` - Go to definition
- `K` - Show hover info
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `<leader>f` - Format code

#### File Navigation:

- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>e` - Toggle file tree

### 7. 🛠️ Troubleshooting

#### If LSP doesn't work:

1. Check if server is installed: `:Mason`
2. Check LSP status: `:LspInfo`
3. Restart LSP: `:LspRestart`

#### If Swift LSP doesn't work:

1. Verify Xcode tools: `xcode-select -p`
2. Check sourcekit-lsp: `which sourcekit-lsp`
3. Restart Neovim in Swift project

#### If formatting doesn't work:

1. Check if formatter is installed: `:Mason`
2. Test manual formatting: `<leader>f`
3. Check conform status: `:ConformInfo`

### 8. 🌳 Update Tree-sitter Parsers

After first launch, update tree-sitter parsers:

```vim
:TSUpdate
```

### 9. 📋 All-in-One Setup Command

You can also run this command to install everything at once:

```vim
:MasonInstall lua-language-server typescript-language-server eslint-lsp tailwindcss-language-server python-lsp-server css-lsp html-lsp json-lsp prettier stylua black isort flake8 shellcheck markdownlint
```

Then install Swift tools via Homebrew:

```bash
brew install swiftlint swift-format
```

### 10. ✅ Verification

After setup, you should have:

- ✅ LSP working for all languages
- ✅ Auto-formatting on save
- ✅ Linting showing errors/warnings
- ✅ Swift project detection and building
- ✅ Telescope file finding
- ✅ Git integration
- ✅ Tree-sitter syntax highlighting

---

🎉 **You're all set for modern development with Neovim 2025!**
