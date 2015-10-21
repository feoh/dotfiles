# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="tjkirch"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git knife svn-fast-info ruby python vagrant)

source $ZSH/oh-my-zsh.sh

# User configuration

alias home='ssh -v -D 8907 -i ~/.ssh/id_rsa_personal feoh@linode.feoh.org'
alias toycraft='ssh feoh@toycraft.feoh.org'
alias nukevagrant='knife node delete -y cpatti-vagrant;knife client delete -y cpatti-vagrant'
alias gpom='git pull origin master'
alias gcm='git checkout master'
alias gprom='git pull --rebase origin master'

export EDITOR=emacs
export VISUAL=emacs

# Tell Python to always use unicode.
export PYTHONIOENCODING=utf-8

export PATH="$HOME/bin:$HOME/.cask/bin:/usr/local/sbin:/usr/local/bin:/opt/chefdk/embedded/bin:$HOME/.chefdk/gem/ruby/2.1.0/bin/:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"

# Yay Rost!
export RUST_SRC_PATH="$HOME/Dropbox/src/rust-dist/src"

if [[ `uname -s` == "Linux" ]];  then
	source /usr/local/bin/z.sh
elif [[ `uname -s` == "Darwin" ]]; then
	eval `/usr/libexec/path_helper -s`
	. `brew --prefix`/etc/profile.d/z.sh
else
	echo "You're not on a Mac or Linux. No z for you! :)"
fi
