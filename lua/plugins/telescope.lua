return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make'
    }
  },
  opts = {
    defaults = {
      prompt_prefix = "   ",
      selection_caret = " ",
      entry_prefix = " ",
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
        },
        width = 0.87,
        height = 0.80,
        preview_cutoff = 120,
      },
      file_ignore_patterns = {
        "node_modules",
        "*/node_modules/*",
        ".git/",
        "*/%.git/*",
      },
      mappings = {
        i = {
          ["<C-j>"] = function(...)
            return require("telescope.actions").move_selection_next(...)
          end,
          ["<C-k>"] = function(...)
            return require("telescope.actions").move_selection_previous(...)
          end,
          ["<C-q>"] = function(prompt_bufnr)
            local actions = require("telescope.actions")
            actions.smart_send_to_qflist(prompt_bufnr)
            actions.open_qflist(prompt_bufnr)
          end,
          ["<C-d>"] = function(...)
            return require("telescope.actions").preview_scrolling_down(...)
          end,
          ["<C-u>"] = function(...)
            return require("telescope.actions").preview_scrolling_up(...)
          end,
        },
        n = {
          ["q"] = function(...)
            return require("telescope.actions").close(...)
          end,
          ["<C-q>"] = function(prompt_bufnr)
            local actions = require("telescope.actions")
            actions.smart_send_to_qflist(prompt_bufnr)
            actions.open_qflist(prompt_bufnr)
          end,
        },
      },
    },
    pickers = {},
    extensions = {
      fzf = {},
      file_browser = {
        theme = "ivy",
        hijack_netrw = false,
      },
    }
  },
  config = function(_, opts)
    local telescope = require('telescope')

    -- Setup telescope first
    telescope.setup(opts)

    -- Load fzf extension (native sorter)
    local ok_fzf, _ = pcall(telescope.load_extension, 'fzf')
    if not ok_fzf then
      vim.notify("Failed to load telescope-fzf-native. Run: cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim && make", vim.log.levels.WARN)
    end

    -- Load file_browser extension
    local ok_fb, _ = pcall(telescope.load_extension, 'file_browser')
    if not ok_fb then
      vim.notify("Failed to load telescope-file-browser", vim.log.levels.WARN)
    end
  end,
  keys = {
    -- ============================================================================
    -- FIND (<leader>f = Find files and navigation)
    -- ============================================================================
    {
      "<leader>ff",
      function()
        require('telescope.builtin').find_files()
      end,
      desc = "Find files"
    },
    {
      "<leader>fg",
      function()
        require('telescope.builtin').git_files({ show_untracked = true })
      end,
      desc = "Find git files"
    },
    {
      "<leader>fb",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "Find buffers"
    },
    {
      "<leader>fr",
      function()
        require("telescope.builtin").oldfiles()
      end,
      desc = "Recent files"
    },
    {
      "<leader>fh",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "Find help"
    },
    {
      "<leader>fm",
      function()
        require("telescope.builtin").marks()
      end,
      desc = "Find marks"
    },
    {
      "<leader>fR",
      function()
        require("telescope.builtin").registers()
      end,
      desc = "Find registers"
    },

    -- ============================================================================
    -- SEARCH (<leader>s = Search/grep operations)
    -- ============================================================================
    {
      "<leader>sg",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Search with grep"
    },
    {
      "<leader>sw",
      function()
        require("telescope.builtin").grep_string()
      end,
      desc = "Search word under cursor"
    },
    {
      "<leader>sc",
      function()
        require("telescope.builtin").commands()
      end,
      desc = "Search commands"
    },
    {
      "<leader>sk",
      function()
        require("telescope.builtin").keymaps()
      end,
      desc = "Search keymaps"
    },
    {
      "<leader>sh",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "Search help"
    },
    {
      "<leader>sm",
      function()
        require("telescope.builtin").man_pages()
      end,
      desc = "Search man pages"
    },
    {
      "<leader>so",
      function()
        require("telescope.builtin").vim_options()
      end,
      desc = "Search vim options"
    },
    {
      "<leader>sr",
      function()
        require("telescope.builtin").resume()
      end,
      desc = "Resume last search"
    },

    -- ============================================================================
    -- GIT SEARCH (<leader>sg* = Git operations via Telescope)
    -- ============================================================================
    -- Note: <leader>g* is reserved for Fugitive operations
    {
      "<leader>sgs",
      function()
        require("telescope.builtin").git_status()
      end,
      desc = "Git status (Telescope)"
    },
    {
      "<leader>sgc",
      function()
        require("telescope.builtin").git_commits()
      end,
      desc = "Git commits (Telescope)"
    },
    {
      "<leader>sgb",
      function()
        require("telescope.builtin").git_branches()
      end,
      desc = "Git branches (Telescope)"
    },
    {
      "<leader>sgf",
      function()
        require("telescope.builtin").git_bcommits()
      end,
      desc = "Git file commits (Telescope)"
    },
    {
      "<leader>sgh",
      function()
        require("telescope.builtin").git_stash()
      end,
      desc = "Git stash (Telescope)"
    },

    -- ============================================================================
    -- LSP SEARCH (<leader>sl* = LSP symbols via Telescope)
    -- ============================================================================
    {
      "<leader>sld",
      function()
        require("telescope.builtin").lsp_definitions()
      end,
      desc = "LSP definitions"
    },
    {
      "<leader>slr",
      function()
        require("telescope.builtin").lsp_references()
      end,
      desc = "LSP references"
    },
    {
      "<leader>sli",
      function()
        require("telescope.builtin").lsp_implementations()
      end,
      desc = "LSP implementations"
    },
    {
      "<leader>slt",
      function()
        require("telescope.builtin").lsp_type_definitions()
      end,
      desc = "LSP type definitions"
    },
    {
      "<leader>sls",
      function()
        require("telescope.builtin").lsp_document_symbols()
      end,
      desc = "LSP document symbols"
    },
    {
      "<leader>slw",
      function()
        require("telescope.builtin").lsp_workspace_symbols()
      end,
      desc = "LSP workspace symbols"
    },
    {
      "<leader>sla",
      function()
        require("telescope.builtin").diagnostics()
      end,
      desc = "LSP diagnostics (all)"
    },

    -- ============================================================================
    -- NEOVIM CONFIG (<leader>f* = Find config files)
    -- ============================================================================
    {
      "<leader>fc",
      function()
        require("telescope.builtin").find_files({
          prompt_title = "Neovim Config",
          cwd = vim.fn.stdpath("config"),
        })
      end,
      desc = "Find config files"
    },
    {
      "<leader>fp",
      function()
        require("telescope.builtin").find_files({
          prompt_title = "Plugins",
          cwd = vim.fn.stdpath("config") .. "/lua/plugins",
          attach_mappings = function(_, map)
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            map("i", "<c-y>", function(prompt_bufnr)
              local new_plugin = action_state.get_current_line()
              actions.close(prompt_bufnr)
              vim.cmd(string.format("edit %s/lua/plugins/%s.lua", vim.fn.stdpath("config"), new_plugin))
            end)
            return true
          end
        })
      end,
      desc = "Find plugin files"
    },

    -- ============================================================================
    -- FILE BROWSER (<leader>bb = Browse files)
    -- ============================================================================
    {
      "<leader>bb",
      function()
        require("telescope").extensions.file_browser.file_browser({
          path = "%:p:h",
          select_buffer = true
        })
      end,
      desc = "File browser"
    },
  },
}
