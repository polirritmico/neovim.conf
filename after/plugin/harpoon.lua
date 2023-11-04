-- Harpoon
if not Check_loaded_plugin("harpoon") then return end

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

Keymap("n", "<leader>a", mark.add_file, "Harpoon: Add current buffer to the tagged files list")
Keymap("n", "<A-e>", ui.toggle_quick_menu, "Harpoon: Open tagged files list")

Keymap("n", "<A-j>", function() ui.nav_file(1) end, "Harpoon: Open tagged file 1")
Keymap("n", "<A-k>", function() ui.nav_file(2) end, "Harpoon: Open tagged file 2")
Keymap("n", "<A-l>", function() ui.nav_file(3) end, "Harpoon: Open tagged file 3")
-- No funciona la ñ
Keymap("n", "<A-h>", function() ui.nav_file(4) end, "Harpoon: Open tagged file 4")
