-- NixOS compatibility layer for LazyVim.
-- Disables Mason (all language tools are installed via NixOS).
-- Registers system-installed LSP servers and configures Tree-sitter.

return {
  -- ─────────────────────────────────────────────────────────────────────────
  -- 1. Disable Mason completely
  -- ─────────────────────────────────────────────────────────────────────────
  {
    "williamboman/mason.nvim",
    enabled = false,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    enabled = false,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    enabled = false,
  },

  -- ─────────────────────────────────────────────────────────────────────────
  -- 2. Configure nvim-lspconfig to use system-installed LSPs
  -- ─────────────────────────────────────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Bash
        bashls = {},
        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
            },
          },
        },
        -- Rust
        rust_analyzer = {},
        -- Nix
        nixd = {},
        -- TOML
        taplo = {},
        -- C / C++
        clangd = {},
        -- Go
        gopls = {},
        -- HTML / CSS / JSON
        html = {},
        cssls = {},
        jsonls = {},
        -- Markdown
        marksman = {},
        -- Python
        basedpyright = {},
        -- YAML
        yamlls = {},
        -- Ansible
        ansiblels = {},
      },
    },
  },

  -- ─────────────────────────────────────────────────────────────────────────
  -- 3. Configure Tree-sitter to use system compiler
  -- ─────────────────────────────────────────────────────────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Use NixOS-provided gcc for parser compilation
      require("nvim-treesitter.install").compilers = { "gcc" }

      -- Ensure parsers are available for these languages
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "bash",
          "lua",
          "rust",
          "nix",
          "toml",
          "c",
          "cpp",
          "go",
          "html",
          "css",
          "json",
          "markdown",
          "markdown_inline",
          "yaml",
          "python",
          "javascript",
          "typescript",
        })
      end
    end,
  },

  -- ─────────────────────────────────────────────────────────────────────────
  -- 4. Configure formatters to use system binaries
  -- ─────────────────────────────────────────────────────────────────────────
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        bash = { "shfmt" },
        sh = { "shfmt" },
        lua = { "stylua" },
        rust = { "rustfmt" },
        nix = { "alejandra" },
        toml = { "taplo" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        go = { "gofumpt" },
        markdown = { "markdownlint" },
        python = { "ruff_format", "ruff_organize_imports" },
        yaml = { "yamlfmt" },
      },
    },
  },

  -- ─────────────────────────────────────────────────────────────────────────
  -- 5. Configure linters to use system binaries
  -- ─────────────────────────────────────────────────────────────────────────
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        bash = { "shellcheck" },
        sh = { "shellcheck" },
        nix = { "statix" },
        markdown = { "markdownlint" },
        yaml = { "yamllint" },
        ansible = { "ansible-lint" },
      },
    },
  },
}
