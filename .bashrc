#
# ~/.bashrc
#

[[ $- != *i* ]] && return

export EDITOR=~/ponder/neovide_launcher
export VISUAL=~/ponder/neovide_launcher

export PYT_OUT=/data/0/pyt/out
export PYT_IN=/data/0/pyt/in
export PYT_SKETCH=/data/0/pyt/sketch

case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*|alacritty)
		PROMPT_COMMAND='echo -ne "\033]0;${USER} ${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

case ${TERM} in
    rxvt-unicode-256color|alacritty)
        use_color=true
        ;;
    *)
        echo [No color for \$TERM=${TERM}]
        use_color=false
        ;;
esac

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;35m\][\h\[\033[01;36m\] \W\[\033[01;35m\]]\$\[\033[00m\] '
	else
		PS1='\[\033[00;33m\]\[\033[01;33m\]\W\[\033[01;31m\]: \[\033[00m\]'
	fi

else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset use_color safe_term match_lhs sh

set -o noclobber

bind "set completion-ignore-case on"
bind "set completion-map-case on"
bind "set show-all-if-ambiguous on"

xhost +local:root > /dev/null 2>&1

shopt -s checkwinsize

shopt -s expand_aliases

# Enable history appending instead of overwriting.  #139609
shopt -s histappend
shopt -s cmdhist

ex ()
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2) tar xjf $1 ;;
            *.tar.gz) tar xzf $1 ;;
            *.bz2) bunzip2 $1 ;;
            *.gz) gunzip $1 ;;
            *.tar) tar xf $1 ;;
            *.tbz2) tar xjf $1 ;;
            *.tgz) tar xzf $1 ;;
            *.zip) unzip $1 ;;
            *.Z) uncompress $1 ;;
            *.7z) 7z x $1 ;;
            *) echo "no extractor for '$1' in ~/.bashrc" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

function gigs () { du -h $1 | grep -E "[0-9]G"; };

export PATH="$ABODE/path:$PATH"
export PATH="/data/0/tools/Zotero_linux-x86_64:$PATH"

export PYTHONPYCACHEPREFIX="/data/0/code/python/.cache"

source "$HOME/.secret"
source "$ABODE/.bashalias"

source "$HOME/.cargo/env"
source /usr/share/nvm/init-nvm.sh

shopt -s cdable_vars
export dots="$ABODE/dots"
export data="/data/0"
export code="/data/0/code"
export py="/data/0/code/python"
export fic="/data/0/code/fic"

