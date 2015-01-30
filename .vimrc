"NeoBundle Scripts-----------------------------
if has('vim_starting')
  set nocompatible               " Be iMproved

  " Required:
  set runtimepath+=/home/cpatti/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('/home/cpatti/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'The-NERD-tree'
NeoBundle 'The-NERD-Commenter'
NeoBundle 'ag.vim'
NeoBundle 'dougireton/vim-chef.git'
NeoBundle 'klen/python-mode'
NeoBundle 'scrooloose/syntastic'

" You can specify revision/branch/tag.
"#NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }

" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------

" Chris Patti customizations
let NERDTreeShowHidden=1

" Pylint configuration file
let g:pymode_lint_config = '$HOME/.pylint.rc'
let g:pymode_options_max_line_length=120
let g:syntastic_python_pylint_post_args="--max-line-length=120"
