syntax on

set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set relativenumber
set nu
set noerrorbells
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set scrolloff=8
set signcolumn=yes
set colorcolumn=80
set nohlsearch

" Plugins
call plug#begin(stdpath('data').'/plugged')
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'rev': '0.1.0' }
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'xiyaowong/nvim-transparent'
Plug 'neovim/nvim-lspconfig'
Plug 'steelsojka/pears.nvim'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'posva/vim-vue'
Plug 'windwp/nvim-autopairs'
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
Plug 'LinArcX/telescope-env.nvim'
Plug 'numToStr/Comment.nvim'
Plug 'jparise/vim-graphql'
Plug 'pantharshit00/vim-prisma'
Plug 'tomlion/vim-solidity'
Plug 'ThePrimeagen/harpoon'
Plug 'wuelnerdotexe/vim-astro'
Plug 'github/copilot.vim'
Plug 'tpope/vim-fugitive'
Plug 'wittyjudge/gruvbox-material.nvim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'nvim-tree/nvim-web-devicons'
Plug 'beauwilliams/statusline.lua'
Plug 'folke/trouble.nvim'
Plug 'tpope/vim-unimpaired'
Plug 'stevearc/oil.nvim'

" Needed for prettier. NOTE: null-ls is deprecated since August 2023
" Watch out for alternatives/updates once available
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'MunifTanjim/prettier.nvim'

Plug 'williamboman/mason.nvim', {'do': ':MasonUpdate'} 
Plug 'williamboman/mason-lspconfig.nvim'               

" Autocompletion
Plug 'hrsh7th/nvim-cmp'     
Plug 'hrsh7th/cmp-nvim-lsp' 
Plug 'L3MON4D3/LuaSnip'     

Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v2.x'}
call plug#end()

" Colorscheme
" colorscheme gruvbox-material
" colorscheme catppuccin-latte
colorscheme tokyonight

" Remaps
let mapleader = " "

" Comment.nvim
lua require('Comment').setup()

" Astro Config
let g:astro_typescript = 'enable'

lua <<EOF
require'nvim-web-devicons'.setup {
    default = true;
}
EOF

" Go Delve
let g:go_debug_substitute_paths = [['/app', '/home/aseidma/oofone/ash/atlas']]


" Oil
lua <<EOF
require('oil').setup()
EOF

nnoremap - <cmd>Oil<cr>

" LSP
lua <<EOF
local lspconfig = require('lspconfig')
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

require("mason").setup()
require('mason-lspconfig').setup({
    ensure_installed = {
        "ts_ls",
        "eslint",
        "html",
        "cssls",
    },
})

require'lspconfig'.ts_ls.setup{
init_options = {
    plugins = {
        {
                name = "@vue/typescript-plugin",
                location = "/home/aseidma/.nvm/versions/node/v20.10.0/lib/node_modules/@vue/typescript-plugin",
                languages = {
                    "typescript",
                    "javascript",
                    "vue",
                },
                }
        }
    },
    filetypes = {
        "javascript",
        "typescript",
        "vue",
    }
    }

local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp.default_keymaps({buffer = bufnr})
end)

lsp.setup()

local cmp = require('cmp')
cmp.setup({
    mapping = {
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }
    })
EOF

" Prettier formatting "
lua <<EOF
local null_ls = require("null-ls")

local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
local event = "BufWritePre" -- or "BufWritePost"
local async = event == "BufWritePost"

local sources = {
  -- python
  null_ls.builtins.formatting.black,
  null_ls.builtins.formatting.isort,
}

null_ls.setup({
  sources = sources,
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.keymap.set("n", "<Leader>p", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })

      -- format on save
      vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
      vim.api.nvim_create_autocmd(event, {
        buffer = bufnr,
        group = group,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, async = async })
        end,
        desc = "[lsp] format on save",
      })
    end

    if client.supports_method("textDocument/rangeFormatting") then
      vim.keymap.set("x", "<Leader>p", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })
    end
  end,
})

local prettier = require("prettier")
prettier.setup({
  bin = 'prettierd',
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "vue",
    "yaml",
  },
})
EOF

nmap <leader>p <cmd>Prettier<cr>

" Telescope "
lua <<EOF
local telescope = require('telescope')
telescope.setup {
             pickers = {
                 find_files = {
         hidden = true,
       }
       }
       }
telescope.load_extension('env')
telescope.load_extension('harpoon')
EOF

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>gs <cmd>Telescope grep_string<cr>

" Diagnostics
nnoremap <leader>i <cmd>lua vim.diagnostic.open_float()<cr>
nnoremap <leader>kk <cmd>lua vim.lsp.buf.hover()<cr>

" Harpoon
nnoremap <leader>pf <cmd>lua require("harpoon.mark").add_file()<cr>
nnoremap <leader>fm <cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>

" Wincmd
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<cr>

" Move lines
" vnoremap("J", ":m '>+1<CR>gv=gv") 
" vnoremap("K", ":m '<-2<CR>gv=gv")

" Source nvim
nnoremap <leader>sv :source $MYVIMRC<cr>

" Autopairs setup
lua require('nvim-autopairs').setup{}

" Vim-Go setup
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1

" Treesitter config
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  additional_vim_regex_highlighting = true,
  refactor = {
               smart_rename = {
           enable = true,
  keymaps = {
           smart_rename = "grr",
         }
         }
         }
}
EOF

nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction


