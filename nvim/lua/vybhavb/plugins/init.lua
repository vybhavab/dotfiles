local function init()
    --packer? i barely know her
    require 'vybhavb.plugins.packer'.init()

    --HARPOOOOOON
    require 'vybhavb.plugins.harpoon'.init()

    -- lsp
    require 'vybhavb.plugins.lsp'.init()
    require 'vybhavb.plugins.compe'.init()
    require 'vybhavb.plugins.treesitter'.init()

    -- telescope
    require 'vybhavb.plugins.telescope'.init()

    -- utils
    require 'vybhavb.plugins.floaterm'.init()

    -- display
    require 'vybhavb.plugins.tokyonight'.init()
    --require 'vybhavb.plugins.lualine'.init()

end

return {
    init = init
}
