return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "c",
        "lua",
        "vim",
        "java",
        "javascript",
        "json",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline",
        "kotlin",
      })
    end,
  },
}
