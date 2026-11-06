# Home Manager entry point for stefan-hacks
{
  config,
  ...
}: {
  imports = [
    ./programs/bash.nix
    ./programs/git.nix
    ./programs/kitty.nix
    ./programs/atuin.nix
    ./programs/carapace.nix
    ./programs/starship.nix
    ./programs/helix.nix
    ./programs/zellij.nix
    ./programs/fastfetch.nix
    ./gnome
  ];

  # User environment
  home = {
    username = "stefan-hacks";
    homeDirectory = "/home/stefan-hacks";
    stateVersion = "26.05";

    # Ensure ~/.local/bin is on PATH.
    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];
  };

  # Let Home Manager manage its own configuration.
  # btop configuration with GNOME Adwaita dark theme
  xdg.configFile."btop/btop.conf".text = ''
    # btop configuration — managed by Nix
    color_theme = "adwaita-dark"
    theme_background = True
    truecolor = True
    force_tty = False
    vim_keys = True
    rounded_corners = True
    graph_symbol = "braille"
    graph_symbol_cpu = "default"
    graph_symbol_mem = "default"
    graph_symbol_net = "default"
    graph_symbol_proc = "default"
    shown_boxes = "cpu mem net proc"
    update_ms = 1000
    proc_sorting = "cpu lazy"
    proc_reversed = False
    proc_tree = False
    proc_colors = True
    proc_gradient = True
    proc_per_core = False
    cpu_graph_upper = "total"
    cpu_graph_lower = "total"
    cpu_invert_lower = True
    cpu_single_graph = False
    cpu_bottom = False
    show_uptime = True
    check_temp = True
    cpu_sensor = "Auto"
    show_coretemp = True
    coretemp_pack = False
    show_cpu_freq = True
    show_graphs = True
    mem_graphs = True
    mem_below_net = False
    show_swap = True
    swap_disk = True
    show_disks = True
    only_physical = True
    use_fstab = False
    disk_free_priv = False
    show_battery = True
    show_powersave = True
    selected_battery = "Auto"
    show_iface = True
    alternate_ouput = True
    proc_editor = "nvim"
  '';

  # btop Adwaita dark theme
  xdg.configFile."btop/themes/adwaita-dark.theme".text = ''
    #Bashtop theme with GNOME Adwaita dark palette
    # Main background, empty for terminal default, need to be empty if you want transparent background
    theme[main_bg]="#1E1E1E"
    # Main text color
    theme[main_fg]="#FFFFFF"
    # Title color for boxes
    theme[title]="#3584E4"
    # Highlight color for keyboard shortcuts
    theme[hi_fg]="#3584E4"
    # Background color of selected item in processes box
    theme[selected_bg]="#303030"
    # Foreground color of selected item in processes box
    theme[selected_fg]="#FFFFFF"
    # Color of inactive/disabled text
    theme[inactive_fg]="#9A9996"
    # Color of text appearing on top of graphs, i.e uptime and current network graph scaling
    theme[graph_text]="#FFFFFF"
    # Background color of the percentage meters
    theme[meter_bg]="#3D3846"
    # Misc colors for processes box including mini cpu graphs, details memory graph and details status text
    theme[proc_misc]="#3584E4"
    # Cpu box outline color
    theme[cpu_box]="#3584E4"
    # Memory box outline color
    theme[mem_box]="#33D17A"
    # Net box outline color
    theme[net_box]="#C061CB"
    # Proc box outline color
    theme[proc_box]="#F6D32D"
    # Box divider line and small arrows color
    theme[div_line]="#3D3846"
    # Temperature graph colors
    theme[temp_start]="#33D17A"
    theme[temp_mid]="#F6D32D"
    theme[temp_end]="#E01B24"
    # CPU graph colors
    theme[cpu_start]="#3584E4"
    theme[cpu_mid]="#C061CB"
    theme[cpu_end]="#E01B24"
    # Mem/Memory graph colors
    theme[mem_start]="#33D17A"
    theme[mem_mid]="#F6D32D"
    theme[mem_end]="#E01B24"
    # Net graph colors
    theme[net_start]="#33D17A"
    theme[net_mid]="#F6D32D"
    theme[net_end]="#E01B24"
    # Proc box color gradient for processes
    theme[proc_start]="#3584E4"
    theme[proc_mid]="#C061CB"
    theme[proc_end]="#E01B24"
  '';

  # bat configuration with Adwaita dark theme
  programs.bat = {
    enable = true;
    config = {
      theme = "ansi-dark";
      style = "numbers,changes,header";
    };
  };

  programs.home-manager.enable = true;

  # Nixdatifier
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
