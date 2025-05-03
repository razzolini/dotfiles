" Use bash instead of fish shell
if &shell =~# 'fish$'
    set shell=bash
endif

" Set leader to space, which is easy to press on many different keyboard
" layouts and isn't otherwise useful in normal mode
let mapleader = ' '

" Plugins {{{

" Management (vim-plug) {{{

" Install vim-plug if needed
let $VIM_DIR=expand('<sfile>:p:h')
let $PLUG_PATH=$VIM_DIR . '/autoload/plug.vim'
if empty(glob($PLUG_PATH))
    silent !curl -fLo $PLUG_PATH --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/site/plugged')

" All filetypes
Plug 'dag/vim-fish' " Vim support for editing fish scripts
Plug 'machakann/vim-sandwich' " Search/select/edit sandwiched textobjects
Plug 'maxbrunsfeld/vim-yankstack' " Lightweight kill-ring implementation
Plug 'scrooloose/nerdcommenter' " Comment functions
Plug 'tpope/vim-eunuch' " Helpers for UNIX

call plug#end()

" }}}

" Configuration {{{

" vim-yankstack (must be first) {{{

" Setup to allow mappings involving y, d, c, etc.
call yankstack#setup()

" Mappings
let g:yankstack_map_keys = 0 " Disable default mappings
nmap <Leader>p <Plug>yankstack_substitute_older_paste
nmap <Leader>P <Plug>yankstack_substitute_newer_paste

" }}}

" vim-sandwich {{{

" Prevent unintended behavior by disabling mappings which are not very useful,
" but are easy to hit by mistake when using this plugin
nmap s <Nop>
xmap s <Nop>
" Ease transition from vim-surround by disabling its commands
nmap ys <Nop>
nmap cs <Nop>
nmap ds <Nop>

" Custom recipes
let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
let g:sandwich#recipes += [
    \ {
        \ 'buns'     : ['`', "'"],
        \ 'input'    : ['`'],
        \ 'filetype' : ['tex']
    \ }
\ ]

" }}}

" NERD commenter {{{

" Add space after delimiters
let g:NERDSpaceDelims = 1
" Default to -- for single line Haskell comments
let g:NERDAltDelims_haskell = 1

" }}}

" }}}

" }}}

" Filetype {{{

" Enable filetype detection
if has("autocmd")
  filetype on
  filetype indent on
  filetype plugin on
endif

" Default to MASM syntax
let g:asmsyntax = 'masm'
augroup filetype_asm
    autocmd!
    autocmd FileType *asm setlocal shiftwidth=8
    " Default to ; for comments
    autocmd FileType *asm setlocal commentstring=;\ %s
    " Use nasm syntax if the file extension is .asm
    autocmd BufNewFile,BufRead *.asm set filetype=nasm
    autocmd BufNewFile,BufRead *.asm let b:asmsyntax = 'nasm'
augroup END

augroup filetype_cabal
    autocmd!
    autocmd FileType cabal setlocal shiftwidth=2
augroup END

augroup filetype_dosbatch
    autocmd!
    " Always use CRLF in batch files
    autocmd FileType dosbatch setlocal fileformat=dos
augroup END

augroup filetype_haskell
    autocmd!
    autocmd FileType haskell setlocal shiftwidth=2
augroup END

augroup filetype_html
    autocmd!
    autocmd FileType html setlocal shiftwidth=2
augroup END

augroup filetype_make
    autocmd!
    autocmd FileType make setlocal shiftwidth=8
augroup END

augroup filetype_tex
    autocmd!
    autocmd FileType tex setlocal shiftwidth=2
    " Wrap lines between words (not between any two characters)
    autocmd FileType tex setlocal wrap linebreak
augroup END

augroup filetype_yaml
    autocmd!
    autocmd FileType yaml setlocal shiftwidth=2
augroup END

augroup filetype_vim
    autocmd!
    " Use marker folding in vim files and start with folds closed
    autocmd FileType vim setlocal foldmethod=marker foldlevelstart=0
augroup END

" Default to latex flavor for .tex files
let g:tex_flavor='latex'

" Default to bash shell syntax for .sh files
let g:is_bash=1

" }}}

" Keymaps {{{

" Leave insert and visual mode mode with df or fd
inoremap df <Esc>
inoremap fd <Esc>
vnoremap df <Esc>
vnoremap fd <Esc>

" Yank to end of line with Y (to match the behavior of D and C: by default, Y
" yanks the whole line instead)
nnoremap Y y$

" Run macros in visual mode
vnoremap @ <Esc>@

" Make j, k, 0 and $ navigate visual (wrapped) lines
noremap <buffer> <silent> j gj
onoremap <buffer> <silent> j gj
noremap <buffer> <silent> k gk
onoremap <buffer> <silent> k gk
noremap <buffer> <silent> 0 g0
onoremap <buffer> <silent> 0 g0
noremap <buffer> <silent> $ g$
onoremap <buffer> <silent> $ g$

