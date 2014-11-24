#!/bin/bash
##############################
### variable setting


### bash screen
export PS1="\[\e[1;34m\][\u@\h:\W]\\$\[\e[00m\] "

### emacs alias
alias en="emacs --no-window-system"
alias ed="emacs --daemon &"
alias ec="emacsclient -c"
alias ee="emacsclient -e '(kill-emacs)'"

### git alias
alias gitlog="git log --graph --oneline --decorate"

##############################
