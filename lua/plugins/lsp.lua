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

    -- Python LSP
    vim.lsp.config('pylsp', {
      settings = {
        pylsp = {
          plugins = {
            pycodestyle = {
              ignore = {'W391'},
              maxLineLength = 100
            },
            -- Disable features that scan large directories
            pylsp_mypy = { enabled = false },
            rope_completion = { enabled = false }
          }
        }
      }
    })

    -- Swift / iOS (sourcekit-lsp en /usr/bin/sourcekit-lsp vía Xcode)
    -- Para proyectos Xcode: ejecutar xcode-build-server config en el directorio del proyecto
    vim.lsp.config('sourcekit', {
      filetypes = { 'swift', 'objective-c', 'objective-cpp' },
      root_dir = function(fname)
        local util = require('lspconfig.util')
        return util.root_pattern(
          'buildServer.json',  -- generado por xcode-build-server
          '*.xcodeproj',
          '*.xcworkspace',
          'Package.swift',
          '.git'
        )(fname)
      end,
    })

    -- Kotlin / Android (kotlin-language-server via Mason)
    -- Docs: https://github.com/fwcd/kotlin-language-server
    vim.lsp.config('kotlin_language_server', {
      root_dir = function(fname)
        local util = require('lspconfig.util')
        return util.root_pattern(
          'settings.gradle',
          'settings.gradle.kts',
          'build.gradle',
          'build.gradle.kts',
          '.git'
        )(fname)
      end,
      -- init_options: SOLO acepta storagePath (según Configuration.kt)
      init_options = {
        storagePath = vim.fn.stdpath('cache') .. '/kotlin-language-server',
      },
      settings = {
        kotlin = {
          -- compiler.jvm.target omitted: LSP reads it from build.gradle.kts
          externalSources = {
            useKlsScheme        = false,  -- decompiler estándar (compatible con Neovim)
            autoConvertToKotlin = true,   -- bytecode Java → Kotlin (legible)
          },
          inlayHints = {
            typeHints      = { enable = true },
            parameterHints = { enable = true },
            chainedHints   = { enable = true },
          },
          completion = {
            snippets = { enabled = true },
          },
        },
      },
    })

    -- ========================================
    -- Enable language servers on-demand by filetype
    -- ========================================
    -- This loads servers only when needed, improving startup time

    local function enable_lsp_for_filetype(filetypes, servers)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function()
          vim.lsp.enable(servers)
        end,
        once = false,
      })
    end

    -- Lua (always load for Neovim config)
    vim.lsp.enable('lua_ls')

    -- Web development
    enable_lsp_for_filetype(
      {'typescript', 'javascript', 'typescriptreact', 'javascriptreact'},
      {'ts_ls', 'eslint'}
    )

    enable_lsp_for_filetype(
      {'html', 'css', 'scss', 'vue', 'svelte'},
      {'tailwindcss', 'cssls', 'html'}
    )

    -- Python
    enable_lsp_for_filetype('python', 'pylsp')

    -- Swift / iOS
    enable_lsp_for_filetype(
      { 'swift', 'objective-c', 'objective-cpp' },
      'sourcekit'
    )

    -- Kotlin / Android
    enable_lsp_for_filetype('kotlin', 'kotlin_language_server')

    -- JSON
    enable_lsp_for_filetype('json', 'jsonls')

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
    vim.lsp.set_log_level('WARN')  -- Less verbose logging
  end,
}
