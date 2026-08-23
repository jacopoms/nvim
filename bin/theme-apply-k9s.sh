#!/usr/bin/env bash
# Applies the resolved theme mode to k9s's active skin.
# k9s only reads ui.skin at startup, so this takes effect on the next
# `k9s` launch, not in an already-running session.
mode="$("$HOME/bin/theme-mode" 2>/dev/null || echo dark)"
config="$HOME/.k9s/config.yaml"

[ -f "$config" ] || exit 0
command -v yq >/dev/null 2>&1 || exit 0

if [ "$mode" = "light" ]; then
  yq e -i '.k9s.ui.skin = "onelight"' "$config"
else
  yq e -i '.k9s.ui.skin = "dracula"' "$config"
fi
