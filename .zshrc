# .zshrc
# by Marcin Rataj (http://lidel.org)
# Updates: http://github.com/lidel/dotfiles/
# License: public domain
#
# vim: ts=4 et sw=4





bindkey -e
setopt correct
setopt nohup

setopt auto_cd
setopt multios

setopt auto_pushd
setopt pushd_ignore_dups

setopt No_Beep


## KEYBOARD

# force-fix keyboard
case "$TERM" in
    linux)
        bindkey '\e[1~' beginning-of-line   # Home
        bindkey '\e[4~' end-of-line         # End
        bindkey '\e[3~' delete-char         # Del
        bindkey '\e[2~' overwrite-mode      # Insert
        ;;
    screen)
        # In Linux console
        bindkey '\e[1~' beginning-of-line   # Home
        bindkey '\e[4~' end-of-line         # End
        bindkey '\e[3~' delete-char         # Del
        bindkey '\e[2~' overwrite-mode      # Insert
        bindkey '\e[7~' beginning-of-line   # home
        bindkey '\e[8~' end-of-line         # end
        # In rxvt
        bindkey '\eOc'  forward-word         # ctrl cursor right
        bindkey '\eOd'  backward-word        # ctrl cursor left
        bindkey '\e[3~' backward-delete-char # This should not be necessary!
        ;;
    rxvt*)
        bindkey '\e[7~' beginning-of-line       # home
        bindkey '\e[8~' end-of-line             # end
        bindkey '\eOc'  forward-word            # ctrl cursor right
        bindkey '\eOd'  backward-word           # ctrl cursor left
        bindkey '\e[3~' backward-delete-char    # This should not be necessary!
        bindkey '\e[2~' overwrite-mode          # Insert
        ;;
    xterm*)
        bindkey "\e[1~" beginning-of-line   # Home
        bindkey "\e[4~" end-of-line         # End
        bindkey '\e[3~' delete-char         # Del
        bindkey '\e[2~' overwrite-mode      # Insert
        ;;
    sun)
        bindkey '\e[214z' beginning-of-line     # Home
        bindkey '\e[220z' end-of-line           # End
        bindkey '^J'      delete-char           # Del
        bindkey '^H'      backward-delete-char  # Backspace
        bindkey '\e[247z' overwrite-mode        # Insert
        ;;
esac

# jump to next/previous word
bindkey "^f" forward-word
bindkey "^b" backward-word


