#!/bin/bash

# /etc/skel/.bash_profile

# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.
[[ -f ~/.bashrc ]] && . ~/.bashrc

vt=$(fgconsole 2>/dev/null)
(( vt == 1 )) && startx -- vt$vt &> ~/.xlog
unset vt

#user specific

export LANG=en_US.UTF-8
eval `ssh-agent`


# on this next line, we start keychain and point it to the private keys that
# we'd like it to cache
/usr/bin/keychain ~/.ssh/id_rsa #~/.ssh/id_dsa

# the environment variables are stored using a hostname-shell file,
# so replace <hostname> with your hostname, and the standard "sh" with
# "csh" or "fish" if you use either of those shells
source ~/.keychain/lambda-sh > /dev/null

# sourcing ~/.bashrc is a good thing
source ~/.bashrc
