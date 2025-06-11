# Neovim Configuration 2025

A modern, efficient Neovim configuration optimized for Swift/SwiftUI, Python, React, and TypeScript development.

## ✨ Features

- **Multi-language Support**: Swift, SwiftUI, Python, React, TypeScript, Tailwind CSS
- **Swift/SwiftUI Development**: Complete iOS/macOS development environment with xcodebuild.nvim
- **Intelligent LSP**: Auto-detection and installation of language servers
- **Auto-formatting**: Format on save for all supported languages
- **Advanced Linting**: Real-time error detection and suggestions
- **Package Management**: Lazy.nvim for efficient plugin management
- **Git Integration**: Built-in Git workflows with Fugitive and Gitsigns
- **Telescope**: Powerful fuzzy finder and file navigation
- **Tree-sitter**: Advanced syntax highlighting and code understanding
- **Auto-completion**: Intelligent code completion with nvim-cmp

## 🚀 Supported Languages & Frameworks

### Swift/SwiftUI (macOS only)

- **LSP**: sourcekit-lsp
- **Build System**: xcodebuild.nvim integration
- **Formatting**: swift-format (4 spaces, Xcode style)
- **Linting**: swiftlint
- **Project Support**: iOS Apps, macOS Apps, Swift Packages
- **Debugging**: lldb integration through nvim-dap

### Web Development

- **TypeScript/JavaScript**: ts_ls, eslint_d, prettier
- **React**: Full JSX/TSX support with auto-imports
- **Tailwind CSS**: Intelligent class completion and suggestions
- **CSS/SCSS**: Built-in support with formatting

### Python

- **LSP**: pylsp (Python LSP Server)
- **Formatting**: black, autopep8
- **Linting**: flake8, pylint

## 📦 Installation

### Prerequisites

- Neovim >= 0.9.0
- Git
- Node.js (for TypeScript/JavaScript LSP)
- Python 3.x (for Python LSP)
- macOS (for Swift/SwiftUI development)
- Xcode Command Line Tools (for Swift development)

### Quick Setup

1. **Clone the configuration:**

   ```bash
   git clone <your-repo-url> ~/.config/nvim
   cd ~/.config/nvim
   ```

2. **Install dependencies:**

   ```bash
   ./install.sh
   ```

3. **Launch Neovim:**

   ```bash
   nvim
   ```

4. **Let plugins install automatically** (Lazy.nvim will handle this)

## 🛠️ Swift/SwiftUI Development Setup

This configuration includes full Swift development support through `xcodebuild.nvim`.

### Required Tools

```bash
# Install Swift development tools
xcode-select --install

# Install swiftlint (optional but recommended)
brew install swiftlint

# Install swift-format (optional but recommended)
brew install swift-format
```

### Swift Package Development

The configuration automatically detects Swift packages and provides:

- **Building**: `:XcodebuildBuild`
- **Testing**: `:XcodebuildTest`
- **Running**: `:XcodebuildRun`
- **Device Selection**: `:XcodebuildSelectDevice`
- **Scheme Selection**: `:XcodebuildSelectScheme`

### iOS App Development

For iOS app projects:

1. Open your iOS project directory in Neovim
2. Use `:XcodebuildSelectProject` to select your .xcodeproj file
3. Use `:XcodebuildSelectScheme` to select your app scheme
4. Use `:XcodebuildSelectDevice` to choose simulator or device
5. Build and run with `:XcodebuildBuildAndRun`

## ⌨️ Key Mappings

### General

- `<leader>e` - Open file explorer (nvim-tree)
- `<leader>ff` - Find files (Telescope)
- `<leader>fg` - Live grep (Telescope)
- `<leader>fb` - Find buffers (Telescope)
- `<leader>fh` - Find help tags (Telescope)

### LSP

- `gd` - Go to definition
- `gD` - Go to declaration
- `gr` - Find references
- `K` - Show hover information
- `<leader>rn` - Rename symbol
- `<leader>f` - Format code
- `[d` / `]d` - Navigate diagnostics

### Swift/Xcode

- `<leader>xb` - Build project
- `<leader>xr` - Run project
- `<leader>xt` - Run tests
- `<leader>xs` - Select scheme
- `<leader>xd` - Select device

### Git

- `<leader>gs` - Git status
- `<leader>gc` - Git commit
- `<leader>gp` - Git push

## 🔧 Configuration Structure

```
~/.config/nvim/
├── init.lua                 # Main configuration entry point
├── lua/
│   ├── config/
│   │   ├── init.lua        # Load all configurations
│   │   ├── settings.lua    # Neovim settings
│   │   ├── keymaps.lua     # Key mappings
│   │   └── lazy.lua        # Plugin manager setup
│   └── plugins/
│       ├── lsp.lua         # LSP configuration
│       ├── xcodebuild.lua  # Swift/Xcode integration
│       ├── mason.lua       # LSP installer
│       ├── cmp.lua         # Completion engine
│       ├── telescope.lua   # Fuzzy finder
│       ├── tree-sitter.lua # Syntax highlighting
│       └── ...            # Other plugins
├── ftplugin/              # File-type specific configurations
└── snippets/              # Custom snippets
```

## 🎨 Customization

### Adding New Languages

1. Add LSP configuration in `lua/plugins/lsp.lua`
2. Add formatting rules in `lua/plugins/conform.lua`
3. Add file-type specific settings in `ftplugin/`

### Modifying Key Mappings

Edit `lua/config/keymaps.lua` to customize key bindings.

### Changing Theme

Edit `lua/plugins/colorscheme.lua` to change the color scheme.

## 🧪 Testing Your Setup

### Swift Package Testing

1. Navigate to a Swift package directory
2. Open Neovim: `nvim Package.swift`
3. Test LSP: Place cursor on a Swift identifier and press `K`
4. Test building: `:XcodebuildBuild`
5. Test formatting: `<leader>f`

### Web Development Testing

1. Open a TypeScript/React project
2. Test auto-completion and imports
3. Test Tailwind CSS class completion
4. Test formatting on save

## 🐛 Troubleshooting

### Swift LSP Not Working

1. Verify sourcekit-lsp is available: `which sourcekit-lsp`
2. Check if Xcode Command Line Tools are installed: `xcode-select -p`
3. Restart Neovim and check `:LspInfo`

### Node.js LSP Issues

1. Verify Node.js installation: `node --version`
2. Check if typescript is installed globally: `npm list -g typescript`
3. Restart the LSP: `:LspRestart`

### Package Dependencies

Some Swift packages may require authentication. Configure your git credentials:

```bash
git config --global credential.helper osxkeychain
```

## 📋 System Requirements

- **macOS**: Required for Swift/SwiftUI development
- **Neovim**: >= 0.9.0
- **Git**: Latest version
- **Node.js**: >= 16.x (for TypeScript/JavaScript)
- **Python**: >= 3.8 (for Python LSP)
- **Xcode Command Line Tools**: Latest version

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This configuration is provided as-is under the MIT License.

## 🔗 Useful Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [xcodebuild.nvim Wiki](https://github.com/wojciech-kulik/xcodebuild.nvim)
- [Swift.org](https://swift.org)
- [Lazy.nvim](https://github.com/folke/lazy.nvim)

---

**Last Updated**: January 2025