# info about running screen
if [[ -x $(which screen) ]]; then
    ZSHRC_SCREENLIST=$(screen -ls)
    # do nothing if no screens or inside of one
    if [[ $#ZSHRC_SCREENLIST -gt 42 ]] && [[ -z $STY ]]; then
        echo $ZSHRC_SCREENLIST
    fi
fi

# info about running tmux
if [[ -x $(which tmux) ]]; then
    ZSHRC_TMUXLIST=$(tmux ls 2>&1 | grep -v 'error connecting')
    # do nothing if no tmux sessions or inside of one
    if [[ $#ZSHRC_TMUXLIST -gt 47 ]] && [[ -z $TMUX ]]; then
        echo "There is a tmux session in the background:"
        echo $ZSHRC_TMUXLIST
    fi
fi

## ALIASES

alias rr='rm -rfI'
rrr () {
    for i in $*
    do
        if [ -f $i ]; then
            shred -n1 -fzuv "$i"
        elif [ -d $i ]; then
            find "$i" -type f -exec shred -n1 -fzuv {} \;
            rm -rf "$i"
        fi
    done
}
alias enman='LANG=en_GB LC_ALL=C man'
alias psaux="ps aux"
alias dv="dirs -v"
alias ...='cd ../..'
alias sl="sl -la" # app-misc/sl (http://www.izumix.org.uk/sl/)
alias recent="ls -rl *(D.om[1,10])"
alias mc='mc -s'              # tryb powolnego  terminala
alias grep="grep --color=auto "
alias mv='nocorrect mv'       # no spelling correction on mv
alias cp='nocorrect cp'       # no spelling correction on cp
alias mkdir='nocorrect mkdir' # no spelling correction on mkdir
alias pu=pushd
alias po=popd
alias wcat='wget -q -O -'
alias rtorrent="ionice -c3 rtorrent" # Linux kernel with active CFQ required

alias dbgemerge="FEATURES=\"nostrip\" CFLAGS=\"-ggdb3\" CXXFLAGS=\"-ggdb3\" emerge"
alias tlzma="tar -c $* | lzma -c9 > $1.tar.lzma" # deprecated?
alias du_dir="find . -maxdepth 1 -type d | xargs du -sb | sort -n"
alias png2jpg="mogrify -format jpg -quality 90 *.png"
alias jpg2greyscale="mogrify -contrast -contrast dither -colors 256 -colorspace gray -normalize"
alias r1600="mogrify -resize 1600x1280 -unsharp 1x1+0.3 -quality 90"
alias lower="tr \"[:upper:]\" \"[:lower:]\""
alias sping="ping -i .002 -s 1472"
alias whatismyip="dig +short myip.opendns.com @resolver1.opendns.com"
alias whatismyip2="curl -s icanhazip.com"
function calc () { awk "BEGIN { print $@ }" } # commandline calculator ;-)
alias makecachetag="echo -n 'Signature: 8a477f597d28d172789f06886806bc55' > CACHEDIR.TAG"
alias exif-fix-datetimeoriginal="exiftool '-exif:datetimeoriginal<filemodifydate' -if 'not \$exif:-exif:datetimeoriginal' -P"

# enterprise ambient sound
alias engage-lo="play -n -c1 synth whitenoise band -n 100 20 band -n 50 20 gain +25  fade h 1 864000 1" # play from  http://sox.sourceforge.net
alias engage-hi="play -n -c1 synth whitenoise lowpass -1 120 lowpass -1 120 lowpass -1 120 gain +14" # play from  http://sox.sourceforge.net

# handy ones
alias screen="screen -U"
alias tma='tmux attach -d -t'
alias tmux-pwd='tmux new -s $(basename $(pwd))' # create named tmux session where all shells start in pwd
autoload -U zmv # smart mv: zmv '(*).lis' '$1.txt'
alias lsa='ls -F --color=auto --group-directories-first -ld .*' # list only files beginning with "."

# 1 letter
alias l=ls
alias d='dirs -v'
alias c="cd ~ ; clear"
#m () { xset s off ; ionice -c2 -n0 mplayer2 "$@" ; xset s on }
alias m="ionice -c2 -n0 mpv"
alias m.25="ionice -c2 -n0 mpv -speed 1.25"
#alias m-fs="ionice -c2 -n0 mplayer2 -fs -heartbeat-cmd 'xscreensaver-command -deactivate'"

alias e="emerge"
alias v="vim"
alias a="aria2c"

alias ytget="youtube-dl -t" # downloads yt video and saves it under meaningful filename
yt () {
    ytcookie=$( mktemp -ut "yt-XXXXXX" );
    m -heartbeat-cmd 'xscreensaver-command -deactivate' -cookies -cookies-file ${ytcookie} $(youtube-dl -g --cookies ${ytcookie} "$@");
    rm -f $ytcookie
}
t () { date ; time $@ ; date } # timing commands

# Transcode files to a DLNA-compatible legacy format
ffmpeg-dlna () {
    for file in $@; do
        nice ionice -c3 ffmpeg -i "${file}" -y -threads 8 -target ntsc-dvd -b:v 4000k -maxrate 5000k -bufsize 2000k -qscale:v 1 -aspect 16:9 -ac 2 -ab 192000 "${file}_dlna.mpg"
    done
}


# global aliases -- These do not have to be
# at the beginning of the command line.
alias -g L='less'
alias -g G='grep'
alias -g M='more'
alias -g H='head'
alias -g T='tail'



## UTILS

update-dotfiles () {
    ping -q -c1 github.com && \
    cat ~/.zshrc > ~/.zshrc.old && \
    curl -L# https://github.com/lidel/dotfiles/raw/master/.zshrc > ~/.zshrc && \
    (test -e ~/.zshprompt && cat ~/.zshprompt > ~/.zshprompt.old) && \
    curl -L# https://github.com/lidel/dotfiles/raw/master/.zshprompt > ~/.zshprompt && \
    (test -e ~/.vimrc && cat ~/.vimrc > ~/.vimrc.old) && \
    curl -L# https://github.com/lidel/dotfiles/raw/master/.vimrc > ~/.vimrc && \
    (mkdir -p ~/.vim/backup ; mkdir -p ~/.vim/tmp) && \
    curl -L# https://github.com/lidel/dotfiles/raw/master/.tmux.conf > ~/.tmux.conf
    source ~/.zshrc
}

# compressed manpages etc
bzless () { less -f <(bzcat $*) }
zless () { less -f <(zcat $*) }
xzless () { less -f <(xzcat $*) }

# simple notifier
saydone () {
    if [ $? = 0 ]; then
        notify-send -i gtk-dialog-info "done :-)"
    else
        notify-send -i gtk-dialog-info --urgency=critical "failed :-("
    fi
}

# http://ku1ik.com/2012/05/04/scratch-dir.html
alias ns="new-scratch $HOME"
function new-scratch {
  cur_dir="$HOME/scratch"
  new_dir="$1/tmp/scratch-`date +%F-%T`"
  mkdir -p $new_dir
  ln -nfs $new_dir $cur_dir
  cd $cur_dir
  echo "New scratch dir ready ($new_dir)"
}

# vim as default editor (remote shells' crontab -e etc)
export EDITOR=vim
# vim as a man-page reader
# put in your ~/.vimrc :
# autocmd FileType man setlocal ro nonumber nolist fdm=indent fdn=2 sw=4 foldlevel=2 | nmap q :quit<CR>
vman() {
  if [ $# -eq 0 ]; then
    /usr/bin/man
  else
    if man -w $* >/dev/null 2>/dev/null
    then
      /usr/bin/man $* |  col -b | vim -c 'set ft=man nomod' -
    else
      echo No man page for $*
    fi
  fi
}

## Higer-order functions
## Source: http://yannesposito.com/Scratch/en/blog/Higher-order-function-in-zsh/index.html

# usage:
#
# $ foo(){print "x: $1"}
# $ map foo a b c d
# x: a
# x: b
# x: c
# x: d
function map {
    local func_name=$1
    shift
    for elem in $@; print -- $(eval $func_name $elem)
}

# $ bar() { print $(($1 + $2)) }
# $ fold bar 0 1 2 3 4 5
# 15
# -- but also
# $ fold bar 0 $( seq 1 100 )
function fold {
    if (($#<2)) {
        print -- "ERROR fold use at least 2 arguments" >&2
        return 1
    }
    if (($#<3)) {
        print -- $2
        return 0
    } else {
        local acc
        local right
        local func_name=$1
        local init_value=$2
        local first_value=$3
        shift 3
        right=$( fold $func_name $init_value $@ )
        acc=$( eval "$func_name $first_value $right" )
        print -- $acc
        return 0
    }
}

# usage:
#
# $ baz() { print $1 | grep baz }
# $ filter baz titi bazaar biz
# bazaar
function filter {
    local predicate=$1
    local result
    typeset -a result
    shift
    for elem in $@; do
        if eval $predicate $elem >/dev/null; then
            result=( $result $elem )
        fi
    done
    print $result
}

## COLOURS

export GREP_COLOR=31
if [ -x /usr/bin/dircolors ] ; then
    eval `dircolors` # ls colors
fi

# GNU/Linux || BSD ls
if [[ $OSTYPE = freebsd* ]]; then
    alias ls="ls -GF"
    alias ll="ls -lhGF"
    alias la="ls -lhaGF"
elif [[ $OSTYPE = linux* ]]; then
    alias ls="ls -F --color=auto --group-directories-first"
    alias ll="ls -lhF --color=auto --group-directories-first"
    alias la="ls -lhaF --color=auto --group-directories-first"
fi


# even more colour-candy  with app-misc/grc (http://goo.gl/2z2j)
if [ "$TERM" != dumb ] && [ -x /usr/bin/grc ] ; then
  alias cl='/usr/bin/grc -es --colour=auto'
  alias configure='cl ./configure'
  alias diff='cl diff'
  alias gcc='cl gcc'
  alias g++='cl g++'
  alias as='cl as'
  alias gas='cl gas'
  alias ld='cl ld'
  alias netstat='cl netstat'
  alias ping='cl ping'
fi

# MC chdir enhancement under Gentoo
if [ -f /usr/share/mc/mc.gentoo ]; then
       . /usr/share/mc/mc.gentoo
fi



# HISTORY
HISTFILE=${HOME}/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt hist_ignore_dups
setopt hist_expire_dups_first
setopt hist_ignore_space
setopt hist_no_store
setopt inc_append_history
setopt extended_history
setopt hist_reduce_blanks
# incognito mode
incognito() {
    HISTFILE=/dev/null
    PROMPT='incognito> '
}



## COMPLETION

zmodload -i zsh/complist
zstyle ':completion:*' menu select=4

setopt auto_remove_slash
setopt complete_in_word
autoload -U compinit
compinit

zstyle ':completion:*' list-colors ''

# completion for ssh hosts from known_hosts file
zstyle -e ':completion:*:(ssh|scp):*' hosts \
	'reply=($(sed -e "/^#/d" -e "s/ .*\$//" -e "s/,/ /g" \
	/etc/ssh_known_hosts /etc/ssh/ssh_known_hosts \
	~/.ssh/known_hosts 2>/dev/null))'
# 'lidel' is my user name
zstyle -e ':completion:*:(ssh|scp):*' my-users \
	'reply=(lidel root)'
zstyle -e ':completion:*:(ssh|scp):*' users \
	'reply=(lidel root)'
zstyle ':completion:*:(ssh|scp):*' tag-order hosts my-users _ignored

zstyle ':completion:*' max-errors 1
zstyle ':completion:*' original true
zstyle ':completion:*' completer _complete _correct _approximate

autoload -U insert-files
zle -N insert-files
bindkey "^Xf" insert-files ## C-x-f

# fancy completion as you type
#
# turned off by default (ctrl+z)
# turn on with ctrl+x+z
autoload -U predict-on
zle -N predict-on
zle -N predict-off
bindkey "^X^Z" predict-on ## C-x C-z
bindkey "^Z" predict-off ## C-z

REPORTTIME=10

# PID completion: kill X<TAB>
zstyle ':completion:*:processes' command 'ps -aux'

# completion cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh_cache
# ignore completion functions for commands you don't have
zstyle ':completion:*:functions' ignored-patterns '_*'



## MISC



# local -- define private stuff there
if [ -r ${HOME}/.zshrc_local ]; then
    . ${HOME}/.zshrc_local
fi

# prompt
if [ -r ${HOME}/.zshprompt ]; then
    . ${HOME}/.zshprompt
    setprompt
elif [ -r /home/lidel/.zshprompt ]; then
    . /home/lidel/.zshprompt
    setprompt
fi
