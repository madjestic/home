# /etc/skel/.bash_profile

# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.
[[ -f ~/.bashrc ]] && . ~/.bashrc

vt=$(fgconsole 2>/dev/null)
(( vt == 1 )) && startx -- vt$vt &> ~/.xlog
unset vt

#user specific

export LANG=en_US.UTF-8

#export TERM=rxvt-unicode -somehow this breakes the tty's locale

