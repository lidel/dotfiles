"   .vimrc
"   by Marcin Rataj (http://lidel.org)
"
"   Compiled from manual and external sources over last decade.
"   Feel free to use it as a reference or base of your own .vimrc.
"
"   License: CC0 (Public Domain)
"   Updates: https://github.com/lidel/dotfiles/blob/master/.vimrc

" load plugins from ~/.vim/bundle
    execute pathogen#infect()

" basic eye-candy
    set t_Co=256                    " force 256 term (x11-terms/rxvt-unicode +xterm-color under Gentoo)
    syntax on
    set background=dark             " i love my eyes and prefer dark background
                                    " (it may be already defined in some themes)
    colorscheme xoria256           " http://www.vim.org/scripts/script.php?script_id=2140

" Default encoding
    set termencoding=utf-8
    set fileencoding=utf-8
    set encoding=utf-8

" General file handling
    filetype plugin on              " recognize filetypes
    filetype indent on
    set nowrap                      " Word wrap is the devil.

" General file handling
    set autochdir                   " always switch to the current file directory
    set fileformats=unix,dos,mac    " support all three, in this order
    set backup                      " make backup files
    set backupcopy=yes              " don't break symlinks
    set backupdir=~/.vim/backup     " where to put backup files
    set directory=~/.vim/tmp        " directory to place swap files in
                                    " I don't want to edit these files
    set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.swp,*.jpg,*.gif,*.png

" UI tweaks
    set nocompatible                " don't be compatible with vi
    set spelllang=pl                " default to polish
    set ttyfast                     " assume fast terminal connection
    set scrolloff=5                 " keep 3 lines below and above the cursor
    set sidescrolloff=5             " keep 5 lines at the size
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
" Default line number modes
    set number relativenumber
    augroup numbertoggle
        " idea credit: https://jeffkreeftmeijer.com/vim-number/
        autocmd!
        autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
        autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
    augroup END
" Default identation settings
    set expandtab                   " use spaces as tabs
    set softtabstop=4               " use 4 softtabstops
    set shiftwidth=4                " spaces to use for autoindent
    set tabstop=4                   " real tabs
    set autoindent                  " always set autoindenting on
    set smartindent                 " smartindent! :)
    "set nosmarttab                 " always use tabstops

" Folding
    "set foldenable                  " Turn on folding
    "set foldlevel=100               " Don't autofold anything ;-P
                                    " what movements open folds
    "set foldopen=block,hor,mark,percent,quickfix,tag

    "function SimpleFoldText() " {
    "    return getline(v:foldstart).' '
    "endfunction " }
    "set foldtext=SimpleFoldText()  " Custom fold text function

" Keybindings
    set backspace=indent,eol,start      " make backspace a more flexible
    nnoremap    <F2> :set list!<CR>     " F2: Toggle list (display unprintable characters).
    nmap        <F5> :set nu! relativenumber!<CR>  " toggle hybrid line numbers

    fun RmCR()
        set fileformats=unix            " to see those ^M while editing a dos file.
        let oldLine=line('.')
        exe ":%s/\r//g"
        exe ':' . oldLine
    endfun
    "map         <F6> :call RmCR()<CR>  " ^M removal

    set         pastetoggle=<F11>       " pastetoggle - this toggles 'paste'
    nmap        <F7> :set spell!<CR>    " toggle spellcheck

" Small macros and fixes
                                        " NOCAPS :W = :w, :Q = :q
    nmap :W :w
    nmap :Q :q
    nnoremap q: q:iq<esc>               " q: = :q
    nmap _s :%s/\s\+$//<CR>             " remove all spaces at end of lines
    nmap _S :%s/^\s\+//<CR>             " remove all spaces at beginning of lines
" }

" Autocompletions
    iab beacuse    because              " fixing here since I can't fix my fingers

" Plugin and external settings
    let g:html_use_css = "1"            " Use css with html export for syntax color
    let perl_extended_vars=1            " highlight advanced perl vars  inside strings

