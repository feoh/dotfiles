set ts=4
set sw=4
set sts=4
set expandtab

set backspace=indent,eol,start

syntax on

set nocompatible               " be iMproved

let VIMPRESS = [{'username':'feoh',
                \'password':'n3v3r3@5y',
                \'blog_url':'http://www.feoh.org/'
                \}] 

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


