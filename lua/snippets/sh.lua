--- Bash Snippets
local ls = require("luasnip")
local c = ls.choice_node
local f = ls.function_node
local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

-- Avoid multiple versions of the same snippet on reload
local reload_key = { key = "my_bash_snippets" }

ls.add_snippets("sh", {
  s("layoutheader", fmt("#!/usr/bin/env bash\n\n{}", i(0))),

  s(
    "layoutsafe",
    fmt(
      [[
        # e - script stops on error (return !=0)
        # u - error if undefined variable
        # o pipefail - script fails if one of piped command fails
        # x - output each line (debug)
        set -euo pipefail

        {}]],
      i(0)
    )
  ),

  s(
    {
      trig = "function",
      name = "Function Template",
      dscr = "A full function template.",
    },
    fmt(
      [[
        #===  FUNCTION  ================================================================
        #         NAME:   {name}
        #  DESCRIPTION:   {desc}
        #    ARGUMENTS:   {args}
        #===============================================================================
        function {alt_name}()
        {{
            {}
        }}  # ------------  end of function {alt_name} ------------


        ]],
      {
        name = i(1, "Name"),
        desc = i(2, "description"),
        args = i(3, "argument (type)"),
        alt_name = f(function(func_name)
          return (string.gsub(func_name[1][1], " ", "_")):lower()
        end, { 1 }),
        i(0),
      }
    )
  ),

  s(
    "h1",
    fmt(
      [[
        #===============================================================================
        # {}
        #===============================================================================

        {}]],
      { i(1, "Header"), i(0) }
    )
  ),

  s(
    "h2",
    fmt(
      [[
        #----------------------------------------
        # {}
        {}]],
      { i(1, "Subheader"), i(0) }
    )
  ),

  s("h3", fmt("# -- {} --\n{}", { i(1, "Section"), i(0) })),

  s("if", fmt("if [[ {} ]]; then\n    {}\nfi\n\n", { i(1), i(0) })),

  s(
    {
      trig = "layoutcolors",
      name = "Add Colors Definitions",
      dscr = "Set colors and formats variables to uso in echo",
    },
    fmta(
      [=[
        #----------------------------------------
        # Terminal output font styles and colors
        GREEN="\033[0;32m"
        ORANGE="\033[0;33m"
        CYAN="\033[1;36m"
        RED="\e[0;31m"
        NS="\033[0m" # No color
        BLD="\e[1m"  # Bold text style
        ITL="\e[3m"  # Italic text style

        <>]=],
      {
        c(1, {
          t('F_OK="${GREEN}${BLD}OK${NS}"'),
          t('F_OK="${GREEN}${BLD}Done${NS}"'),
          t(""),
        }),
      }
    )
  ),

  s(
    { trig = "layoutcheckdeps", name = "checkdeps", dscr = "Check dependencies list." },
    fmta(
      [=[
        #-----------------------------------------------------------------------
        # Check dependencies
        #-----------------------------------------------------------------------
        DEPENDENCIES=( <> )

        missing_deps=0
        for dependency in "${DEPENDENCIES[@]}"; do
        	echo -e "$SCRIPT_NAME v$SCRIPT_VERSION, ${SHORT_DESCRIPTION,}"
        	if ! command -v $dependency >> /dev/null 2>>&1; then
        		echo -e "$RED$SCRIPT_RUN: Could't find '$dependency' on the system."\
        				"Check if is installed.$NS"
        		((++missing_deps))
        	fi
        done
        if [[ $missing_deps -gt 0 ]]; then
        	exit 1
        fi

        <>
        ]=],
      {
        i(1, '"each_package_string"'),
        i(0),
      }
    )
  ),
}, reload_key)
