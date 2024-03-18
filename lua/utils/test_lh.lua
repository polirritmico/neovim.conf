local performance_tester = require("utils.tests")

require("harpoon")

---@type Runner
local runner_a = {
  call = require("utils.custom").lualine_harpoon,
  name = "String concatenation without find mode",
}
---@type Runner
local runner_b = {
  call = require("utils.custom").lualine_harpoonB,
  name = "String concatenation with function instead table index",
}

local iterations = 10000000 -- 10 k
local log_file = "/home/eduardo/performance-results/output.log"
performance_tester.set_tests(runner_a, runner_b, iterations, log_file)

performance_tester.tests_run()
