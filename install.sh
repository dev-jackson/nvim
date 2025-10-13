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
  deactivate
  echo "⚠️  pip3 not found. Skipping Python packages."
  echo "   Install Python from: https://python.org"
fi

# .NET dependencies for C# LSP
if command_exists dotnet; then
  echo "📦 Installing .NET tools..."
  dotnet tool install --global csharpier
  echo "✅ .NET tools installed"
else
  echo "⚠️  dotnet not found. Skipping .NET tools."
  echo "   Install .NET SDK from: https://dotnet.microsoft.com"
fi

echo ""
echo "✨ Installation complete!"
echo "Run :checkhealth in Neovim to verify everything is working."
