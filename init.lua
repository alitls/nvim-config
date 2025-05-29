-- Key mappings
vim.g.mapleader = " "

-- Basic Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.termguicolors = true

--Key mappings Ex to <leader>pv
vim.keymap.set("n","<leader>pv",vim.cmd.Ex)


-- Bootstrap lazy.nvim plugin
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)


-- Configure plugins
require("lazy").setup({
  {
    "nvim-telescope/telescope.nvim", tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" }
  },

 -- example: colorscheme
{
  "xiantang/darcula-dark.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  priority = 1000, -- Ensure it loads before other plugins
  config = function()
    vim.cmd.colorscheme("darcula-dark")
  end,
},

 -- tree-sitter
 {
     "nvim-treesitter/nvim-treesitter",
     build = ":TSUpdate", -- updates parsers on install
     config = function()
         require("nvim-treesitter.configs").setup({
             ensure_installed = { "lua", "python", "bash", "javascript", "html", "css", "c", "cpp"}, -- your languages
             highlight = {
                 enable = true,
             },
             indent = {
                 enable = true,
             },
         })
     end,
 },

 -- nvim-tree
{
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- optional, for file icons
  },
  config = function()
    require("nvim-tree").setup({
      view = {
        width = 30,
      },
      filters = {
        dotfiles = false,
      },
    })
  end
}



})

-- telescope
-- Keybinding to open file finder using Telescope
vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "Find files" })

-- Keybinding to grep text in files
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "Grep files" })

-- Keybinding to search open buffers
vim.keymap.set("n", "<leader>sb", require("telescope.builtin").buffers, { desc = "Find buffers" })

-- Keybinding to search help tags
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "Help tags" })



-- nvim-tree
vim.keymap.set("n", "<leader>ff", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

