-- lazy-lsp.nvim plugin configuration
-- Automatically installs nvim-lspconfig language servers via nix-shell.
-- Requires Neovim 0.7+ and the Nix package manager (available on NixOS).

return {
  {
    "dundalek/lazy-lsp.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("lazy-lsp").setup {
        -- By default all available servers are set up.
        -- Exclude unwanted or misbehaving servers here.
        excluded_servers = {
          -- "ccls",
          -- "zk",
        },

        -- Default config passed to all servers.
        default_config = {
          flags = {
            debounce_text_changes = 150,
          },
        },

        -- Override config for specific servers.
        configs = {
          lua_ls = {
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
              },
            },
          },
        },

        -- Prefer locally installed servers over nix-shell (default: true)
        -- On NixOS most servers won't be locally installed, so nix-shell
        -- will handle them transparently.
        prefer_local = true,
      }
    end,
  },
}
