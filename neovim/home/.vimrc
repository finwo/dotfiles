" vim:fdm=marker:fdl=0

" vim-plug {{{

" Install vim-plug without my interference
if has('nvim')
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd!
    autocmd VimEnter * PlugInstall
  endif

endif

" }}}
" Plugins {{{

" Specify plugin directory
call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'alvan/vim-closetag'
Plug 'editorconfig/editorconfig-vim'
Plug 'itchyny/calendar.vim'
Plug 'jparise/vim-graphql'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'morhetz/gruvbox'
Plug 'padawan-php/deoplete-padawan', { 'do': 'composer install' }
Plug 'qpkorr/vim-bufkill'
Plug 'ryym/vim-riot'
Plug 'scrooloose/nerdtree'
Plug 'sheerun/vim-polyglot'
Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-eunuch'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'


if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" JS-specific
Plug 'carlitux/deoplete-ternjs'

" PHP-specific
Plug 'StanAngeloff/php.vim', {'for': 'php'}

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

set wrap linebreak        " enable line wrapping
set showbreak="  "        " show by indent
set list                  " show whitespace
set listchars=nbsp:⦸      " CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)
set listchars+=tab:▷┅     " WHITE RIGHT-POINTING TRIANGLE (U+25B7, UTF-8: E2 96 B7)
                          " + BOX DRAWINGS HEAVY TRIPLE DASH HORIZONTAL (U+2505, UTF-8: E2 94 85)
set listchars+=extends:»  " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
set listchars+=precedes:« " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
set listchars+=trail:•    " BULLET (U+2022, UTF-8: E2 80 A2)

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

set bg=dark         " dark mode
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
nnoremap <c-h> <c-w><c-h>
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>
" }}}
" X11 Clipboard support {{{

" Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y

" Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

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
" Deoplete {{{

" Basics
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('auto_complete_delay', 0)
let g:echodoc_enable_at_startup = 1
set splitbelow
set completeopt+=menuone,noinsert,noselect
autocmd CompleteDone * pclose

" Define basic sources
function! Multiple_cursors_before()
  let b:deoplete_disable_auto_complete=2
endfunction
function! Multiple_cursors_after()
  let b:deoplete_disable_auto_complete=0
endfunction
call deoplete#custom#option('enable_buffer_path', 1)
call deoplete#custom#source('buffer', 'mark', 'ℬ')
call deoplete#custom#source('tern', 'mark', '')
call deoplete#custom#source('padawan', 'mark', "\ue608")
call deoplete#custom#source('omni', 'mark', '⌾')
call deoplete#custom#source('file', 'mark', '')
" call deoplete#custom#source('jedi', 'mark', '')
call deoplete#custom#source('neosnippet', 'mark', '')
call deoplete#custom#source('LanguageClient', 'mark', '')
call deoplete#custom#source('typescript',  'rank', 630)
" call deoplete#custom#source('_', 'matchers', ['matcher_cpsm'])
" call deoplete#custom#source('_', 'sorters', [])
let g:deoplete#omni_patterns = {
      \ 'html': '',
      \ 'css': '',
      \ 'scss': ''
      \}
function! Preview_func()
  if &pvw
    setlocal nonumber norelativenumber
    endif
endfunction
autocmd WinEnter * call Preview_func()
call deoplete#custom#option('ignore_sources', {'_': ['around', 'buffer' ]})

" Whether to include the types of the completions in the result data. Default: 0
let g:deoplete#sources#ternjs#types = 1

" Whether to include the distance (in scopes for variables, in prototypes for 
" properties) between the completions and the origin position in the result 
" data. Default: 0
let g:deoplete#sources#ternjs#depths = 1

" Whether to include documentation strings (if found) in the result data.
" Default: 0
let g:deoplete#sources#ternjs#docs = 1

" When on, only completions that match the current word at the given point will
" be returned. Turn this off to get all results, so that you can filter on the 
" client side. Default: 1
let g:deoplete#sources#ternjs#filter = 0

" Whether to use a case-insensitive compare between the current word and 
" potential completions. Default 0
let g:deoplete#sources#ternjs#case_insensitive = 1

" When completing a property and no completions are found, Tern will use some 
" heuristics to try and return some properties anyway. Set this to 0 to 
" turn that off. Default: 1
let g:deoplete#sources#ternjs#guess = 0

" Determines whether the result set will be sorted. Default: 1
let g:deoplete#sources#ternjs#sort = 1

" When disabled, only the text before the given position is considered part of 
" the word. When enabled (the default), the whole variable name that the cursor
" is on will be included. Default: 1
let g:deoplete#sources#ternjs#expand_word_forward = 0

" Whether to ignore the properties of Object.prototype unless they have been 
" spelled out by at least two characters. Default: 1
let g:deoplete#sources#ternjs#omit_object_prototype = 0

" Whether to include JavaScript keywords when completing something that is not 
" a property. Default: 0
let g:deoplete#sources#ternjs#include_keywords = 1

" If completions should be returned when inside a literal. Default: 1
let g:deoplete#sources#ternjs#in_literal = 0


"Add extra filetypes
let g:deoplete#sources#ternjs#filetypes = [
                \ 'jsx',
                \ 'javascript.jsx',
                \ 'vue',
                \ '...'
                \ ]

" }}}
" Calendar {{{
let g:calendar_google_calendar = 1
let g:calendar_first_day       = "Monday"
" }}}
" EasyAlign {{{

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlgin for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" }}}
" Syntax detection {{{
au BufNewFile,BufRead,BufReadPost *.hbs set syntax=handlebars
" }}}
