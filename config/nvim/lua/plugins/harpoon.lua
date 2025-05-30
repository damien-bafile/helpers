return {
  {
    "ThePrimeagen/harpoon",
    event = "BufRead",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    keys = {
      {
        "<leader>fm",
        "<cmd>Telescope harpoon marks<cr>",
        desc = "Telescope Harpoon Marks",
      },
      {
        "<leader>fh",
        "<cmd>Telescope harpoon history<cr>",
        desc = "Telescope Harpoon History",
      },
      {
        "<leader>fc",
        "<cmd>Telescope harpoon commands<cr>",
        desc = "Telescope Harpoon Commands",
      },
    },
    opts = {},
    config = function(_, options)
      local status_ok, harpoon = pcall(require, "harpoon")
      if not status_ok then
        return
      end

      harpoon.setup(options)

      local tele_status_ok, telescope = pcall(require, "telescope")
      if not tele_status_ok then
        return
      end

      telescope.load_extension("harpoon")
    end,
  },
}
