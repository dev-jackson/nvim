return {
  "neovim/nvim-lspconfig",
  priority = 98,
  dependencies = {
    "mason-org/mason.nvim",
    -- lazydev reemplaza a neodev (EOL): tipos de la API de nvim para lua_ls
    { "folke/lazydev.nvim", ft = "lua", opts = {} },
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

    -- ========================================
    -- Performance: Directory Exclusions
    -- ========================================
    -- TypeScript and ESLint handle exclusions via their own settings
    -- See ts_ls config below for watchOptions.excludeDirectories

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
      init_options = {
        preferences = {
          -- Exclude these patterns from file watching and indexing
          disableSuggestions = false,
        },
        -- Tell tsserver to ignore these directories
        tsserver = {
          watchOptions = {
            excludeDirectories = {
              "**/node_modules",
              "**/.git",
              "**/dist",
              "**/build",
              "**/.next",
              "**/.nuxt",
              "**/coverage",
            }
          }
        }
      },
      settings = {
        typescript = {
          inlayHints = inlay_hints,
          tsserver = {
            maxTsServerMemory = 4096,  -- Limit memory usage to 4GB
          },
        },
        javascript = {
          inlayHints = inlay_hints
        },
      },
    })

    -- ESLint LSP (auto-fix on save)
    vim.lsp.config('eslint', {
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        -- Only create autocmd if eslint client supports code actions
        if client.server_capabilities.codeActionProvider then
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            callback = function()
              -- Only run ESLint auto-fix, no fallback to avoid "No code actions" message
              pcall(vim.cmd, 'EslintFixAll')
            end,
          })
        end
      end,
      settings = {
        workingDirectory = { mode = 'auto' },
        -- Soporte para ESLint 9+ flat config (eslint.config.js / .mjs)
        experimental = {
          useFlatConfig = true,
        },
        -- Performance: limit validation to open files only
        codeAction = {
          disableRuleComment = {
            enable = true,
            location = "separateLine"
          },
          showDocumentation = {
            enable = false  -- Disable to improve performance
          }
        },
      }
    })

    -- Tailwind CSS LSP
    vim.lsp.config('tailwindcss', {
      filetypes = {
        'html', 'css', 'scss', 'javascript', 'javascriptreact',
        'typescript', 'typescriptreact', 'vue', 'svelte'
      }
    })

    -- Python: pyright (inteligencia de tipos) + ruff (diagnósticos/format vía ruff server)
    vim.lsp.config('pyright', {
      settings = {
        pyright = {
          disableOrganizeImports = true,  -- ruff se encarga de los imports
        },
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = 'openFilesOnly',  -- no escanear proyectos grandes completos
          },
        },
      },
    })

    vim.lsp.config('ruff', {
      -- on_attach por-server REEMPLAZA al global '*': llamar el compartido explícitamente
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        client.server_capabilities.hoverProvider = false  -- hover lo da pyright
      end,
    })

    -- Swift / iOS (sourcekit-lsp en /usr/bin/sourcekit-lsp vía Xcode)
    -- Para proyectos Xcode: ejecutar xcode-build-server config en el directorio del proyecto
    -- root_dir y filetypes heredados de lspconfig (usa firma Neovim 0.11: function(bufnr, on_dir))
    vim.lsp.config('sourcekit', {})

    -- Kotlin / Android (JetBrains kotlin-lsp oficial, basado en IntelliJ)
    -- Docs: https://github.com/Kotlin/kotlin-lsp
    -- cmd (intellij-server --stdio), filetypes y root_markers heredados de
    -- lspconfig (lsp/kotlin_lsp.lua). Trae su propio JBR embebido.
    -- NOTA: el schema de settings de fwcd (settings.kotlin.*) NO aplica aquí.
    vim.lsp.config('kotlin_lsp', {})

    -- Fallback: si kotlin-lsp falla, descomentar este bloque y cambiar
    -- 'kotlin_lsp' por 'kotlin_language_server' en vim.lsp.enable().
    -- OJO: fwcd kotlin-language-server crashea con Java 25 (IllegalArgumentException
    -- al parsear la versión); requiere JDK ≤21 en PATH.
    -- vim.lsp.config('kotlin_language_server', {
    --   init_options = {
    --     storagePath = vim.fn.stdpath('cache') .. '/kotlin-language-server',
    --   },
    --   settings = {
    --     kotlin = {
    --       externalSources = { useKlsScheme = false, autoConvertToKotlin = true },
    --       inlayHints = {
    --         typeHints = { enable = true },
    --         parameterHints = { enable = true },
    --         chainedHints = { enable = true },
    --       },
    --       completion = { snippets = { enabled = true } },
    --     },
    --   },
    -- })

    -- ========================================
    -- Enable language servers
    -- ========================================
    -- vim.lsp.enable() ya es lazy: solo registra autocmds FileType y el server
    -- arranca al abrir un buffer compatible. Envolverlo en otro autocmd FileType
    -- (patrón anterior) impedía el attach al PRIMER buffer de cada filetype:
    -- enable() llamado durante el evento FileType no attachea al buffer que lo disparó.

    vim.lsp.enable({
      -- Lua (config de Neovim)
      'lua_ls',
      -- Web
      'ts_ls', 'eslint',
      'tailwindcss', 'cssls', 'html', 'jsonls',
      -- Python
      'pyright', 'ruff',
      -- Swift / iOS
      'sourcekit',
      -- Kotlin / Android
      'kotlin_lsp',
    })

    -- ========================================
    -- Performance optimizations for large projects
    -- ========================================

    -- Configure diagnostics to reduce interruptions
    vim.diagnostic.config({
      update_in_insert = false,  -- Don't update while typing
      virtual_text = {
        spacing = 4,
        prefix = '●',
        -- Only show diagnostics for current line in insert mode
        severity = { min = vim.diagnostic.severity.HINT },
      },
      signs = true,
      underline = true,
      severity_sort = true,
    })

    -- Reduce frequency of LSP updates
    -- (vim.lsp.set_log_level está deprecado en nvim 0.12)
    vim.lsp.log.set_level(vim.log.levels.WARN)  -- Less verbose logging
  end,
}
