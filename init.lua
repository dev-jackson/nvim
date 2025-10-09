-- Set leader keys BEFORE loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config")

vim.api.nvim_create_user_command("Jackson", function()
  local picker = require("telescope.pickers")
  local finders = require("telescope.finders")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local conf = require("telescope.config").values

  picker.new({}, {
    prompt_title = "Dragon",
    finder = finders.new_table({
      results = { "alpha", "beta", "delta", "omega" }
    }),
    sorter = conf.generic_sorter(),
    previewer = false,
    attach_mappings = function (_, map)
      map("i", "<cr>", function (promt_bufnr)
        actions.close(promt_bufnr)
        local entry = action_state.get_selected_entry()
        vim.notify(entry[1])
      end)

      return true
    end,
  }):find()
end, {})

-- Theme selector command with Telescope and live preview
vim.api.nvim_create_user_command("ThemeSelect", function()
  local theme_persistence = require("config.theme_persistence")
  local picker = require("telescope.pickers")
  local finders = require("telescope.finders")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local conf = require("telescope.config").values
  local previewers = require("telescope.previewers")

  -- Save current theme to restore if user cancels
  local original_theme = vim.g.colors_name or theme_persistence.load_theme() or "gruvbox"

  -- Convert themes to display format
  local theme_list = {}
  for _, theme in ipairs(theme_persistence.themes) do
    table.insert(theme_list, { theme.name, theme.display })
  end

  -- Load sample code from theme_preview module
  local sample_code = require("config.theme_preview")

  -- Custom previewer that shows code sample with theme applied
  local theme_previewer = previewers.new_buffer_previewer({
    title = "Code Preview",
    define_preview = function(self, entry)
      local bufnr = self.state.bufnr

      -- Set buffer content with sample code first
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(sample_code, "\n"))

      -- Set filetype for syntax highlighting
      vim.api.nvim_set_option_value("filetype", "javascript", { buf = bufnr })
      vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = bufnr })
      vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })

      -- Apply the selected theme to all windows
      vim.schedule(function()
        pcall(vim.cmd.colorscheme, entry.value)
      end)
    end,
  })

  -- Function to apply preview theme
  local function preview_theme(prompt_bufnr)
    local selection = action_state.get_selected_entry(prompt_bufnr)
    if selection and selection.value then
      pcall(vim.cmd.colorscheme, selection.value)
    end
  end

  picker.new({}, {
    prompt_title = "🎨 Select Theme (live preview with code)",
    finder = finders.new_table({
      results = theme_list,
      entry_maker = function(entry)
        return {
          value = entry[1],
          display = entry[2],
          ordinal = entry[2],
        }
      end,
    }),
    sorter = conf.generic_sorter(),
    previewer = theme_previewer,
    attach_mappings = function(prompt_bufnr, map)
      -- Apply and save theme on Enter
      local function select_theme()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry(prompt_bufnr)
        if selection then
          theme_persistence.set_theme(selection.value)
        end
      end

      -- Restore original theme on cancel
      local function cancel_selection()
        actions.close(prompt_bufnr)
        pcall(vim.cmd.colorscheme, original_theme)
        vim.notify("Theme selection cancelled, restored: " .. original_theme, vim.log.levels.INFO)
      end

      -- Wrap navigation keys to apply preview
      local function move_and_preview(move_action)
        return function()
          move_action(prompt_bufnr)
          vim.schedule(function()
            preview_theme(prompt_bufnr)
          end)
        end
      end

      -- Map all navigation keys with preview
      map("i", "<Down>", move_and_preview(actions.move_selection_next))
      map("i", "<Up>", move_and_preview(actions.move_selection_previous))
      map("i", "<C-n>", move_and_preview(actions.move_selection_next))
      map("i", "<C-p>", move_and_preview(actions.move_selection_previous))

      map("n", "j", move_and_preview(actions.move_selection_next))
      map("n", "k", move_and_preview(actions.move_selection_previous))
      map("n", "<Down>", move_and_preview(actions.move_selection_next))
      map("n", "<Up>", move_and_preview(actions.move_selection_previous))

      -- Selection and cancel
      map("i", "<cr>", select_theme)
      map("n", "<cr>", select_theme)
      map("i", "<esc>", cancel_selection)
      map("n", "<esc>", cancel_selection)
      map("n", "q", cancel_selection)

      -- Apply preview to initial selection
      vim.schedule(function()
        preview_theme(prompt_bufnr)
      end)

      return true
    end,
  }):find()
end, {})
