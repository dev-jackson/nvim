local prettier = require "prettier"

local M = {};

function M.setup()
  prettier.setup({
    bin = "prettier",
    filetypes = {
      "css",
      "graphql",
      "html",
      "javascript",
      "javascriptreact",
      "json",
      "less",
      "markdown",
      "scss",
      "typescript",
      "typescriptreact",
      "yaml",
    },
    ["null-ls"] = {
      condition = function()
        return prettier.config_exists({
          check_package_json = true
        })
      end,
      runtime_condition = function(_)
        return true
      end,
      timeout = 5000,
    }
  })
end

return M
