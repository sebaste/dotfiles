" Add a modeline: use specific settings only for this file.

set modeline
set modelines=1

" Functions {{{

fun! SetTabLength(len)
    " The number of whitespaces that a TAB counts for when editing (and the
    " same number removed with BKSP).
    let &softtabstop=a:len
    " Number of whitespaces to be used for autoindent.
    let &shiftwidth=a:len
    " The number of whitespaces that VIM uses to display a TAB (escape code).
    let &tabstop=a:len
endfunction
    
" }}}

" General {{{

" Set the number of lines VIM should store.
set history=1024

" Set the number of undo levels to save.
set undolevels=256

" Enable filetype plugins.
filetype plugin on
filetype indent on

call SetTabLength(4)
" Use multiple of shiftwidth when indenting with < and >.
set shiftround

" Convert a TAB into whitespaces.
set expandtab

set autoindent
set copyindent

" }}}

" Backup {{{

" Make sure that backups are saved in a single place.
set backup
set backupdir=~/.vimbkp,/tmp
set directory=~/.vimbkp,/tmp
set writebackup

" }}}

" Key bindings {{{

" '\' is impractical to use as mapleader.
let mapleader=","

" Shortcuts to edit certain files.
nnoremap <leader>eg :vsp ~/.gitconfig
nmap <silent> <leader>ev :e $MYVIMRC<CR>
" Shortcut to reload .vimrc.
nmap <silent> <leader>rv :so $MYVIMRC<CR>

" Save a session, that can be returned to with "vim -S".
nnoremap <leader>s :mksession<CR>

" Toggle showing invisible symbols (tabs, eol, trailing whitespaces).
nnoremap <leader>q :set list!<CR>

" To disable search highlights after a search (executing :nohlsearch).
" Mapped to the key combination \ + <space>.
nnoremap <leader><space> :nohlsearch<CR>

" Split current buffer horizontally.
nnoremap <leader>sh :split<CR>
" Split current buffer vertically.
nnoremap <leader>sv :vsplit<CR>

" Switch buffers in ascending/descending order.
nnoremap <leader><Left> :bprevious<CR>
nnoremap <leader><Right> :bnext<CR>

" Print all buffers and expect a selection.
nnoremap <F1> :buffers<CR>:buffer<Space>

" Enter paste mode: no autoindent on text pasted into VIM.
set pastetoggle=<F2>

" Tags (for exuberant ctags).
" Go to definition.
nnoremap <F3> <C-]>
" Go back one step from latest definition.
nnoremap <F4> <C-t>

" }}}

" User interface {{{

" Show line numbers.
set number

" Always show the last command entered, at the very bottom right.
set showcmd

" Always show the current position.
set ruler

" Configure backspace so that it behaves in the expected way.
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching.
set ignorecase
" Activated if ignorecase is set.
" Entering one or more capital letters in the search string will make the search case-sensitive.
set smartcase

" Highlight search results.
set hlsearch
" Search as characters are entered.
set incsearch

" Do not redraw while executing macros (a good performance config).
set lazyredraw

" Turn magic on for regexps.
set magic

" Show matching brackets when text indicator is over a bracket.
set showmatch

" Turn on graphical menu to cycle through possible matches from commands.
set wildmenu

" Do not redraw in the middle of macros - only redraw when needed. This makes Vim faster.
set lazyredraw

" Enable folding (fold nested code).
" Show all folds.
set foldenable
" Set the starting fold level for opening a new buffer.
" If 0:  all folds will be closed.
" If 99: folds are always open, basically.
set foldlevelstart=10
" Folds can be nested. Set a maximum for this.
set foldnestmax=10
" Fold based on indentation (useful for Python).
set foldmethod=indent

" }}}

" Movement {{{

" Disable the use of the arrow keys.
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Easier window navigation.
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Movement based on visual lines.
" If a line is wrapped, movement down/up will not skip the wrapped line.
nnoremap j gj
nnoremap k gk

" Move to beginning/end of line.
" The default is otherwise ^ and $ (inconvenient).
nnoremap B ^
nnoremap E $

" }}}

" Colors and syntax {{{

" Enable syntax highlighting.
syntax enable

" Enable 256 colors.
if $TERM == "xterm-256color"
   set t_Co=256
endif

colorscheme 256-grayvim

" Use a unique colorscheme for each file type.
autocmd BufEnter *                        colorscheme smpl
autocmd BufEnter *.c,*.cpp,*.cc,*.h,*.hpp colorscheme iceberg
autocmd BufEnter *.py                     colorscheme khaki
autocmd BufEnter *.hs                     colorscheme 256-grayvim
autocmd BufEnter .vimrc                   colorscheme 256-grayvim
autocmd BufEnter .bashrc*,.cshrc*,.zshrc* colorscheme atom-dark-256 
autocmd BufEnter .Xdefaults               colorscheme 256-grayvim
autocmd BufEnter .inputrc                 colorscheme 256-grayvim

" TODO: Implement this using highlights instead, since the symbols printed here will
" be included in copied text.
" Show invisible characters (activated by "set list").
set list listchars=trail:~,tab:¤¤,eol:£
" Deactivate the list option by default.
set nolist

" }}}

" Local {{{
" Source local file in home directory containing local (not generic) settings if it exists.
if !empty(glob("~/.local.vimrc"))
   so ~/.local.vimrc
endif
" }}}

" vim: foldmethod=marker foldlevel=0
