# ----------------------------------------------------------------------------
# Theme switching: Dracula (dark) / One Dark Pro "onelight" (light)
#
# Contract: $THEME = "light" | "dark" | unset/"auto" (follows macOS appearance).
# `bin/theme-mode` is the single source of truth for resolving that into
# THEME_MODE; tmux.conf shells out to it too, so keep logic there in sync.
# ----------------------------------------------------------------------------

export THEME_MODE="$("$HOME/bin/theme-mode" 2>/dev/null || echo dark)"

if [[ "$THEME_MODE" == "light" ]]; then
  export BAT_THEME="OneHalfLight"
else
  export BAT_THEME="Dracula"
fi

# Only force wezterm's scheme when the user explicitly overrode $THEME;
# leave it unset in "auto" mode so wezterm's own appearance watcher decides.
if [[ "$THEME" == "light" ]]; then
  export WEZTERM_COLOR_SCHEME="onedarkpro_onelight"
elif [[ "$THEME" == "dark" ]]; then
  export WEZTERM_COLOR_SCHEME="Dracula"
else
  unset WEZTERM_COLOR_SCHEME
fi

if [[ "$THEME_MODE" == "light" ]]; then
  export OMP_CONFIG="$HOME/dotfiles/myjan-onelight.omp.json"
else
  export OMP_CONFIG="$HOME/dotfiles/myjan.omp.json"
fi

# k9s only reads its skin at startup, so keep ~/.k9s/config.yaml's ui.skin
# in sync with every new shell — the next `k9s` launch will pick it up.
"$HOME/bin/theme-apply-k9s.sh" 2>/dev/null

# `theme light|dark|auto` — switch now (this shell + live tmux status bar) and
# persist the choice to ~/.env so new shells/panes/windows pick it up too.
theme() {
  case "$1" in
    light|dark|auto) ;;
    *)
      echo "Usage: theme light|dark|auto" >&2
      return 1
      ;;
  esac

  if [[ "$1" == "auto" ]]; then
    unset THEME
    [[ -f "$HOME/.env" ]] && sed -i '' '/^export THEME=/d' "$HOME/.env"
  else
    export THEME="$1"
    if [[ -f "$HOME/.env" ]] && grep -q '^export THEME=' "$HOME/.env"; then
      sed -i '' "s/^export THEME=.*/export THEME=$1/" "$HOME/.env"
    else
      echo "export THEME=$1" >>"$HOME/.env"
    fi
  fi

  export THEME_MODE="$("$HOME/bin/theme-mode")"
  if [[ "$THEME_MODE" == "light" ]]; then
    export BAT_THEME="OneHalfLight"
  else
    export BAT_THEME="Dracula"
  fi

  [[ -n "$TMUX" ]] && "$HOME/bin/theme-apply-tmux.sh"
  "$HOME/bin/theme-apply-k9s.sh" 2>/dev/null

  echo "Theme set to $THEME_MODE (mode: ${1}). Ghostty follows macOS appearance directly (no manual override); open a new nvim/wezterm/k9s window to pick up the change there."
}
