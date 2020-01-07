# Tutrl
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
   echo "Initialising new SSH agent..."
   /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
   echo succeeded
   chmod 600 "${SSH_ENV}"
   . "${SSH_ENV}" > /dev/null
   /usr/bin/ssh-add;
}

# https://github.com/turtlco/ops/tree/master/ansible#local-setup
export WORKON_HOME=~/.virtual_envs
source /usr/local/bin/virtualenvwrapper.sh
workon opsv2

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
   . "${SSH_ENV}" > /dev/null
   ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
       start_agent;
   }
else
   start_agent;
fi
# end of Turtl

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="sedovsek"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="false"

# Uncomment following line if you want to disable colors in ls
DISABLE_LS_COLORS="false"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="false"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="false"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git osx autojump)

source $ZSH/oh-my-zsh.sh

# sublime as default editor
export EDITOR='subl -w'

# functions
function tree {
    find ${1:-.} -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
}

# Extract
extract () {
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       rar x $1       ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *)           echo "don't know how to extract '$1'..." ;;
      esac
  else
      echo "'$1' is not a valid file!"
  fi
}

# clones a repository, cds into it, and opens it in my editor.
# - arg 1 - url|username|repo remote endpoint, username on github, or name of
#           repository.
# - arg 2 - (optional) name of repo
#
# usage:
#   $ clone things
#     .. git clone git@github.com:stephenplusplus/things.git things
#     .. cd things
#     .. subl .
#
#   $ clone git@github.com:stephenplusplus/dots.git
#     .. git clone git@github.com:stephenplusplus/dots.git dots
#     .. cd dots
#     .. subl .
#
#   $ clone yeoman generator
#     .. git clone git@github.com:yeoman/generator.git generator
#     .. cd generator
#     .. subl .

function clone {
    local url=$1;
    local repo=$2;

    if [[ ${url:0:4} == 'http' || ${url:0:3} == 'git' ]]
    then
        # just clone this thing.
        repo=$(echo $url | awk -F/ '{print $NF}' | sed -e 's/.git$//');
    elif [[ -z $repo ]]
    then
        # my own stuff.
        repo=$url;
        url="git@github.com:stephenplusplus/$repo";
    else
        # not my own, but I know whose it is.
        url="git@github.com:$url/$repo.git";
    fi

    git clone $url $repo && cd $repo && subl .;
}

# grunt-cli
# http://gruntjs.com/
#
# Copyright (c) 2012 Tyler Kellen, contributors
# Licensed under the MIT license.
# https://github.com/gruntjs/grunt/blob/master/LICENSE-MIT

# Usage:
#
# To enable zsh <tab> completion for grunt, add the following line (minus the
# leading #, which is the zsh comment character) to your ~/.zshrc file:
#
# eval "$(grunt --completion=zsh)"

# Enable zsh autocompletion.
function _grunt_completion() {
  local completions
  # The currently-being-completed word.
  local cur="${words[@]}"
  # The current grunt version, available tasks, options, etc.
  local gruntinfo="$(grunt --version --verbose 2>/dev/null)"
  # Options and tasks.
  local opts="$(echo "$gruntinfo" | awk '/Available options: / {$1=$2=""; print $0}')"
  local compls="$(echo "$gruntinfo" | awk '/Available tasks: / {$1=$2=""; print $0}')"
  # Only add -- or - options if the user has started typing -
  [[ "$cur" == -* ]] && compls="$compls $opts"
  # Trim whitespace.
  compls=$(echo "$compls" | sed -e 's/^ *//g' -e 's/ *$//g')
  # Turn compls into an array to of completions.
  completions=(${=compls})
  # Tell complete what stuff to show.
  compadd -- $completions
}

compdef _grunt_completion grunt

# aliases
alias db="cd ~/Dropbox"
alias robert="cd /Users/robert"
alias h=history
alias l='ls -lh'
alias ll='ls -alh'
alias lp='ls -p'
alias lsd='ls -l ${colorflag} | grep "^d"' # List only directories
alias myIp='print $(ipconfig getifaddr en0)'
alias turtldev='open http://development.$(ipconfig getifaddr en0).xip.io:5000'
alias purge='curl -s -X PURGE'

# OS X only
    # Get OS X Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
    alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm update npm -g; npm update -g; sudo gem update'

    # Recursively delete `.DS_Store` files
    alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

    # Empty the Trash on all mounted volumes and the main HDD
    # Also, clear Apple’s System Logs to improve shell startup speed
    alias emptytrash="sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

    # Show/hide hidden files in Finder
    alias show="defaults write com.apple.Finder AppleShowAllFiles -bool true && killall Finder"
    alias hide="defaults write com.apple.Finder AppleShowAllFiles -bool false && killall Finder"

    # Hide/show all desktop icons (useful when presenting)
    alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
    alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"


# server
alias server="open http://$(ipconfig getifaddr en0):8000 && python -m SimpleHTTPServer"
alias phpserver="open http://$(ipconfig getifaddr en0):8080 && php -S $(ipconfig getifaddr en0):8080"
alias rubyserver="open http://$(ipconfig getifaddr en0):5000 && ruby -run -e httpd . -p5000"

# productivity
function removeEmptyLinesAtEnd () { sudo sed -i "" -e :a -e "/^\n*$/{$d;N;};/\n$/ba" $1 }
blacklist=(facebook.com 24ur.com nepremicnine.com twitter.com pinterest.com)
function productivityOn {
    removeEmptyLinesAtEnd /etc/hosts

    if grep -q "productivity boost" /etc/hosts ;
      then return ;
    else
      echo -e "\n# productivity boost" | sudo tee -a /etc/hosts

      for url in "${blacklist[@]}"; do
        echo -e "127.0.0.1 "$url"" | sudo tee -a /etc/hosts
        echo -e "127.0.0.1 www."$url"" | sudo tee -a /etc/hosts
      done
    fi
}

function productivityOff {
    sudo sed -i "" "/# productivity boost/d" /etc/hosts

    for url in "${blacklist[@]}"; do
      sudo sed -i "" "/127.0.0.1 "$url"/d" /etc/hosts
      sudo sed -i "" "/127.0.0.1 www."$url"/d" /etc/hosts
    done
    
    removeEmptyLinesAtEnd /etc/hosts
}

# add RVM to PATH for scripting
PATH=$PATH:$HOME/.rvm/bin

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Autojump
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh