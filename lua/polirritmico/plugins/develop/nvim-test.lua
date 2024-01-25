--- Test manager
return {
  "polirritmico/nvim-test",
  dev = false,
  cmd = {
    "TestSuite",
    "TestFile",
    "TestNearest",
    "TestLast",
    "TestVisit",
    "TestInfo",
  },
  opts = {
    termOpts = {
      direction = "float", -- vertical, horizontal, float
      float_position = "bottom",
      height = 24,
      width = 200,
      stopinsert = false,
    },
  },
  -- stylua: ignore
  keys = {
    { "<leader>rtf", "<Cmd>silent TestFile<CR>", desc = "nvim-test: Runs all test in the current file or runs the last file tests." },
    { "<leader>rta", "<Cmd>silent TestSuite<CR>", desc = "nvim-test: Run the whole test suite following the current file or the last run test." },
    { "<leader>rtu", "<Cmd>silent TestNearest<CR>", desc = "nvim-test: Run the test nearest to the cursor or run the last test." },
    { "<leader>rtl", "<Cmd>silent TestLast<CR>", desc = "nvim-test: Runs the last test." },
    { "<leader>glt", "<Cmd>silent TestVisit<CR>", desc = "nvim-test: Go/Open to the last test file that has ben run." },
    { "<leader>rtI", "<Cmd>silent TestInfo<CR>", desc = "nvim-test: Show info about the plugin" },
  },
}
