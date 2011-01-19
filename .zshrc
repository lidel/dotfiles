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



## ALIASES

alias rr='rm -Rf'
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
alias whatismyip="wget -O- -q whatismyip.org"
function calc () { awk "BEGIN { print $@ }" } # commandline calculator ;-)

# handy ones
alias ssh="ssh -4"
alias screen="screen -U"
autoload -U zmv # smart mv: zmv '(*).lis' '$1.txt'
alias lsa='ls -F --color=auto --group-directories-first -ld .*' # list only files beginning with "."

# 1 letter
alias l=ls
alias d='dirs -v'
alias c="cd ~ ; clear"
#m () { xset s off ; ionice -c2 -n0 mplayer "$@" ; xset s on }
alias m="ionice -c2 -n0 mplayer"

alias e="emerge"
yt () { mplayer `youtube-dl -g "$@"` } # youtube player ( net-misc/youtube-dl and mplayer)
t () { date ; time $@ ; date } # timing commands

# global aliases -- These do not have to be
# at the beginning of the command line.
alias -g L='less'
alias -g G='grep'
alias -g M='more'
alias -g H='head'
alias -g T='tail'



## UTILS

# update
zsh-updaterc () {
    ping -q -c1 github.com && \
    cp ~/.zshrc ~/.zshrc.old && \
    wget http://github.com/lidel/dotfiles/raw/master/.zshrc -O ~/.zshrc && \
    wget http://github.com/lidel/dotfiles/raw/master/.zshprompt -O ~/.zshprompt
}

# compressed manpages etc
bzless () { less -f <(bzcat $*) }
zless () { less -f <(zcat $*) }

# simple notifier
saydone () {
    if [ $? = 0 ]; then
          notify-send ":-) done "
      else
          notify-send --urgency=critical ":( failed"
    fi
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
