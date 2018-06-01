    " Specify python progs manually because we mess around with virtual envs alot.
    " Pick up Ruby and Node from rbenv and nvm respectively. If that ever needs to
    " change, can manual specify here similar.
    let g:python_host_prog = expand('~/.pyenv/versions/2.7.14/bin/python2')
    let g:python3_host_prog = expand('~/.pyenv/versions/3.6.4/bin/python3')
     
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
     
     
    " LSP config
    " Required for operations modifying multiple buffers like rename.
    set hidden
     
    if !empty($VIRTUAL_ENV) && filereadable($VIRTUAL_ENV . "/bin/python2")
        let pyls = [expand("~/.pyenv/versions/pyls2/bin/pyls")]
    else
        let pyls = [expand("~/.pyenv/versions/pyls/bin/pyls")]
    endif
     
    let g:LanguageClient_loggingLevel = "DEBUG"
    let g:LanguageClient_serverCommands = {
            \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
            \ 'python': pyls
            \ }
     
    nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
    nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
    nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
    nnoremap <leader>h :call LanguageClient#textDocument_hover()<CR>
