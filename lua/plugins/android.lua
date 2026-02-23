return {
  -- ============================================================================
  -- ANDROID-NVIM-PLUGIN: Build, run, logcat, AVD y Gradle desde Neovim
  -- Requiere: ANDROID_HOME=~/Library/Android/sdk en ~/.zshrc
  -- Primera vez por proyecto: :AndroidMenu para seleccionar módulo/variante
  -- Keymaps: <leader>A* (ver which-key.lua)
  -- ============================================================================
  {
    "iamironz/android-nvim-plugin",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("android").setup({
        sdk = {
          root_env_keys    = { "ANDROID_HOME", "ANDROID_SDK_ROOT" },
          local_properties = true,  -- detecta vía local.properties del proyecto
        },
        keymaps = {
          enabled = false,  -- usamos nuestros propios keymaps (<leader>A*)
        },
        file_watcher   = true,  -- recarga config si cambia build.gradle
        autosave       = true,  -- guarda antes de build
        restore_logcat = true,  -- reabre logcat al reiniciar Neovim
      })
    end,
    keys = {
      { "<leader>Am", "<cmd>AndroidMenu<cr>",          desc = "Android: Menu" },
      { "<leader>At", "<cmd>AndroidTargets<cr>",       desc = "Android: Targets" },
      { "<leader>Ao", "<cmd>AndroidTools<cr>",         desc = "Android: Tools" },
      { "<leader>Aa", "<cmd>AndroidActions<cr>",       desc = "Android: Actions" },
      { "<leader>Ab", "<cmd>AndroidBuild<cr>",         desc = "Android: Build + Install + Run" },
      { "<leader>AB", "<cmd>AndroidBuildAssemble<cr>", desc = "Android: Assemble APK" },
      { "<leader>Ar", "<cmd>AndroidRun<cr>",           desc = "Android: Run" },
      { "<leader>AR", "<cmd>AndroidRunStop<cr>",       desc = "Android: Stop" },
      { "<leader>Al", "<cmd>AndroidLogcat<cr>",        desc = "Android: Logcat" },
      { "<leader>Ag", "<cmd>AndroidGradleTasks<cr>",   desc = "Android: Gradle Tasks" },
    },
    ft = { "kotlin", "java", "gradle", "groovy", "xml" },
  },
}
