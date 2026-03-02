#!/bin/bash

echo "🔧 Installing Neovim LSP dependencies..."

# Check if commands exist
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Node.js dependencies for TypeScript/JavaScript/CSS/HTML
if command_exists npm; then
  echo "📦 Installing Node.js packages..."
  npm install -g \
    typescript \
    typescript-language-server \
    vscode-langservers-extracted \
    @tailwindcss/language-server \
    prettier \
    eslint
  echo "✅ Node.js packages installed"
else
  echo "⚠️  npm not found. Skipping Node.js packages."
  echo "   Install Node.js from: https://nodejs.org"
fi

# Python dependencies for Python LSP
if command_exists pip3; then
  echo "📦 Installing Python packages..."
  python3 -m venv tempenv
  source tempenv/bin/activate
  pip install python-lsp-server \
    black \
    isort \
    flake8
  deactivate
  rm -rf tempenv
  echo "✅ Python packages installed"
else
  echo "⚠️  pip3 not found. Skipping Python packages."
  echo "   Install Python from: https://python.org"
fi

# .NET dependencies for C# (CSharpier formatter)
# Note: Roslyn LSP is managed by roslyn.nvim (descarga automáticamente)
if command_exists dotnet; then
  echo "📦 Installing .NET tools..."
  dotnet tool install --global csharpier
  echo "✅ .NET tools installed (CSharpier formatter)"
  echo "   Roslyn LSP: se descarga automáticamente al abrir un archivo .cs"
else
  echo "⚠️  dotnet not found. Skipping .NET tools."
  echo "   Install .NET SDK from: https://dotnet.microsoft.com"
fi

# iOS / Swift tools (macOS only)
if [[ "$(uname)" == "Darwin" ]]; then
  echo ""
  echo "📱 Checking iOS/Swift tools (macOS only)..."

  if command_exists brew; then
    # tree-sitter: Neovim depende de libtree-sitter como librería dinámica.
    # DEBE instalarse via Homebrew (no npm/cargo) para que el dylib esté disponible.
    # Si Neovim fue instalado con brew, tree-sitter ya debería estar presente.
    if ! command_exists tree-sitter; then
      brew install tree-sitter
      echo "✅ tree-sitter installed via Homebrew"
    else
      echo "✅ tree-sitter $(tree-sitter --version 2>/dev/null | head -1) (Homebrew)"
    fi

    # xcode-build-server: bridge entre sourcekit-lsp y proyectos Xcode
    if ! brew list xcode-build-server &>/dev/null; then
      brew install xcode-build-server
      echo "✅ xcode-build-server installed"
    else
      echo "✅ xcode-build-server already installed"
    fi

    # xcbeautify: formatea el output de xcodebuild (usado por xcodebuild.nvim)
    if ! brew list xcbeautify &>/dev/null; then
      brew install xcbeautify
      echo "✅ xcbeautify installed"
    else
      echo "✅ xcbeautify already installed"
    fi

    # swiftformat: formatter para Swift (usado por conform.nvim)
    if ! brew list swiftformat &>/dev/null; then
      brew install swiftformat
      echo "✅ swiftformat installed"
    else
      echo "✅ swiftformat already installed"
    fi

    # swiftlint: linter para Swift (opcional pero recomendado)
    if ! brew list swiftlint &>/dev/null; then
      echo "  Installing swiftlint..."
      brew install swiftlint
      echo "✅ swiftlint installed"
    else
      echo "✅ swiftlint already installed"
    fi

    echo ""
    echo "  IMPORTANTE para proyectos Xcode:"
    echo "  Ejecuta esto en la raíz de cada proyecto iOS:"
    echo "  xcode-build-server config -scheme <NombreScheme> -workspace <Archivo.xcworkspace>"
    echo "  Esto genera buildServer.json que necesita sourcekit-lsp para funcionar."
  else
    echo "⚠️  Homebrew not found. Install from: https://brew.sh"
    echo "   Then manually: brew install xcode-build-server xcbeautify swiftformat swiftlint"
  fi
fi

# Kotlin / Android
echo ""
echo "🤖 Kotlin/Android: kotlin-language-server se instala via Mason automáticamente."
echo "   Abre un archivo .kt en Neovim y Mason lo instalará."

# AI: Claude Code CLI + OpenAI Codex CLI
echo ""
echo "🧠 AI CLI Integration:"
echo ""
echo "   1. Claude Code CLI:"
if command_exists claude; then
  echo "   ✅ claude CLI found: $(which claude)"
else
  echo "   ⚠️  claude CLI not found."
  echo "      Install from: https://claude.ai/code"
fi
echo ""
echo "   2. OpenAI Codex CLI:"
if command_exists codex; then
  echo "   ✅ codex CLI found: $(which codex)"
else
  echo "   ⚠️  codex CLI not found."
  echo "      Install: npm install -g @openai/codex"
  echo "      Or download from: https://github.com/openai/codex/releases"
  if command_exists npm; then
    read -p "   Install codex CLI now? (y/N) " install_codex
    if [[ "$install_codex" =~ ^[Yy]$ ]]; then
      npm install -g @openai/codex
      echo "   ✅ codex CLI installed"
    fi
  fi
fi
echo ""
echo "   3. OpenCode CLI:"
if command_exists opencode; then
  echo "   ✅ opencode CLI found: $(which opencode)"
else
  echo "   ⚠️  opencode CLI not found."
  echo "      Install: curl -fsSL https://opencode.ai/install.sh | sh"
  echo "      Or via brew: brew install opencode/tap/opencode"
fi
echo ""
echo "   En Neovim: <leader>ac (Claude Code) | <leader>ao (Codex) | <leader>aO (OpenCode)"

echo ""
echo "✨ Installation complete!"
echo "Run :checkhealth in Neovim to verify everything is working."
