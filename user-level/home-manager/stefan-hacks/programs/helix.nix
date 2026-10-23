# helix.nix — Home Manager helix configuration
{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "nord";
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
