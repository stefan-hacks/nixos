# NixOS flake location
export NIXCFG="${NIXCFG:-$HOME/.config/nixos}"

# Let aliases expand after sudo / watch
alias sudo='sudo '
alias watch='watch '

# Source NixOS environment variables (FZF_DEFAULT_OPTS, etc.)
[ -f /etc/set-environment ] && source /etc/set-environment

# Enable vi mode for bash
set -o vi

# colorize output via grc
export GRC_ALIASES=true

# preferred editor
export EDITOR="vim"

# batman integration
if command -v batman > /dev/null 2>&1; then
  eval "$(batman --export-env)"
fi

# carapace
if command -v carapace > /dev/null 2>&1; then
  export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
  source <(carapace _carapace)
fi

# Atuin
if command -v atuin > /dev/null 2>&1; then
  eval "$(atuin init bash)"
fi

# zoxide
if command -v zoxide > /dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi

# starship prompt
if command -v starship > /dev/null 2>&1; then
  eval "$(starship init bash)"
fi

# Welcome message
if command -v lolcat > /dev/null 2>&1; then
  echo "w3lc0m3 h4ck3r - let the games begin! - m4ast3r y0ur cr4ft" | lolcat
fi

# Attach ble.sh if loaded
if [[ ${BLE_VERSION-} ]]; then
  ble-attach
fi

# Source functions from _bash_aliases
[ -f ~/.bash_functions ] && source ~/.bash_functions
