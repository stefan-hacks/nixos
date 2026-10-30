# atuin.nix — Home Manager atuin shell history
# NOTE: enableBashIntegration is disabled here because bash.nix handles atuin
# initialization manually.
_: {
  programs.atuin = {
    enable = true;
    enableBashIntegration = false;

    settings = {
      auto_sync = true;
      sync_address = "https://api.atuin.sh";
      sync_frequency = "10m";
      search_mode = "fuzzy";
      filter_mode = "global";
      style = "compact";
      show_preview = true;
      preview_height = 10;
      max_preview_height = 10;
      show_help = true;
      exit_mode = "return-original";
      enter_accept = true;
      keybinding = "c-r";
      update_check = false;
    };
  };
}
