return {
  "neovim/nvim-lspconfig",
  priority = 98,
  dependencies = {
    "williamboman/mason.nvim",
    "folke/neodev.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- Setup diagnostic keymaps
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

    -- LSP attach function
    local on_attach = function(client, bufnr)
      vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
      local opts = { buffer = bufnr, noremap = true, silent = true }

      -- Navigation
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

      -- Workspace
      vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
      vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
      vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts)

      -- Code actions
      vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)

      -- Formatting
      vim.keymap.set('n', '<space>f', function()
        vim.lsp.buf.format({ async = true })
      end, opts)
    end

    -- Setup neodev for lua development
    require("neodev").setup()

    -- ========================================
    -- Neovim 0.11+ API: vim.lsp.config()
    -- ========================================

    -- Global configuration for all language servers
    vim.lsp.config('*', {
      on_attach = on_attach,
      capabilities = lsp_capabilities,
    })

    -- Lua LSP (Neovim configuration)
    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          telemetry = { enable = false },
          workspace = { checkThirdParty = false },
          diagnostics = { globals = { 'vim' } }
        }
      }
    })

    -- TypeScript/JavaScript LSP
    local inlay_hints = {
      includeInlayParameterNameHints = 'all',
      includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,
    }

    vim.lsp.config('ts_ls', {
      settings = {
        typescript = { inlayHints = inlay_hints },
        javascript = { inlayHints = inlay_hints }
      }
    })

    -- ESLint LSP (auto-fix on save)
    vim.lsp.config('eslint', {
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        vim.api.nvim_create_autocmd('BufWritePre', {
          buffer = bufnr,
          command = 'EslintFixAll',
        })
      end,
    })

    -- Tailwind CSS LSP
    vim.lsp.config('tailwindcss', {
      filetypes = {
        'html', 'css', 'scss', 'javascript', 'javascriptreact',
        'typescript', 'typescriptreact', 'vue', 'svelte'
      }
    })

    -- Python LSP
    vim.lsp.config('pylsp', {
      settings = {
        pylsp = {
          plugins = {
            pycodestyle = {
              ignore = {'W391'},
              maxLineLength = 100
            }
          }
        }
      }
    })

    -- ========================================
    -- Enable all language servers
    -- ========================================
    -- Servers without custom settings inherit from '*' config
    vim.lsp.enable({
      'lua_ls',      -- Lua
      'ts_ls',       -- TypeScript/JavaScript
      'eslint',      -- ESLint
      'tailwindcss', -- Tailwind CSS
      'pylsp',       -- Python
      'omnisharp',   -- C# / .NET
      'cssls',       -- CSS
      'html',        -- HTML
      'jsonls'       -- JSON
    })
  end,
}
