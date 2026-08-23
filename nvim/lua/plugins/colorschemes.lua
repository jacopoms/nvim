return {
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_bg = true,
      italic_comment = true,
    },
  },
  {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    -- colorscheme names it registers: onedark, onelight, onedark_vivid, onedark_dark, vaporwave
    -- (which one loads is picked below via LazyVim.opts.colorscheme)
  },
  {
    "Tsuzat/NeoSolarized.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      transparent = false,
      style = "light",
    },
  },
  {
    "yorik1984/newpaper.nvim",
    lazy = true,
    opts = {
      style = "light",
      custom_highlights = {
        GitSignsCurrentLineBlame = { fg = "#778899" },
      },
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    branch = "main",
    version = false,
    lazy = true,
    priority = 1000,
    opts = {
      flavor = "latte", -- latte, frappe, macchiato, mocha
      neo_tree = true,
      blink_cmp = true,
      snacks = {
        enabled = true,
        indent_scope_color = "lavender", -- catppuccin color (eg. `lavender`) Default: text
      },
    },
  },
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = true, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = {
      dim_inactive = true,
      -- hide_end_of_buffer = false, -- Hide the '~' character at the end of the buffer for a cleaner look
      hide_nc_statusline = false, -- Override the underline style for non-active statuslines
    },
  },
  {
    -- "uloco/bluloco.nvim",
    "mistweaverco/bluloco.nvim",
    -- dependencies = { "rktjmp/lush.nvim" },
    lazy = true,
    opts = {
      italics = true,
      theme = "light",
    },
  },
  {
    "edmondburnett/leeward.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      theme = "dark",
    },
    -- config = function()
    --     require("leeward").setup()
    --     require("leeward").load()
    -- end
  },
  -- lua/plugins/rose-pine.lua
  {
    "rose-pine/neovim",
    lazy = true,
    name = "rose-pine",
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "tiagovla/tokyodark.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      transparent = false,
    },
  },
  {
    "maxmx03/fluoromachine.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      glow = false,
      theme = "fluoromachine",
      transparent = true,
    },
  },
  -- Configure LazyVim to load  colorscheme
  -- Follows $THEME_MODE (exported by theme.zsh: Dracula dark / onedarkpro "onelight" light)
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = (vim.env.THEME_MODE == "light") and "catppuccin-latte" or "dracula",
    },
  },
}
