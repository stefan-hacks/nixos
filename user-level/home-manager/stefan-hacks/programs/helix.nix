# helix.nix — Home Manager helix configuration
_: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        line-number = "relative";
        mouse = true;
        cursorline = true;
        indent-guides = {
          render = true;
        };
        lsp = {
          display-messages = true;
        };
      };
    };
  };
}
