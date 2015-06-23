#!/usr/bin/env bash

# Load RVM, if you are using it

# Path to the bash it configuration
export BASH_IT=$HOME/.bash_it

# Lock and Load a custom theme file
# location /.bash_it/themes/
#export BASH_IT_THEME='bobby'
export BASH_IT_THEME='candy'

# Your place for hosting Git repos. I use this for private repos.
#export GIT_HOSTING='git@git.domain.com'

# Set my editor and git editor
export EDITOR='emacs'
export GIT_EDITOR='emacs'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.

export IRC_CLIENT='irssi'

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/xvzf/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# Load Bash It
source $BASH_IT/bash_it.sh

# CAP personal customizations for Gazelle
# MySQL
export MYSQL_HOME=/usr/local/mysql
PATH=$MYSQL_HOME/bin:$PATH

export PATH="~/bin:/usrlocal/bin:$PATH"

alias gpom='git pull origin master'
alias gprom='git pull --rebase origin master'
alias t="/Users/cpatti/.chefdk/gem/ruby/2.1.0/bin/t"
eval "$(chef shell-init bash)"

# added by Anaconda 2.2.0 installer
export PATH="$HOME/anaconda/bin:$PATH"
