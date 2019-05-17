" vim:fdm=marker:fdl=0

" Plugins {{{

" Specify plugin directory
call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'alvan/vim-closetag'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'
Plug 'qpkorr/vim-bufkill'
Plug 'scrooloose/nerdtree'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-eunuch'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'

" Initialize plugin system
call plug#end()

" }}}
" Basics {{{
set nocompatible           " be iMproved, required
filetype off               " required
let mapleader = "\<space>" " leader is space

set smarttab       " Smarter tabs
set tabstop=2      " Tabs = 2 columns
set shiftwidth=2   " 
set shiftround     " 
set expandtab      " soft tabs
set encoding=utf-8 " enable unicode support

set scrolloff=8      " keep 8 lines above/below cursor
set sidescroll=1     " enable horizontal scoll
set sidescrolloff=15 " keep 15 columns before/after cursor

set switchbuf=usetab " search in buffers before opening window
set hidden           " hide buffers instead of asking to save them

set noerrorbells " disable annoying beeps
set visualbell   " bell = blink

set wildmenu              " visual command autocomplete
set wildmode=longest,full " autocomplete as much as you can

set wrap linebreak " enable line wrapping
set showbreak="  " " show by indent

set cursorline  " highlight current line
set number      " show line numbers
set ruler       " show the cursor position at all times
set showcmd     " display incomplete commands
set cmdheight=1 " command box = 1 row
set showmatch   " highlight matching [{()}]

set incsearch  " incremental searching
set ignorecase " ignore case during search
set smartcase  " don't ignore capitals in search

" auto-center on matched string
nnoremap n nzz
nnoremap N Nzz

" move to beginning/end of line
nnoremap B ^
nnoremap E $

" $/^ doesn't do anything
nnoremap $ <nop>
nnoremap ^ <nop>

set iskeyword+=- " Use dash as word separator

set autoread " reload unchanged files automatically
set fileformats+=mac " support all kind of EOLs by default

" Y yanks from cursor to EOL as expected
nnoremap Y y$

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" in many terminal emulators the mouse works just fine
if has('mouse')
  set mouse=a
endif

" }}}
" Colors {{{

set termguicolors   " use colors instead of styles
syntax enable       " enable syntax highlighting
colorscheme gruvbox " nice theme

" }}}
" Custom keybindings {{{
nnoremap <leader>c :nohlsearch<cr>
nnoremap <leader>s :Ag<cr>
nnoremap <leader>o :Files<cr>
nnoremap <tab> :bnext<cr>
nnoremap <s-tab> :bprevious<cr>
nnoremap <c-w> :BD<cr>
nnoremap <c-n> :NERDTreeToggle<cr>
" }}}
" Airline {{{
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='gruvbox'
set laststatus=2
" }}}
" fzf {{{
let g:fzf_files_options =
      \ '--preview "(highlight -O ansi {} || cat {}) 2> /dev/null | head -'.&lines.'"'
let g:fzf_buffers_jump = 1
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
let g:fzf_tags_command = 'ctags -R'
let g:fzf_commands_expext = 'alt-enter,ctrl-x'
nnoremap <silent> <leader><enter> :Buffers<cr>
" }}}
" NERDTree {{{

" Highlighting of nerd dev icons and filenames in nerd tree
let g:NERDTreeFileExtensionsHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
" }}}
" ALE {{{

" Don't restrict JSX syntax highlighting to .jsx files
let g:jsx_ext_required = 0

" Enable completion where available
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '•'
let g:ale_sign_column_always = 1

" What programs handle what
let g:ale_fixers = {}
let g:ale_fixers['javascript'] = ['eslint', 'prettier']
let g:ale_fixers['css'] = ['prettier']
let g:ale_fixers['vue'] = ['prettier']
let g:ale_fixers['scss'] = ['stylelint', 'prettier']

" Automagically fix
let g:ale_open_list= 0
let g:ale_fix_on_save = 1

" Don't run every keystroke
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0

" }}}
