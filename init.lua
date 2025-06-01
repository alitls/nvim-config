-- Basic Settings
vim.g.mapleader = " "            -- Key mappings
vim.opt.number = true            -- Show line number
vim.opt.relativenumber = true    -- Show relative line number
vim.opt.guicursor=""             -- Fat cursor
vim.opt.expandtab = true         -- Use spaces instead of tab characters.
vim.opt.tabstop = 4              -- A tab is 4 space
vim.opt.shiftwidth = 4           -- When you indent (>> or auto indent), it uses 4 spaces.
vim.opt.smartindent = true
vim.opt.smartindent = true       -- Automatically indent new lines smartly, based on code structure.
vim.opt.wrap = false             -- Don’t wrap long lines — they go off screen instead of going to the next line.
vim.opt.termguicolors = true     -- Enable true color support (so themes like darcula-dark look nice).
vim.opt.hlsearch = false         -- Highlight search
vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"



vim.keymap.set("n","<leader>pv",vim.cmd.Ex) --Key mappings Ex to <leader>pv



-- Allows me to move statements with J and K when highlighted
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keeps cursor in the middle of screen when using Crrl+d and Ctrl+u
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keeps search terms in the middle of screen(zz)
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Use <leader>p to paste without loosing it from register
--vim.keymap.set("x", "<leader>p", [["_dP]])


-- Use <leader>y to yank it into system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])


-- Deleting into void register in normal mode and visual mode
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")

-- disable Q
vim.keymap.set("n", "Q", "<nop>")


-- Quick list keymaps
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")



-- Use <leader>s on a word to replace it in file
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])


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
},




 -- LSP Config
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            -- Python
            lspconfig.pyright.setup({
                capabilities = capabilities,
            })

            -- C
            lspconfig.clangd.setup({
                capabilities = capabilities,
            })
    end,
  },

  -- Mason (LSP installer)
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = true,
  },

  -- Mason bridge to lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "clangd" },
        automatic_installation = true,
      })
    end,
  },


    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",   -- LSP source for nvim-cmp
            "hrsh7th/cmp-buffer",     -- buffer completions
            "hrsh7th/cmp-path",       -- path completions
            "L3MON4D3/LuaSnip",       -- snippet engine
            "saadparwaiz1/cmp_luasnip", -- snippets in completion
        },
    },

    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = true
    }


})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
  end
})



-- Setup nvim-cmp (auto complete)
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping.select_next_item(), -- Tab
        ["<S-Tab>"] = cmp.mapping.select_prev_item(), -- Shift + Tab
        ["<CR>"] = cmp.mapping.confirm({ select = true }), --Enter
        ["<C-Space>"] = cmp.mapping.complete(),  -- Ctrl + Space
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
    }, {
            { name = "buffer" },
            { name = "path" },
        })
})


--toggleterm config
require("toggleterm").setup {
  size = 20,
  open_mapping = [[<C-\>]],
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  direction = "float", -- options: 'vertical' | 'horizontal' | 'tab' | 'float'
  float_opts = {
    border = "curved",
    winblend = 0,
  },
}


-- telescope
vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "Find files" }) -- Keybinding to open file finder using Telescope
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "Grep files" }) -- Keybinding to grep text in files
vim.keymap.set("n", "<leader>sb", require("telescope.builtin").buffers, { desc = "Find buffers" })-- Keybinding to search open buffers
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "Help tags" }) -- Keybinding to search help tags

-- nvim-tree
vim.keymap.set("n", "<leader>ff", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

--toggleterm use <leader>tt
--vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=float<CR>", { desc = "Toggle floating terminal" })

-- Exit terminal mode with Esc
--vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Escape terminal mode" })

