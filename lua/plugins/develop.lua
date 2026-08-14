local utils = require("utils")

return {
  {
    "polirritmico/manual-tag-closer.nvim",
    cond = false,
    dev = true and not DisableMyPlugins,
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {},
  },
  --- DAP: Debugger connector
  {
    {
      "mfussenegger/nvim-dap",
      -- stylua: ignore
      keys = {
        { "<F5>", function() require("dap").continue() end, desc = "DAP: Continue execution" },
        { "<F6>", function() require("dap").pause() end, desc = "DAP: Pause execution" },
        { "<F7>", function() require("dap").step_out() end, desc = "DAP: Step out" },
        { "<F8>", function() require("dap").step_into() end, desc = "DAP: Step into" },
        { "<F9>", function() require("dap").step_over() end, desc = "DAP: Step over" },
        { "<F12>", function() require("dap").close() end, desc = "DAP: Close execution" },
        { "<Leader>dc", function() require("dap").repl.open() end, desc = "DAP: Open debug console" },
        { "<Leader>dr", function() require("dap").run_last() end, desc = "DAP: Rerun last debug adapter/config" },
        { "<Leader>b", function() require("dap").toggle_breakpoint() end, desc = "DAP: Add/remove breakpoint into the current line" },
        { "<Leader>B", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "DAP: Add a conditional breakpoint" },
        { "<Leader>dl", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, desc = "DAP: Add a logpoint into the current line" },
      },
      config = function()
        local dap = require("dap")
        utils.plugins.dap_config_java(dap)
        utils.plugins.dap_config_php(dap)
        utils.plugins.dap_config_typescript(dap)
        utils.plugins.dap_config_local_lua_debugger(dap)

        local dapui = require("dapui")
        dap.listeners.before.attach.dapui_config = function() dapui.open() end
      end,
      dependencies = {
        {
          "mfussenegger/nvim-dap-python",
          ft = "python",
          dependencies = "mason.nvim",
          config = function()
            require("dap-python").setup("debugpy-adapter")
            require("dap-python").test_runner = "pytest"
          end,
          -- stylua: ignore
          keys = {
            { "<Leader>rtd", function() require("dap-python").test_method() end, ft = "python", desc = "DAP: Run test method" },
          },
        },
        {
          "jbyuki/one-small-step-for-vimkind",
          config = function() utils.plugins.dap_config_lua_osv_debugger() end,
          -- stylua: ignore
          keys = {
            { "<F10>", function() require("osv").launch({port = 8086}) end, mode = { "n", "v" }, desc = "DAP: (Lua) Launch Server." },
          },
        },
      },
    },
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "nvim-dap", "nvim-neotest/nvim-nio" },
      -- stylua: ignore
      keys = {
        { "<Leader>dk", function() require("dapui").eval() end, desc = "DAP: Show debug info of the element under the cursor" },
        { "<Leader>dg", function() require("dapui").toggle() end, desc = "DAP: Toggle DAP GUI" },
        { "<Leader>dG", function() require("dapui").open({ reset = true }) end, desc = "DAP: Reset DAP GUI layout size" },
      },
      config = function(_, opts)
        require("dapui").setup(opts)
        utils.plugins.dap_set_custom_marks()
      end,
      opts = {
        controls = {
          element = "repl",
          enabled = true,
          icons = {
            disconnect = "",
            pause = "",
            play = "",
            run_last = "",
            step_back = "",
            step_into = "",
            step_out = "",
            step_over = "",
            terminate = "",
          },
        },
        element_mappings = {},
        expand_lines = true,
        floating = {
          border = "single",
          mappings = { close = { "q", "<Esc>" } },
        },
        force_buffers = true,
        icons = { collapsed = "", current_frame = "", expanded = "" },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.61 },
              { id = "breakpoints", size = 0.13 },
              { id = "stacks", size = 0.13 },
              { id = "repl", size = 0.13 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "watches", size = 0.25 },
              { id = "console", size = 0.75 },
            },
            position = "bottom",
            size = 10,
          },
        },
        mappings = {
          edit = "e",
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          repl = "r",
          toggle = "t",
        },
        render = {
          indent = 1,
          max_value_lines = 100,
        },
        open = { reset = true },
      },
    },
  },
  --- Test manager
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter",
      -- Adapters
      "nvim-neotest/neotest-python",
      "MisanthropicBit/neotest-busted",
    },
    -- stylua: ignore
    keys = {
      { "<leader>rta", function() require("neotest").run.run({ suite = true }) end, desc = "neotest: Run all test in the current project" },
      { "<leader>rtf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "neotest: Run all test in the current file" },
      { "<leader>rtt", function() require("neotest").run.run() end, desc = "neotest: Run nearest test" },
      { "<leader>rtd", function() require("neotest").run.run({ strategy = "dap", suite = false }) end, desc = "neotest: Debug nearest test" },
      { "<leader>rtl", function() require("neotest").run.run_last() end, desc = "neotest: Re-run last test" },
      { "<leader>rtL", function() require("neotest").run.run_last({ strategy = "dap", suite = false }) end, desc = "neotest: Debug last test" },
      { "<leader>rtS", function() require("neotest").run.stop() end, desc = "neotest: Stop the nearest test" },
      { "<leader>rto", function() require("neotest").output_panel.toggle() end, desc = "neotest: Toggle output panel" },
      { "<leader>rtO", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "neotest: Show test output" },
      { "<leader>rtp", function() require("neotest").summary.toggle() end, desc = "neotest: Toggle summary panel" },
      { "<leader>rtc", function() require("neotest").output_panel.clear() end, desc = "neotest: Clean the output panel" },
    },
    ---@module "neotest.config"
    ---@type neotest.Config
    ---@diagnostic disable: missing-fields
    opts = {
      log_level = vim.log.levels.OFF, -- default: WARN
      output = { open_on_run = true },
      summary = { open = "topleft vsplit | vertical resize 45" }, -- botright | topleft
      status = { virtual_text = true },
      busted = {
        busted_command = ".tests/data/nvim/lazy/busted/bin/busted",
        minimal_init = "tests/busted.lua",
        local_luarocks_only = true,
      },
      python = {
        dap = { justMyCode = true },
        runner = "pytest",
      },
    },
    config = function(_, opts)
      opts.adapters = {
        require("neotest-python")(opts.python),
        require("neotest-busted")(opts.busted),
      }
      require("neotest").setup(opts)
    end,
  },
  --- Git integration
  {
    "nvim-mini/mini.diff",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    -- stylua: ignore
    keys = {
      { "<leader>td", function() require("mini.diff").toggle_overlay(0) end, desc = "Mini.diff: Toggle diff overlay", },
    },
    opts = { style = "number" },
  },
  --- Auto update edited markdown, html and svg files in the web browser
  {
    "brianhuster/live-preview.nvim",
    dependencies = { "telescope.nvim" },
    cmd = "LivePreview",
    -- stylua: ignore
    keys = {
      { "<leader>LP", utils.plugins.livepreview_toggle, ft = "html", desc = "LivePreview: Toggle." },
    },
  },
  --- PlantUML diagrams preview
  {
    "https://gitlab.com/itaranto/preview.nvim",
    version = "*",
    lazy = false,
    dependencies = {
      { "aklt/plantuml-syntax", lazy = false },
    },
    opts = {
      render_on_write = true,
      previewers = {
        plantuml_png = { command = "plantuml", args = { "-pipe", "-tpng" } },
        plantuml_svg = { command = "plantuml", args = { "-pipe", "-tsvg" } },
      },
      previewers_by_ft = {
        plantuml = {
          -- name = "plantuml_png",
          -- renderer = { type = "command", opts = { cmd = { "qimgv" }, ext = "png" } },
          name = "plantuml_svg",
          renderer = { type = "command", opts = { cmd = { "qimgv" }, ext = "svg" } },
        },
      },
    },
  },
  --- Neovim Development
  --- Lsp helpers like types for lua and neovim plugin development
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "${3rd}/luassert/library", words = { "assert" } },
        { path = "${3rd}/busted/library", words = { "describe" } },
      },
    },
  },
  --- Profiler. Check the utils.profiler module for helper functions
  {
    "stevearc/profile.nvim",
    enabled = Workstation,
    cond = false,
    priority = 1500,
    lazy = false,
  },
  --- Show highlights applied to variables names and virtual text marks
  {
    "nvim-mini/mini.hipatterns",
    enabled = Workstation,
    cond = vim.uv.cwd():match("monokai%-nightasty") ~= nil,
    event = "VeryLazy",
    opts = {},
  },
  --- Automatically adjust shiftwidth and expandtab
  {
    "tpope/vim-sleuth",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  },
  --- Improve Ansible support
  {
    "mfussenegger/nvim-ansible",
    ft = { "yaml" },
  },
  --- Java
  {
    "mfussenegger/nvim-jdtls",
    dependencies = { "blink.cmp", "mason.nvim" },
    ft = { "java" },
    opts = function()
      local map = require("utils").config.set_ft_keymap

      if vim.env.MASON == nil then
        vim.notify("$MASON is not set", vim.log.levels.ERROR)
        return
      end

      if vim.env.JAVA_HOME == nil then
        vim.notify("$JAVA_HOME is not set", vim.log.levels.ERROR)
        return
      end

      local function get_workspace()
        local workspace_metadata_path = vim.fn.stdpath("cache") .. "/jdtls/"
        local cwd = vim.fn.getcwd()
        local hash = vim.fn.sha256(cwd)
        return workspace_metadata_path .. hash
      end

      local lombok = vim.fn.expand("$MASON/share/jdtls/lombok.jar")

      local jdtls_cmd = {
        vim.fn.exepath("jdtls"),
        "--jvm-arg=-javaagent:" .. lombok,
        "-data",
        get_workspace(),
      }

      local jdtls = require("jdtls")

      local extendedClientCapabilities = vim.deepcopy(jdtls.extendedClientCapabilities)
      extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

      local settings = {
        java = {
          eclipse = {
            downloadSource = true,
          },
          maven = {
            downloadSources = true,
          },
          signatureHelp = {
            enabled = true,
          },
          -- fernflower decompiler when using the javap command to decompile byte
          -- code back to java code
          contentProvider = {
            preferred = "fernflower",
          },
          -- Setup automatical package import oranization on file save
          saveActions = {
            organizeImports = true,
          },
          completion = {
            -- When using an unimported static method, how should the LSP rank
            -- possible places to import the static method from
            favoriteStaticMembers = {
              "org.junit.jupiter.api.Assertions.*",
              "org.mockito.Mockito.*",
            },
            -- Try not to suggest imports from these packages in the code action window
            filteredTypes = {
              "com.sun.*",
              "io.micrometer.shaded.*",
              "java.awt.*",
              "jdk.*",
              "sun.*",
            },
            -- Set the order in which the language server should organize imports
            -- "" is all others, "#" is static imports
            importOrder = {
              "com",
              "lombok",
              "org",
              "jakarta",
              "javax",
              "java",
              "",
              "#",
            },
          },
          sources = {
            -- How many classes from a specific package should be imported before
            -- automatic imports combine them all into a single import
            organizeImports = {
              starThreshold = 9999,
              staticThreshold = 9999,
            },
          },
          codeGeneration = {
            -- When generating toString use a json format
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            -- When generating hashCode and equals methods use the java 7 objects method
            hashCodeEquals = {
              useJava7Objects = true,
            },
            -- When generating code use code blocks
            useBlocks = true,
          },
          -- JAVA_HOME should be set in the environment. Also check the name matches
          -- the current Java version on the system
          configuration = {
            runtimes = {
              {
                name = "JavaSE-25",
                path = os.getenv("JAVA_HOME"),
              },
            },
            updateBuildConfiguration = "automatic",
          },
          referencesCodeLens = {
            enabled = true,
          },
          inlayHints = {
            parameterNames = {
              enabled = "all",
            },
          },
        },
        ["org.eclipse.jdt.core.compiler.problem.task"] = "ignore",
      }

      local on_attach = function(_, bufnr)
        vim.bo[bufnr].indentexpr = ""
        vim.bo[bufnr].cindent = true
        vim.bo[bufnr].expandtab = true
        vim.bo[bufnr].shiftwidth = 4
        vim.bo[bufnr].softtabstop = 4
        vim.bo[bufnr].tabstop = 4

        -- vim.lsp.codelens.enable(true, { bufnr = bufnr })

        -- Keymaps
        -- stylua: ignore start
        map("n", "<leader>ji", "<Cmd>terminal ./mvnw clean install -U -X -DskipTests<CR>", "Java: Clean Install (no tests)")
        map("n", "<leader>jt", "<Cmd>terminal ./mvnw clean install -U -X<CR>", "Java: Clean Install")
        map("n", "<leader>jo", function() require("jdtls").organize_imports() end, "Java: Organize Imports")
        map("n", "<leader>rr", "<Cmd>terminal ./mvnw spring-boot:run<CR>", "Java: Run Dev Profile")
        map("n", "<leader>jtc", function() require("jdtls").test_class() end, "Java: Test Class")
        map("n", "<leader>jtm", function() require("jdtls").test_nearest_method() end, "Java: Test Nearest Method")
        map("n", "<F1>", vim.diagnostic.open_float, "Java: Open float diagnostic info")
        map("n", "<F2>", vim.lsp.buf.rename, "Java: Rename object")
        -- stylua: ignore end
      end

      return {
        cmd = jdtls_cmd,
        settings = settings,
        on_attach = on_attach,
        init_options = {
          extendedClientCapabilities = extendedClientCapabilities,
        },
      }
    end,
    config = function(_, opts)
      local function get_bundles()
        local java_debug = vim.fn.expand("$MASON/share/java-debug-adapter")
        local java_test = vim.fn.expand("$MASON/share/java-test")
        local bundles = {
          vim.fn.glob(java_debug .. "/com.microsoft.java.debug.plugin-*.jar", true),
        }
        vim.list_extend(
          bundles,
          vim.split(
            vim.fn.glob(java_test .. "/*.jar", true),
            "\n",
            { trimempty = true }
          )
        )
        return bundles
      end

      local ignored = {}
      local ignore_msg = {
        ["Validate documents"] = true,
        ["Publish Diagnostics"] = true,
      }

      local lsp_message_handler = function(err, result, ctx, config)
        local token = result.token
        local v = result.value

        if type(v) == "table" and token then
          if v.kind == "begin" and ignore_msg[v.title] then
            ignored[token] = true
            return
          end

          if ignored[token] then
            if v.kind == "end" then
              ignored[token] = nil
            end
            return
          end
        end

        return vim.lsp.handlers["$/progress"](err, result, ctx, config)
      end

      local function attach_jdtls()
        local tbl_bundles = { bundles = get_bundles() }
        local config = {
          cmd = opts.cmd,
          init_options = vim.tbl_extend("error", opts.init_options, tbl_bundles),
          settings = opts.settings,
          on_attach = opts.on_attach,
          capabilities = require("blink.cmp").get_lsp_capabilities(),
          handlers = { ["$/progress"] = lsp_message_handler },
        }

        require("jdtls").start_or_attach(config)
      end

      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*.java",
        callback = function()
          vim.defer_fn(function() vim.cmd("checktime") end, 1500)
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "java" },
        callback = attach_jdtls,
      })
    end,
  },
}
