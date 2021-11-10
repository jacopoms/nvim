local ts_config = require("nvim-treesitter.configs")

ts_config.setup {
  ensure_installed = {
    "lua",
    "ruby",
    "elixir",
    "dockerfile",
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  indent = {
    enable = false,
  }
}