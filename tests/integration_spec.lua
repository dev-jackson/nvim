-- Integration tests: verify LSP servers actually attach to fixture files.
-- Requires LSP servers installed via Mason.  Run: make test-integration

local config_dir = vim.fn.stdpath("config")
local fixtures   = config_dir .. "/tests/fixtures"

-- Returns true if the binary is reachable (Mason or system PATH)
local function has_binary(name)
  return vim.fn.executable(name) == 1
end

-- Open a file and return its bufnr
local function open(path)
  vim.cmd("edit " .. vim.fn.fnameescape(path))
  return vim.api.nvim_get_current_buf()
end

-- Spin the event loop until `server_name` attaches or timeout expires
local function wait_for_lsp(bufnr, server_name, timeout_ms)
  return vim.wait(timeout_ms, function()
    for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
      if c.name == server_name then return true end
    end
    return false
  end, 500)
end

-- ── Lua ──────────────────────────────────────────────────────────────────────
describe("integration › lua_ls", function()
  it("attaches to a Lua file", function()
    if not has_binary("lua-language-server") then pending("lua-language-server not installed") return end
    local buf = open(fixtures .. "/lua/test.lua")
    assert.is_true(wait_for_lsp(buf, "lua_ls", 10000), "lua_ls did not attach in 10s")
  end)
end)

-- ── TypeScript ────────────────────────────────────────────────────────────────
describe("integration › ts_ls", function()
  it("attaches to a TypeScript file", function()
    if not has_binary("typescript-language-server") then pending("typescript-language-server not installed") return end
    local buf = open(fixtures .. "/typescript/src/index.ts")
    assert.is_true(wait_for_lsp(buf, "ts_ls", 15000), "ts_ls did not attach in 15s")
  end)
end)

-- ── Python ────────────────────────────────────────────────────────────────────
describe("integration › pylsp", function()
  it("attaches to a Python file", function()
    if not has_binary("pylsp") then pending("pylsp not installed") return end
    local buf = open(fixtures .. "/python/main.py")
    assert.is_true(wait_for_lsp(buf, "pylsp", 10000), "pylsp did not attach in 10s")
  end)
end)

-- ── Swift ─────────────────────────────────────────────────────────────────────
describe("integration › sourcekit", function()
  it("attaches to a Swift file", function()
    if not has_binary("sourcekit-lsp") then pending("sourcekit-lsp not found — install Xcode CLT") return end
    local buf = open(fixtures .. "/swift/Sources/TestProject/main.swift")
    assert.is_true(wait_for_lsp(buf, "sourcekit", 15000), "sourcekit did not attach in 15s")
  end)
end)

-- ── Kotlin (lento: JVM startup ~30-60s) ──────────────────────────────────────
describe("integration › kotlin_language_server", function()
  it("attaches to a Kotlin file [slow]", function()
    if not has_binary("kotlin-language-server") then pending("kotlin-language-server not installed") return end
    local buf = open(fixtures .. "/kotlin/src/main/kotlin/Main.kt")
    assert.is_true(wait_for_lsp(buf, "kotlin_language_server", 60000), "kotlin LSP did not attach in 60s")
  end)
end)
