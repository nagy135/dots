local wk = require("which-key")
wk.register({
  ["<leader>h"] = { name = "+harpoon" },
})

local define_mappings = function(keys_until)
  local harpoonToggle = function()
    require("harpoon.ui").toggle_quick_menu()
  end
  local mappings = {
    {
      "<leader>ht",
      harpoonToggle,
      desc = "toggle",
    },
    {
      "<leader>hh",
      harpoonToggle,
      desc = "toggle",
    },
    {
      "<leader>ha",
      function()
        require("harpoon.mark").add_file()
      end,
      desc = "add",
    },
  }
  for i = 1, keys_until do
    table.insert(mappings, {
      "<leader>h" .. i,
      function()
        require("harpoon.ui").nav_file(i)
      end,
      desc = "-> " .. i,
    })
  end
  return mappings
end

return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = define_mappings(5),
}
