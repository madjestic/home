# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.

PATH="${PATH}:/home/madjestic/.cabal/bin:/home/madjestic/.xmonad:/home/madjestic/cabal-dev/bin:/home/madjestic/Projects/Python/FFI:/home/madjestic/bin"
alias ls="ls -h --color=auto"

HISTSIZE=10000

alias e="emacsclient -t"
alias ec="emacsclient -c"
alias cim=vim


