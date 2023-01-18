return function(use)
  use {'mfussenegger/nvim-dap'}
  use {'mfussenegger/nvim-dap-python'}
  require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
end


