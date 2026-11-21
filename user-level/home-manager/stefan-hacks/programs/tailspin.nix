# tailspin.nix — Log file highlighter with Catppuccin-Mocha theme.
{
  config,
  pkgs,
  ...
}: {
  # Tailspin package is installed system-wide via color-output.nix.
  # This module deploys the theme file and environment config.

  home = {
    packages = [pkgs.tailspin];

    file.".config/tailspin/theme.toml".text = ''
      # Catppuccin Mocha theme for tailspin (ANSI named colours only)
      # See: https://github.com/bensadeh/tailspin#customizing-highlight-groups

      [numbers]
      style = { fg = "cyan" }

      [uuids]
      number = { fg = "blue", italic = true }
      letter = { fg = "magenta", italic = true }
      separator = { fg = "red" }

      [quotes]
      quote_token = '"'
      style = { fg = "yellow" }

      [ipv4]
      number = { fg = "blue", italic = true }
      separator = { fg = "red" }

      [ipv6]
      number = { fg = "blue", italic = true }
      letter = { fg = "magenta", italic = true }
      separator = { fg = "red" }

      [dates]
      date = { fg = "magenta" }
      time = { fg = "blue" }
      zone = { fg = "red" }
      separator = { faint = true }

      [durations]
      value = { fg = "blue" }
      separator = { fg = "magenta" }
      unit = { fg = "magenta", italic = true }

      [paths]
      segment = { fg = "green" }
      separator = { fg = "yellow" }

      [urls]
      http = { fg = "red", faint = true }
      https = { fg = "green", faint = true }
      host = { fg = "blue", faint = true }
      path = { fg = "blue" }
      query_params_key = { fg = "magenta" }
      query_params_value = { fg = "cyan" }
      symbols = { fg = "red" }

      [emails]
      local_part = { fg = "green", underline = true }
      at_sign = { fg = "red" }
      domain = { fg = "green", underline = true }
      dot = { fg = "red" }

      [pointers]
      number = { fg = "blue", italic = true }
      letter = { fg = "magenta", italic = true }
      x = { fg = "red" }

      [processes]
      name = { fg = "yellow" }
      id = { fg = "cyan" }
      bracket = { fg = "red" }

      [key_value_pairs]
      key = { fg = "white", faint = true }
      separator = { fg = "bright_black" }

      [json]
      key = { fg = "white", faint = true }
      quote_token = { faint = true }
      curly_bracket = { fg = "yellow" }
      square_bracket = { fg = "yellow" }
      comma = { faint = true }
      colon = { faint = true }

      [jvm_stack_traces]
      caused_by = { bold = true }
      package = { fg = "red", faint = true }
      exception = { fg = "red" }
      frame = { fg = "red", faint = true }
      file = { fg = "yellow" }
      unknown_source = { fg = "yellow", faint = true }
      line_number = { fg = "cyan" }

      # Custom keyword groups — log severities and Nix-specific terms
      [[keywords]]
      words = ["ERROR", "FATAL", "CRITICAL", "PANIC"]
      style = { fg = "red", bold = true }

      [[keywords]]
      words = ["WARN", "WARNING", "DEPRECATED", "OBSOLETE"]
      style = { fg = "yellow", bold = true }

      [[keywords]]
      words = ["INFO", "NOTICE", "SUCCESS", "OK", "PASS", "DONE"]
      style = { fg = "green", bold = true }

      [[keywords]]
      words = ["DEBUG", "TRACE", "VERBOSE"]
      style = { fg = "cyan", italic = true }

      [[keywords]]
      words = ["null", "true", "false", "undefined", "None", "nil"]
      style = { fg = "magenta", italic = true }

      [[keywords]]
      words = ["nix", "nixpkgs", "flake", "derivation", "build", "switch"]
      style = { fg = "bright_magenta", italic = true }
    '';

    sessionVariables = {
      TAILSPIN_THEME = "${config.home.homeDirectory}/.config/tailspin/theme.toml";
    };
  };
}
