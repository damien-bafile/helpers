return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    opts.ensure_installed = opts.ensure_installed or {}
    vim.list_extend(
      opts.ensure_installed,
      { "c", "java", "json", "lua", "markdown", "markdown_inline", "python", "regex", "toml", "vim", "yaml" }
    )
  end,
}
