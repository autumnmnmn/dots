#
# ~/.bashrc
#

[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

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
		PS1='\[\033[00;33m\]!\!\[\033[01;33m\] \W\[\033[01;31m\] -> \[\033[00m\]'
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
export PATH="~/data0/tools/Zotero_linux-x86_64:$PATH"

source "$HOME/.secret"
source "$ABODE/.bashalias"

source "$HOME/.cargo/env"
source /usr/share/nvm/init-nvm.sh

shopt -s cdable_vars
export dots="$ABODE/dots"
export data="$HOME/data0"
export code="$HOME/data0/code"
export py="$HOME/data0/code/python-scripts"
export fic="$HOME/data0/code/fic"

