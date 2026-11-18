return {
    {
        "marko-cerovac/material.nvim",
        config = function(_, opts)
            vim.g.material_style = "deep ocean"
        end,
    },

    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "material",
        }
    }
}
