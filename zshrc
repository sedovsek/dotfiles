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
plugins=(git osx sublime autojump)

source $ZSH/oh-my-zsh.sh

# sublime as default editor
export EDITOR='subl -w'

# functions
function tree {
    find ${1:-.} -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
}

function browsertest() {
    open -a "/Applications/Google Chrome.app" $1
    open -a "/Applications/Safari.app/"       $1
    open -a "/Applications/Firefox.app"       $1
}

function celtra-dashboard-test {
    # settings
    msgUsage="Usage: celtra-dashboard-test [chrome/firefox/ff/safari] [accountIdent] [creatveId] (optional)"
    msgMissingIdent="Creative ID is missing, skipping some tests..."
    baseUrl="mab.robert" # http://$accountIdent.$baseUrl

    # checking parameters
    if [[ -z $1 || -z $2 ]]; then echo $msgUsage
        return
    fi

    if [ $1 == "chrome" ]; then
        app="Google Chrome"

    elif [[ $1 == "firefox" || $1 == "ff" ]]; then
        app="Firefox"

    elif [ $1 == "safari" ]; then
        app="Safari"
    else
        echo $msgUsage
        return  
    fi

    if [ -z $3 ]; then echo $msgMissingIdent
    fi
    
    # open up a browser
    if [ app ]; then
        echo "Opening Celtra Dashboard pages with $app"

        for page in "#campaigns" "#demo" "#account" "#billing" "#analytics-settings"
            open "https://"$2.$baseUrl/$page -a "/Applications/$app.app"

        if [[ -z !$3 ]]
            for page in "#campaigns/$3" "#analytics/$3" "tags.html#ad=$3"
                open "https://"$2.$baseUrl/$page -a "/Applications/$app.app"
    else
        echo $msgUsage
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

# aliases
alias db="cd ~/Dropbox"
alias robert="cd /Users/robert"
alias h=history
alias l='ls -lh'
alias ll='ls -alh'
alias lp='ls -p'
alias lsd='ls -l ${colorflag} | grep "^d"' # List only directories

# functions
function tree {
    find ${1:-.} -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
}

# OS X only
    # Get OS X Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
    alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm update npm -g; npm update -g; sudo gem update'

    # Recursively delete `.DS_Store` files
    alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

    # Empty the Trash on all mounted volumes and the main HDD
    # Also, clear Apple’s System Logs to improve shell startup speed
    alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

    # Show/hide hidden files in Finder
    alias show="defaults write com.apple.Finder AppleShowAllFiles -bool true && killall Finder"
    alias hide="defaults write com.apple.Finder AppleShowAllFiles -bool false && killall Finder"

    # Hide/show all desktop icons (useful when presenting)
    alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
    alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# ssh
alias debian="ssh -l robert 192.168.1.171"
alias ubuntu="ssh -l robert 192.168.1.178"

# server
alias server="open http://$(ipconfig getifaddr en0):8000 && python -m SimpleHTTPServer"
alias phpserver="open http://$(ipconfig getifaddr en0):8080 && php -S $(ipconfig getifaddr en0):8080"
alias rubyserver="open http://$(ipconfig getifaddr en0):5000 && ruby -run -e httpd . -p5000"

# vm machies
alias vmstart="vboxmanage startvm debian --type headless"
alias vmstop="vboxmanage controlvm debian savestate"

# zshrc reload
alias reload!='. ~/.zshrc'

# nvm environment
source ~/.nvm/nvm.sh
. ~/.nvm/nvm.sh

# Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# add RVM to PATH for scripting
PATH=$PATH:$HOME/.rvm/bin

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
