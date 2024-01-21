-- Python snippets
local ls = require("luasnip")
local s, t, i, c, f =
  ls.snippet, ls.text_node, ls.insert_node, ls.choice_node, ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

-- Avoid multiple versions of the same snippet on reload
local reload_key = { key = "my_python_snippets" }

ls.add_snippets("python", {
  s(
    {
      trig = "header",
      name = "Python header",
      dscr = "Python header with env and encoding.",
    },
    t({ "#!/usr/bin/env python", "# -*- coding: utf-8 -*-", "", "" })
  ),

  s(
    {
      trig = "layoutmain",
      name = "Python main.py layout",
      dscr = "Python layout for the main file.",
    },
    fmt(
      [[
        def main():
            {}
            return 0
        
        
        if __name__ == "__main__":
            main()
        ]],
      {
        i(1, "# Code goes here..."),
      }
    )
  ),

  s(
    { trig = "skiptest", name = "Pytest skip", dscr = "Pytest skip test decorator" },
    fmt(
      [[
        #@pytest.mark.skip(reason="{}")
        ]],
      {
        i(1, "Not implemented"),
      }
    )
  ),

  s(
    { trig = "def", name = "New function", dscr = "Snippet for a function definition." },
    fmt(
      [[
        def {}({}){}:
            {}
        ]],
      {
        c(1, { i(1, "name"), t("__init__") }),
        i(2, "self"),
        c(
          3,
          { i(1), t({ " -> None" }), fmt(" -> {}", i(1), { dedent = false }), i(1) }
        ),
        i(4, "pass"),
      }
    )
  ),

  s(
    { trig = "deftest", name = "Define pytest", dscr = "Layout for pytest test" },
    fmt(
      [[
        #@pytest.mark.skip(reason="{}")
        def test_{}({}) -> None:
            {}

        ]],
      {
        i(1, "Not implemented"),
        i(2, "name"),
        c(3, { i(1, "arg: type"), t("monkeypatch: MonkeyPatch") }),
        i(4, "pass"),
      }
    )
  ),

  s(
    {
      trig = "layoutpytest",
      name = "Pytest imports and function layout",
      dscr = "Template for a pytest file with imports and a base test.",
    },
    fmt(
      [[
            import pytest
            {}

            def test_{}({}) -> None:
                {}


        ]],
      {
        c(1, { i(1, ""), t({ "from pytest import MonkeyPatch", "" }) }),
        i(2, "name"),
        c(3, { i(1, ""), t("monkeypatch: MonkeyPatch") }),
        i(4, "pass"),
      }
    )
  ),

  s(
    { trig = "fixture", name = "Pytest fixture", dscr = "A pytest fixture layout." },
    fmt(
      [[
        @pytest.fixture
        def mock_{}() -> {}:
            {}

        ]],
      {
        i(1, "name"),
        i(2, "None"),
        i(3, "pass"),
      }
    )
  ),

  s(
    {
      trig = "mkpatch",
      name = "MonkeyPatch patcher",
      dscr = "Make with env for patch.",
    },
    fmt(
      [[
        with monkeypatch.context() as m:
            m.setattr({}, "{}", {})
            {}
        ]],
      {
        i(1, "PatchedClass"),
        i(2, "function_name"),
        i(3, "lambda _: None"),
        i(0),
      }
    )
  ),

  s(
    { trig = "class", name = "def class", dscr = "Class definition template." },
    fmt(
      [[
        class {}({}):
            {}

        ]],
      {
        i(1, "ClassName"),
        c(2, { t(""), i(1, "Parent") }),
        i(3, "pass"),
      }
    )
  ),
}, reload_key)
