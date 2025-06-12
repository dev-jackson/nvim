return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "main",
  cmd = "CopilotChat",
  dependencies = {
    "github/copilot.vim", -- Official GitHub Copilot plugin
    { "nvim-lua/plenary.nvim", branch = "master" },
  },
  build = "make", -- optional: build tiktoken when available
  opts = function()
    -- Personalized headers
    local user = vim.env.USER or "User"
    user = user:sub(1, 1):upper() .. user:sub(2)

    return {
      auto_insert_mode = true,
      question_header = "  " .. user .. " ",
      answer_header = "  Copilot ",
      -- Open chat in a right vertical split
      window = {
        layout = "vertical", -- vertical split
        width = 0.4,          -- 40% of the editor width
      },
      -- Override mappings so <C-c> does NOT close the chat
      mappings = {
        close = {
          normal = "q",  -- keep normal-mode mapping
          insert = false, -- disable <C-c> mapping in insert mode
        },
      },
    }
  end,
  keys = {
    {
      "<leader>aa",
      function()
        return require("CopilotChat").toggle()
      end,
      desc = "Toggle Copilot Chat",
      mode = { "n", "v" },
    },
    {
      "<leader>ax",
      function()
        return require("CopilotChat").reset()
      end,
      desc = "Reset Copilot Chat",
      mode = { "n", "v" },
    },
    {
      "<leader>ap",
      function()
        require("CopilotChat").select_prompt()
      end,
      desc = "Prompt Actions",
      mode = { "n", "v" },
    },
  },
  config = function(_, opts)
    -- Always open vertical splits to the right so chat appears on the right side
    vim.opt.splitright = true

    -- Apply user options
    require("CopilotChat").setup(opts)

    -- Optional UI tweaks for the chat buffer
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "copilot-chat",
      callback = function()
        vim.opt_local.relativenumber = false
        vim.opt_local.number = false
      end,
    })
  end,
} 