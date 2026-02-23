return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = true,
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+",
    },
    win = {
      border = "rounded",
      padding = { 1, 2 },
    },
    layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 3,
      align = "left",
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- ============================================================================
    -- GROUP REGISTRATIONS (Visual organization of keymaps)
    -- ============================================================================
    wk.add({
      -- Find group
      { "<leader>f", group = "Find", icon = "" },
      { "<leader>ff", desc = "Find files" },
      { "<leader>fg", desc = "Find git files" },
      { "<leader>fb", desc = "Find buffers" },
      { "<leader>fr", desc = "Recent files" },
      { "<leader>fh", desc = "Find help" },
      { "<leader>fm", desc = "Find marks" },
      { "<leader>fR", desc = "Find registers" },
      { "<leader>fc", desc = "Find config files" },
      { "<leader>fp", desc = "Find plugin files" },

      -- Search group
      { "<leader>s", group = "Search", icon = "" },
      { "<leader>sg", desc = "Search with grep" },
      { "<leader>sw", desc = "Search word under cursor" },
      { "<leader>sc", desc = "Search commands" },
      { "<leader>sk", desc = "Search keymaps" },
      { "<leader>sh", desc = "Search help" },
      { "<leader>sm", desc = "Search man pages" },
      { "<leader>so", desc = "Search vim options" },
      { "<leader>sr", desc = "Resume last search" },
      { "<leader>st", desc = "Search todos" },
      { "<leader>sT", desc = "Search todos/fix" },

      -- Search Git subgroup
      { "<leader>sg", group = "Git (Telescope)", icon = "" },
      { "<leader>sgs", desc = "Git status" },
      { "<leader>sgc", desc = "Git commits" },
      { "<leader>sgb", desc = "Git branches" },
      { "<leader>sgf", desc = "Git file commits" },
      { "<leader>sgh", desc = "Git stash" },

      -- Search LSP subgroup
      { "<leader>sl", group = "LSP", icon = "" },
      { "<leader>sld", desc = "Definitions" },
      { "<leader>slr", desc = "References" },
      { "<leader>sli", desc = "Implementations" },
      { "<leader>slt", desc = "Type definitions" },
      { "<leader>sls", desc = "Document symbols" },
      { "<leader>slw", desc = "Workspace symbols" },
      { "<leader>sla", desc = "Diagnostics" },

      -- Git group (Fugitive)
      { "<leader>g", group = "Git", icon = "" },
      { "<leader>gg", desc = "Git status" },
      { "<leader>gc", desc = "Git commit" },
      { "<leader>gp", desc = "Git push" },
      { "<leader>gl", desc = "Git pull" },
      { "<leader>gd", desc = "Git diff" },
      { "<leader>gB", desc = "Git blame" },

      -- Git Hunks group (Gitsigns)
      { "<leader>h", group = "Hunks", icon = "" },
      { "<leader>hs", desc = "Stage hunk" },
      { "<leader>hr", desc = "Reset hunk" },
      { "<leader>hS", desc = "Stage buffer" },
      { "<leader>hR", desc = "Reset buffer" },
      { "<leader>hu", desc = "Undo stage hunk" },
      { "<leader>hp", desc = "Preview hunk" },
      { "<leader>hP", desc = "Preview hunk inline" },
      { "<leader>hb", desc = "Blame line" },
      { "<leader>hd", desc = "Diff this" },
      { "<leader>hD", desc = "Diff this ~" },

      -- Buffer group
      { "<leader>b", group = "Buffers", icon = "" },
      { "<leader>bd", desc = "Close buffer" },
      { "<leader>bn", desc = "Next buffer" },
      { "<leader>bp", desc = "Previous buffer" },
      { "<leader>ba", desc = "Close all buffers" },
      { "<leader>bb", desc = "File browser" },

      -- Code group (LSP)
      { "<leader>c", group = "Code", icon = "" },
      { "<leader>ca", desc = "Code actions" },
      { "<leader>cr", desc = "Rename" },
      { "<leader>cf", desc = "Format" },
      { "<leader>cw", desc = "Clean whitespace" },
      { "<leader>cx", desc = "Close quickfix" },
      { "<leader>co", desc = "Open quickfix" },

      -- Diagnostics group
      { "<leader>d", group = "Diagnostics", icon = "" },
      { "<leader>dd", desc = "Show diagnostic" },
      { "<leader>dl", desc = "Diagnostic list" },

      -- Toggle group
      { "<leader>t", group = "Toggle/Terminal", icon = "" },
      { "<leader>tw", desc = "Toggle word wrap" },
      { "<leader>tn", desc = "Toggle line numbers" },
      { "<leader>tr", desc = "Toggle relative numbers" },
      { "<leader>ts", desc = "Toggle spell check" },
      { "<leader>tb", desc = "Toggle git blame" },
      { "<leader>td", desc = "Toggle deleted lines" },
      { "<leader>tf", desc = "Float terminal" },
      { "<leader>th", desc = "Horizontal terminal" },
      { "<leader>to", desc = "New tab" },
      { "<leader>tc", desc = "Close tab" },
      { "<leader>tN", desc = "Next tab" },
      { "<leader>tP", desc = "Previous tab" },

      -- Window group
      { "<leader>w", desc = "Save file" },
      { "<leader>wa", desc = "Save all files" },

      -- Quit group
      { "<leader>q", desc = "Quit window" },
      { "<leader>qa", desc = "Quit all" },

      -- Reload group
      { "<leader>r", group = "Reload", icon = "" },
      { "<leader>rr", desc = "Source current file" },
      { "<leader>rc", desc = "Reload config" },

      -- Navigation
      { "<leader>e", desc = "Toggle file explorer", icon = "" },
      { "<leader>nh", desc = "Clear search highlights" },

      -- Utilities
      { "<leader>x", desc = "Make executable", icon = "" },
      { "<leader>y", desc = "Copy to clipboard", icon = "" },
      { "<leader>Y", desc = "Copy line to clipboard" },
      { "<leader>p", desc = "Paste without losing register" },

      -- Trouble (if installed)
      { "<leader>x", group = "Trouble", icon = "" },
      { "<leader>xt", desc = "Todos (Trouble)" },
      { "<leader>xT", desc = "Todos/Fix (Trouble)" },

      -- AI group (Claude Code CLI + Codex CLI)
      { "<leader>a", group = "AI", icon = "" },
      { "<leader>ac", desc = "Claude Code: Toggle" },
      { "<leader>aA", desc = "Claude Code: Focus" },
      { "<leader>as", desc = "Claude Code: Send selection", mode = "v" },
      { "<leader>ay", desc = "Claude Code: Accept diff" },
      { "<leader>an", desc = "Claude Code: Reject diff" },
      { "<leader>ao", desc = "Codex: Toggle" },
      { "<leader>ae", desc = "Codex: Send selection", mode = "v" },

      -- Xcode / iOS group (capital X, no conflicto con <leader>x)
      { "<leader>X", group = "Xcode/iOS", icon = "" },
      { "<leader>Xb", desc = "Build" },
      { "<leader>XB", desc = "Build for Testing" },
      { "<leader>Xr", desc = "Build & Run" },
      { "<leader>Xt", desc = "Run All Tests" },
      { "<leader>XT", desc = "Run Test Class" },
      { "<leader>Xs", desc = "Select Scheme" },
      { "<leader>Xd", desc = "Select Device" },
      { "<leader>Xl", desc = "Open Logs" },
      { "<leader>Xc", desc = "Toggle Coverage" },
      { "<leader>Xp", desc = "Select Test Plan" },
    })

    -- ============================================================================
    -- NORMAL MODE MAPPINGS (non-leader)
    -- ============================================================================
    wk.add({
      -- LSP
      { "gd", desc = "Go to definition" },
      { "gD", desc = "Go to declaration" },
      { "gr", desc = "References" },
      { "gi", desc = "Go to implementation" },
      { "K", desc = "Hover documentation" },
      { "gO", desc = "Document symbols" },

      -- Diagnostics navigation
      { "[d", desc = "Previous diagnostic" },
      { "]d", desc = "Next diagnostic" },

      -- Git hunks navigation
      { "[c", desc = "Previous git hunk" },
      { "]c", desc = "Next git hunk" },

      -- Todo comments navigation
      { "[t", desc = "Previous todo" },
      { "]t", desc = "Next todo" },
      { "[e", desc = "Previous error todo" },
      { "]e", desc = "Next error todo" },

      -- Quickfix navigation
      { "[q", desc = "Previous quickfix" },
      { "]q", desc = "Next quickfix" },
    })
  end
}
