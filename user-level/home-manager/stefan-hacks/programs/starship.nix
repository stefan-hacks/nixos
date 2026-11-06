{
  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      # Use Adwaita dark palette
      palette = "adwaita-dark";

      palettes.adwaita-dark = {
        bg = "#1E1E1E";
        fg = "#FFFFFF";
        blue = "#3584E4";
        green = "#33D17A";
        red = "#E01B24";
        yellow = "#F6D32D";
        purple = "#C061CB";
        cyan = "#5E5C64";
        white = "#F6F5F4";
        black = "#3D3846";
      };

      # Use blue (Adwaita accent) for directory
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

      # Git uses Adwaita colors
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
