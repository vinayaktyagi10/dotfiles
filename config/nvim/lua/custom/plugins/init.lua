-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {

  'neovim/nvim-lspconfig',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'L3MON4D3/LuaSnip',

  -- Treesitter for better Dart highlighting
  { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' },

  -- Flutter tools for flutter commands + debugger integration
  'akinsho/flutter-tools.nvim',
}