" MAN wrapper
    autocmd FileType man setlocal ro nonumber nolist fdm=indent fdn=2 sw=4 foldlevel=2 | nmap q :quit<CR>

" LATEX
    " More: http://vim-latex.sourceforge.net/
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

" PYTHON
    " don't want comments at the beginning of the line in Python
    "au BufNewFile,BufRead *.py set nocindent
    "au BufNewFile,BufRead *.py set nosmartindent
    "au BufNewFile,BufRead *.py set autoindent
    set spelllang=en                    " default to english

" Javascript
    autocmd BufRead,BufNewFile *.es6 setfiletype javascript

" custom indents
    let g:html_indent_inctags = "html,body,head,tbody"
    autocmd FileType javascript setlocal sw=2 sts=2 et
    autocmd FileType css        setlocal sw=2 sts=2 et
    autocmd FileType html       setlocal sw=2 sts=2 et
    autocmd FileType ruby       setlocal sw=2 sts=2 et

" vim modeline
    autocmd FileType javascript let b:TheCommentThing='//'
    autocmd FileType     python let b:TheCommentThing='#'
    autocmd FileType        cpp let b:TheCommentThing='//'
    autocmd FileType          c let b:TheCommentThing='//'
    autocmd FileType       bash let b:TheCommentThing='#'
    autocmd FileType         sh let b:TheCommentThing='#'
    autocmd FileType       html let b:TheCommentThing='##'
    autocmd FileType        css let b:TheCommentThing='/*'

command ML execute
    \ '$s@$@\r'
    \ .(exists('b:TheCommentThing') ? b:TheCommentThing : '')
    \ .' vim\:ts=4\:sw=4\:et\:@|noh|write!|edit'

" golang (https://github.com/fatih/vim-go)
" https://github.com/fatih/vim-go-tutorial#readme
    au FileType go let g:go_highlight_functions = 1
    au FileType go let g:go_highlight_methods = 1
    au FileType go let g:go_highlight_structs = 1
    au FileType go let g:go_highlight_operators = 1
    au FileType go let g:go_highlight_build_constraints = 1
    au FileType go let g:go_highlight_types = 1
    au FileType go let g:go_highlight_extra_types = 1
    au FileType go let g:go_highlight_fields = 1
    au FileType go let g:go_list_type = "quickfix"
    au FileType go let g:go_fmt_command = "goimports"
    au FileType go let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
    au FileType go let g:go_metalinter_autosave = 1
    au FileType go let g:go_auto_type_info = 1
    au FileType go let g:go_auto_sameids = 1

    au BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
    au FileType go set autowrite

    au FileType go nmap <leader>b  <Plug>(go-build)
    au FileType go nmap <leader>r  <Plug>(go-run)
    au FileType go nmap <leader>t  <Plug>(go-test)
    au FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
    au FileType go map <C-n> :cnext<CR>
    au FileType go map <C-m> :cprevious<CR>
    au FileType go nnoremap <leader>a :cclose<CR>
    au FileType go command! -bang A call go#alternate#Switch(<bang>0, 'edit')




" outlining via .org files
au BufEnter *.org setlocal sw=2 sts=2 et
au BufEnter *.org setlocal backspace=2
au BufEnter *.org setlocal tw=79 formatoptions+=t
au BufEnter *.org setlocal fo=aw2tq " paragraph auto-reflow
au BufEnter *.org setlocal foldmethod=indent


" vimwiki - Personal Wiki for VIM (https://vimwiki.github.io/)
" markdown support
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
" vim-instant-markdown - Instant Markdown previews from Vim (https://github.com/suan/vim-instant-markdown)
"let g:instant_markdown_autostart = 0    " disable autostart
"map <leader>md :InstantMarkdownPreview<CR>

" GIT Gutter support via https://vimawesome.com/plugin/vim-gitgutter
let g:gitgutter_diff_args = '-w' " ignore whitespace
set updatetime=250 " diff markers should appear automatically, but  default value is 4000ms

" tailing fixes
set viminfo='100,<1000,s1000,h   " max buffer saved for each register
