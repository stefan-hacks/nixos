# Git + GitHub CLI + delta pager + lazygit.
# Replaces the hand-written ~/.gitconfig (which pinned a nix store path for the
# gh credential helper — GC could have broken `git push` at any moment).
{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    # release-26.05 schema: userName/userEmail/aliases/extraConfig were
    # renamed into settings.* (old names still work but warn).
    settings.user = {
      name = "stefan-hacks";
      email = "stefanmrobertson@gmail.com";
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings = {
      version = 1;
      git_protocol = "https";
      prompt = "enabled";
      clipboard = "enabled";
      aliases.co = "pr checkout";
    };
    # ~/.config/gh/hosts.yml (auth tokens) is managed by `gh auth login`, not HM.
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true; # explicit; auto-enablement is deprecated in release-26.05
  };

  programs.lazygit = {
    enable = true;
    settings = { };
  };
}
