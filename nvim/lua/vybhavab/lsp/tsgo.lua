local node = require("vybhavab.utils.node")
local typescript = require("vybhavab.lsp.typescript")

return {
  cmd = function(dispatchers, config)
    local cmd = "tsgo"
    if config and config.root_dir then
      cmd = node.find_local_bin(config.root_dir, "tsgo") or cmd
    end

    return vim.lsp.rpc.start({ cmd, "--lsp", "--stdio" }, dispatchers)
  end,
  root_dir = function(bufnr, on_dir)
    local project_root = typescript.root_dir(bufnr)

    if typescript.uses_native_preview(project_root) then
      on_dir(project_root)
    end
  end,
}
