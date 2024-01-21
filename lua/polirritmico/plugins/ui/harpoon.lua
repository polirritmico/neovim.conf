--- Harpoon: Navigation through pinned files

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = true,
  event = "VeryLazy",
  keys = function()
    local harpoon = require("harpoon")
    -- stylua: ignore
    return {
      { "<leader>a", function() harpoon:list():append() end, desc = "Harpoon: Add current buffer to the tagged files list", silent = true },
      { "<A-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Harpoon: Open tagged files list", silent = true },
      { "<A-j>", function() harpoon:list():select(1) end, desc = "Harpoon: Open tagged file 1", silent = true },
      { "<A-k>", function() harpoon:list():select(2) end, desc = "Harpoon: Open tagged file 2", silent = true },
      { "<A-l>", function() harpoon:list():select(3) end, desc = "Harpoon: Open tagged file 3", silent = true },
      { "<A-h>", function() harpoon:list():select(4) end, desc = "Harpoon: Open tagged file 4", silent = true },
    }
  end,
}
