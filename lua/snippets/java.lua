--- Java Snippets
return {
  s(
    {
      trig = "classlayout",
      name = "Java empty class (auto package)",
      dscr = "Default Java class",
    },
    fmt(
      [[
      package {};

      public class {} {{
          {}
      }}
    ]],
      {
        f(function()
          local path = vim.fn.expand("%:p:h")
          local src_index = path:find("src/main/java/")
          if not src_index then
            return "com.example"
          end
          local pkg = path:sub(src_index + #"src/main/java/")
          return pkg:gsub("/", ".")
        end),
        f(function() return vim.fn.expand("%:t:r") end),
        i(1),
      }
    )
  ),
}
