"NeoBundle Scripts-----------------------------
if has('vim_starting')
  set nocompatible               " Be iMproved

  " Required:
  set runtimepath+=/Users/cpatti/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('/Users/cpatti/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'The-NERD-tree'
NeoBundle 'The-NERD-Commenter'
NeoBundle 'ag.vim'
NeoBundle 'dougireton/vim-chef.git'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'nvie/vim-flake8.git'

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
" Enable Neosnippet
let g:neocomplete#enable_at_startup = 1
" Pylint configuration file
let g:syntastic_python_pylint_post_args="--max-line-length=120"
:syntax on
