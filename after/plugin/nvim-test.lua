-- nvim-test
if not Check_loaded_plugin("nvim-test") then return end

require("nvim-test").setup({
    termOpts = {
        direction = "float",  -- vertical, horizontal, float
        stopinsert = false,
        width = 200,
        height = 24,
        float_position = "bottom",
    },
})

Keymap("n", "<leader>rta", "<CMD>silent TestSuite<CR>", "nvim-test: Run the whole test suite following the current file or the last run test.")
Keymap("n", "<leader>rtf", "<CMD>silent TestFile<CR>", "nvim-test: Runs all test in the current file or runs the last file tests.")
Keymap("n", "<leader>rtu", "<CMD>silent TestNearest<CR>", "nvim-test: Run the test nearest to the cursor or run the last test.")
Keymap("n", "<leader>rtl", "<CMD>silent TestLast<CR>", "nvim-test: Runs the last test.")
Keymap("n", "<leader>glt", "<CMD>silent TestVisit<CR>", "nvim-test: Go/Open to the last test file that has ben run.")
Keymap("n", "<leader>rtI", "<CMD>silent TestInfo<CR>", "nvim-test: Show info about the plugin")

