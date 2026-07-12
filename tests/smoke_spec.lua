-- Smoke tests por lenguaje: abre cada fixture y verifica que
--   (a) el highlighter de treesitter se activa
--   (b) el LSP esperado attachea
-- Requiere: parsers instalados (site/parser) y LSP servers via Mason.
-- Run: make test-smoke

local config_dir = vim.fn.stdpath("config")
local fixtures   = config_dir .. "/tests/fixtures"

local function has_binary(name)
  return vim.fn.executable(name) == 1
end

local function open(path)
  vim.cmd("edit " .. vim.fn.fnameescape(path))
  return vim.api.nvim_get_current_buf()
end

local function wait_for_ts(bufnr, timeout_ms)
  return vim.wait(timeout_ms, function()
    return vim.treesitter.highlighter.active[bufnr] ~= nil
  end, 100)
end

local function wait_for_lsp(bufnr, server_name, timeout_ms)
  return vim.wait(timeout_ms, function()
    for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
      if c.name == server_name then return true end
    end
    return false
  end, 500)
end

-- { nombre, fixture, binario LSP, nombre client LSP, timeout LSP }
local cases = {
  { "lua",        "/lua/test.lua",                          "lua-language-server",          "lua_ls",     10000 },
  { "typescript", "/typescript/src/index.ts",               "typescript-language-server",   "ts_ls",      15000 },
  { "python",     "/python/main.py",                        "pyright-langserver",           "pyright",    10000 },
  { "swift",      "/swift/Sources/TestProject/main.swift",  "sourcekit-lsp",                "sourcekit",  15000 },
  { "kotlin",     "/kotlin/src/main/kotlin/Main.kt",        "intellij-server",              "kotlin_lsp", 90000 },
}

for _, case in ipairs(cases) do
  local name, fixture, binary, client, timeout = case[1], case[2], case[3], case[4], case[5]

  describe("smoke › " .. name, function()
    it("treesitter highlighter activates", function()
      local buf = open(fixtures .. fixture)
      assert.is_true(wait_for_ts(buf, 5000),
        "treesitter highlighter did not activate for " .. name .. " in 5s")
    end)

    it("LSP " .. client .. " attaches", function()
      if not has_binary(binary) then pending(binary .. " not installed") return end
      local buf = open(fixtures .. fixture)
      assert.is_true(wait_for_lsp(buf, client, timeout),
        client .. " did not attach in " .. timeout .. "ms")
    end)
  end)
end
