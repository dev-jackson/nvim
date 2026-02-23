return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  config = function()
    require("conform").setup({
      -- Define formatters by filetype
      formatters_by_ft = {
        -- Lua
        lua = { "stylua" },
        
        -- TypeScript/JavaScript
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        
        -- Web
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        
        -- Python
        python = { "black", "isort" },

        -- C# / .NET
        cs = { "csharpier" },

        -- Swift / iOS (swiftformat en /opt/homebrew/bin/swiftformat)
        swift = { "swiftformat" },

        -- Kotlin / Android (ktlint via Mason o fallback a LSP format)
        kotlin = { "ktlint" },

      },

      -- Format on save configuration
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        
        return {
          timeout_ms = 500,
          lsp_fallback = true,
        }
      end,
      
      -- Define custom formatters
      formatters = {
        swiftformat = {
          -- swiftformat está en PATH vía /opt/homebrew/bin
          prepend_args = { "--swiftversion", "5.10" },
        },
      },
    })
    
    -- Create commands for formatting control
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting globally
        vim.g.disable_autoformat = true
      else
        vim.b.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })
    
    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })
    
    -- Key mapping for manual formatting
    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      require("conform").format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
} 