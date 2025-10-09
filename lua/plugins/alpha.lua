return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Neovim Logo
    dashboard.section.header.val = {
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡄⠀⠀⠀⠀⠀⠀⠀⢀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡄⢸⣿⣇⠀⠀⠀⠀⠀⠀⠀⢸⣿⡇⢠⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[⢲⣤⡀⠀⠀⠀⠀⠀⠀⠀⣸⡇⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⢸⣇⠀⠀⠀⠀⠀⠀⠀⢀⣠⡖]],
      [[⠀⠹⣿⣆⠀⠀⠀⠀⠀⣰⣿⠇⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⠸⣿⣆⠀⠀⠀⠀⠀⣰⣿⠏⠀]],
      [[⠀⠀⢻⣿⡆⠀⠀⠐⢿⣿⣿⣦⣼⣿⣿⡇⠀⠀⠀⠀⠀⢰⣿⣿⣇⣴⣿⣿⡿⠂⠀⠀⢰⣿⡟⠀⠀]],
      [[⠀⠀⢸⣿⡇⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿⠏⠁⠀⠀⠀⢸⣿⡇⠀⠀]],
      [[⠀⠀⢸⣿⣿⡄⠀⠀⠀⠀⢹⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⢠⣾⣿⡇⠀⠀]],
      [[⢰⡄⠸⣿⣿⣿⣦⣄⠀⠀⢸⣿⣿⣿⣿⣿⡀⠀⠀⠀⢀⣿⣿⣿⣿⣿⡇⠀⠀⣠⣴⣿⣿⣿⡇⢠⡆]],
      [[⢸⣿⣆⢻⣿⣿⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟⠁⠀⣀⠀⠈⢻⣿⣿⣿⣿⣿⣾⣿⣿⣿⣿⣿⡟⣰⣿⡇]],
      [[⠀⣿⣿⣷⣽⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⢾⣿⡷⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣾⣿⣿⠀]],
      [[⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠀⠉⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⡀]],
      [[⢸⣦⡈⢿⣿⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⣿⣿⡄⠀⢠⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⡿⢁⣴⡇]],
      [[⠀⢿⣿⣮⣿⣿⣿⣿⣿⡇⠈⠻⣿⣿⣿⣿⣿⣿⣶⣿⣿⣿⣿⣿⣿⠟⠁⢸⣿⣿⣿⣿⣿⣵⣿⡿⠁]],
      [[⠀⠈⢻⣿⣿⣿⣿⣿⣿⡇⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⢸⣿⣿⣿⣿⣿⣿⡟⠁⠀]],
      [[⠀⠀⠀⠉⠻⢿⣿⣿⣿⣧⠀⠀⡀⠀⠙⣿⣿⣿⣿⣿⣿⣿⠋⠀⢀⠀⠀⣼⣿⣿⣿⣿⠟⠉⠀⠀⠀]],
      [[⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣷⣄⣹⣷⣤⣈⣿⣿⣿⣿⣿⣁⣤⣾⣏⣠⣾⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⡇⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⢸⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⡇⢷⣿⣿⣿⣿⣿⣿⣿⣿⣿⡾⢸⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⡇⣈⢿⣿⣿⣿⣿⣿⣿⣿⡿⣡⢸⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠶⣾⣿⣿⣿⣿⣿⣿⣿⣷⠶⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⣿⣿⣿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    }

    -- Buttons with beautiful Nerd Font icons
    dashboard.section.buttons.val = {
      dashboard.button("f", "  Find File", ":Telescope find_files<CR>"),
      dashboard.button("n", "  New File", ":ene <BAR> startinsert<CR>"),
      dashboard.button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
      dashboard.button("g", "  Find Text", ":Telescope live_grep<CR>"),
      dashboard.button("c", "  Configuration", ":e $MYVIMRC<CR>"),
      dashboard.button("l", "  Lazy", ":Lazy<CR>"),
      dashboard.button("m", "  Mason", ":Mason<CR>"),
      dashboard.button("q", "  Quit", ":qa<CR>"),
    }

    -- Footer
    local function footer()
      local total_plugins = require("lazy").stats().count
      local datetime = os.date("  %d-%m-%Y   %H:%M:%S")
      local version = vim.version()
      local nvim_version_info = "  v" .. version.major .. "." .. version.minor .. "." .. version.patch

      return {
        "",
        datetime .. "     " .. total_plugins .. " plugins" .. nvim_version_info,
        "",
        "  by Jackson",
      }
    end

    dashboard.section.footer.val = footer()

    -- Perfect centering configuration
    dashboard.config.layout = {
      { type = "padding", val = 2 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }

    -- Apply centered opts
    dashboard.config.opts = {
      noautocmd = true,
    }

    alpha.setup(dashboard.config)

    -- Auto commands for alpha
    vim.cmd([[
      autocmd FileType alpha setlocal nofoldenable
    ]])
  end,
}
