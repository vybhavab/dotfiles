local dapui = require("dapui")
local dap = require("dap")
local daptext = require("nvim-dap-virtual-text")

local function setup_dap_cpp()
  -- Adapters
  dap.adapters.lldb = {
    type = "executable",
    command = vim.fn.exepath("lldb-vscode"),
    name = "lldb",
  }

  -- configurations
  dap.configurations.cpp = {
    {
      name = "Launch",
      type = "lldb",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},
      runInTerminal = false,
      -- postRunCommands = {'process handle -p true -s false -n false SIGWINCH'}
    }
  }

  dap.configurations.c = dap.configurations.cpp

end

local function setup_dap_js()

  require("dap-vscode-js").setup({
    adapters = { 'pwa-node', 'pwa-chrome', 'node-terminal'},
  })

  dap.adapters.node2 = {
    type = 'executable',
    command = 'node',
    args = {os.getenv('HOME') .. '/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js'},
  }

  dap.adapters.node = dap.adapters.node2;

  dap.configurations.typescriptreact = {
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach to process",
      port = 9229,
      skipFiles = {"<node_internals>/**"},
      sourceMaps = true,
      timeout = 100000,
    }
  }

  for _, language in ipairs({ "typescript", "javascript" }) do
    dap.configurations[language] = {
      {
        {
          type = "node2",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "node2",
          request = "attach",
          name = "Attach",
          processId = require'dap.utils'.pick_process,
          cwd = "${workspaceFolder}",
        },
        {
          type = "node2",
          request = "attach",
          name = "node:attach",
          port = 9229,
          skipFiles = {"<node_internals>/**"},
          timeout = 100000
        }
      }
    }
  end

end

local function setup_dap_ui()
  -- dapui.setup({
  --   layouts = {
  --     {
  --       elements = {
  --         "console",
  --       },
  --       size = 7,
  --       position = "bottom",
  --     },
  --     {
  --       elements = {
  --         { id = "scopes", size = 0.25 },
  --         "watches",
  --       },
  --       size = 40,
  --       position = "left",
  --     }
  --   },
  -- })
  dapui.setup()
end

local function setup_dap()

  -- defs
  vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end

  -- https://github.com/mfussenegger/nvim-dap/blob/4c30fb44e056d140ef28d10a527742846661b3a5/doc/dap.txt#L279

  -- require('dap.ext.vscode').load_launchjs(nil, { node = {'javascript', 'javascriptreact', 'typescriptreact', 'typescript' } })
  setup_dap_cpp()
  setup_dap_js()
end

local function setup_dap_map()
    local map = vim.api.nvim_set_keymap

    local opts = {noremap=true}

    map('n', '<Up>', "<Cmd>lua require'dap'.continue()<CR>", opts)
    map('n', '<Down>', "<Cmd>lua require'dap'.step_over()<CR>", opts)
    map('n', '<Right>', "<Cmd>lua require'dap'.step_into()<CR>", opts)
    map('n', '<Left>', "<Cmd>lua require'dap'.step_out()<CR>", opts)
    map('n', "<Leader>b", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
    map('n', "<Leader>B", "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition?: '))<CR>", opts)
    map('n', "<Leader>rc", "<Cmd>lua require'dap'.run_to_cursor()<CR>", opts)
end

local function init(...)

  setup_dap()
  daptext.setup()
  setup_dap_ui()
  setup_dap_map()

end

return {
  init=init
}
