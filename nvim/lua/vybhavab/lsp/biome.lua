local util = require("lspconfig.util")
local node = require("vybhavab.utils.node")

return {
  cmd = function(dispatchers, config)
    local cmd = "biome"
    if config and config.root_dir then
      cmd = node.find_local_bin(config.root_dir, "biome") or cmd
    end

    return vim.lsp.rpc.start({ cmd, "lsp-proxy" }, dispatchers)
  end,
  root_dir = function(bufnr, on_dir)
    if vim.fs.root(bufnr, { "deno.json", "deno.jsonc", "deno.lock" }) then
      return
    end

    local filename = vim.api.nvim_buf_get_name(bufnr)
    local root_files = { "biome.json", "biome.jsonc" }
    root_files = util.insert_package_json(root_files, "biome", filename)

    local config_path = vim.fs.find(root_files, {
      path = filename,
      type = "file",
      upward = true,
      limit = 1,
    })[1]

    if config_path then
      on_dir(vim.fs.dirname(config_path))
    end
  end,
}
