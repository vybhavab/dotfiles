local dapui = require("dapui")
local dap = require("dap")

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
  dap.adapters.node2 = {
    type = 'executable',
    command = 'node',
    args = {os.getenv('HOME') .. '/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js'},
  }
  dap.configurations.javascript = {
    {
      name = 'Launch',
      type = 'node2',
      request = 'launch',
      program = '${file}',
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = 'inspector',
      console = 'integratedTerminal',
    },
    {
      -- For this to work you need to make sure the node process is started with the `--inspect` flag.
      name = 'Attach to process',
      type = 'node2',
      request = 'attach',
      processId = require'dap.utils'.pick_process,
    },
  }
end

local function setup_dap_ui()
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

  -- require('dap.ext.vscode').load_launchjs(nil,{ node = {'node2', 'typescriptreact', } })
  setup_dap_cpp()
  setup_dap_js()

end

local function setup_dap_map()
    local map = vim.api.nvim_set_keymap

    local opts = {noremap=true}

    map('n', '<F5>', "<Cmd>lua require'dap'.continue()<CR>", opts)
    map('n', '<F10>', "<Cmd>lua require'dap'.step_over()<CR>", opts)
    map('n', '<F11>', "<Cmd>lua require'dap'.step_into()<CR>", opts)
    map('n', '<F12>', "<Cmd>lua require'dap'.step_out()<CR>", opts)
    map('n', "<Leader>b", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
end

local function init(...)

  setup_dap()
  setup_dap_ui()
  setup_dap_map()

end

return {
  init=init
}
