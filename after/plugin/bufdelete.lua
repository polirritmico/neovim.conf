-- Bufdelete
if Check_loaded_plugin("bufdelete") then print("NOP") return end

local bufdelete = require("bufdelete")

Keymap({"n", "v"}, "<leader>db", function() bufdelete.bufdelete(0, true) end, "bufdelete: Fercibly delete the current buffer.")
