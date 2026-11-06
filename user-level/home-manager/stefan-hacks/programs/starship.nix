{
  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      # Use Catppuccin-Mocha palette
      palette = "catppuccin-mocha";

      palettes.catppuccin-mocha = {
        bg = "#1E1E2E";
        fg = "#CDD6F4";
        blue = "#89B4FA";
        green = "#A6E3A1";
        red = "#F38BA8";
        yellow = "#F9E2AF";
        purple = "#CBA6F7";
        cyan = "#94E2D5";
        white = "#BAC2DE";
        black = "#45475A";
      };

      # Use blue (Catppuccin accent) for directory
      directory = {
        truncation_length = 3;
        truncation_symbol = "…/";
        read_only = "🔒";
        style = "bold blue";
      };

      # Character prompt uses green for success, red for error
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✕](bold red)";
      };

      # Git uses Catppuccin colors
      git_branch = {
        style = "bold purple";
      };
      git_status = {
        style = "bold yellow";
      };

      # Nix shell indicator
      nix_shell = {
        style = "bold blue";
        symbol = "❄️ ";
      };

      # Package disabled to reduce noise
      package.disabled = true;
    };
  };
}
