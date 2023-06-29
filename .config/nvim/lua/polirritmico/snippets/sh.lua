-- Bash snippets
local ls = require("luasnip")
local s, t, i, c, f = ls.snippet, ls.text_node, ls.insert_node, ls.choice_node, ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local remove_

ls.add_snippets("sh", {
    s("header", fmt("#!/usr/bin/env bash\n\n{}", i(0))),
    --s("fullheader", ftm()),

    s("safe", fmt([[
        # e - script stops on error (return !=0)
        # u - error if undefined variable
        # o pipefail - script fails if one of piped command fails
        # x - output each line (debug)
        set -euo pipefail
        
        {}]],
        i(0))
    ),

    s(
        {trig = "function", name = "Function Template", dscr = "A full function template."}, fmt([[
        #===  FUNCTION  ================================================================
        #         NAME:   {name}
        #  DESCRIPTION:   {desc}
        #    ARGUMENTS:   {args}
        #===============================================================================
        function {alt_name}()
        {{
            {}
        }}  # ------------  end of function {alt_name} ------------
        
        
        ]], {
        name = i(1, "Name"),
        desc = i(2, "description"),
        args = i(3, "argument (type)"),
        alt_name = f(
            function(func_name)
                return (string.gsub(func_name[1][1], " ", "_")):lower()
            end, {1}),
        i(0)
    })),

    s("h1", fmt( [[
        #===============================================================================
        # {}
        #===============================================================================

        {}]],
        {i(1, "Header"), i(0)})
    ),

    s("h2", fmt([[
        #----------------------------------------
        # {}
        {}]],
        {i(1, "Subheader"), i(0)})
    ),

    s("h3", fmt(
        "# -- {} --\n{}",
        {i(1, "Section"), i(0)})
    ),

    s("if", fmt("if [[ {} ]]; then\n    {}\nfi\n\n",
        {i(1), i(0)})
    ),
})


--snippet checkdeps

--#-----------------------------------------------------------------------
--# Check dependencies
--#-----------------------------------------------------------------------
--DEPENDENCIES=( "${1}" )

--missing_deps=0
--for dependency in "${DEPENDENCIES[@]}"; do
--	echo -e "$SCRIPT_NAME v$SCRIPT_VERSION, ${SHORT_DESCRIPTION,}"
--	if ! command -v $dependency > /dev/null 2>&1; then
--		echo -e "$RED$SCRIPT_RUN: Could't find '$dependency' on the system."\
--				"Check if is installed.$NS"
--		((++missing_deps))
--	fi
--done
--if [[ $missing_deps -gt 0 ]]; then
--	exit 1
--fi

--$0
--endsnippet

--snippet template "A script template with header, getopts and base functions" b
--#=== SH_SCRIPT  ================================================================
--#         NAME:   ${1:Name}
--#  DESCRIPTION:   ${2:Short description.}
--#         DATE:   ${3:`date +%Y/%m/%d`}
--#===============================================================================

--# e - script stops on error (any internal or external return !=0)
--# u - error if undefined variable
--# o pipefail - script fails if one of piped command fails
--# x - output each line (debug)
--set -euo pipefail


--#-----------------------------------------------------------------------
--#  Global settings
--#-----------------------------------------------------------------------
--SCRIPT_VERSION="${4:0.1}"
--SHORT_DESCRIPTION="$2"
--SCRIPT_NAME="$1"

--DEPENDENCIES=( "" )

--# Get the real script filename even through a symbolic link
--SCRIPT_RUN="$(basename "$(test -L "\$0" && readlink "\$0" || echo "\$0")")"

--#----------------------------------------
--# Terminal output font styles and colors
--GREEN="\033[0;32m"
--ORANGE="\033[0;33m"
--NS="\033[0m" # No style
--BLD="\e[1m"  # Bold text style
--ITL="\e[3m"  # Italic text style

--F_OK="${GREEN}${BLD}OK${NS}"
--F_APP="${ORANGE}"
--F_ERR="\e[0;31m"
--F_CMD="\033[1;36m"
--F_ARG="\033[1;32m"
--F_OPT="\033[1;32m"
--F_SCR="\033[1;36m\e[1m${SCRIPT_RUN}:${NS} "
--F_WAR="\033[0;33m\e[3m"
--F_SEP="$GREEN==============================================================$NS"


--#-----------------------------------------------------------------------
--# Check dependencies
--#-----------------------------------------------------------------------
--missing_deps=0
--for dependency in "${DEPENDENCIES[@]}"; do
--	if ! command -v "$dependency" > /dev/null 2>&1 ; then
--		echo -e "$F_ERR$SCRIPT_RUN: Could't find '$dependency' on the system."\
--				"Check if is installed.$NS"
--		((++missing_deps))
--	fi
--done
--if [[ $missing_deps -gt 0 ]]; then
--	exit 1
--fi



--#===  FUNCTION  ================================================================
--#         NAME:   Version
--#  DESCRIPTION:   Show script name, script version and short description.
--#===============================================================================
--function version()
--{
--	echo -e "$BLD$SCRIPT_NAME v$SCRIPT_VERSION$NS"
--	echo -e "$ITL$SHORT_DESCRIPTION$NS\n"
--}  # ------------  end of function version  ------------



--#===  FUNCTION  ================================================================
--#         NAME:   Help
--#  DESCRIPTION:   Show the script usage and documentation help.
--#===============================================================================
--function help()
--{
--	echo -e "Usage: $SCRIPT_RUN [OPTION]... [FILE]
--       $SCRIPT_RUN [OPTION]... [FILE] [OUTFILE]

--Options:
--  ${5:-o|option        Description.}
--  -h|help          Display this help message.
--  -v|version       Display the version of $SCRIPT_NAME and exit."

--}  # ------------  end of function help  ------------



--#-------------------------------------------------------------------------------
--#  Global variables
--#-------------------------------------------------------------------------------

--${8}


--#-------------------------------------------------------------------------------
--#  Handle command line arguments
--#-------------------------------------------------------------------------------
--while getopts ":hv${6}" opt
--	do
--		case $opt in${7}
--			h|help)
--				version
--				help
--				exit 0
--				;;
--			v|version)
--				version
--				exit 0
--				;;
--			:)
--				echo -e "$F_ERR$SCRIPT_NAME: Invalid option: '-$OPTARG'" \
--						"requires an argument. Check '-help'.$NS"
--				exit 1
--				;;
--			*)
--				echo -e "$F_ERR$SCRIPT_NAME: Invalid option: '-$OPTARG'." \
--						"Check '-help'.$NS"
--				exit 1
--				;;
--	esac
--done
--shift $((OPTIND-1))

--$0
--endsnippet

