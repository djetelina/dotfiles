-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
  { "dracula/vim", name = "dracula" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = function()
    local parsers = { "python", "lua", "bash", "json", "yaml", "toml", "hcl", "terraform", "markdown", "markdown_inline", "vim", "vimdoc" }
    require("nvim-treesitter").install(parsers)
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end },
  { "lewis6991/gitsigns.nvim", config = true },
  { "echasnovski/mini.pairs", config = true },
  { "tpope/vim-sleuth" },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", config = true },
  { "nvim-lualine/lualine.nvim", opts = { options = { theme = "dracula" } } },
  { "nvim-tree/nvim-web-devicons", config = true },
  { "folke/which-key.nvim", config = true },

  -- LSP
  { "mason-org/mason.nvim", config = true },
  { "mason-org/mason-lspconfig.nvim", opts = {
    ensure_installed = { "pyright" },
    automatic_enable = true,
  }},
  { "neovim/nvim-lspconfig" },

  -- Autocomplete
  { "hrsh7th/nvim-cmp", config = function()
    local cmp = require("cmp")
    cmp.setup({
      sources = { { name = "nvim_lsp" } },
      mapping = cmp.mapping.preset.insert({
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
    })
  end },
  { "hrsh7th/cmp-nvim-lsp" },

  -- Format on save
  { "stevearc/conform.nvim", opts = {
    format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
    formatters_by_ft = {
      python = { "ruff_format" },
      terraform = { "tofu_fmt" },
      hcl = { "tofu_fmt" },
    },
  }},
})

-- Enable tofu-ls (installed via AUR, not mason)
vim.lsp.enable("tofu_ls")

-- Colorscheme
vim.cmd.colorscheme("dracula")

-- UI
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.hlsearch = true

-- Visible whitespace
vim.opt.list = true
vim.opt.listchars = { eol = "¬", tab = ">·", trail = "~", extends = ">", precedes = "<" }

-- Arrow keys and h/l wrap across lines
vim.opt.whichwrap:append("<,>,h,l,[,]")
