return function(use)
  use {"ellisonleao/glow.nvim"}
  use {'mfussenegger/nvim-dap'}
  use {'mfussenegger/nvim-dap-python'}
  require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
end


