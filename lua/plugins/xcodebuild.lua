return {
  "wojciech-kulik/xcodebuild.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-tree.lua", -- optional, for nvim-tree integration
  },
  config = function()
    require("xcodebuild").setup({
      -- Restore previous settings and picker selections
      restore_on_start = true,
      
      -- Auto-save before running any command
      auto_save = true,
      
      -- Show build logs in a separate buffer
      show_build_progress_in_quickfix = true,
      
      -- Notifications
      notifications = {
        -- Show build notifications
        build = true,
        -- Show test notifications
        test = true,
        -- Show run notifications
        run = true,
      },
      
      -- Log level (error, warn, info, debug, trace)
      log_level = vim.log.levels.INFO,
      
      -- Integration with nvim-tree
      integrations = {
        nvim_tree = {
          enabled = true,
          should_update_project = true,
        },
      },
      
      -- Code coverage settings
      code_coverage = {
        enabled = true,
        -- Show coverage in gutter
        show_covered_lines = true,
        -- Show coverage in virtual text
        show_partial_lines = true,
      },
      
      -- Test settings
      tests = {
        -- Show test results in gutter
        show_diagnostics = true,
        -- Show test duration
        show_duration = true,
      },
      
      -- Simulator settings
      simulator = {
        -- Reuse simulator if already running
        reuse_simulator = true,
      },
      
      -- Build settings
      build = {
        -- Auto-focus on errors
        auto_focus_on_error = true,
      },
    })
    
    -- Key mappings for xcodebuild.nvim
    local function map(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.silent = opts.silent ~= false
      vim.keymap.set(mode, lhs, rhs, opts)
    end
    
    -- Build and run
    map("n", "<leader>xb", "<cmd>XcodebuildBuild<cr>", { desc = "Build Project" })
    map("n", "<leader>xr", "<cmd>XcodebuildRun<cr>", { desc = "Run Project" })
    map("n", "<leader>xt", "<cmd>XcodebuildTest<cr>", { desc = "Run Tests" })
    map("n", "<leader>xT", "<cmd>XcodebuildTestClass<cr>", { desc = "Run This Test Class" })
    map("n", "<leader>x.", "<cmd>XcodebuildTestNearest<cr>", { desc = "Run Nearest Test" })
    
    -- Project management
    map("n", "<leader>xs", "<cmd>XcodebuildSelectScheme<cr>", { desc = "Select Scheme" })
    map("n", "<leader>xd", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Select Device" })
    map("n", "<leader>xp", "<cmd>XcodebuildSelectTestPlan<cr>", { desc = "Select Test Plan" })
    map("n", "<leader>xP", "<cmd>XcodebuildSelectProject<cr>", { desc = "Select Project" })
    
    -- Debugging
    map("n", "<leader>xdd", "<cmd>XcodebuildDebug<cr>", { desc = "Debug Build" })
    map("n", "<leader>xdt", "<cmd>XcodebuildDebugTests<cr>", { desc = "Debug Tests" })
    map("n", "<leader>xdc", "<cmd>XcodebuildDebugClass<cr>", { desc = "Debug Test Class" })
    map("n", "<leader>xd.", "<cmd>XcodebuildDebugNearest<cr>", { desc = "Debug Nearest Test" })
    
    -- Utilities
    map("n", "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Toggle Logs" })
    map("n", "<leader>xc", "<cmd>XcodebuildToggleCodeCoverage<cr>", { desc = "Toggle Code Coverage" })
    map("n", "<leader>xC", "<cmd>XcodebuildShowCodeCoverageReport<cr>", { desc = "Show Coverage Report" })
    map("n", "<leader>xq", "<cmd>XcodebuildQuickfixLine<cr>", { desc = "Quickfix Line" })
    map("n", "<leader>xa", "<cmd>XcodebuildCodeActions<cr>", { desc = "Code Actions" })
    
    -- Auto-commands for Swift files
    vim.api.nvim_create_augroup("XcodebuildNvim", { clear = true })
    
    -- Auto-detect Swift projects and show device/scheme in statusline
    vim.api.nvim_create_autocmd("FileType", {
      group = "XcodebuildNvim",
      pattern = "swift",
      callback = function()
        -- Check if we're in a Swift project
        local swift_project_markers = {
          "Package.swift",
          "*.xcodeproj",
          "*.xcworkspace"
        }
        
        for _, marker in ipairs(swift_project_markers) do
          if vim.fn.glob(marker) ~= "" then
            vim.notify("Swift project detected! Use <leader>x* commands for Xcode integration", vim.log.levels.INFO)
            break
          end
        end
      end,
    })
  end,
} 