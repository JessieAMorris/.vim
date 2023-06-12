" My ~/.vimrc
"
"
" Maintainer:	Jessie Adan Morris <jessie@jessieamorris.com>
" Last change:	2012 Oct 15
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" Use the old Command-T
let g:CommandTPreferredImplementation='ruby'

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set undofile
set undodir=~/.vim/undo
set number

" Make / trigger an actual regex search rather than a messed
" up regex search
nnoremap / /\v
vnoremap / /\v

" Hidden allows me to change buffers without writing my changes
set hidden

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" Mouse cursor position setting
set mouse=a

" Syntax
syntax on
" Always show highlights
set hlsearch

" Color theme
colorscheme desert

" If we're running in GUI mode then use a better gui and color
if has('gui_running')
  "Add spellchecking
  set spell
  set mousemodel=popup

  set guifont=Droid\ Sans\ Mono\ 9
  colors slate_mine
endif

filetype off
filetype plugin indent on

" backspace is actin funky
set backspace=indent,eol,start

" Default to 2 space tabs :-(
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" Custom function to quickly set spaces vs tabs
function! SetTab(spaces)
  let spaces = a:spaces
  if a:spaces > 0
    echo a:spaces
    execute 'setlocal tabstop='.spaces
    execute 'setlocal shiftwidth='.spaces
    execute 'setlocal softtabstop='.spaces
    execute 'setlocal expandtab'
  else
    setlocal tabstop=4
    setlocal shiftwidth=4
    setlocal softtabstop=4
    setlocal noexpandtab
  endif
endfunction

" Bind SetTab function to ST command
command -nargs=? ST :call SetTab(<f-args>)

" Prevents those damn swap files
set noswapfile
" Prevents those damn backup files
set nobackup

" Clear highlights (from search) after hitting Escape a bunch
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

if has("autocmd")
  " Whitespace Highlighting
  highlight ExtraWhitespace ctermbg=red guibg=red
  match ExtraWhitespace /\s\+$/
  autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
  autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave * match ExtraWhitespace /\s\+$/
  autocmd BufWinLeave * call clearmatches()

  " Uncomment the following to have Vim jump to the last position when
  " reopening a file
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Switch off :match highlighting.
match

" For Gundo.vim
let g:gundo_prefer_python3 = 1
nnoremap <F5> :GundoToggle<CR>

" Adds tabs to CommandT
let g:CommandTAcceptSelectionMap = '<C-t>'
let g:CommandTAcceptSelectionTabMap = '<CR>'

" Us PWD instead of .git root
let g:CommandTTraverseSCM='pwd'

" Allow escapes in CommandT on terminal
if &term =~ "xterm" || &term =~ "screen"
  let g:CommandTCancelMap = ['<ESC>', '<C-c>']
endif


" Flushes CommandT when Vim gets focus and such
augroup CommandTExtension
  autocmd!
  autocmd FocusGained * CommandTFlush
  autocmd BufWritePost * CommandTFlush
augroup END

" Ignores directories for CommandT
set wildignore+=node_modules,.git,build,venv,env,coverage,vendor,__pycache__

" Makes the little "|" show up for tabs
set list
set listchars=tab:\|\ ,trail:·,nbsp:¤,lead:·

" ex command for toggling hex mode - define mapping if desired
command -bar Hexmode call ToggleHex()
nnoremap <C-H> :Hexmode<CR>
inoremap <C-H> <Esc>:Hexmode<CR>
vnoremap <C-H> :<C-U>Hexmode<CR>

" helper function to toggle hex mode
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction

" Makes macros faster
set lazyredraw

" Let Terraform be auto-indented
let g:terraform_align=1
let g:terraform_fmt_on_save=1

" Let Python files be auto-formatted
let g:autopep8_disable_show_diff=1
" let g:autopep8_on_save = 1

" Wordmotion (aka camelcase and underscore word movements)
let g:wordmotion_prefix = ','

let g:sqlfmt_command = "sqlformat"
let g:sqlfmt_options = "-r -k upper"
let g:sqlfmt_auto = 0

" let g:pymode_indent = 1

let g:go_imports_autosave = 1
let g:go_fmt_autosave = 1
"let g:go_imports_mode = 'goimports'
"au FileType go nmap <leader>r <Plug>(go-run)
"au FileType go nmap <leader>c <Plug>(go-build)
"au FileType go nmap <leader>h <Plug>(go-test)
"imap <C-Space> <C-x><C-o>
"imap <C-@> <C-Space>
