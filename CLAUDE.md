# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Neovim configuration (Neovim 0.11+) for multi-language development: TypeScript/JavaScript (React), Python, C#/.NET, Swift/iOS, Kotlin/Android, Lua, HTML/CSS/Tailwind. Uses Lazy.nvim for plugin management with modular configuration.

## Commands

### Tests

```bash
make test              # syntax check + unit tests (fast, default)
make test-syntax       # loadfile() every file under lua/
make test-unit         # plenary tests, no LSP servers needed (tests/lsp_config_spec.lua)
make test-integration  # real LSP servers via Mason; slow (up to 60s for Kotlin)
```

Tests run headless Neovim with plenary.busted. Unit tests bootstrap via `tests/minimal_init.lua` (plenary + lspconfig on rtp only); integration tests via `tests/lsp_integration_init.lua`, which stubs `cmp_nvim_lsp`/`neodev`, prepends Mason bin to PATH, and executes the real `lua/plugins/lsp.lua` config. Test fixtures per language live in `tests/fixtures/{typescript,python,swift,kotlin,lua}`.

Run a single spec file:
```bash
nvim --headless --noplugin -u tests/minimal_init.lua \
  -c "lua require('plenary.busted').run(vim.fn.getcwd() .. '/tests/lsp_config_spec.lua')"
```

### First-Time Setup

```bash
./install.sh   # installs npm/pip3/dotnet system packages LSP servers need
```

Mason auto-installs LSP servers/formatters/linters on startup (3s delay) via `mason-tool-installer.nvim` — the `ensure_installed` list is in `lua/plugins/mason.lua`.

### Status / Debugging

```vim
:Lazy                " Plugin manager UI
:Mason               " LSP/formatter installer UI
:LspInfo             " Active LSP servers
:LspRestart          " Restart LSP servers
:ConformInfo         " Formatter config
:checkhealth         " Health checks
:ThemeSelect         " Theme selector with live preview
```

## Architecture

### Configuration Loading Order

1. `init.lua` — sets `vim.g.mapleader`/`maplocalleader` FIRST (critical — must precede any plugin load), then loads `config` module. Also defines `:ThemeSelect` and `:Jackson` user commands.
2. `lua/config/init.lua` — loads settings, lazy, keymaps
3. `lua/config/lazy.lua` — bootstraps Lazy.nvim, imports every file in `lua/plugins/`
4. `lua/plugins/*.lua` — each returns a Lazy plugin spec (URL, dependencies, config function)

### LSP Setup (`lua/plugins/lsp.lua`)

Uses the Neovim 0.11+ native API — `vim.lsp.config()` to configure, `vim.lsp.enable()` to activate. **No mason-lspconfig.** Global `on_attach` + capabilities applied to every server via `vim.lsp.config('*', {...})`.

Servers load lazily per filetype: a `FileType` autocmd (`enable_lsp_for_filetype`) calls `vim.lsp.enable()` only when a matching buffer opens. Only `lua_ls` is enabled at startup.

- `ts_ls` + `eslint` — TS/JS; ESLint auto-fixes on save (`EslintFixAll` in a `BufWritePre` autocmd), flat-config (ESLint 9+) enabled
- `pylsp` — Python
- `sourcekit` — Swift/ObjC/C/C++; config intentionally empty `{}` — root_dir/filetypes inherit lspconfig defaults (Neovim 0.11 `function(bufnr, on_dir)` signature). For Xcode projects run `xcode-build-server config` in the project dir first.
- `kotlin_language_server` — Kotlin; `init_options` accepts ONLY `storagePath` (everything else goes under `settings.kotlin`). root_dir inherits lspconfig root_markers. JVM target read from build.gradle.kts.
- `tailwindcss`, `cssls`, `html`, `jsonls` — web

**C# is the exception**: uses `roslyn.nvim` (`lua/plugins/roslyn.lua`), NOT configured in lsp.lua and NOT omnisharp. Auto-downloads Microsoft.CodeAnalysis.LanguageServer via dotnet (~200MB first run).

