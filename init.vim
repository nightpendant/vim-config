set nocompatible
set relativenumber
set tabstop=4
set shiftwidth=4
set autoindent
filetype plugin indent on
set cursorline
set nobackup
set smartcase
set nowrap
set hlsearch
set wildmenu
set hidden
set guifont=:ComicShannsMono_Nerd_Font:h10
set number
" au VimEnter *  NERDTree
set fillchars+=vert:║
set signcolumn=number

nnoremap <C-p> :Telescope live_grep<CR>
nnoremap <C-g> :Neotree<CR>
nnoremap <C-,> :cd %:p:h<CR>
nnoremap <C-q> <C-v>
let mapleader = '\'
" let g:neovide_cursor_vfx_mode = 'pixiedust'
" let g:neovide_cursor_particle_density = 1.0
" let g:neovide_cursor_vfx_opacity = 200.0
" let g:neovide_cursor_vfx_particle_lifetime = 1.0
 let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

autocmd BufRead,BufNewFile *.gd set filetype=gdscript
cd C:\Users\acer\dev\

lua << EOF
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = "\\"
vim.g.maplocalleader = "."
local border = "double"

-- PLUGINS PLUGINS PLUGINS I LOVE PLUGINS
require("lazy").setup({
	{"preservim/nerdtree",cmd = "NERDTree",},
	{"rafi/awesome-vim-colorschemes",event = "UIEnter",},
	{"preservim/tagbar",cmd = "TagbarToggle",},
	{"nvim-telescope/telescope.nvim",cmd = "Telescope",dependencies = { "nvim-lua/plenary.nvim" },},
	{"neovim/nvim-lspconfig",event = { "BufReadPre", "BufNewFile" },},
	{"williamboman/mason.nvim",cmd = "Mason",},
	{"williamboman/mason-lspconfig.nvim",event = { "BufReadPre", "BufNewFile" },},
	{"hrsh7th/nvim-cmp",event = "InsertEnter",dependencies = {
	 "hrsh7th/cmp-nvim-lsp",
	 "hrsh7th/cmp-buffer",
	 "hrsh7th/cmp-path",
	 "hrsh7th/cmp-cmdline",
	 "L3MON4D3/LuaSnip",
	 "saadparwaiz1/cmp_luasnip",},},
	{"habamax/vim-godot",ft = { "gd", "gdscript" },},
	{"airblade/vim-gitgutter",event = { "BufReadPost", "BufNewFile" },},
	{"vimwiki/vimwiki",ft = "vimwiki",},
	{"nathanaelkane/vim-indent-guides",event = "BufReadPost",},
	{"nvim-treesitter/nvim-treesitter",build = ":TSUpdate",event = {"BufReadPost", "BufNewFile"},},
	{"nvim-lualine/lualine.nvim", event = "UIEnter",dependencies = {
	 "nvim-tree/nvim-web-devicons"},},
	{"nvim-neo-tree/neo-tree.nvim",branch = "v3.x",lazy = false,dependencies = {
	 "nvim-lua/plenary.nvim",
	 "MunifTanjim/nui.nvim",
	 "nvim-tree/nvim-web-devicons",},},
	{"folke/snacks.nvim",priority = 1000,lazy = false,
				---@type snacks.Config
				opts = {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
				bigfile = { enabled = true },
				dashboard = { enabled = true},
				explorer = { enabled = false },
				indent = { enabled = true },
				input = { enabled = true },
				picker = { enabled = true },
				notifier = { enabled = true },
				quickfile = { enabled = true },
				scope = { enabled = true },
				scroll = { enabled = false },
				statuscolumn = { enabled = true },
				words = { enabled = true },},}
})

vim.api.nvim_create_autocmd("UIEnter", {
	once = true,
	callback = function()
	require("lualine").setup({
		options = {
			theme = "ayu_light", -- matches airline theme
			section_separators = { left = "", right = "" },
			component_separators = { left = "", right = "" },
			globalstatus = false,
			icons_enabled = true,
	  	},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff" },
			lualine_c = { "filename" },

			lualine_x = {
			  "encoding",
			  "fileformat",
			  "filetype",
			},
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		  },
		extensions = {
			"nerdtree",
			"quickfix",
			"fugitive",
			"lazy",
		},
	})
	end,
})

-- lsp setup
vim.api.nvim_create_autocmd("BufReadPre", {
	once = true,
	callback = function()

	require("mason").setup()

	require("mason-lspconfig").setup({
	  ensure_installed = { "pyright", "lua_ls", "clangd" },
	})

	vim.lsp.handlers["textDocument/hover"] =
	  vim.lsp.with(vim.lsp.handlers.hover, { border = border })

	vim.lsp.handlers["textDocument/signatureHelp"] =
	  vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })

	vim.diagnostic.config({
	  float = { border = border },
	})

	local capabilities =
	  require("cmp_nvim_lsp").default_capabilities()

	vim.lsp.handlers["textDocument/hover"] =
	  vim.lsp.with(vim.lsp.handlers.hover, { border = "double" })

	vim.lsp.handlers["textDocument/signatureHelp"] =
	  vim.lsp.with(vim.lsp.handlers.signature_help, { border = "double" })

	vim.diagnostic.config({
	  float = { border = "double" },
	})

	vim.lsp.config("pyright", {
	  capabilities = capabilities,
	})

	vim.lsp.config("lua_ls", {
	  capabilities = capabilities,
	})

	vim.lsp.config("clangd", {
	  capabilities = capabilities,
	})

	vim.lsp.config("gdscript", {
	  name = "godot",
	  cmd = { "ncat", "127.0.0.1", "6005" },
	  filetypes = { "gd", "gdscript" },
	  root_dir = function()
		return vim.fn.getcwd()
	  end,
	  capabilities = capabilities,
	})
  end,
})

-- cmp setup
vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()

    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({

      window = {
        completion = {
          border = "double",
          winhighlight =
            "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
        },

        documentation = {
          border = "double",
          winhighlight =
            "Normal:NormalFloat,FloatBorder:NormalFloat",
        },
      },

      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
      }),

      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      },
    })
  end,
})

EOF

let g:godot_executable = 'C:/Users/acer/dev/games/Godot_v4.5.1-stable_win64.exe'
set completeopt=menu,menuone,noselect
color solarized8_high

nnoremap K <cmd>lua vim.lsp.buf.hover({border = "double"})<CR>
nnoremap gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <leader>ca <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>e <cmd>lua vim.diagnostic.open_float()<CR>
nnoremap [d <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap ]d <cmd>lua vim.diagnostic.goto_next()<CR>
