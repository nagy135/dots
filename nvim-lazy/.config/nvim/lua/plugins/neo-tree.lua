return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    "s1n7ax/nvim-window-picker",
  },
  opts = {
    enable_normal_mode_for_inputs = true,
    window = {
      mappings = {
        ["<space>"] = "none",
        ["s"] = "split_with_window_picker",
        ["v"] = "vsplit_with_window_picker",
        ["/"] = "none",
      },
    },
  },
}
