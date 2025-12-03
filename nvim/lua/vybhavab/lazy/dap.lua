return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      {
        "mxsdev/nvim-dap-vscode-js",
        dependencies = {
          {
            "microsoft/vscode-js-debug",
            version = "1.93.0",
            build = "npm install --legacy-peer-deps && npm run compile",
          },
        },
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local widgets = require("dap.ui.widgets")
      local dap_utils = require("dap.utils")

      dapui.setup({
        floating = { border = "rounded" },
        layouts = {
          { elements = { "scopes", "watches" },   size = 40, position = "left" },
          { elements = { "repl", "breakpoints" }, size = 12, position = "bottom" },
        },
      })

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      require("dap-vscode-js").setup({
        debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
        node_path = "node",
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
        log_file_level = vim.log.levels.ERROR,
      })

      local js_filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" }
      for _, language in ipairs(js_filetypes) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file (Node)",
            program = "${file}",
            cwd = "${workspaceFolder}",
            runtimeExecutable = "node",
            sourceMaps = true,
            skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to Next.js server",
            processId = dap_utils.pick_process,
            cwd = "${workspaceFolder}",
            skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
          },
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch Chrome for Next.js",
            url = "http://localhost:3000",
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
            userDataDir = false,
          },
          {
            type = "pwa-chrome",
            request = "attach",
            name = "Attach Chrome (9222)",
            port = 9222, -- start Chrome with --remote-debugging-port=9222
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
          },
        }
      end

      local function map(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { desc = desc })
      end

      map("<F5>", dap.continue, "DAP continue")
      map("<F10>", dap.step_over, "DAP step over")
      map("<F11>", dap.step_into, "DAP step into")
      map("<F12>", dap.step_out, "DAP step out")
      map("<leader>db", dap.toggle_breakpoint, "DAP toggle breakpoint")
      map("<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, "DAP conditional breakpoint")
      map("<leader>dl", function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
      end, "DAP log point")
      map("<leader>dr", dap.repl.open, "DAP open REPL")
      map("<leader>du", dapui.toggle, "Toggle DAP UI")
      map("<leader>ds", function()
        widgets.centered_float(widgets.scopes)
      end, "DAP scopes")
    end,
  },
}
