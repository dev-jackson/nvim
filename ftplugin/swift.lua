-- Swift-specific settings (Xcode style: 4 spaces)
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.softtabstop = 4

-- Swift-specific indentation
vim.opt_local.cindent = true
vim.opt_local.cinoptions = ":0,l1,t0,g0,(0"

-- Enable spell check for comments
vim.opt_local.spell = false

-- Set up Swift-specific key mappings
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.buffer = 0  -- Set for current buffer only
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Swift-specific mappings (only if xcodebuild is available)
if pcall(require, "xcodebuild") then
  map("n", "<leader>sb", "<cmd>XcodebuildBuild<cr>", { desc = "Swift: Build" })
  map("n", "<leader>sr", "<cmd>XcodebuildRun<cr>", { desc = "Swift: Run" })
  map("n", "<leader>st", "<cmd>XcodebuildTest<cr>", { desc = "Swift: Test" })
  map("n", "<leader>sc", "<cmd>XcodebuildClean<cr>", { desc = "Swift: Clean" })
end

-- Auto-commands for Swift development
local swift_augroup = vim.api.nvim_create_augroup("SwiftDev", { clear = true })

-- Auto-save before building
vim.api.nvim_create_autocmd("User", {
  group = swift_augroup,
  pattern = "XcodebuildBuildStarted",
  callback = function()
    vim.cmd("silent! wall")
  end,
})

-- Show notification when entering Swift file in a project
vim.api.nvim_create_autocmd("BufEnter", {
  group = swift_augroup,
  pattern = "*.swift",
  once = true,
  callback = function()
    -- Check if we're in a Swift project
    local swift_project_markers = {
      "Package.swift",
      "*.xcodeproj",
      "*.xcworkspace"
    }
    
    for _, marker in ipairs(swift_project_markers) do
      if vim.fn.glob(marker) ~= "" then
        vim.defer_fn(function()
          vim.notify("Swift project detected! Use <leader>x* for Xcode commands", vim.log.levels.INFO, {
            title = "Swift Development",
            timeout = 3000,
          })
        end, 1000)
        break
      end
    end
  end,
}) 