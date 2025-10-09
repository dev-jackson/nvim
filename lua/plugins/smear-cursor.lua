return {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
  opts = {
    -- Smear cursor when switching buffers or windows
    smear_between_buffers = true,

    -- Smear cursor when moving between neighbor lines
    smear_between_neighbor_lines = true,

    -- Draw smear in buffer space when scrolling
    scroll_buffer_space = true,

    -- Enable smear in insert mode
    smear_insert_mode = true,

    -- Cursor animation stiffness (0-1, higher = less bouncy)
    stiffness = 0.8,

    -- Trailing stiffness (affects how the trail follows)
    trailing_stiffness = 0.5,

    -- Damping (0-1, higher = less oscillation)
    trailing_exponent = 0.1,

    -- Distance at which cursor stops animating
    distance_stop_animating = 0.5,

    -- Hide the real cursor while smearing
    hide_target_hack = true,
  },
}
