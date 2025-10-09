return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require('gitsigns').setup {
      numhl = true,
      max_file_length = 10000,
      signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, lhs, rhs, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- ============================================================================
        -- NAVIGATION (]c / [c = next/prev hunk)
        -- ============================================================================
        map('n', ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true, desc="Next git hunk"})

        map('n', '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true, desc="Previous git hunk"})

        -- ============================================================================
        -- ACTIONS (<leader>h = Hunk operations)
        -- ============================================================================

        -- Stage
        map('n', '<leader>hs', gs.stage_hunk, {desc="Stage hunk"})
        map('v', '<leader>hs', function()
          gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')}
        end, {desc="Stage hunk (visual)"})
        map('n', '<leader>hS', gs.stage_buffer, {desc="Stage entire buffer"})

        -- Reset
        map('n', '<leader>hr', gs.reset_hunk, {desc="Reset hunk"})
        map('v', '<leader>hr', function()
          gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')}
        end, {desc="Reset hunk (visual)"})
        map('n', '<leader>hR', gs.reset_buffer, {desc="Reset entire buffer"})

        -- Undo
        map('n', '<leader>hu', gs.undo_stage_hunk, {desc="Undo stage hunk"})

        -- Preview
        map('n', '<leader>hp', gs.preview_hunk, {desc="Preview hunk"})
        map('n', '<leader>hP', gs.preview_hunk_inline, {desc="Preview hunk inline"})

        -- Blame
        map('n', '<leader>hb', function()
          gs.blame_line{full=true}
        end, {desc="Blame line (full)"})
        map('n', '<leader>tb', gs.toggle_current_line_blame, {desc="Toggle git blame line"})

        -- Diff
        map('n', '<leader>hd', gs.diffthis, {desc="Diff this"})
        map('n', '<leader>hD', function()
          gs.diffthis('~')
        end, {desc="Diff this ~"})

        -- Toggle deleted
        map('n', '<leader>td', gs.toggle_deleted, {desc="Toggle deleted lines"})

        -- ============================================================================
        -- TEXT OBJECT (ih = inner hunk)
        -- ============================================================================
        map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', {desc="Select git hunk"})
      end
    }
  end
}
