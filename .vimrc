set ts=4
set sw=4
set sts=4
set expandtab

set backspace=indent,eol,start

syntax on
filetype plugin on

set nocompatible               " be iMproved


set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" My Bundles here:
"
" original repos on github
Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/vim-easymotion'
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "snipmate-snippets"
Bundle "garbas/vim-snipmate"
Bundle "ack.vim"
Bundle "The-NERD-tree"
Bundle "Command-T"
Bundle "surround.vim"
Bundle "PIV"
Bundle "The-NERD-Commenter"
Bundle "fugitive.vim"
