-- Unit tests for lua/plugins/lsp.lua
-- Verifies the structure of ALL LSP configs: Lua, TypeScript, ESLint,
-- Tailwind, Python, Swift (sourcekit), and Kotlin.
--
-- Run with:  make test-unit
-- Or:        make test

local captured = {}  -- will hold configs passed to vim.lsp.config()

-- ── helpers ──────────────────────────────────────────────────────────────────

local function load_lsp_plugin()
  -- Stubs for modules not available in the minimal test environment
  package.loaded['cmp_nvim_lsp'] = { default_capabilities = function() return {} end }
  package.loaded['neodev']       = { setup = function() end }

  -- Save originals
  local orig = {
    lsp_config            = vim.lsp.config,
    lsp_enable            = vim.lsp.enable,
    keymap_set            = vim.keymap.set,
    nvim_create_autocmd   = vim.api.nvim_create_autocmd,
  }

  -- Spy: capture vim.lsp.config calls
  vim.lsp.config = function(name, config)
    if type(name) == "string" then
      captured[name] = config
    end
  end

  -- No-ops for APIs we don't need to test
  vim.lsp.enable            = function() end
  vim.keymap.set            = function() end
  vim.api.nvim_create_autocmd = function() end

  -- Load and execute the plugin's config function
  local path = vim.fn.stdpath("config") .. "/lua/plugins/lsp.lua"
  local plugin, load_err = loadfile(path)
  assert(plugin, "Failed to load lsp.lua: " .. tostring(load_err))

  local spec = plugin()
  assert(type(spec) == "table" and type(spec.config) == "function",
    "lsp.lua must return a table with a config function")

  local ok, run_err = pcall(spec.config, nil, {})
  assert(ok, "lsp.lua config() raised an error: " .. tostring(run_err))

  -- Restore originals
  vim.lsp.config            = orig.lsp_config
  vim.lsp.enable            = orig.lsp_enable
  vim.keymap.set            = orig.keymap_set
  vim.api.nvim_create_autocmd = orig.nvim_create_autocmd

  package.loaded['cmp_nvim_lsp'] = nil
  package.loaded['neodev']       = nil
end

-- ── setup (run once for the whole file) ──────────────────────────────────────

local loaded = false
local function ensure_loaded()
  if not loaded then
    load_lsp_plugin()
    loaded = true
  end
end

-- ── Lua LSP ──────────────────────────────────────────────────────────────────

describe("lsp.lua › lua_ls (Lua)", function()

  before_each(ensure_loaded)

  it("is configured", function()
    assert.is_not_nil(captured["lua_ls"], "lua_ls must be registered with vim.lsp.config()")
  end)

  it("telemetry is disabled", function()
    local telemetry = captured["lua_ls"].settings.Lua.telemetry
    assert.is_false(telemetry.enable)
  end)

  it("'vim' is in diagnostics globals (no false positives in nvim config)", function()
    local globals = captured["lua_ls"].settings.Lua.diagnostics.globals
    assert.truthy(vim.tbl_contains(globals, "vim"),
      "'vim' must be listed in diagnostics.globals")
  end)

  it("checkThirdParty is false (no annoying prompts)", function()
    local ws = captured["lua_ls"].settings.Lua.workspace
    assert.is_false(ws.checkThirdParty)
  end)

end)

-- ── TypeScript / JavaScript LSP ───────────────────────────────────────────────

describe("lsp.lua › ts_ls (TypeScript/JavaScript)", function()

  before_each(ensure_loaded)

  it("is configured", function()
    assert.is_not_nil(captured["ts_ls"], "ts_ls must be registered with vim.lsp.config()")
  end)

  it("memory is capped at 4096 MB", function()
    local mem = captured["ts_ls"].settings.typescript.tsserver.maxTsServerMemory
    assert.are.equal(4096, mem)
  end)

  it("typescript inlayHints are configured", function()
    local hints = captured["ts_ls"].settings.typescript.inlayHints
    assert.is_not_nil(hints)
    assert.are.equal("all", hints.includeInlayParameterNameHints)
  end)

  it("javascript inlayHints are configured", function()
    local hints = captured["ts_ls"].settings.javascript.inlayHints
    assert.is_not_nil(hints)
    assert.are.equal("all", hints.includeInlayParameterNameHints)
  end)

  it("excludeDirectories includes node_modules", function()
    local dirs = captured["ts_ls"].init_options.tsserver.watchOptions.excludeDirectories
    assert.truthy(vim.tbl_contains(dirs, "**/node_modules"),
      "node_modules must be excluded from file watching")
  end)

  it("excludeDirectories includes dist and build", function()
    local dirs = captured["ts_ls"].init_options.tsserver.watchOptions.excludeDirectories
    assert.truthy(vim.tbl_contains(dirs, "**/dist"))
    assert.truthy(vim.tbl_contains(dirs, "**/build"))
  end)

end)

-- ── ESLint LSP ───────────────────────────────────────────────────────────────

describe("lsp.lua › eslint", function()

  before_each(ensure_loaded)

  it("is configured", function()
    assert.is_not_nil(captured["eslint"], "eslint must be registered with vim.lsp.config()")
  end)

  it("useFlatConfig is enabled (ESLint 9+ support)", function()
    local flat = captured["eslint"].settings.experimental.useFlatConfig
    assert.is_true(flat)
  end)

  it("workingDirectory mode is 'auto'", function()
    local mode = captured["eslint"].settings.workingDirectory.mode
    assert.are.equal("auto", mode)
  end)

  it("has an on_attach function (for auto-fix on save)", function()
    assert.is_function(captured["eslint"].on_attach)
  end)

end)

