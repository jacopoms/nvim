# ============================================================================
# Modern Zsh Configuration - Optimized for Performance
# ============================================================================

# ----------------------------------------------------------------------------
# Early Initialization (must be first)
# ----------------------------------------------------------------------------
[[ -f "$HOME/.env" ]] && source "$HOME/.env"

# Disable terminal-specific shell integration inside tmux — these inject escape
# sequences that conflict with tmux's own terminal management and cause pane
# rendering artifacts (visual overlap between vertical panes).
if [[ -n "$TMUX" ]]; then
  # Ghostty: prevent shell integration OSC sequences from leaking into tmux
  unset GHOSTTY_RESOURCES_DIR
  unset GHOSTTY_SHELL_INTEGRATION_NO_SUDO

  # Prevent oh-my-posh / zsh plugins from using terminal-specific cursor/OSC features
  unset TERM_PROGRAM

  # WezTerm: unset pane/socket vars so programs don't think they're in a WezTerm pane
  # (new tmux panes inherit these from the parent shell, but they're meaningless inside tmux)
  unset WEZTERM_PANE
  unset WEZTERM_UNIX_SOCKET
  unset WEZTERM_EXECUTABLE
  export WEZTERM_SHELL_SKIP_ALL=1

  # Disable OMZ's auto window-title feature — termsupport.zsh sends OSC 0/1/2 sequences
  # that WezTerm processes even from inside tmux, potentially desyncing its cursor state
  export DISABLE_AUTO_TITLE=true

  # Disable zsh's PROMPT_SP option — it uses cursor-positioning sequences before each
  # prompt to preserve partial lines, which can confuse tmux/WezTerm terminal state
  unsetopt PROMPT_SP
fi

# ----------------------------------------------------------------------------
# Package Manager Prefix Configuration (MacPorts vs Homebrew)
# ----------------------------------------------------------------------------
# Check MacPorts first (/opt/local), then Homebrew (/opt/homebrew or /usr/local)
if [[ -x "/opt/local/bin/port" ]]; then
  PACKAGE_MANAGER="macports"
  MACPORTS_PREFIX="/opt/local"
elif [[ "$(uname -m)" == "arm64" && -x "/opt/homebrew/bin/brew" ]]; then
  PACKAGE_MANAGER="homebrew"
  HOMEBREW_PREFIX="/opt/homebrew"
elif [[ -x "/usr/local/bin/brew" ]]; then
  PACKAGE_MANAGER="homebrew"
  HOMEBREW_PREFIX="/usr/local"
fi

# ----------------------------------------------------------------------------
# Environment Variables - Consolidated
# ----------------------------------------------------------------------------
export ASDF_DATA_DIR="$HOME/.asdf"
export EDITOR=nvim
export VISUAL="$EDITOR"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Docker settings
export DOCKER_COMPOSE_TIMEOUT=200
export COMPOSE_HTTP_TIMEOUT=200

# Increase file descriptor limit
ulimit -n 10240

# ----------------------------------------------------------------------------
# PATH Configuration - Optimized order (most specific first)
# ----------------------------------------------------------------------------
path=(
  "$HOME/.local/bin"
  "$HOME/.atuin/bin"
  # "$HOME/.antigravity/antigravity/bin"
  "$HOME/bin"
  $path  # Keep existing PATH entries
)

# Package Manager PATH (MacPorts or Homebrew)
if [[ "$PACKAGE_MANAGER" == "macports" ]]; then
  path=("$MACPORTS_PREFIX/bin" "$MACPORTS_PREFIX/sbin" $path)
elif [[ "$PACKAGE_MANAGER" == "homebrew" ]]; then
  path=("$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin" $path)
fi

# Remove duplicates and non-existent directories
typeset -U path
path=($^path(N-/))

# ----------------------------------------------------------------------------
# Package Manager Setup (MacPorts or Homebrew)
# ----------------------------------------------------------------------------
if [[ "$PACKAGE_MANAGER" == "macports" ]]; then
  [[ -f "$MACPORTS_PREFIX/share/asdf/asdf.sh" ]] && . "$MACPORTS_PREFIX/share/asdf/asdf.sh"
  [[ -f "$MACPORTS_PREFIX/share/fzf/shell/completion.zsh" ]] && source "$MACPORTS_PREFIX/share/fzf/shell/completion.zsh"
  [[ -f "$MACPORTS_PREFIX/share/fzf/shell/key-bindings.zsh" ]] && source "$MACPORTS_PREFIX/share/fzf/shell/key-bindings.zsh"

  export FZF_BASE="$MACPORTS_PREFIX/bin/fzf"
  fpath=(
    "$MACPORTS_PREFIX/share/zsh/site-functions"
    "${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
    $fpath
  )
