-- Dockerfile Snippets
return {
  s(
    {
      trig = "brk",
      name = "Continue command",
      desc = "Continue the current command on the next line",
    },
    fmt(
      [[&& \
{}]],
      { i(0) }
    )
  ),
}
