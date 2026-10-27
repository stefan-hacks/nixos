# LazyVim home-manager module via lazyvim-nix.
# Provides a bleeding-edge LazyVim setup with catppuccin-mocha theme.
{inputs, ...}: {
  imports = [
    inputs.lazyvim-nix.homeManagerModules.default
  ];

  programs.lazyvim = {
    enable = true;

    plugins = {
      colorscheme = ''
        return { "catppuccin/nvim", opts = { flavour = "mocha" }, }
      '';

      vellum = ''
        return {
          "blackhat-7/vellum.nvim",
          config = function()
            require("vellum").setup({ max_width = 100 })
          end,
        }
      '';

      kitty_scrollback = ''
        return {
          "mikesmithgh/kitty-scrollback.nvim",
          config = function()
            require("kitty-scrollback").setup()
          end,
        }
      '';
    };
  };
}