elif [[ "$PACKAGE_MANAGER" == "homebrew" ]]; then
  eval "$("$HOMEBREW_PREFIX/bin/brew" shellenv)"

  # FZF setup
  export FZF_BASE="$(brew --prefix)/bin/fzf"

  # Completion paths
  fpath=(
    "$(brew --prefix)/share/zsh/site-functions"
    "${ASDF_DIR}/completions"
    $fpath
  )
fi

# ----------------------------------------------------------------------------
# ASDF Shims - Must be AFTER Homebrew to ensure highest priority
# ----------------------------------------------------------------------------
# Prepend asdf shims to PATH to override all other executables (including Homebrew)
path=("$ASDF_DATA_DIR/shims" $path)
typeset -U path  # Remove any duplicates

# ----------------------------------------------------------------------------
# History Configuration
# ----------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# History options
setopt HIST_SAVE_NO_DUPS      # Don't write duplicate entries
setopt INC_APPEND_HISTORY     # Write to history immediately
setopt SHARE_HISTORY          # Share history between sessions
setopt HIST_IGNORE_SPACE      # Ignore commands starting with space
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks

# ----------------------------------------------------------------------------
# Antidote Plugin Manager
# ----------------------------------------------------------------------------
# oh-my-zsh's git.zsh and kubectx.plugin.zsh both do `local _style` at the
# top level of the sourced file. Antidote's static bundle sources every
# plugin in the same top-level scope, so kubectx's re-declaration of an
# already-local `_style` triggers zsh's "typeset with existing local prints
# it" behavior, spamming "_style=no" on every new shell. Called via
# post:_omz_unset_style_leak (see zsh_plugins.txt) right after git/gitfast
# load, before kubectx gets a chance to collide with it.
_omz_unset_style_leak() { unset _style }

source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# Set ZSH variable for oh-my-zsh plugins
export ZSH="$(antidote path ohmyzsh/ohmyzsh)"

# Load plugins (generates static file if needed)
antidote load

# ----------------------------------------------------------------------------
# Completion System
# ----------------------------------------------------------------------------
# Add Docker completions to fpath
fpath=("$HOME/.docker/completions" $fpath)

# Initialize completion system
autoload -Uz compinit

# Speed up compinit by only checking once a day
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# ----------------------------------------------------------------------------
# Key Bindings
# ----------------------------------------------------------------------------
# History substring search
bindkey "^[[A" history-substring-search-up      # Up arrow
bindkey "^[[B" history-substring-search-down    # Down arrow

# Autosuggestions
bindkey "^[[Z" autosuggest-accept               # Shift+Tab

# ----------------------------------------------------------------------------
# FZF Configuration
# ----------------------------------------------------------------------------
export FZF_COMPLETION_TRIGGER="@@"
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix auto --exclude .git"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--style full --layout=reverse"

# FZF preview configurations
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
export FZF_CTRL_T_OPTS="--preview 'if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi'"

# Custom FZF functions
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    z)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

# ----------------------------------------------------------------------------
# Theme (Dracula dark / Solarized Osaka light, follows macOS appearance)
# ----------------------------------------------------------------------------
source ~/dotfiles/theme.zsh

# ----------------------------------------------------------------------------
# External Tool Integrations
# ----------------------------------------------------------------------------
# Zoxide (smart cd)
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# Starship prompt (fast Rust-based)
# (( $+commands[starship] )) && eval "$(starship init zsh)"

# Oh My Posh
(( $+commands[oh-my-posh])) && eval "$(oh-my-posh init zsh --config "$OMP_CONFIG")"
# (( $+commands[oh-my-posh])) && eval "$(oh-my-posh init zsh --config tokyo)"

# Atuin (shell history sync)
if [[ -f "$HOME/.atuin/bin/env" ]]; then
  . "$HOME/.atuin/bin/env"
  eval "$(atuin init zsh --disable-up-arrow)"
elif (( $+commands[atuin] )); then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

# Stern (Kubernetes log viewer)
(( $+commands[stern] )) && source <(stern --completion=zsh)

# Kubectl completion (only if installed)
if (( $+commands[kubectl] )); then
  source <(kubectl completion zsh)
  complete -o default -F __start_kubectl k
fi

# SSH agent
eval "$(ssh-agent -s)" &>/dev/null

# ----------------------------------------------------------------------------
# Aliases & Custom Functions
# ----------------------------------------------------------------------------
[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=($HOME/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# opencode
export PATH=/Users/jacopo/.opencode/bin:$PATH
