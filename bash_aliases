# some more ls aliases
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"

alias ll='eza --color=always --long --git --icons=always'

alias la='ll -lAh'

# some color aliases for greps
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# color aliases for less and cat
#alias cat='ccat'
alias less='cless'

alias find-here='grep -rnw . -e'
alias find-file='find . -type f -iname'

function ff() {
  find . -type f -iname "*$1*"
}

## aliases for rails
alias be='bundle exec'
alias rc='bundle exec rake tmp:cache:clear'
alias bi='bundle install'

## aliases
alias weg="killall ssh"
alias showFiles="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app"
alias hideFiles="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app"
alias refreshMenuBar="killall -KILL SystemUIServer"
# alias hg='history | grep'

## wttr alias
alias wttr='curl wttr.in/berlin'
# alias chetempochefa='function weather() { curl wttr.in/$1; };weather'
function weather() { curl wttr.in/"$1"; }

## pretty print json rom curl
# alias prtjson='function prettyJson() { curl $1 | python -m json.tool; }; prettyJson'
function prettyJson() { curl "$1" | python -m json.tool; }

## update brew and remove old packages
alias brewski='brew update && brew upgrade && brew cleanup; brew doctor'
alias portski='sudo port selfupdate && port outdated && sudo port upgrade outdated && sudo port clean --all installed; sudo port reclaim'

alias prep_commit='bundle exec reek . && rubocop -A && rspec'

#aliases for docker
alias dc='docker compose'
alias dcd='docker compose -f docker-compose.yml -f docker-compose.development.yml'
alias dc-dev="docker compose -f docker-compose.yml -f docker-compose.dev.yml"
alias dct='docker compose -f docker-compose.yml -f docker-compose.test.yml'
alias dck='docker compose -f docker-compose.yml -f docker-compose.kafka.yml'

# aliases for aws marleyspoon
alias ams='aws-vault exec marleyspoon-cx-staging'
alias amp='aws-vault exec marleyspoon-cx-production'

# alias for kubernetes
alias k='kubectl'
alias pkube='kubectl --kubeconfig=$HOME/.kube/culinary-production.config'
alias skube='kubectl --kubeconfig=$HOME/.kube/culinary-staging.config'
alias sk='skube'
alias pk='pkube'
alias pklogs='stern --kubeconfig=$HOME/.kube/culinary-production.config --timestamps --color always'
alias sklogs='stern --kubeconfig=$HOME/.kube/culinary-staging.config --timestamps --color always'
alias klogs='stern --kubeconfig=$HOME/.kube/config --timestamps --color always'

alias pk9s='k9s --kubeconfig=$HOME/.kube/culinary-production.config'
alias sk9s='k9s --kubeconfig=$HOME/.kube/culinary-staging.config'

alias nvim-kickstart='NVIM_APPNAME="nvim-kickstart" nvim'

# alias cat='bat'
# alias cd="z"

# alias helper for decoding base 64 encrypted strings
function decode-base64() { echo "$1" | base64 --decode; }

# alias internetSongToMp3='youtube-dl --rm-cache-dir --extGract-audio --audio-quality 320K --audio-format mp3 $1'
function internetSongToMp3() { yt-dlp --rm-cache-dir --extract-audio --audio-quality 320K --audio-format mp3 "$1"; }
# alias internetSongToFlac1='youtube-dl --rm-cache-dir --extract-audio --audio-format flac $1'
function internetSongToFlac1() { yt-dlp --rm-cache-dir --extract-audio --audio-format flac "$1"; }
# alias internetSongToFlac9='youtube-dl --rm-cache-dir --extract-audio --audio-quality 9 --audio-format flac $1'
function internetSongToFlac9() { yt-dlp --rm-cache-dir --extract-audio --audio-quality 9 --audio-format flac "$1"; }

function gh-run-notifier() {
  local param1=$1
  local param2=${2:-CI}
  echo "Running gh run watch with param1=$param1 and param2=$param2"
  # Replace the command below with your desired command
  gh run watch "$param1" && terminal-notifier -title GH RUN FINISHED! -sound default -message "$param2 done"
}
alias ca='cursor-agent'

function ksc() {
  local context=$(kubectl config get-contexts -o name | fzf -m)

  if [[ -n $context ]]; then
    kubectl config use "$context"
  else
    echo "No context selected."
  fi
}
