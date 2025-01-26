return {
  {
    'goolord/alpha-nvim',
    -- dependencies = { 'echasnovski/mini.icons' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local alpha = require 'alpha'
      local dashboard = require 'alpha.themes.dashboard'

      local startify = require 'alpha.themes.startify'
      -- available: devicons, mini, default is mini
      -- if provider not loaded and enabled is true, it will try to use another provider
      startify.file_icons.provider = 'devicons'
      alpha.setup(startify.config)
      dashboard.section.header.val = {
        '                             ',
        '  ██████╗ ██████╗ ██╗███████╗',
        ' ██╔═══██╗██╔══██╗██║╚══███╔╝',
        ' ██║   ██║██████╔╝██║  ███╔╝ ',
        ' ██║   ██║██╔══██╗██║ ███╔╝  ',
        ' ╚██████╔╝██║  ██║██║███████╗',
        '  ╚═════╝ ╚═╝  ╚═╝╚═╝╚══════╝',
        '                             ',
      }
      dashboard.section.buttons.val = {
        dashboard.button('f', '  > file browser', '<leader>fb'),
        dashboard.button('r', '  > Recent', ':Telescope oldfiles<CR>'),
        dashboard.button('s', '  > Settings', ':e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>'),
        dashboard.button('q', '  > Quit NVIM', ':qa<CR>'),
      }
      alpha.setup(dashboard.opts)
    end,
  },
}
