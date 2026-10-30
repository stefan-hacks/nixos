# LazyVim home-manager module via lazyvim-nix.
# Provides a bleeding-edge LazyVim setup with catppuccin-mocha theme
# and language support for all requested languages.
{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.lazyvim-nix.homeManagerModules.default
  ];

  programs.lazyvim = {
    enable = true;

    # ── Language extras (LSP + treesitter + completions) ──
    # Available extras from lazyvim-nix data/extras.json:
    # https://github.com/pfassina/lazyvim-nix/blob/main/data/extras.json
    extras = {
      lang = {
        # ── User-requested languages ──
        rust.enable = true; # rust-analyzer + rustfmt + treesitter
        python.enable = true; # pyright/ruff + treesitter
        nix.enable = true; # nil_ls / nixd + nixfmt + treesitter
        yaml.enable = true; # yamlls + schemastore + treesitter
        toml.enable = true; # taplo + treesitter
        ansible.enable = true; # ansiblels + ansible-lint + nvim-ansible
        clangd.enable = true; # clangd (C/C++) + treesitter
        go.enable = true; # gopls + gofumpt + treesitter
        markdown.enable = true; # marksman + markdown preview + treesitter
        json.enable = true; # jsonls + schemastore + treesitter
        sql.enable = true; # sqlls / sqlfluff + treesitter
        git.enable = true; # gitcommit/gitconfig filetype support
      };

      # ── Editor / coding enhancements ──
      coding.blink.enable = true; # blink-cmp (fast completion)
      editor.telescope.enable = true; # fuzzy finder
      ui.treesitter-context.enable = true; # show current function/class context
    };

    # ── Treesitter parsers for languages without dedicated extras ──
    # Bash and scheme don't have dedicated lang extras in lazyvim-nix,
    # but their parsers are available via nvim-treesitter grammar plugins.
    treesitterParsers = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      bash # shell scripting (no lang.bash extra exists)
      scheme # racket/mit/guile
      ini # ini/conf/cfg files
    ];

    # ── Additional tools not auto-installed by extras ──
    extraPackages = with pkgs; [
      # Bash tooling (no dedicated lang.bash extra)
      bash-language-server
      shellcheck
      shfmt

      # Fix: luarocks/hererocks bootstrap failure — provide system luarocks
      # so lazy.nvim skips hererocks self-install and uses the system one.
      luarocks
      lua5_1

      # Fix: tree-sitter-cli required by nvim-treesitter for parser compilation
      tree-sitter

      # Fix: vellum.nvim needs a browser for markdown preview rendering
      chromium

      # Fix: snacks.nvim inline image rendering (PDF, LaTeX math, Mermaid diagrams)
      ghostscript
      tectonic
      mermaid-cli

      # Generic tools
      ripgrep
      fd
    ];

    # ── Custom plugin configs ──
    plugins = {
      colorscheme = ''
        return { "catppuccin/nvim", opts = { flavour = "mocha" }, }
      '';

      # Git gutter signs + inline blame (gitsigns is bundled with LazyVim core,
      # but we override opts here to enable line blame)
      gitsigns = ''
        return {
          "lewis6991/gitsigns.nvim",
          opts = {
            signs = {
              add = { text = "│" },
              change = { text = "│" },
              delete = { text = "_" },
              topdelete = { text = "‾" },
              changedelete = { text = "~" },
              untracked = { text = "┆" },
            },
            current_line_blame = true,
            current_line_blame_opts = {
              delay = 200,
              virt_text_pos = "eol",
            },
          },
        }
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
