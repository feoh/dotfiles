#!/usr/bin/env bash

# Hate bash_it. Hate hate HATE! :)
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
export EDITOR='emacsclient'
export VISUAL='emacsclient'
export GIT_EDITOR='emacsclient'
export ALTERNATE_EDITOR='vim'

# Tell Python to always use unicode.
export PYTHONIOENCODING=utf-8

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.

export IRC_CLIENT='irssi'

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/xvzf/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# Load Bash It
source $BASH_IT/bash_it.sh

export GOPATH="$HOME/src/personal/go"

export PATH="$HOME/bin:$HOME/anaconda/bin:/usr/local/bin:$GOPATH/bin:$PATH"

alias gpom='git pull origin master'
alias gprom='git pull --rebase origin master'
alias t="/Users/cpatti/.chefdk/gem/ruby/2.1.0/bin/t"
eval "$(chef shell-init bash)"

