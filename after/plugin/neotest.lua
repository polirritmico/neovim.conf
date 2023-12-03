-- Neotest
if not Check_loaded_plugin("neotest") then return end

local neotest = require("neotest")
neotest.setup({
    adapters = {
        require("neotest-python")({
            dap = {
                justMyCode = true
            },
            pytest_discover_instances = true,
        }),
    },
    output = { open_on_run = false },
    -- output_panel = { enabled = true, open = "botright split | resize 15" },
    floating = {
        max_height = 24,
        max_width = 200,
    },
})

local run_and_open_panel = function()
    neotest.run.run_last()
    neotest.output_panel.open()
end

-- Keymap("n", "<leader>rto", function() neotest.output.open({open_win=function() vim.cmd("split") end}) end, "nvim-test: Runs all test in the current file or runs the last file tests.")
Keymap("n", "<leader>rto", function() run_and_open_panel() end, "Neotest: Runs all test in the current file or runs the last file tests.")
Keymap("n", "<leader>rtf", function() neotest.run.run(vim.fn.expand("%")) end, "neotest: Runs all test in the current file or runs the last file tests.")
Keymap("n", "<leader>rtu", function() neotest.run.run() end, "Neotest: Run the test nearest to the cursor.")
Keymap("n", "<Leader>dt", function() neotest.run.run({strategy = "dap"}) end, "Neotest: Debug nearest test")
Keymap("n", "<leader>rtl", function() neotest.run.run_last() end, "Neotest: Runs the last test.")
Keymap("n", "<leader>rts", function() neotest.run.stop() end, "Neotest: Stops the running test.")

-- Keymap("n", "<leader>rta", "<CMD>silent TestSuite<CR>", "nvim-test: Run the whole test suite following the current file or the last run test.")
-- Keymap("n", "<leader>rtf", "<CMD>silent TestFile<CR>", "nvim-test: Runs all test in the current file or runs the last file tests.")
-- Keymap("n", "<leader>glt", "<CMD>silent TestVisit<CR>", "nvim-test: Go/Open to the last test file that has ben run.")
-- Keymap("n", "<leader>rtI", "<CMD>silent TestInfo<CR>", "nvim-test: Show info about the plugin")
