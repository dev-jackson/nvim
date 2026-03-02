-- lua/config/bootstrap.lua
-- Setup automático al primer lanzamiento + verificación de herramientas en cada inicio.
--
-- Primera vez:  muestra prompt para correr install.sh (interactivo en terminal)
-- Lanzamientos siguientes: verifica herramientas opcionales y notifica si faltan
--
-- Comandos disponibles siempre:
--   :BootstrapInstall  → corre install.sh manualmente en cualquier momento
--   :BootstrapCheck    → re-verifica herramientas y muestra estado
--   :BootstrapReset    → borra el flag para re-promtear al próximo inicio

local M = {}

-- Flag file: marca si el setup ya fue corrido alguna vez
local flag_file = vim.fn.stdpath("data") .. "/bootstrap_done"
local config_dir = vim.fn.stdpath("config")
local install_script = config_dir .. "/install.sh"

local function cmd_exists(cmd)
  return vim.fn.executable(cmd) == 1
end

local function notify(msg, level, opts)
  vim.notify(msg, level or vim.log.levels.INFO, vim.tbl_extend("keep", opts or {}, {
    title = "Neovim Setup",
  }))
end

-- Abre una ventana terminal y ejecuta install.sh
local function run_install_script()
  if vim.fn.filereadable(install_script) == 0 then
    notify("install.sh no encontrado en: " .. install_script, vim.log.levels.ERROR)
    return
  end

  -- noautocmd: impide que plugins (alpha, snacks, etc.) disparen BufEnter/BufNewFile
  -- y modifiquen el buffer antes de que el terminal lo tome.
  -- Ambos comandos necesitan noautocmd: tabnew Y terminal.
  vim.cmd("noautocmd tabnew")
  local buf = vim.api.nvim_get_current_buf()

  -- TermClose se dispara cuando el proceso terminal termina (Neovim 0.9+)
  vim.api.nvim_create_autocmd("TermClose", {
    buffer = buf,
    once = true,
    callback = function()
      local exit_code = vim.v.event.status
      if exit_code == 0 then
        vim.fn.writefile({ "done" }, flag_file)
        vim.defer_fn(function()
          notify(
            "Setup completado. Reinicia Neovim para activar todo.",
            vim.log.levels.INFO
          )
        end, 300)
      else
        notify(
          "install.sh terminó con código " .. exit_code .. ". Revisa la salida arriba.",
          vim.log.levels.WARN
        )
      end
    end,
  })

  vim.cmd("noautocmd terminal bash " .. vim.fn.shellescape(install_script))
  vim.cmd("startinsert")
end

-- Verifica herramientas y devuelve tabla con ausentes
local function get_missing_tools()
  local missing = {}

  -- Node.js
  if not cmd_exists("npm") then
    table.insert(missing, { tool = "npm", hint = "https://nodejs.org" })
  end

  -- Python
  if not cmd_exists("pip3") and not cmd_exists("pip") then
    table.insert(missing, { tool = "pip3", hint = "https://python.org" })
  end

  -- .NET (para Roslyn LSP y CSharpier)
  if not cmd_exists("dotnet") then
    table.insert(missing, { tool = "dotnet", hint = "https://dotnet.microsoft.com" })
  end

  -- AI CLIs
  if not cmd_exists("claude") then
    table.insert(missing, { tool = "claude", hint = "https://claude.ai/code" })
  end
  if not cmd_exists("codex") then
    table.insert(missing, { tool = "codex", hint = "npm install -g @openai/codex" })
  end
  if not cmd_exists("opencode") then
    table.insert(missing, { tool = "opencode", hint = "https://opencode.ai" })
  end

  -- macOS only: herramientas Swift/iOS + tree-sitter CLI
  if vim.fn.has("mac") == 1 then
    if not cmd_exists("tree-sitter") then
      table.insert(missing, { tool = "tree-sitter", hint = "brew install tree-sitter  (necesario para Neovim — NO usar npm)" })
    end
    if not cmd_exists("swiftformat") then
      table.insert(missing, { tool = "swiftformat", hint = "brew install swiftformat" })
    end
    if not cmd_exists("swiftlint") then
      table.insert(missing, { tool = "swiftlint", hint = "brew install swiftlint" })
    end
    if not cmd_exists("xcode-build-server") then
      table.insert(missing, { tool = "xcode-build-server", hint = "brew install xcode-build-server" })
    end
    if not cmd_exists("xcbeautify") then
      table.insert(missing, { tool = "xcbeautify", hint = "brew install xcbeautify" })
    end
    -- sourcekit-lsp viene con Xcode
    if not cmd_exists("sourcekit-lsp") and vim.fn.filereadable("/usr/bin/sourcekit-lsp") == 0 then
      table.insert(missing, { tool = "sourcekit-lsp", hint = "Install Xcode from App Store" })
    end
  end

  return missing
