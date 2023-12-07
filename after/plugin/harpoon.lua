-- Harpoon
if not Check_loaded_plugin("harpoon") then return end

local harpoon = require("harpoon")
harpoon:setup()

Keymap("n", "<leader>a", function() harpoon:list():append() end,
    "Harpoon: Add current buffer to the tagged files list")
Keymap("n", "<A-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
    "Harpoon: Open tagged files list")

Keymap("n", "<A-j>", function() harpoon:list():select(1) end, "Harpoon: Open tagged file 1")
Keymap("n", "<A-k>", function() harpoon:list():select(2) end, "Harpoon: Open tagged file 2")
Keymap("n", "<A-l>", function() harpoon:list():select(3) end, "Harpoon: Open tagged file 3")
-- No funciona la ñ
Keymap("n", "<A-h>", function() harpoon:list():select(4) end, "Harpoon: Open tagged file 4")
