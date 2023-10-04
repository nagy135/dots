local wk = require("which-key")
wk.register({
  ["<leader>h"] = { name = "+harpoon" },
})


local define_mappings = function(keys_until)
  local mappings = {
    {
      "<leader>ht",
      function() require("harpoon.ui").toggle_quick_menu() end,
      desc = "toggle"
    },
    {
      "<leader>ha",
      function() require("harpoon.mark").add_file() end,
      desc = "add"
    }
  }
  for i = 1, keys_until do
    table.insert(mappings, {
      "<leader>h" .. i,
      function()
        require("harpoon.ui").nav_file(i)
      end,
      desc = "jump to " .. i
    })
  end
  return mappings
end


return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim"
  },
  keys = define_mappings(5)
}
