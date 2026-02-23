require "config.settings"
require "config.lazy"
require "config.keymaps"

-- Load theme persistence and apply saved theme
vim.defer_fn(function()
  require("config.theme_persistence").init()
end, 100)

-- Bootstrap: first-run setup + tool verification on every launch
require("config.bootstrap").init()
