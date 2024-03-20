---@class PerformanceTester
local M = {}

---@class Runner
---@field call function The function to test
---@field name string Name of the function used in the logs
---@field time? number Execution time

M.log = {}

-- Mockup
-- === Performance Tester Log ======================================
-- Function 1: current_implementation
-- Function 2: using_cache
-- Iterations: 100000 (1000 for each loop x 10 times)
-- Date: 2024-03-18T11:46:43
--
-- |---------------------------------------------------------------|
-- |      Function 1     |      Function 2     |      Summary      |
-- | exe time | avg time | exe time | avg time |  func  |  Diff %  |
-- |---------------------|---------------------|-------------------|
-- | 99:99.99 | 99:99.99 | 99:99.99 | 99:99.99 |  funN  | 99.999 % |
-- | 99:99.99 | 99:99.99 | 99:99.99 | 99:99.99 |  funN  | 99.999 % |
-- | 99:99.99 | 99:99.99 | 99:99.99 | 99:99.99 |  funN  | 99.999 % |
-- | 99:99.99 | 99:99.99 | 99:99.99 | 99:99.99 |  funN  | 99.999 % |
-- | 99:99.99 | 99:99.99 | 99:99.99 | 99:99.99 |  funN  | 99.999 % |
-- | 99:99.99 | 99:99.99 | 99:99.99 | 99:99.99 |  funN  | 99.999 % |
-- |---------------------|---------------------|-------------------|
-- | 99:99.99 | 99:99.99 | 99:99.99 | 99:99.99 |  funN  | 99.999 % |
--
-- current_implementation better by 99:99.99 seconds (99.99 %)

---@param ... string Strings to append in the log
function M.print_and_add_to_log(...)
  for _, message in pairs({ ... }) do
    vim.notify(message)
    table.insert(M.log, message)
  end
end

---Function to set the tests for run
---@param fn1 Runner Test function 1
---@param fn2 Runner Test function 2
---@param loops integer
---@param log_file? string Path to output the log_file
function M.set_tests(fn1, fn2, loops, log_file)
  local logp = M.print_and_add_to_log
  M.output_log = log_file
  M.loops = loops
  M.fn1 = fn1
  M.fn2 = fn2

  logp("--------------------------------------------------------------------")
  logp(string.format("Performance Test: %s - %s", fn1.name, fn2.name))
  logp(string.format("Iterations: %d", loops))
  logp(string.format("Date: %s", os.date("%Y-%m-%dT%H:%M:%S")))
  logp("--------------------------------------------------------------------")
end

function M.write_log()
  if M.log == nil or #M.log < 6 then
    error("Error: Empty log. Try executing `tests_run` first.")
  end
  print("[write] " .. M.output_log)
  if vim.fn.finddir(M.output_log) == "" then
    vim.fn.mkdir(vim.fs.dirname(M.output_log), "p")
  end
  local file = assert(io.open(M.output_log, "a"))
  file:write(table.concat(M.log, "\n"))
  file:close()
end

---Execute the passed tests
function M.tests_run()
  local logp = M.print_and_add_to_log
  logp("Running...")

  ---@param fun Runner
  function M.execute_fn(fun)
    logp(string.format("\n- Executing `%s`...", fun.name))
    local start_time = os.clock()
    for _ = 1, M.loops do
      fun.call()
    end

    local end_time = os.clock()
    local time = end_time - start_time
    logp(string.format("  - Total execution time: %.4f seconds", time))
    logp(string.format("  - Average execution time: %.6f seconds", time / M.loops))

    fun.time = time
  end

  M.execute_fn(M.fn1)
  M.execute_fn(M.fn2)
  logp("OK\n")

  local diff_time = math.abs(M.fn1.time - M.fn2.time)
  local diff_percentage = diff_time / ((M.fn1.time + M.fn2.time) / 2) * 100
  local faster_function = M.fn1.time < M.fn2.time and M.fn1 or M.fn2
  logp("--------------------------------------------------------------------")
  logp(string.format("Faster performant: %s", faster_function.name))
  logp(string.format("Better by: %.4f seconds (%.2f%%)", diff_time, diff_percentage))
  logp("\n\n")

  M.write_log()
end

return M
