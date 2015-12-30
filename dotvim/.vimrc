" All system-wide defaults are set in $VIMRUNTIME/debian.vim (usually just
" /usr/share/vim/vimcurrent/debian.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vim/vimrc), since debian.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing debian.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
"syntax on

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"if has("autocmd")
"  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
"    \| exe "normal g'\"" | endif
"endif

" Uncomment the following to have Vim load indentation rules according to the
" detected filetype. Per default Debian Vim only load filetype specific
" plugins.
"if has("autocmd")
"  filetype indent on
"endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd		" Show (partial) command in status line.
"set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden             " Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes) in terminals

" Source a global configuration file if available
" Deprecated, please move your changes here in /etc/vim/vimrc
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

"source $VIMRUNTIME/mswin.vim
set tabstop=2             "tab鍵為4個空格
set softtabstop=2
set shiftwidth=2
set number
let $LANG="zh_TW.UTF-8"
set fileencodings=utf-8,big5,euc-jp,gbk,euc-kr,utf-bom,iso8859-1
set encoding=utf8
set tenc=utf8
"show status line
set ls=2
set statusline=$\ %F\ [FORMAT=%{&ff}]\ [TYPE=%Y]
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
" ref. http://www.linux.com/feature/120126

"TODO
function! MySys()
  return "windows"
endfunction

"if MySys() == 'linux'
"  map <C-Up> :tabnew<CR>:e ./
"elseif MySys() == 'windows'
"  map <C-Up> :tabnew<CR>
"endif

"map
" for putty
" http://blog.nekobe.tw/?p=239
"map [A :tabnew<CR>:o ./
"imap <ESC><C-Up> :tabnew
"map [B :tabclose<CR>
"map [C :tabnext<CR>
"map [D :tabprev<CR>
map <C-Up> :tabnew<CR>
map <C-Right> :tabnext<CR>
map <C-Left> :tabprev<CR>
nmap ,s :source $VIM/_vimrc<CR>
nmap ,v :e $VIM/_vimrc<CR>
nmap <F12> :Tlist<CR>
nmap <F11> :NERDTree<CR>

"   Edit another file in the same directory as the current file
"   uses expression to extract path from current file's path
"  (thanks Douglas Potts)
if has("unix")
    map ,e :e <C-R>=expand("%:p:h") . "/" <CR>
else
    map ,e :e <C-R>=expand("%:p:h") . "\" <CR>
endif


""""""" color&font """""""
"set guifont=Consolas:h11:cANSI
set guifont=Monaco:h10:cANSI
set background=dark
syntax on 

hi Normal ctermfg=LightGray 
hi NonText ctermfg=Gray
hi Comment ctermfg=DarkCyan
"hi Function ctermfg=
hi Constant ctermfg=Blue
hi Statement ctermfg=Yellow
hi PreProc ctermfg=Red
hi Type ctermfg=DarkMagenta
hi LineNr ctermfg=DarkRed
hi Special ctermfg=Brown
hi SpecialChar ctermfg=Green
"hi Identifier ctermfg=White
hi StatusLine ctermfg=DarkBlue ctermbg=Gray
"hi StatusLineNC ctermfg=Black       ctermbg=Gray
"hi Cursor ctermfg=White ctermbg=DarkYellow
hi Visual ctermfg=DarkGreen ctermbg=Gray
hi Error ctermfg=White ctermbg=Red
"" moogoo's old
hi Normal	guifg=gray80 guibg=gray20
hi Comment	guifg=#16A514
hi Constant	guifg=LightBlue
hi Statement	guifg=Yellow
hi PreProc	guifg=#00A0A0
hi LineNr guifg=black guibg=gray40
hi Type		guifg=Magenta
hi Special	guifg=lightgreen "XML
hi Identifier	guifg=yellow
hi SpecialKey	guifg=yellow

