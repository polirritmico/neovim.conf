-- vim-test
if not Check_loaded_plugin("vim-test") then return end

vim.g["test#strategy"] = "neovim"

Keymap("n", "<leader>rta", "<CMD>TestSuite<CR>", "vim-test: Run the whole test suite following the current file or the last run test.")
Keymap("n", "<leader>rtf", "<CMD>TestFile<CR>", "vim-test: Runs all test in the current file or runs the last file tests.")
Keymap("n", "<leader>rtF", "<CMD>TestFile -v<CR>", "vim-test: Runs all test in the current file or runs the last file tests.")
Keymap("n", "<leader>rtu", "<CMD>TestNearest<CR>", "vim-test: Run the test nearest to the cursor or run the last test.")
Keymap("n", "<leader>rtU", "<CMD>TestNearest -v<CR>", "vim-test: Run the test nearest to the cursor or run the last test.")
Keymap("n", "<leader>rtl", "<CMD>TestLast<CR>", "vim-test: Runs the last test.")
Keymap("n", "<leader>glt", "<CMD>TestVisit<CR>", "vim-test: Go/Open to the last test file that has ben run.")