-- ── Tailwind CSS LSP ─────────────────────────────────────────────────────────

describe("lsp.lua › tailwindcss", function()

  before_each(ensure_loaded)

  it("is configured", function()
    assert.is_not_nil(captured["tailwindcss"], "tailwindcss must be registered")
  end)

  it("filetypes include React (typescriptreact)", function()
    local ft = captured["tailwindcss"].filetypes
    assert.truthy(vim.tbl_contains(ft, "typescriptreact"),
      "typescriptreact must be in tailwindcss filetypes")
  end)

  it("filetypes include html and css", function()
    local ft = captured["tailwindcss"].filetypes
    assert.truthy(vim.tbl_contains(ft, "html"))
    assert.truthy(vim.tbl_contains(ft, "css"))
  end)

end)

-- ── Python LSP ───────────────────────────────────────────────────────────────

describe("lsp.lua › pylsp (Python)", function()

  before_each(ensure_loaded)

  it("is configured", function()
    assert.is_not_nil(captured["pylsp"], "pylsp must be registered with vim.lsp.config()")
  end)

  it("maxLineLength is 100", function()
    local pycs = captured["pylsp"].settings.pylsp.plugins.pycodestyle
    assert.are.equal(100, pycs.maxLineLength)
  end)

  it("pylsp_mypy is disabled (performance)", function()
    local mypy = captured["pylsp"].settings.pylsp.plugins.pylsp_mypy
    assert.is_false(mypy.enabled)
  end)

  it("rope_completion is disabled (performance)", function()
    local rope = captured["pylsp"].settings.pylsp.plugins.rope_completion
    assert.is_false(rope.enabled)
  end)

end)

-- ── Swift / iOS LSP (sourcekit) ───────────────────────────────────────────────

describe("lsp.lua › sourcekit (Swift/iOS)", function()

  before_each(ensure_loaded)

  it("is configured", function()
    assert.is_not_nil(captured["sourcekit"], "sourcekit must be registered with vim.lsp.config()")
  end)

  -- filetypes and root_dir delegated to lspconfig defaults (Neovim 0.11 compatible API)
  it("does not override filetypes (uses lspconfig defaults: swift/objc/objcpp)", function()
    assert.is_nil(captured["sourcekit"].filetypes,
      "sourcekit filetypes should be nil — inherited from lspconfig")
  end)

  it("does not override root_dir (uses lspconfig default with bufnr/on_dir signature)", function()
    assert.is_nil(captured["sourcekit"].root_dir,
      "sourcekit root_dir should be nil — inherited from lspconfig")
  end)

end)

-- ── Kotlin / Android LSP ─────────────────────────────────────────────────────

describe("lsp.lua › kotlin_language_server", function()

  before_each(ensure_loaded)

  it("is configured (vim.lsp.config was called for it)", function()
    assert.is_not_nil(captured["kotlin_language_server"],
      "kotlin_language_server must be registered with vim.lsp.config()")
  end)

  it("init_options does NOT contain externalSources  [regression]", function()
    local init_opts = captured["kotlin_language_server"].init_options or {}
    assert.is_nil(init_opts.externalSources,
      "externalSources must live in settings.kotlin, NOT in init_options")
  end)

  it("init_options only contains storagePath", function()
    local init_opts = captured["kotlin_language_server"].init_options or {}
    local keys = vim.tbl_keys(init_opts)
    assert.are.equal(1, #keys,
      "init_options should have exactly 1 key (storagePath), found: " .. vim.inspect(keys))
    assert.are.equal("storagePath", keys[1])
  end)

  it("storagePath ends with 'kotlin-language-server'", function()
    local sp = (captured["kotlin_language_server"].init_options or {}).storagePath
    assert.is_not_nil(sp)
    assert.truthy(sp:match("kotlin%-language%-server$"),
      "storagePath should end with kotlin-language-server, got: " .. tostring(sp))
  end)

  it("settings.kotlin.externalSources exists", function()
    local k = (captured["kotlin_language_server"].settings or {}).kotlin or {}
    assert.is_not_nil(k.externalSources,
      "externalSources must be in settings.kotlin")
  end)

  it("externalSources.useKlsScheme is false", function()
    local ext = captured["kotlin_language_server"].settings.kotlin.externalSources
    assert.is_false(ext.useKlsScheme)
  end)

  it("externalSources.autoConvertToKotlin is true", function()
    local ext = captured["kotlin_language_server"].settings.kotlin.externalSources
    assert.is_true(ext.autoConvertToKotlin)
  end)

  -- root_dir delegated to lspconfig (uses root_markers, Neovim 0.11 native approach)
  it("does not override root_dir (uses lspconfig root_markers)", function()
    assert.is_nil(captured["kotlin_language_server"].root_dir,
      "kotlin root_dir should be nil — lspconfig handles it via root_markers")
  end)

  it("inlayHints are all enabled", function()
    local hints = captured["kotlin_language_server"].settings.kotlin.inlayHints
    assert.is_not_nil(hints)
    assert.is_true(hints.typeHints.enable)
    assert.is_true(hints.parameterHints.enable)
    assert.is_true(hints.chainedHints.enable)
  end)

  it("completion.snippets.enabled is true", function()
    local c = captured["kotlin_language_server"].settings.kotlin.completion
    assert.is_true(c.snippets.enabled)
  end)

end)