### Formatting (`lua/plugins/conform.lua`)

Format-on-save enabled by default, 500ms timeout, `lsp_fallback = true`. Disable with `:FormatDisable` (buffer) / `:FormatDisable!` (global), re-enable with `:FormatEnable`, manual format `<leader>mp`.

- prettier (web), stylua (Lua), black+isort (Python), csharpier (C#), swiftformat (Swift, `--swiftversion 5.10`)
- **Kotlin deliberately absent**: ktlint's JVM startup exceeds the 500ms timeout, so Kotlin format-on-save falls through to LSP. Run ktlint manually if needed.

### Mobile Development

- **iOS**: `lua/plugins/ios.lua` — xcodebuild.nvim, keymaps `<leader>X*` (build/run/test/scheme/device). Requires xcode-build-server + xcbeautify. First time per project: `:XcodebuildSetup`.
- **Android**: `lua/plugins/android.lua` — android-nvim-plugin, keymaps `<leader>A*` (build/run/logcat/gradle). Requires `ANDROID_HOME`. First time per project: `:AndroidMenu`.

### AI Agent Integrations (`lua/plugins/ai.lua`)

Three terminal-panel agents, all backed by snacks.nvim terminals; changes appear as diffs to accept/reject:

- **claudecode.nvim** — `<leader>ac` toggle (right panel), `<leader>as` send selection, `<leader>ay`/`<leader>an` accept/reject diff
- **codex.nvim** — `<leader>ao` toggle (left panel), `<leader>ae` send selection; `auto_start = false` on purpose (avoids EADDRINUSE from stale port)
- **opencode.nvim** — `<leader>aO` toggle, `<leader>ai` ask with `@this` context, `<leader>aL` prompt library

### Theme System

Custom selector in `init.lua` (`:ThemeSelect`): Telescope picker with live preview using sample code from `lua/config/theme_preview.lua`; selection persisted/restored by `lua/config/theme_persistence.lua`.

### Performance

- LSP servers load per-filetype (see above); TS server memory capped at 4GB; `watchOptions.excludeDirectories` in ts_ls config excludes node_modules/dist/build/.next/etc. — extend that array for more
- Treesitter auto-disables for files >200KB or >5000 lines; parsers auto-install on buffer enter
- Diagnostics don't update in insert mode

## Key Mappings

Leader: `<Space>`. Full listing in `lua/config/keymaps.lua` and which-key.

- `<leader>e` explorer · `<leader>ff`/`fg`/`fb` Telescope find/grep/buffers
- `<leader>w` save · `<leader>q` quit · `<leader>rc` reload config
- LSP: `gd`/`gD`/`gr`/`K`, `<space>rn` rename, `<space>ca` code action, `<space>f` format, `[d`/`]d` diagnostics
- Buffers: `<leader>bd` close, `<leader>bn`/`bp` next/prev
- Git: `<leader>gs`/`gc`/`gp` status/commit/push
- Prefixes: `<leader>a*` AI agents, `<leader>X*` iOS, `<leader>A*` Android

## Adding a New Language

1. `lua/plugins/lsp.lua`: `vim.lsp.config('your_lsp', {...})` + add to an `enable_lsp_for_filetype()` call (or `vim.lsp.enable()` for always-on)
2. `lua/plugins/conform.lua`: add to `formatters_by_ft` (skip if formatter is JVM-slow — see Kotlin note)
3. `lua/plugins/mason.lua`: add tools to `ensure_installed`
4. `:TSInstall your_language`
5. Optional: fixture under `tests/fixtures/` + specs in `tests/`

## Important Notes

- Commit messages: no `Co-Authored-By` trailer
- Comments in plugin files are often Spanish — keep the existing style when editing
- `ftplugin/*.lua` holds filetype-specific settings
- Old docs may claim Swift/iOS was removed — false; it's fully supported (sourcekit + xcodebuild.nvim + swiftformat)
