return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")
    
    -- Configure linters by filetype
    lint.linters_by_ft = {
      -- JavaScript/TypeScript (handled by ESLint LSP)
      -- javascript = { "eslint_d" },
      -- javascriptreact = { "eslint_d" },
      -- typescript = { "eslint_d" },
      -- typescriptreact = { "eslint_d" },
      
      -- Python
      python = { "flake8" },

      -- Markdown
      markdown = { "markdownlint" },
      
      -- YAML
      yaml = { "yamllint" },
      
      -- Docker
      dockerfile = { "hadolint" },
    }
    
    -- Auto-lint on specific events
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        -- Only lint if the file type has configured linters
        local ft = vim.bo.filetype
        if lint.linters_by_ft[ft] then
          lint.try_lint()
        end
      end,
    })
    
    -- Key mapping for manual linting
    vim.keymap.set("n", "<leader>ml", function()
      lint.try_lint()
    end, { desc = "Run linter for current file" })
  end,
} 