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

    -- Setup lspconfig
    local lspconfig = require("lspconfig")

    -- Lua LSP
    lspconfig.lua_ls.setup({
      on_attach = on_attach,
      capabilities = lsp_capabilities,
      settings = {
        Lua = {
          telemetry = { enable = false },
          workspace = { checkThirdParty = false },
          diagnostics = {
            globals = { 'vim' }
          }
        }
      }
    })

    -- TypeScript/JavaScript LSP
    lspconfig.ts_ls.setup({
      on_attach = on_attach,
      capabilities = lsp_capabilities,
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          }
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          }
        }
      }
    })

    -- ESLint LSP
    lspconfig.eslint.setup({
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        vim.api.nvim_create_autocmd('BufWritePre', {
          buffer = bufnr,
          command = 'EslintFixAll',
        })
      end,
      capabilities = lsp_capabilities,
    })

    -- Tailwind CSS LSP
    lspconfig.tailwindcss.setup({
      on_attach = on_attach,
      capabilities = lsp_capabilities,
      filetypes = {
        'html', 'css', 'scss', 'javascript', 'javascriptreact', 
        'typescript', 'typescriptreact', 'vue', 'svelte'
      }
    })

    -- Python LSP
    lspconfig.pylsp.setup({
      on_attach = on_attach,
      capabilities = lsp_capabilities,
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

    -- Swift LSP (only on macOS)
    if vim.fn.has('macunix') == 1 then
      lspconfig.sourcekit.setup({
        on_attach = on_attach,
        capabilities = lsp_capabilities,
        filetypes = { 'swift', 'objective-c', 'objective-cpp' },
        root_dir = lspconfig.util.root_pattern('Package.swift', '.git', '*.xcodeproj', '*.xcworkspace'),
        settings = {
          sourcekit_lsp = {
            formatting = {
              tab_width = 4,
              indentation_width = 4,
            }
          }
        }
      })
    end

    -- CSS LSP
    lspconfig.cssls.setup({
      on_attach = on_attach,
      capabilities = lsp_capabilities,
    })

    -- HTML LSP
    lspconfig.html.setup({
      on_attach = on_attach,
      capabilities = lsp_capabilities,
    })

    -- JSON LSP
    lspconfig.jsonls.setup({
      on_attach = on_attach,
      capabilities = lsp_capabilities,
    })
  end,
}
