---@diagnostic disable: missing-fields
local cmp = require('cmp')
local luasnip = require('luasnip')
local cmp_autopairs = require "nvim-autopairs.completion.cmp"

local M = {}

function M.setup()
  cmp.setup({
    window = {
      completion = {
        border = "rounded",
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
      },
      documentation = {
        border = "rounded",
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
      },
    },
    formatting = {
      format = function(entry, vim_item)
        local KIND_ICONS = {
          Tailwind = '󰹞',
          Color = ' ',
          Snippet = " ",
          Text = " ",
          Method = " ",
          Function = " ",
          Constructor = " ",
          Field = " ",
          Variable = " ",
          Class = " ",
          Interface = " ",
          Module = " ",
          Property = " ",
          Unit = " ",
          Value = " ",
          Enum = " ",
          Keyword = " ",
          File = " ",
          Reference = " ",
          Folder = " ",
          EnumMember = " ",
          Constant = " ",
          Struct = " ",
          Event = " ",
          Operator = " ",
          TypeParameter = " ",
        }

        -- Special handling for Tailwind CSS colors
        if vim_item.kind == 'Color' and entry.completion_item.documentation then
          local _, _, r, g, b =
          ---@diagnostic disable-next-line: param-type-mismatch
              string.find(entry.completion_item.documentation, '^rgb%((%d+), (%d+), (%d+)')

          if r and g and b then
            local color = string.format('%02x', r) .. string.format('%02x', g) .. string.format('%02x', b)
            local group = 'Tw_' .. color

            if vim.api.nvim_call_function('hlID', { group }) < 1 then
              vim.api.nvim_command('highlight' .. ' ' .. group .. ' ' .. 'guifg=#' .. color)
            end

            vim_item.kind = KIND_ICONS.Tailwind
            vim_item.kind_hl_group = group

            return vim_item
          end
        end

        -- Apply icon
        vim_item.kind = string.format('%s %s', KIND_ICONS[vim_item.kind] or '', vim_item.kind)

        -- Show source name
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          luasnip = "[Snip]",
          buffer = "[Buf]",
          path = "[Path]",
        })[entry.source.name]

        return vim_item
      end,
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },

    -- ============================================================================
    -- SUPER-TAB MAPPINGS (2025 Best Practice)
    -- ============================================================================
    mapping = cmp.mapping.preset.insert({
      -- Scroll documentation
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),

      -- Abort completion
      ["<C-e>"] = cmp.mapping.abort(),

      -- Trigger completion manually
      ["<C-Space>"] = cmp.mapping.complete(),

      -- Navigate items (Ctrl+n/p as alternative)
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-p>"] = cmp.mapping.select_prev_item(),

      -- Enter to confirm (only if explicitly selected)
      ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = false, -- Only confirm if explicitly selected (more control)
      }),

      -- Super-Tab: Tab to select next or expand/jump snippet
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),

      -- Shift-Tab: Select previous or jump back in snippet
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),

    sources = cmp.config.sources({
      { name = "nvim_lsp", priority = 1000 },
      { name = "luasnip", priority = 750 },
      { name = "path", priority = 500 },
      { name = "buffer", priority = 250 },
    }),

    -- Don't auto-select first item
    preselect = cmp.PreselectMode.None,
    completion = {
      completeopt = 'menu,menuone,noinsert,noselect'
    },

    experimental = {
      ghost_text = {
        hl_group = "CmpGhostText",
      },
    },
  })

  -- Autopairs integration
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })

  -- ============================================================================
  -- FILETYPE SPECIFIC CONFIGS
  -- ============================================================================

  -- Git commit messages
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
  })

  -- ============================================================================
  -- CMDLINE COMPLETION
  -- ============================================================================

  -- Search (/, ?)
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Command line (:)
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
end

return M
