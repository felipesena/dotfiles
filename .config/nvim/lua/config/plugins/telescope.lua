return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons' },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          fzf = {},
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          }
        }
      }

      require('telescope').load_extension('fzf')
      require('telescope').load_extension('ui-select')

      local builtin = require('telescope.builtin')

      vim.keymap.set("n", "<leader>ff", builtin.find_files)
      vim.keymap.set("n", "<leader>fh", builtin.help_tags)

      require('config.telescope.multigrep').setup()
    end
  }
}
