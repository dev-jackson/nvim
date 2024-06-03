return {
  "jose-elias-alvarez/null-ls.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "MunifTanjim/prettier.nvim",
    "mhartington/formatter.nvim"
  },
  main = "config.plugins.prettier",
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.diagnostics.eslint_d.with({
          diagnostics_format = 'eslint #{m}\n(#{c})'
        }),
        null_ls.builtins.diagnostics.fish
      },
    })
    local prettier = require("prettier")
    prettier.setup({
      bin = 'prettierd',
      filetypes = {
        "css",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "json",
        "scss",
        "less"
      }
    })
    -- Auto format on save
    local formatter_prettier = { require('formatter.defaults.prettier') }
    require("formatter").setup({
      filetype = {
        javascript      = formatter_prettier,
        javascriptreact = formatter_prettier,
        typescript      = formatter_prettier,
        typescriptreact = formatter_prettier,
        css             = formatter_prettier,
        scss            = formatter_prettier
      }
    })
    -- automatically format buffer before writing to disk:
    vim.api.nvim_create_augroup('BufWritePostFormatter', {})
    vim.api.nvim_create_autocmd('BufWritePost', {
      command = 'FormatWrite',
      group = 'BufWritePostFormatter',
      pattern = { '*.js', '*.jsx', '*.ts', '*.tsx' },
    })
  end
}
