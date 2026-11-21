# tailspin.nix — Log file highlighter with Catppuccin-Mocha theme.
{ config, pkgs, ... }: {
  # Tailspin package is installed system-wide via color-output.nix.
  # This module deploys the theme file and environment config.

  home.packages = [ pkgs.tailspin ];

  # Catppuccin-Mocha color palette for tailspin
  home.file.".config/tailspin/theme.toml".text = ''
    # Catppuccin Mocha theme for tailspin
    # See: https://github.com/bensadeh/tailspin#customizing-highlight-groups

    [numbers]
    style = { fg = "#89dceb" }

    [uuids]
    number = { fg = "#89b4fa", italic = true }
    letter = { fg = "#f5c2e7", italic = true }
    separator = { fg = "#f38ba8" }

    [quotes]
    quote_token = '"'
    style = { fg = "#f9e2af" }

    [ipv4]
    number = { fg = "#89b4fa", italic = true }
    separator = { fg = "#f38ba8" }

    [ipv6]
    number = { fg = "#89b4fa", italic = true }
    letter = { fg = "#f5c2e7", italic = true }
    separator = { fg = "#f38ba8" }

    [dates]
    date = { fg = "#f5c2e7" }
    time = { fg = "#89b4fa" }
    zone = { fg = "#f38ba8" }
    separator = { faint = true }

    [durations]
    value = { fg = "#89b4fa" }
    separator = { fg = "#f5c2e7" }
    unit = { fg = "#f5c2e7", italic = true }

    [paths]
    segment = { fg = "#a6e3a1" }
    separator = { fg = "#f9e2af" }

    [urls]
    http = { fg = "#f38ba8", faint = true }
    https = { fg = "#a6e3a1", faint = true }
    host = { fg = "#89b4fa", faint = true }
    path = { fg = "#89b4fa" }
    query_params_key = { fg = "#f5c2e7" }
    query_params_value = { fg = "#89dceb" }
    symbols = { fg = "#f38ba8" }

    [emails]
    local_part = { fg = "#a6e3a1", underline = true }
    at_sign = { fg = "#f38ba8" }
    domain = { fg = "#a6e3a1", underline = true }
    dot = { fg = "#f38ba8" }

    [pointers]
    number = { fg = "#89b4fa", italic = true }
    letter = { fg = "#f5c2e7", italic = true }
    x = { fg = "#f38ba8" }

    [processes]
    name = { fg = "#f9e2af" }
    id = { fg = "#89dceb" }
    bracket = { fg = "#f38ba8" }

    [key_value_pairs]
    key = { fg = "#cdd6f4", faint = true }
    separator = { fg = "#bac2de" }

    [json]
    key = { fg = "#cdd6f4", faint = true }
    quote_token = { faint = true }
    curly_bracket = { fg = "#f9e2af" }
    square_bracket = { fg = "#f9e2af" }
    comma = { faint = true }
    colon = { faint = true }

    [jvm_stack_traces]
    caused_by = { bold = true }
    package = { fg = "#f38ba8", faint = true }
    exception = { fg = "#f38ba8" }
    frame = { fg = "#f38ba8", faint = true }
    file = { fg = "#f9e2af" }
    unknown_source = { fg = "#f9e2af", faint = true }
    line_number = { fg = "#89dceb" }

    # Custom keyword groups — log severities and Nix-specific terms
    [[keywords]]
    words = ["ERROR", "FATAL", "CRITICAL", "PANIC"]
    style = { fg = "#f38ba8", bold = true }

    [[keywords]]
    words = ["WARN", "WARNING", "DEPRECATED", "OBSOLETE"]
    style = { fg = "#f9e2af", bold = true }

    [[keywords]]
    words = ["INFO", "NOTICE", "SUCCESS", "OK", "PASS", "DONE"]
    style = { fg = "#a6e3a1", bold = true }

    [[keywords]]
    words = ["DEBUG", "TRACE", "VERBOSE"]
    style = { fg = "#89dceb", italic = true }

    [[keywords]]
    words = ["null", "true", "false", "undefined", "None", "nil"]
    style = { fg = "#f5c2e7", italic = true }

    [[keywords]]
    words = ["nix", "nixpkgs", "flake", "derivation", "build", "switch"]
    style = { fg = "#cba6f7", italic = true }
  '';

  # Point tailspin to our custom theme
  home.sessionVariables = {
    TAILSPIN_THEME = "${config.home.homeDirectory}/.config/tailspin/theme.toml";
  };
}
