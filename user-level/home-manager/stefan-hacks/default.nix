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
  # btop configuration with Nord theme
  xdg.configFile."btop/btop.conf".text = ''
    # btop configuration — managed by Nix
    color_theme = "nord"
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

  # bat configuration with Nord theme
  programs.bat = {
    enable = true;
    config = {
      theme = "Nord";
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
