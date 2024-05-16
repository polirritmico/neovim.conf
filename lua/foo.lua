local function iterative(n)
  local a, b = 0, 1

  for _ = 1, n do
    a, b = b, a + b
  end
  return a
end

local function naive(n)
  local function inner(m)
    if m < 2 then
      return m
    end
    return inner(m - 1) + inner(m - 2)
  end
  return inner(n)
end

local perf_tester = require("utils.performance_tester")

---@type Runner
local iter_approach = {
  call = function() iterative(10) end,
  name = "Fibonacci iterative",
}
---@type Runner
local naive_approach = {
  call = function() naive(10) end,
  name = "Fibonacci naive",
}

perf_tester.set_tests(naive_approach, iter_approach, 10, "out.txt")
perf_tester.run()
