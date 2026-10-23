# git.nix — Home Manager git configuration
{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    settings = {
      user.name = "stefan-hacks";
      user.email = "stefanmrobertson@gmail.com";
      credential."https://github.com".helper = "!gh auth git-credential";
      credential."https://gist.github.com".helper = "!gh auth git-credential";
    };
  };
}
