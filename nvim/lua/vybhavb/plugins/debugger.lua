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

  setup_dap_cpp()
  setup_dap_js()

  -- https://github.com/mfussenegger/nvim-dap/blob/4c30fb44e056d140ef28d10a527742846661b3a5/doc/dap.txt#L279
  require('dap.ext.vscode').load_launchjs()

end

local function init(...)

  setup_dap()
  setup_dap_ui()

end

return {
  init=init
}