" Navigate splits with M-h/j/k/l in normal and terminal mode
nnoremap <M-h> <C-w>h
tnoremap <M-h> <C-\><C-n><C-w>h
nnoremap <M-j> <C-w>j
tnoremap <M-j> <C-\><C-n><C-w>j
nnoremap <M-k> <C-w>k
tnoremap <M-k> <C-\><C-n><C-w>k
nnoremap <M-l> <C-w>l
tnoremap <M-l> <C-\><C-n><C-w>l

" Switch tabs with F7 and F8 (even in terminal mode)
nnoremap <silent> <F7> :tabp<CR>
tnoremap <silent> <F7> <C-\><C-n>:tabp<CR>
nnoremap <silent> <F8> :tabn<CR>
tnoremap <silent> <F8> <C-\><C-n>:tabn<CR>

" Add blank line (always without comment char) before/after current line {{{
" Code adapted from Tim Pope's vim-unimpaired
" Original source: https://github.com/tpope/vim-unimpaired/blob/b3bd13e6d0f118e88b2a0be18bfe335f8678cb46/plugin/unimpaired.vim#L149-L165

function! BlankDown(count) abort
    put =repeat(nr2char(10), a:count)
    '[-1
    silent! call repeat#set("\<Plug>addBlankDown", a:count)
endfunction

function! BlankUp(count) abort
    put!=repeat(nr2char(10), a:count)
    ']+1
    silent! call repeat#set("\<Plug>addBlankUp", a:count)
endfunction

" Internal mappings (used for repeat#set)
nnoremap <silent> <Plug>addBlankDown :<C-u>call BlankDown(v:count1)<CR>
nnoremap <silent> <Plug>addBlankUp :<C-u>call BlankUp(v:count1)<CR>

" Actual mappings (on an Italian querty keyboard à and ù are right of the home
" row, after ò)
nmap à<Space> <Plug>addBlankUp
nmap ù<Space> <Plug>addBlankDown

" }}}

" Unjoin (insert line break) and indent before current WORD
nnoremap <silent> <Leader>J F r<CR>>>

" }}}

" Formatting and display {{{

" Colors {{{

" Use default Vim terminal color scheme (insted of Neovim 0.10+ color scheme
" and 24-bit colors)
colorscheme vim
set notermguicolors

" Use colors suited to a dark background
set background=dark

" Enable syntax highlighting
syntax enable

" }}}

" Indentation {{{

" Intent with 4 spaces by default
set expandtab
set shiftwidth=4 " Autoindent
set softtabstop=-1 " Tab key (use same value as shiftwidth)

" Always indent to tabstops
set shiftround

" Keep indentation when typing newline
set autoindent

" Automatically indent or dedent next line based on keywords
set smartindent

" C and C++ indentation
set cinoptions+=:0 " Don't indent switch case labels
set cinoptions+=g0 " Don't indent public, protected and private

" }}}

" Don't add two spaces after the end of a sentence when using J or gq
set nojoinspaces

augroup formatoptions
    autocmd!
    " Don't insert comment leader when using o or O
    autocmd FileType * set formatoptions-=o
augroup end

" Show line breaks
set showbreak=↳\  " Escaped space is part of string

" Show tabs and trailing spaces
set list listchars=tab:▸·,trail:♦

" Show (absolute) line numbers
set number

" Always show at least one line above/below the cursor
set scrolloff=1

" Open new splits to the right/bottom by default
set splitright splitbelow

" }}}

" Searching {{{

" Case-insensitive searches (temporarily revert with \C or, in substitutions,
" the I flag) when they don't contain uppercase letters
set ignorecase smartcase

" Do not highlight search results
set nohlsearch

" Enable incremental search (temporarily highlight first match while typing
" search command)
set incsearch

" Show substitution effects incrementally (in the main window and in a split)
set inccommand=split

" }}}

" Backup, swap and undo {{{

" Save backup and swap files out of the way
set backupdir=~/.local/share/nvim/backup
set directory=~/.local/share/nvim/swap
" Create backupdir if it doesn't exist
if !isdirectory(&backupdir)
    call mkdir(&backupdir, 'p')
endif

" Create a backup when overwriting a file
set backup

" Enable persistent undo storage
set undofile undodir=~/.local/share/nvim/undo

" }}}

" Misc settings {{{

" Allow backspacing indentation, newlines and text before start of insert mode
set backspace=indent,eol,start

" Allow selection of empty space in visual block mode
set virtualedit=block

" Enable command line tab completion
set wildmenu wildmode=longest:full,full

" Use clipboard register by default
set clipboard+=unnamedplus

" Change cursor shape based on current mode
set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20

" Warn about swap files even if they belong to other running Neovim instances
" (to avoid ending up with multiple unsaved versions of the same edited file)
autocmd! nvim.swapfile

" }}}
