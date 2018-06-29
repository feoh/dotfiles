     
    " Spaces & Tabs
    set tabstop=4       " number of visual spaces per TAB
    set softtabstop=4   " number of spaces in tab when editing
    set shiftwidth=4    " number of spaces to use for autoindent
    set expandtab       " tabs are space
    set autoindent
    set copyindent      " copy indent from the previous line
     
    " Mouse is nice
    set mouse=a
     
    " integrate with clipboard
    set clipboard+=unnamedplus
     
    " Install plugins
    call plug#begin('~/.local/share/nvim/plugged')
     
    " SuperTab
    Plug 'ervandew/supertab'
    let g:SuperTabDefaultCompletionType = "<c-n>"
    let g:SuperTabClosePreviewOnPopupClose = 1
    " Sanner mappings
    Plug 'tpope/vim-unimpaired'
     
    " For LSP
    Plug 'autozimu/LanguageClient-neovim', {
            \ 'branch': 'next',
            \ 'do': 'bash install.sh',
            \ }
     
    " (Optional) Multi-entry selection UI.
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'

    Plug 'scrooloose/nerdcommenter'
     
    " Deoplete
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    let g:deoplete#enable_at_startup = 1

    let g:LanguageClient_loggingLevel = "DEBUG"
    let g:LanguageClient_serverCommands = {
            \ 'python': '/home/cpatti/.pyenv/shims/python2',
            \ 'python3': '/home/cpatti/.pyenv/shims/python3',
           \ }
     
    " NERDTree
    Plug 'scrooloose/nerdtree', { 'do': ':UpdateRemotePlugins' }
     
    let NERDTreeMinimalUI = 1
    let NERDTreeDirArrows = 1
    nnoremap <leader>t :NERDTreeToggle<CR>
     
    " Airline
     
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#tabline#enabled = 1
     
     
    Plug 'joshdick/onedark.vim'
     
    call plug#end()
     
    syntax enable
    "set background=dark
    colorscheme darkblue
     
     
     
    nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
    nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
    nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
    nnoremap <leader>h :call LanguageClient#textDocument_hover()<CR>
