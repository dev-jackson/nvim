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
      
      -- Swift (only on macOS)
      swift = vim.fn.has('macunix') == 1 and { "swiftlint" } or nil,
      
      -- Markdown
      markdown = { "markdownlint" },
      
      -- YAML
      yaml = { "yamllint" },
      
      -- Docker
      dockerfile = { "hadolint" },
    }
    
    -- Custom linter configurations
    lint.linters.swiftlint = {
      cmd = "swiftlint",
      args = { "lint", "--use-stdin", "--quiet" },
      stdin = true,
      stream = "stderr",
      ignore_exitcode = true,
      parser = function(output)
        local diagnostics = {}
        for line in output:gmatch("[^\r\n]+") do
          -- SwiftLint output format: <file>:<line>:<col>: <severity>: <message> (<rule>)
          local file, line_nr, col_nr, severity, message = line:match("([^:]+):(%d+):(%d+):%s*(%w+):%s*(.+)")
          if file and line_nr and col_nr and severity and message then
            local diagnostic_severity = vim.diagnostic.severity.INFO
            if severity:lower() == "error" then
              diagnostic_severity = vim.diagnostic.severity.ERROR
            elseif severity:lower() == "warning" then
              diagnostic_severity = vim.diagnostic.severity.WARN
            end
            
            table.insert(diagnostics, {
              lnum = tonumber(line_nr) - 1,
              col = tonumber(col_nr) - 1,
              message = message,
              severity = diagnostic_severity,
              source = "swiftlint",
            })
          end
        end
        return diagnostics
      end,
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