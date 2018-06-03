scriptencoding utf-8
set nocompatible               " be iMproved, required

set tabstop=2
set shiftwidth=2
set expandtab 		             " use spaces instead of tab
set linespace=5
set autoindent

set number 		                 " show line numbers

set colorcolumn=90						 " show ruler at 90

set showmatch                  " show matching parentheses

set formatoptions=c,r,t        " c - autowrap comments using textwidth
                               " r - automatically insert the current comment leader after hitting <Enter>
                               " t - autowrap text using textwidth(does not apply to comments)

set backspace=indent,eol,start " allow backspacing over everything in insert mode

set nobackup 		               " don't create backup files
set nowritebackup 	           " nor create them for edit time

set splitbelow                 " :sp to open new window over active one
set splitright                 " :vs to open new window on the right side of active one

set linebreak                  " don't break words across the lines

set display+=lastline          " show incomplete paragraphes

set whichwrap=b,s,<,>,h,l      " those keys can exceed linebreaks

set ruler                      " show cursor position

set hlsearch                   " highlight searched words

set nowrap                     " do not wrap lines

set pastetoggle=<F3>           " toggle paste mode with F3 (:set paste/nopaste)

set timeoutlen=1000 ttimeoutlen=0               " minimize delay when switching from insert to normal mode"

au BufNewFile,BufRead *.prawn set filetype=ruby " Add Ruby syntax highlithing to .prawn files"

" Change cursor when in insert mode START
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
" optional reset cursor on start:
augroup myCmds
au!
autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END
" END

" map HJKL for easier window movement
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Paste without overwriting register
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction

function! s:Repl()
    let s:restore_reg = @"
    return "p@=RestoreRegister()\<cr>"
endfunction

" NB: this supports "rp that replaces the selection by the contents of @r
vnoremap <silent> <expr> p <sid>Repl()

set ssop-=options    " do not store global and local values in a session
set ssop-=folds      " do not store folds in a session

filetype off                   " required

" remove extra whitespace on save
autocmd FileType * autocmd BufWritePre <buffer> %s/\s\+$//e

nnoremap <esc> :noh<return><esc> " cancel last search with esc
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Project tree
Plugin 'scrooloose/nerdtree.git'

" Searching files
Plugin 'kien/ctrlp.vim'

" Railscasts vim theme!
Plugin 'jpo/vim-railscasts-theme'

" JavaScript
Plugin 'pangloss/vim-javascript'

" CoffeeScript
Plugin 'strogonoff/vim-coffee-script'

" Git integration
Plugin 'tpope/vim-fugitive'

" Surrounding with quotes, brackets etc.
Plugin 'tpope/vim-surround'

" Ruby support
Plugin 'vim-ruby/vim-ruby'

" Rails helpers
Plugin 'tpope/vim-rails'

" Align code more easily
Plugin 'godlygeek/tabular'

" .hamlc support
Plugin 'hiukkanen/vim-hamlc'

" statusline
Plugin 'itchyny/lightline.vim'

" Golang
Plugin 'fatih/vim-go'

" JSX
Plugin 'mxw/vim-jsx'

" automatically close blocks
Plugin 'tpope/vim-endwise'

" emmet for vim
Plugin 'mattn/emmet-vim'

" autoclose matching stuff
Plugin 'jiangmiao/auto-pairs'

" highlight yanked text
Plugin 'machakann/vim-highlightedyank'

" autocomplete
Plugin 'Valloric/YouCompleteMe'

" asynchronous linting
Plugin 'w0rp/ale'

call vundle#end()            " required
filetype plugin indent on    " required

" ==== ruby-vim config ====

" parse entire buffer and add list of classes to completion results
let g:rubycomplete_classes_in_global = 1

" detect and load Rails env for files within rails project for autocompletion
let g:rubycomplete_rails = 1

" ==== NERDTree config ====

" Open NERDTree automatically when vim starts up if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Toggle NERDTree window with Ctrl+N
map <C-n> :NERDTreeToggle<CR>

" Autoclose vim if only window remaining is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" ==== Syntastic config ====

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_eruby_ruby_quiet_messages =
    \ {'regex': 'possibly useless use of a variable in void context'}

" ==== CTRL-P config ====

" exclude files from searching
set wildignore+=*/node_modules,*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

" count of suggested files
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:15'

" persist cache in configured location, so vim can read it when launching to
" speed up ctrl-p startup
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'

" use ag searcher instead of vim's native globpath() apis
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" ==== Lightline config ====

" fix missing status line
set laststatus=2

" ==== vim-highlightyanked config ====

if !exists('##TextYankPost')
  map y <Plug>(highlightedyank)
endif

let g:highlightedyank_highlight_duration = 500

" ==== Lightline statusline config ====

let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'filename': 'FilenameForLightline'
      \ },
			\ 'tab_component_function': {
			\	  'filename': 'MyTabFilename',
      \ },
      \ }

" shorter filenames on statusline
function! FilenameForLightline()
  return expand('%')
endfunction

" custom tab filenames
function! MyTabFilename(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let bufnum = buflist[winnr - 1]
  let bufname = expand('#'.bufnum.':t')
  let buffullname = expand('#'.bufnum.':p')
  let buffullnames = []
  let bufnames = []
  for i in range(1, tabpagenr('$'))
    if i != a:n
      let num = tabpagebuflist(i)[tabpagewinnr(i) - 1]
      call add(buffullnames, expand('#' . num . ':p'))
      call add(bufnames, expand('#' . num . ':t'))
    endif
  endfor
  let i = index(bufnames, bufname)
  if strlen(bufname) && i >= 0 && buffullnames[i] != buffullname
    return substitute(buffullname, '.*/\([^/]\+/\)', '\1', '')
  else
    return strlen(bufname) ? bufname : '[No Name]'
  endif
endfunction

" ==== vim-jsx config ====

" enable jsx syntax for .js files
let g:jsx_ext_required = 0

" ==== emmet-vim config ====

" emmet for jsx
let g:user_emmet_settings = {
      \  'javascript.jsx' : {
      \      'extends' : 'jsx',
      \  },
      \}

" ==== Railscasts colorscheme config ====

" Allow 256 colors schemes
syntax on
set t_Co=256
colorscheme railscasts

" vim fix 256-color in tmux
if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif
