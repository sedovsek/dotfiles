# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="sedovsek"

# Example aliases
# alias zshconfig="subl ~/.zshrc"
# alias ohmyzsh="subl ~/.oh-my-zsh"

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
plugins=(git osx sublime autojump)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

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

# aliases
alias db="cd /Users/robert/Dropbox"
alias robert="cd /Users/robert"

alias h=history

# List only directories
alias lsd='ls -l ${colorflag} | grep "^d"'

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
alias vigred="ssh -l lili kbp.vigred.com -p443"
alias relax="ssh -L 2121:www.relax.si:2121 lili@kbp.vigred.com -p443 -N"

# server
alias server="open http://localhost:8000 && python -m SimpleHTTPServer"

# sublime as default editor
export EDITOR='subl -w'

# nvm environment
. ~/nvm/nvm.sh

# autojump
if [ -f `brew --prefix`/etc/autojump ]; then
  . `brew --prefix`/etc/autojump
fi

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
