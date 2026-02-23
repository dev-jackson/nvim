# Neovim Configuration 2026

A production-ready Neovim configuration for full-stack development across Web, Android, iOS, C#, and AI-assisted workflows.

## Features

- **Multi-language LSP**: TypeScript/JavaScript, Python, C# (Roslyn), Kotlin, Swift
- **AI Integration**: Claude Code CLI (`claude`) + OpenAI Codex CLI (`codex`) via native terminal panels with diff accept/reject
- **iOS/macOS Development**: xcodebuild.nvim with build, test, and device selection
- **Android/Kotlin**: kotlin-language-server via Mason with inlay hints
- **Web**: React + Next.js, Tailwind CSS, ESLint 9+ flat config support
- **C# / .NET**: Roslyn LSP (replaces deprecated OmniSharp) via roslyn.nvim
- **Auto-formatting**: conform.nvim with per-language formatters on save
- **Linting**: nvim-lint with per-filetype linters
- **Completion**: nvim-cmp with LSP, snippets, path, and buffer sources
- **Plugin Management**: Lazy.nvim with lazy loading for fast startup
- **Theme Selector**: Interactive live preview (`:ThemeSelect`)

## Supported Languages & Tools

| Language | LSP | Formatter | Linter |
|----------|-----|-----------|--------|
| TypeScript/JavaScript | ts_ls | prettier | eslint |
| Python | pylsp | black, isort | flake8 |
| C# / .NET | Roslyn (roslyn.nvim) | csharpier | — |
| Kotlin / Android | kotlin_language_server | ktlint | — |
| Swift / iOS | sourcekit-lsp | swiftformat | swiftlint |
| Lua | lua_ls | stylua | — |
| HTML/CSS | html, cssls, tailwindcss | prettier | — |

## Prerequisites

### All Platforms
- Neovim >= 0.11
- Git
- Node.js >= 18.x
- Python >= 3.10
- .NET SDK >= 8.0

### macOS (iOS/Swift)
- Xcode (for sourcekit-lsp at `/usr/bin/sourcekit-lsp`)
- Homebrew (for swiftformat, swiftlint, xcbeautify, xcode-build-server)

### AI CLI Tools
- `claude` CLI — Claude Code (Anthropic)
- `codex` CLI — OpenAI Codex (`npm install -g @openai/codex`)

## Installation

### 1. Clone the configuration

```bash
git clone <your-repo-url> ~/.config/nvim
cd ~/.config/nvim
```

### 2. Run the install script

```bash
./install.sh
```

This installs:
- Node.js global packages (typescript, prettier, eslint, etc.)
- Python LSP packages (black, isort, flake8, python-lsp-server)
- .NET tools (CSharpier formatter; Roslyn downloads automatically on first `.cs` open)
- macOS: xcode-build-server, xcbeautify, swiftformat, swiftlint via Homebrew
- Checks for `claude` and `codex` CLIs, offers to install Codex if missing

### 3. Launch Neovim

```bash
nvim
```

Lazy.nvim installs all plugins on first launch. Mason auto-installs LSP servers.

## Language Setup

### TypeScript / React / Next.js

Works out of the box after `./install.sh`. Supports ESLint 9+ flat config (`eslint.config.js` / `.mjs`).

```vim
" Verify
:LspInfo     " ts_ls + eslint should appear
:ConformInfo " prettier should appear
```

### Python

Works out of the box after `./install.sh`.

```vim
:LspInfo     " pylsp should appear
```

### C# / .NET (Roslyn)

roslyn.nvim downloads `Microsoft.CodeAnalysis.LanguageServer` automatically on first `.cs` open (~200MB, takes 30-60s the first time).

```vim
" Open a .cs file — Roslyn downloads automatically
:LspInfo     " roslyn should appear (NOT omnisharp)
```

### Kotlin / Android

Mason auto-installs `kotlin-language-server` when you first open a `.kt` file.

```vim
" Open a .kt file — Mason installs kotlin-language-server automatically
:LspInfo     " kotlin_language_server should appear
```

### Swift / iOS

#### Simple Swift Packages (`Package.swift` only)

Open any `.swift` file — sourcekit-lsp activates automatically.

#### Xcode Projects (`.xcodeproj` / `.xcworkspace`)

Run once per project to generate `buildServer.json`:

```bash
cd /path/to/MyProject
xcode-build-server config -scheme MyApp -workspace MyApp.xcworkspace
```

Then open any `.swift` file in Neovim — sourcekit-lsp and xcodebuild.nvim activate automatically.

```vim
:LspInfo     " sourcekit should appear
<leader>Xb   " Build the project
```

### AI: Claude Code + Codex

Both tools connect their respective CLIs to Neovim via terminal panels. Claude proposes file changes as diffs that you accept or reject inline.

```vim
<leader>ac   " Open Claude Code panel (right side)
" Type your request in Claude, it proposes changes
<leader>ay   " Accept proposed diff
<leader>an   " Reject proposed diff

<leader>ao   " Open Codex panel (left side)
```

## Key Mappings

**Leader key**: `<Space>`

### AI (`<leader>a`)

| Keymap | Action |
|--------|--------|
| `<leader>ac` | Toggle Claude Code terminal |
| `<leader>aA` | Focus Claude Code |
| `<leader>as` | Send visual selection to Claude |
| `<leader>ay` | Accept Claude's diff |
| `<leader>an` | Reject Claude's diff |
| `<leader>ao` | Toggle Codex terminal |
| `<leader>ae` | Send visual selection to Codex |

### Xcode / iOS (`<leader>X`)

