# Nixdatifier TUI for NixOS rebuild / update / gc tasks
{ ... }: {
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
}