end

-- Muestra el estado de todas las herramientas (usado por :BootstrapCheck)
local function show_tool_status()
  local tools = {
    -- { nombre, comando/path, descripción }
    { "npm",                "npm",                      "Node.js package manager" },
    { "pip3",               "pip3",                     "Python package manager" },
    { "dotnet",             "dotnet",                   ".NET SDK (Roslyn LSP / CSharpier)" },
    { "claude",             "claude",                   "Claude Code CLI" },
    { "codex",              "codex",                    "OpenAI Codex CLI" },
    { "opencode",           "opencode",                 "OpenCode AI coding agent" },
  }

  -- macOS-only tools
  if vim.fn.has("mac") == 1 then
    vim.list_extend(tools, {
      { "swiftformat",        "swiftformat",              "Swift formatter" },
      { "swiftlint",          "swiftlint",                "Swift linter" },
      { "xcode-build-server", "xcode-build-server",       "Xcode build bridge" },
      { "xcbeautify",         "xcbeautify",               "Xcode output formatter" },
      { "sourcekit-lsp",      "/usr/bin/sourcekit-lsp",   "Swift LSP (needs Xcode)" },
    })
  end

  local lines = { "=== Neovim Tool Status ===", "" }
  for _, t in ipairs(tools) do
    local name, cmd, desc = t[1], t[2], t[3]
    local found = cmd_exists(cmd) or vim.fn.filereadable(cmd) == 1
    local icon = found and "✓" or "✗"
    local status = found and "installed" or "MISSING"
    table.insert(lines, string.format("  %s  %-25s %s  (%s)", icon, name, status, desc))
  end

  table.insert(lines, "")
  table.insert(lines, "Run :BootstrapInstall to install missing tools.")

  -- Mostrar en un buffer flotante
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

  local width = 65
  local height = #lines + 2
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " Neovim Setup Status ",
    title_pos = "center",
  })

  -- Cerrar con q o <Esc>
  for _, key in ipairs({ "q", "<Esc>" }) do
    vim.keymap.set("n", key, function()
      vim.api.nvim_win_close(win, true)
    end, { buffer = buf, nowait = true, silent = true })
  end
end

-- Prompt de primera vez
local function first_run_prompt()
  vim.ui.select(
    { "Sí, instalar ahora", "No, lo haré manualmente" },
    {
      prompt = "Primera vez en esta config — ¿Correr install.sh para instalar dependencias?",
    },
    function(choice)
      if choice and choice:match("^Sí") then
        -- vim.schedule: defer to the next event loop tick so vim.ui.select
        -- fully closes its buffer before termopen runs (requires unmodified buffer)
        vim.schedule(run_install_script)
      else
        -- Marcar como hecho para no preguntar de nuevo
        vim.fn.writefile({ "skipped" }, flag_file)
        notify(
          "Puedes correr :BootstrapInstall en cualquier momento para instalar dependencias.",
          vim.log.levels.INFO
        )
      end
    end
  )
end

-- Notificación silenciosa si faltan herramientas importantes
local function silent_check()
  local missing = get_missing_tools()
  if #missing == 0 then
    return
  end

  local names = vim.tbl_map(function(t) return t.tool end, missing)
  notify(
    "Herramientas faltantes: " .. table.concat(names, ", ") .. "\n:BootstrapCheck para detalles",
    vim.log.levels.WARN
  )
end

function M.init()
  local is_first_run = vim.fn.filereadable(flag_file) == 0

  if is_first_run then
    -- Esperar a que la UI esté lista antes de mostrar el prompt
    vim.defer_fn(first_run_prompt, 800)
  else
    -- En lanzamientos posteriores: verificación ligera y silenciosa
    vim.defer_fn(silent_check, 3000)
  end

  -- Comandos disponibles siempre
  vim.api.nvim_create_user_command("BootstrapInstall", function()
    run_install_script()
  end, { desc = "Correr install.sh para instalar dependencias del sistema" })

  vim.api.nvim_create_user_command("BootstrapCheck", function()
    show_tool_status()
  end, { desc = "Mostrar estado de todas las herramientas" })

  vim.api.nvim_create_user_command("BootstrapReset", function()
    vim.fn.delete(flag_file)
    notify(
      "Flag de bootstrap borrado. Al próximo inicio se pedirá correr install.sh.",
      vim.log.levels.INFO
    )
  end, { desc = "Resetear bootstrap (re-promtear al próximo inicio)" })
end

return M