| Keymap | Action |
|--------|--------|
| `<leader>Xb` | Build |
| `<leader>XB` | Build for Testing |
| `<leader>Xr` | Build & Run |
| `<leader>Xt` | Run All Tests |
| `<leader>XT` | Run Test Class |
| `<leader>Xs` | Select Scheme |
| `<leader>Xd` | Select Device |
| `<leader>Xl` | Open Build Logs |
| `<leader>Xc` | Toggle Code Coverage |
| `<leader>Xp` | Select Test Plan |

### File Navigation

| Keymap | Action |
|--------|--------|
| `<leader>e` | Toggle file explorer (nvim-tree) |
| `<leader>ff` | Find files (Telescope) |
| `<leader>fg` | Live grep |
| `<leader>fb` | Find buffers |
| `<leader>fr` | Recent files |

### LSP

| Keymap | Action |
|--------|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Find references |
| `K` | Hover documentation |
| `<space>rn` | Rename symbol |
| `<space>ca` | Code actions |
| `<space>f` | Format file |
| `[d` / `]d` | Navigate diagnostics |

### Buffer Management

| Keymap | Action |
|--------|--------|
| `<leader>bd` | Close current buffer |
| `<leader>bn` | Next buffer |
| `<leader>bp` | Previous buffer |

### Git

| Keymap | Action |
|--------|--------|
| `<leader>gg` | Git status |
| `<leader>gc` | Git commit |
| `<leader>gp` | Git push |
| `<leader>gl` | Git pull |
| `<leader>gd` | Git diff |

### Format Control

| Command | Action |
|---------|--------|
| `:FormatDisable` | Disable format-on-save (buffer) |
| `:FormatDisable!` | Disable format-on-save (global) |
| `:FormatEnable` | Re-enable format-on-save |
| `<leader>mp` | Manual format |

## Configuration Structure

```
~/.config/nvim/
├── init.lua                     # Entry point: sets leader, loads config module
├── install.sh                   # System dependency installer
├── lua/
│   ├── config/
│   │   ├── init.lua             # Loads settings, lazy, keymaps
│   │   ├── settings.lua         # Neovim options
│   │   ├── keymaps.lua          # Global key mappings
│   │   ├── lazy.lua             # Lazy.nvim bootstrap
│   │   └── theme_persistence.lua # Theme save/load
│   └── plugins/
│       ├── ai.lua               # Claude Code + Codex CLI integration
│       ├── ios.lua              # xcodebuild.nvim for iOS/macOS
│       ├── roslyn.lua           # Roslyn LSP for C#
│       ├── lsp.lua              # All LSP configs (0.11+ API)
│       ├── mason.lua            # Mason + auto-installer
│       ├── conform.lua          # Format-on-save
│       ├── lint.lua             # nvim-lint
│       ├── cmp.lua              # Completion
│       ├── telescope.lua        # Fuzzy finder
│       ├── tree-sitter.lua      # Syntax highlighting
│       ├── which-key.lua        # Keymap documentation
│       └── ...                  # Other plugins
├── ftplugin/                    # Filetype-specific settings
└── snippets/                    # Custom snippets
```

## Useful Commands

```vim
:Lazy               " Plugin manager UI
:Mason              " LSP/formatter installer UI
:LspInfo            " Active LSP servers for current buffer
:ConformInfo        " Formatter config for current buffer
:TSUpdate           " Update Tree-sitter parsers
:checkhealth        " Run all health checks
:ThemeSelect        " Interactive theme selector with live preview
:SmearCursorToggle  " Toggle animated cursor effect
:XcodebuildSetup    " Setup xcodebuild.nvim for current project
```

## Troubleshooting

### LSP Not Working

```vim
:LspInfo       " Check if server is attached
:LspRestart    " Restart all LSP servers
:Mason         " Verify tool is installed
:checkhealth   " Full diagnostics
```

### C# / Roslyn

- First time opening a `.cs` file: Roslyn downloads ~200MB. Wait 30-60 seconds.
- `:LspInfo` should show `roslyn`, not `omnisharp`
- If download fails: check `dotnet --version`, needs >= 8.0

### Swift / iOS

```bash
# Verify sourcekit-lsp is available
/usr/bin/sourcekit-lsp --version

# For Xcode projects: generate buildServer.json
cd /path/to/project
xcode-build-server config -scheme MyScheme -workspace MyApp.xcworkspace
```

```vim
:LspInfo     " sourcekit should appear
```

### Kotlin / Android

```vim
" Open a .kt file and wait for Mason to auto-install kotlin-language-server
:Mason       " Check installation status
:LspInfo     " kotlin_language_server should appear
```

### AI (Claude Code / Codex)

```bash
# Verify CLIs are in PATH
claude --version
codex --version

# Install Codex if missing
npm install -g @openai/codex
```

```vim
<leader>ac   " Should open Claude Code panel
<leader>ao   " Should open Codex panel
```

### Performance Issues

```vim
" Check file size
:echo getfsize(expand('%'))

" Check active LSPs
:LspInfo

" Temporarily disable treesitter
:TSBufToggle highlight

" Stop specific LSP
:LspStop ts_ls

" Restart all LSPs
:LspRestart
```

For TypeScript projects: add large directories to `excludeDirectories` in `lua/plugins/lsp.lua` (ts_ls config, `watchOptions.excludeDirectories`).

## System Requirements

| Component | Minimum |
|-----------|---------|
| Neovim | >= 0.11 |
| Node.js | >= 18.x |
| Python | >= 3.10 |
| .NET SDK | >= 8.0 (for C#) |
| Xcode | Latest (for iOS/Swift) |
| macOS | Required for iOS/Swift |

---

**Last Updated**: February 2026
