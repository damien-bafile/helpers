return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      jdtls = {},
    },
    setup = {
      jdtls = function()
        return true
      end,
    },
  },
}
