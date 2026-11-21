# color-output.nix — Context-aware terminal colorization for all users.
# Uses grc, bat, delta, ccze, glow, fx, and source-highlight for semantic,
# language-aware colorization (not generic rainbow prettifiers).
{ pkgs, ... }: {
  environment = {
    # Core context-aware colorization tools
    systemPackages = with pkgs; [
      # Syntax-aware diff pager (replaces diff, git diff)
      delta

      # Log colorizer (syslog, apache, nginx, etc.)
      ccze

      # Terminal markdown renderer
      glow

      # Syntax-highlighting for code snippets
      sourceHighlight

      # Colorized diff alternative
      colordiff

      # Interactive JSON viewer with color
      fx

      # Hex viewer with color coding
      hexyl
    ];

    # Environment variables — force color in standard tools
    sessionVariables = {
      # Nix command output colorization
      NIX_BUILD_SHELL_COLOR = "1";

      # GCC/clang color output
      GCC_COLORS = "error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01";

      # systemd status colors (built-in, but ensure enabled)
      SYSTEMD_COLORS = "1";

      # Colored grep output (handled by ripgrep / batgrep, but ensure legacy tools work)
      GREP_COLORS = "mt=1;35:fn=1;34:ln=1;33:se=1;36";

      # Make color output
      MAKE_TERMOUT = "1";

      # Cargo/rustc color output
      CARGO_TERM_COLOR = "always";

      # npm color output
      NPM_CONFIG_COLOR = "always";

      # Less with color support (batpipe already handles this, but reinforce)
      LESS = "--RAW-CONTROL-CHARS --mouse";
    };

    # System-wide profile script — aliases and colorization helpers
    etc."profile.d/color-output.sh".text = ''
      # Context-aware terminal colorization — sourced for all users

      # Only apply in interactive terminals with color support
      if [ -n "''${TERM:-}" ] && [ "$TERM" != "dumb" ] && [ -t 1 ]; then
        # ---------------------------------------------------------------
        # delta — syntax-aware diff pager
        # ---------------------------------------------------------------
        if command -v delta >/dev/null 2>&1; then
          export DELTA_FEATURES="side-by-side line-numbers decorations"
          export DELTA_NAVigate="true"
          alias diff='delta'
          alias diffc='delta --color-only'
        fi

        # ---------------------------------------------------------------
        # ccze — log colorizer
        # ---------------------------------------------------------------
        if command -v ccze >/dev/null 2>&1; then
          alias logs='ccze -A'
          alias syslog='ccze -A < /var/log/syslog 2>/dev/null || journalctl --no-pager | ccze -A'
          alias dmesg='dmesg | ccze -A'
        fi

        # ---------------------------------------------------------------
        # glow — markdown renderer
        # ---------------------------------------------------------------
        if command -v glow >/dev/null 2>&1; then
          alias md='glow'
          alias readme='glow README.md 2>/dev/null || glow'
        fi

        # ---------------------------------------------------------------
        # source-highlight — syntax-highlighting cat replacement
        # ---------------------------------------------------------------
        if command -v source-highlight >/dev/null 2>&1; then
          alias ccat='source-highlight --faster --out-format=esc --infer-lang -i'
          alias catcode='source-highlight --faster --out-format=esc --infer-lang -i'
        fi

        # ---------------------------------------------------------------
        # fx — interactive JSON viewer
        # ---------------------------------------------------------------
        if command -v fx >/dev/null 2>&1; then
          alias json='fx'
        fi

        # ---------------------------------------------------------------
        # hexyl — colorized hex viewer
        # ---------------------------------------------------------------
        if command -v hexyl >/dev/null 2>&1; then
          alias hex='hexyl'
          alias xxd='hexyl'
        fi

        # ---------------------------------------------------------------
        # colordiff — colorized diff output
        # ---------------------------------------------------------------
        if command -v colordiff >/dev/null 2>&1; then
          alias cdiff='colordiff'
        fi

        # ---------------------------------------------------------------
        # Standard tool colorization via environment
        # ---------------------------------------------------------------
        # ls: handled by eza (already in HM config)
        # grep: handled by batgrep (already in HM config)
        # man: handled by batman (already in HM config)
        # less: handled by batpipe (already in HM config)

        # Force color in common CLI tools that support it
        alias ip='ip --color=auto'
        alias lsusb='lsusb -v 2>/dev/null | ccze -A 2>/dev/null || lsusb'
        alias lspci='lspci -v 2>/dev/null | ccze -A 2>/dev/null || lspci'

        # Kubernetes colorization (kubectl supports color via KUBECTL_EXTERNAL_DIFF)
        if command -v kubectl >/dev/null 2>&1; then
          export KUBECTL_EXTERNAL_DIFF="colordiff"
        fi
      fi
    '';
  };
}
