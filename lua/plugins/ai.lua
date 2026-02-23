return {
  -- ============================================================================
  -- CLAUDECODE.NVIM: Integración Claude Code CLI con Neovim
  -- Conecta el CLI `claude` (ya instalado) a Neovim via WebSocket MCP
  --
  -- Flujo de trabajo:
  --   1. Abrir Claude Code en Neovim: <leader>ac
  --   2. El CLI `claude` se lanza en un panel terminal
  --   3. Cuando Claude propone cambios en archivos, Neovim los muestra como diffs
  --   4. Aceptar diff: <leader>ay | Rechazar: <leader>an
  --
  -- Requiere: `claude` CLI en PATH (ya instalado vía Claude Code)
  -- ============================================================================
  {
    "coder/claudecode.nvim",
    dependencies = {
      -- snacks.nvim: maneja la ventana terminal de Claude Code
      "folke/snacks.nvim",
    },
    opts = {
      -- Puerto para el servidor WebSocket que Claude Code usa para comunicarse
      -- Claude Code lo detecta automáticamente via CLAUDE_CODE_NVIM_SOCKET
      port = nil,         -- nil = puerto aleatorio disponible (recomendado)
      log_level = "warn", -- "debug" para troubleshooting
      auto_start = true,  -- Inicia el servidor WebSocket al abrir Neovim

      -- Configuración del terminal donde se ejecuta `claude`
      terminal = {
        split_side = "right",  -- Panel a la derecha
        split_width_percentage = 0.35,
        provider = "snacks",   -- Usar snacks.nvim para el terminal
        show_native_term_exit_tip = true,
      },

      -- Diff: cómo mostrar los cambios propuestos por Claude
      diff = {
        provider = "native", -- Usar diff nativo de Neovim (sin deps extras)
      },
    },
    config = function(_, opts)
      require("claudecode").setup(opts)
    end,
    keys = {
      -- Toggle Claude Code terminal
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Claude Code: Toggle" },
      -- Abrir Claude con contexto del archivo actual
      { "<leader>aA", "<cmd>ClaudeCodeFocus<cr>", desc = "Claude Code: Focus" },
      -- Enviar selección visual a Claude
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Claude Code: Send selection" },
      -- Diff: aceptar cambios propuestos por Claude
      { "<leader>ay", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Claude Code: Accept diff" },
      -- Diff: rechazar cambios propuestos por Claude
      { "<leader>an", "<cmd>ClaudeCodeDiffReject<cr>", desc = "Claude Code: Reject diff" },
    },
    event = "VeryLazy",
  },

  -- snacks.nvim: requerido por claudecode.nvim para manejo de ventana terminal
  -- (también útil como utilería general de Neovim)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- Solo activamos lo que claudecode.nvim necesita
      terminal = { enabled = true },
      -- Resto de features de snacks desactivadas para no interferir con config existente
      bigfile = { enabled = false },
      dashboard = { enabled = false },
      indent = { enabled = false },
      input = { enabled = false },
      notifier = { enabled = false },
      quickfile = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },
    },
  },

  -- ============================================================================
  -- CODEX.NVIM: Integración OpenAI Codex CLI con Neovim
  -- Conecta el CLI `codex` a Neovim, mostrando cambios para aceptar/rechazar
  --
  -- Flujo de trabajo:
  --   1. Abrir Codex en Neovim: <leader>ao
  --   2. El CLI `codex` se lanza en panel terminal
  --   3. Codex propone cambios, Neovim los muestra como diffs
  --   4. Aceptar/rechazar igual que Claude
  --
  -- Requiere: `codex` CLI en PATH (npm install -g @openai/codex)
  -- ============================================================================
  {
    "ishiooon/codex.nvim",
    dependencies = {
      "folke/snacks.nvim",  -- Ya incluido arriba
    },
    opts = {
      -- Comando para lanzar el Codex CLI
      terminal_cmd = "codex",
      -- Panel a la izquierda para distinguirlo visualmente de Claude (derecha)
      split_side = "left",
      split_width_percentage = 0.35,
      -- Puerto WebSocket para la comunicación MCP
      port = nil,            -- nil = puerto automático
      log_level = "warn",
      -- false: el servidor solo arranca al abrir Codex (<leader>ao)
      -- true causaba EADDRINUSE si quedaba un proceso del puerto de sesiones anteriores
      auto_start = false,
    },
    config = function(_, opts)
      require("codex").setup(opts)
    end,
    keys = {
      -- Toggle Codex terminal
      { "<leader>ao", "<cmd>CodexToggle<cr>", desc = "Codex: Toggle" },
      -- Enviar selección visual a Codex
      { "<leader>ae", "<cmd>CodexSend<cr>", mode = "v", desc = "Codex: Send selection" },
    },
    event = "VeryLazy",
  },
}
