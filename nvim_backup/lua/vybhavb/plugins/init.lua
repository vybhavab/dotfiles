local function init()
    --packer? i barely know her
    require 'vybhavb.plugins.packer'.init()

    --HARPOOOOOON
    require 'vybhavb.plugins.harpoon'.init()

    -- lsp
    require 'vybhavb.plugins.lsp'.init()
    require 'vybhavb.plugins.cmp'.init()
    -- require 'vybhavb.plugins.compe'.init()
    require 'vybhavb.plugins.treesitter'.init()

    -- telescope
    require 'vybhavb.plugins.telescope'.init()

    -- utils
    require 'vybhavb.plugins.lazygit'.init()


    -- display
    require 'vybhavb.plugins.theme'.init()
    require 'vybhavb.plugins.zenmode'.init()
    require 'vybhavb.plugins.lualine'.init()

    -- git
    require 'vybhavb.plugins.gitsigns'.init()

    -- debugger
    require 'vybhavb.plugins.debugger'.init()

    --undotree
    require 'vybhavb.plugins.undotree'.init()

end

return {
    init = init
}
