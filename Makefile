NVIM        := nvim
CONFIG_DIR  := $(HOME)/.config/nvim

.PHONY: test test-syntax test-unit test-integration test-smoke test-all

## Run all tests (syntax + unit)
test: test-syntax test-unit

## Run everything, including slow integration and smoke tests
test-all: test-syntax test-unit test-integration test-smoke

## Check Lua syntax for all files in lua/
test-syntax:
	@echo "==> Checking Lua syntax..."
	@$(NVIM) --headless --noplugin -c "\
	lua \
	  local files = vim.fn.globpath('lua', '**/*.lua', 0, 1); \
	  local errors = {}; \
	  for _, f in ipairs(files) do \
	    local fn, err = loadfile(f); \
	    if not fn then table.insert(errors, 'FAIL: ' .. err) end \
	  end; \
	  if #errors > 0 then \
	    for _, e in ipairs(errors) do print(e) end; \
	    vim.cmd('cq') \
	  else \
	    print('All ' .. #files .. ' files OK') \
	  end" \
	-c "qa!" 2>&1
	@echo "==> Syntax OK"

## Run plenary unit tests (fast, no LSP servers required)
test-unit:
	@echo "==> Running unit tests..."
	@cd $(CONFIG_DIR) && \
	  $(NVIM) --headless --noplugin \
	    -u $(CONFIG_DIR)/tests/minimal_init.lua \
	    -c "lua require('plenary.busted').run('$(CONFIG_DIR)/tests/lsp_config_spec.lua')" \
	    2>&1; \
	  EXIT=$$?; \
	  exit $$EXIT

## Run LSP integration tests (slow: up to 90s for Kotlin — requires Mason-installed LSP servers)
test-integration:
	@echo "==> LSP integration tests (hasta 90s para Kotlin)..."
	@cd $(CONFIG_DIR) && \
	  $(NVIM) --headless --noplugin \
	    -u $(CONFIG_DIR)/tests/lsp_integration_init.lua \
	    -c "lua require('plenary.busted').run('$(CONFIG_DIR)/tests/integration_spec.lua')" \
	    2>&1; \
	  EXIT=$$?; \
	  exit $$EXIT

## Per-language smoke tests: treesitter highlight + LSP attach on fixtures (slow)
test-smoke:
	@echo "==> Smoke tests por lenguaje (treesitter + LSP)..."
	@cd $(CONFIG_DIR) && \
	  $(NVIM) --headless --noplugin \
	    -u $(CONFIG_DIR)/tests/smoke_init.lua \
	    -c "lua require('plenary.busted').run('$(CONFIG_DIR)/tests/smoke_spec.lua')" \
	    2>&1; \
	  EXIT=$$?; \
	  exit $$EXIT
