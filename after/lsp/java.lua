--- https://github.com/georgewfraser/java-language-server
return {
  settings = {
    pylsp = {
      plugins = {
        black = { enabled = true },
        jedi = {
          extra_paths = { "./src" },
        },
        pylsp_mypy = { enabled = true },
        pycodestyle = {
          maxLineLength = 88,
          ignore = { "E203", "E265", "E501", "E704", "W391", "W503" },
        },
        rope_completion = {
          enabled = true,
          eager = false, -- Resolve documentation and detail eagerly.
        },
      },
    },
  },
}
