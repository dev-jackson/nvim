-- Theme persistence module
-- Saves and loads the user's preferred colorscheme

local M = {}

-- Path to store the theme preference
local theme_file = vim.fn.stdpath("data") .. "/current_theme.txt"

-- Available themes with their variants
M.themes = {
  { name = "gruvbox", display = "Gruvbox" },
  { name = "tokyonight", display = "Tokyo Night" },
  { name = "tokyonight-night", display = "Tokyo Night (Night)" },
  { name = "tokyonight-storm", display = "Tokyo Night (Storm)" },
  { name = "tokyonight-day", display = "Tokyo Night (Day)" },
  { name = "tokyonight-moon", display = "Tokyo Night (Moon)" },
  { name = "catppuccin", display = "Catppuccin (Mocha)" },
  { name = "catppuccin-latte", display = "Catppuccin (Latte)" },
  { name = "catppuccin-frappe", display = "Catppuccin (Frappe)" },
  { name = "catppuccin-macchiato", display = "Catppuccin (Macchiato)" },
  { name = "catppuccin-mocha", display = "Catppuccin (Mocha)" },
  { name = "onedark", display = "OneDark" },
}

-- Save the current theme to file
function M.save_theme(theme_name)
  local file = io.open(theme_file, "w")
  if file then
    file:write(theme_name)
    file:close()
    return true
  end
  return false
end

-- Load the saved theme from file
function M.load_theme()
  local file = io.open(theme_file, "r")
  if file then
    local theme = file:read("*all")
    file:close()
    return theme
  end
  return nil
end

-- Apply a theme and save it
function M.set_theme(theme_name)
  local ok, err = pcall(vim.cmd.colorscheme, theme_name)
  if ok then
    M.save_theme(theme_name)
    vim.notify("Theme set to: " .. theme_name, vim.log.levels.INFO)
    return true
  else
    vim.notify("Failed to set theme: " .. theme_name .. "\n" .. err, vim.log.levels.ERROR)
    return false
  end
end

-- Initialize and load saved theme
function M.init()
  local saved_theme = M.load_theme()
  if saved_theme and saved_theme ~= "" then
    pcall(vim.cmd.colorscheme, saved_theme)
  else
    -- Default theme if none saved
    pcall(vim.cmd.colorscheme, "gruvbox")
  end
end

return M
