# Home Manager entry point for stefan-hacks
{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.ble-sh.homeModules.default
    ./programs/bash.nix
    ./programs/git.nix
    ./programs/kitty.nix
    ./programs/starship.nix
    ./programs/atuin.nix
    ./programs/helix.nix
    ./programs/zellij.nix
    ./programs/fastfetch.nix
    ./programs/lazyvim.nix
    ./gnome
  ];

  home.username = "stefan-hacks";
  home.homeDirectory = "/home/stefan-hacks";

  # ── ble.sh (Bash Line Editor) fork ──
  programs.ble-sh = {
    enable = true;
    enableBashIntegration = true;
    rcInit = ''
      bleopt history_share=1
      bleopt prompt_ps1_final='\[$(tput setaf 6)\]\w \[$(tput sgr0)\]\$ '
      bleopt complete_auto_complete=1
      bleopt complete_menu_complete=1
      bleopt complete_ambiguous=1
    '';
  };

  # Ensure ~/.local/bin is on PATH
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # ── Nixdatifier ──
  programs.nixdatifier = {
    enable = true;
    ui = true;
    autostart = true;
    tui = {
      commands = [
        {
          label = "rebuild";
          cmd = "cd ~/.config/nixos && sudo nixos-rebuild switch --flake .#titan";
        }
        {
          label = "check";
          cmd = "cd ~/.config/nixos && nix flake check";
        }
        {
          label = "update";
          cmd = "cd ~/.config/nixos && nix flake update";
        }
        {
          label = "gc";
          cmd = "sudo nix-collect-garbage --delete-older-than 30d";
        }
      ];
      updateCheck = {
        enable = true;
        interval = "6h";
      };
      theme = "deep";
      layout = "roomy";
    };
    githubUseGh = true;
  };

  home.stateVersion = "26.05";
}
