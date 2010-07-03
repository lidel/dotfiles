"   .vimrc (by Marcin Rataj -- http://lidel.org) {
"
"   Compiled from manual and external sources over last decade.
"   Feel free to use it as a reference or base of your own .vimrc.
"
"   License: public domain
"
"   vim: set foldenable foldmarker={,} foldlevel=0
" }

" basic eye-candy {
    set t_Co=256                    " force 256 term (x11-terms/rxvt-unicode +xterm-color under Gentoo)
    syntax on
    colorscheme xoria256_modified   " http://svn.ungrund.org/system/skel/.vim/colors/xoria256.vim
    "colorscheme desert_modified    " http://fugal.net/vim/colors/desert.vim
    "colorscheme earendel           " pretty light theme
    "colorscheme desert256          " dark with light red and blue
    "colorscheme wombat256
    "set background=dark            " i love my eyes and prefer dark background
                                    " (it may be already defined in some themes)
    "colorscheme charged-256        " universal fix for some bad themes
" }

" Default encoding {
    set termencoding=utf-8
    set fileencoding=utf-8
    set encoding=utf-8
" }

" General file handling {
    filetype plugin on              " recognize filetypes
    filetype indent on
    set nowrap                      " Word wrap is the devil.
" }

" General file handling {
    set autochdir                   " always switch to the current file directory
    set fileformats=unix,dos,mac    " support all three, in this order
    set backup                      " make backup files
    set backupcopy=yes              " don't break symlinks
    set backupdir=~/.vim/backup     " where to put backup files
    set directory=~/.vim/tmp        " directory to place swap files in
                                    " I don't want to edit these files
    set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.swp,*.jpg,*.gif,*.png
" }

" UI tweaks {
    set nocompatible                " don't be compatible with vi
    set spelllang=pl                " default to polish
    set ttyfast                     " assume fast terminal connection
    set scrolloff=5                 " keep 3 lines below and above the cursor
    set sidescrolloff=10            " keep 5 lines at the size
    set ruler                       " row / column of cursor
    set modeline                    " last lines in document sets vim mode
    set modelines=3                 " number lines checked for modelines
    set shortmess=aTI               " no 'welcome' message
    set confirm                     " to get a dialog when a command fails
    set shell=zsh
    set listchars=tab:>-,trail:.,eol:$  " chars to show for :set list -> <F5>
    set guitablabel=%N/\ %t\ %M     " tab labels show the filename without path
    set cursorline                  " highlight the current column
    "set cursorcolumn                " highlight the current column
    set lazyredraw                  " do not redraw while running macros
    set nostartofline               " leave my cursor where it was
    set ignorecase                  " case insensitive by default
    set infercase                   " case inferred by default
    set smartcase                   " if there are caps, go case-sensitive
    set shiftround                  " when at 3 spaces, and I hit > ... go to 4, not 5
    set mouse=a                     " use mouse everywhere
                                    " Highlight redundant whitespaces
    highlight RedundantSpaces ctermbg=blue guibg=blue
    match RedundantSpaces /\s\+$\| \+\ze\t/
    set showmatch                   " show matching brackets
    set matchtime=5                 " how many tenths of a second to blink
                                    " matching brackets for
" }

" Default identation settings {
    set expandtab                   " use spaces as tabs
    set softtabstop=4               " use 4 softtabstops
    set shiftwidth=4                " spaces to use for autoindent
    set tabstop=4                   " real tabs
    set autoindent                  " always set autoindenting on
    set smartindent                 " smartindent! :)
    "set nosmarttab                 " always use tabstops
" }

" Folding {
    set foldenable                  " Turn on folding
    set foldlevel=100               " Don't autofold anything ;-P
                                    " what movements open folds
    set foldopen=block,hor,mark,percent,quickfix,tag

    function SimpleFoldText() " {
        return getline(v:foldstart).' '
    endfunction " }
    set foldtext=SimpleFoldText()  " Custom fold text function
" }


" Keybindings {
    set backspace=indent,eol,start      " make backspace a more flexible
    nnoremap    <F2> :set list!<CR>     " F2: Toggle list (display unprintable characters).
    nmap        <F5> :set nu!<CR>       " toggle line numbers

    fun RmCR()
        set fileformats=unix            " to see those ^M while editing a dos file.
        let oldLine=line('.')
        exe ":%s/\r//g"
        exe ':' . oldLine
    endfun
    "map         <F6> :call RmCR()<CR>  " ^M removal

    set         pastetoggle=<F11>       " pastetoggle - this toggles 'paste'
    nmap        <F7> :set spell!<CR>    " toggle spellcheck
" }

" Small macros and fixes {
    " NOCAPS :W = :w :Q = :q
    nmap :W :w
    nmap :Q :q
    " We all hate hitting q: instead of :q ;-)
    nnoremap q: q:iq<esc>
    " Suppress all spaces at end/beginning of lines
    nmap _s :%s/\s\+$//<CR>
    nmap _S :%s/^\s\+//<CR>
" }

" Autocompletions {
    iab beacuse    because              " fixing here since I can't fix my fingers
" }

" Plugin and external settings {
    let g:html_use_css = "1"            " Use css with html export for syntax color
    let perl_extended_vars=1            " highlight advanced perl vars  inside strings
" }


" MAN wrapper {
    autocmd FileType man setlocal ro nonumber nolist fdm=indent fdn=2 sw=4 foldlevel=2 | nmap q :quit<CR>
" }

" LATEX {
    " http://vim-latex.sourceforge.net/
    let g:tex_flavor='latex'
    let g:Tex_DefaultTargetFormat = 'pdf'
    let g:Tex_CompileRule_pdf = 'make pdf'
    let g:Tex_ViewRule_pdf = 'evince'
    let g:Tex_PromptedCommands = ''
    " don't want strange indenting for LaTeX files
    au BufNewFile,BufRead *.tex set nosmartindent
    au BufNewFile,BufRead *.tex set grepprg=grep\ -nH\ $*
    " TIP: if you write your \label's as \label{fig:something}, then if you
    " type in \ref{fig: and press <C-n> you will automatically cycle through
    " all the figure labels. Very useful!
    au BufNewFile,BufRead *.tex set iskeyword+=:
    au BufNewFile,BufRead *.tex set sw=2 sts=2 shiftwidth=2 tabstop=2 wrap
" }

" PYTHON {
    " don't want comments at the beginning of the line in Python
    au BufNewFile,BufRead *.py set nocindent
    au BufNewFile,BufRead *.py set nosmartindent
    au BufNewFile,BufRead *.py set autoindent
    set spelllang=en " default to english
" }
