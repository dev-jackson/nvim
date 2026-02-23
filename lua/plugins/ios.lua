return {
  -- ============================================================================
  -- XCODEBUILD.NVIM: Build, test y debug para iOS/macOS desde Neovim
  -- Requiere (ya instalados): xcode-build-server, xcbeautify
  -- Primera vez en cada proyecto: ejecutar :XcodebuildSetup
  -- Keymaps: <leader>X* (ver which-key.lua)
  -- ============================================================================
  {
    "wojciech-kulik/xcodebuild.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-tree.lua",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("xcodebuild").setup({
        project_marks_path = vim.fn.expanduser("~/.local/share/nvim/xcodebuild/"),
        code_coverage = {
          enabled = false,
        },
        logs = {
          auto_open_on_success_tests = false,
          auto_open_on_failed_tests = true,
          auto_open_on_build_failure = true,
          auto_focus = true,
          filetype = "objc",
          open_command = "silent botright 20split {path}",
          show_build_output = true,
          notify = {
            enabled = true,
            timeout = 4000,
          },
          xcbeautify = {
            enabled = true,  -- xcbeautify en /opt/homebrew/bin/xcbeautify
          },
        },
        quickfix = {
          show_errors_warnings = true,
          show_build_output = false,
        },
        simulator = {
          focus_simulator_on_app_launch = true,
        },
      })
    end,
    keys = {
      { "<leader>Xb", "<cmd>XcodebuildBuild<cr>", desc = "Xcode: Build" },
      { "<leader>XB", "<cmd>XcodebuildBuildForTesting<cr>", desc = "Xcode: Build for Testing" },
      { "<leader>Xr", "<cmd>XcodebuildBuildRun<cr>", desc = "Xcode: Build & Run" },
      { "<leader>Xt", "<cmd>XcodebuildTest<cr>", desc = "Xcode: Run All Tests" },
      { "<leader>XT", "<cmd>XcodebuildTestClass<cr>", desc = "Xcode: Run Test Class" },
      { "<leader>Xs", "<cmd>XcodebuildSelectScheme<cr>", desc = "Xcode: Select Scheme" },
      { "<leader>Xd", "<cmd>XcodebuildSelectDevice<cr>", desc = "Xcode: Select Device" },
      { "<leader>Xl", "<cmd>XcodebuildOpenLogs<cr>", desc = "Xcode: Open Logs" },
      { "<leader>Xc", "<cmd>XcodebuildToggleCodeCoverage<cr>", desc = "Xcode: Toggle Coverage" },
      { "<leader>Xp", "<cmd>XcodebuildSelectTestPlan<cr>", desc = "Xcode: Select Test Plan" },
    },
    ft = { "swift" },
  },
}
