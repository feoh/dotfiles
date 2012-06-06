# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
#ZSH_THEME="jnrowe"
#ZSH_THEME="alanpeabody"
ZSH_THEME="tjkirch"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)

# Make custom PATH additions first.
export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:/usr/local/share/ruby:/usr/local/share/python:~/bin:$PATH

if [ "$SYSTYPE" = "Linux" ]; then
    export PATH=$PATH:/home/php/bin:/home/mysql/bin:/home/build/bin
fi

export SYSTYPE=`uname -s`
plugins=(git vi vundle cap gem)

if [ "$SYSTYPE" = "Darwin" ]; then
    plugins=($plugins brew osx)
    export HAXE_LIBRARY_PATH="`brew --prefix`/share/haxe/std"
fi

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

bindkey -v

export PAGER='vimpager'
if [ "$SYSTYPE" = "Darwin" ]; then
    export EDITOR='mvim -f'
else
    export EDITOR='vim'
fi

export NODE_PATH=/usr/local/lib/node
alias home='ssh -D 1080 feoh@linode.feoh.org -p 1968'
alias bi='ssh -L3306:build1:3306 -L1099:build1:1099 -L8080:build1:8080 -L8000:build1:8000 build1.bluestatedigital.com'
alias b1='ssh build1.bluestatedigital.com'
alias th='ssh thuse.bluestatedigital.com'
alias e='ssh enoch.bluestatedigital.com'  
alias sb='ssh sandbox'
