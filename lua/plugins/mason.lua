return {
  -- Mason: Package manager for LSP servers, formatters, linters
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end,
  },

  -- Mason Tool Installer: Auto-install LSP servers, formatters, and linters
  -- Note: In Neovim 0.11+, we use vim.lsp.config() directly instead of mason-lspconfig
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        -- Automatically install these tools
        -- Note: Some require system dependencies (run install.sh)
        ensure_installed = {
          -- LSP Servers
          "lua-language-server",    -- Lua
          "typescript-language-server", -- TypeScript/JavaScript (requires: npm)
          "eslint-lsp",            -- ESLint (requires: npm)
          "tailwindcss-language-server", -- Tailwind CSS (requires: npm)
          "pyright",               -- Python (type checking)
          "ruff",                  -- Python (lint + format + imports, vía ruff server)
          "kotlin-language-server", -- Kotlin/Android (JetBrains, incluye JRE propio)
          "css-lsp",               -- CSS (requires: npm)
          "html-lsp",              -- HTML (requires: npm)
          "json-lsp",              -- JSON (requires: npm)

          -- Formatters
          "prettier",              -- JS/TS/HTML/CSS/JSON (requires: npm)
          "stylua",                -- Lua
          "csharpier",             -- C# / .NET (requires: dotnet)
          "ktlint",                -- Kotlin linter/formatter (Android)

          -- Linters
          "markdownlint",          -- Markdown
        },
        -- Auto-update tools
        auto_update = false,
        -- Install on Neovim startup
        run_on_start = true,
        -- Show notifications
        start_delay = 3000, -- Wait 3 seconds before installing
      })
    end,
  },
}
