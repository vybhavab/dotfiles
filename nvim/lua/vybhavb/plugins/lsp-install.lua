
local lsp_installer = require("nvim-lsp-installer")

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
local function init()
  lsp_installer.on_server_ready(function(server)
      local opts = {}

      -- (optional) Customize the options passed to the server
      -- if server.name == "tsserver" then
      --     opts.root_dir = function() ... end
      -- end
      if server.name == "pyright" then
           opts.before_init = function(_, config)
             local p
             if vim.env.VIRTUAL_ENV then
               p = lsp_util.path.join(vim.env.VIRTUAL_ENV, "bin", "python3")
             else
               p = utils.find_cmd("python3", ".venv/bin", config.root_dir)
             end
             config.settings.python.pythonPath = p
           end
      end

      server:setup(opts)
  end)
end

return {
  init = init
}
