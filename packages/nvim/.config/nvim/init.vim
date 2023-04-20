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
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'xiyaowong/nvim-transparent'
Plug 'neovim/nvim-lspconfig'
Plug 'steelsojka/pears.nvim'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
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
call plug#end()

" Colorscheme
colorscheme tokyonight-moon

" Remaps
let mapleader = " "

" Comment.nvim
lua require('Comment').setup()

" Astro Config
let g:astro_typescript = 'enable'

" Telescope 
lua <<EOF
local telescope = require('telescope')
telescope.setup {
            \ pickers = {
                \ find_files = {
        \ hidden = true,
      \ }
      \ }
      \ }
telescope.load_extension('env')
telescope.load_extension('harpoon')
EOF
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>gs <cmd>Telescope grep_string<cr>

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
              \ smart_rename = {
          \ enable = true,
  keymaps = {
          \ smart_rename = "grr",
        \ }
        \ }
        \ }
}
EOF

" Transparency
lua <<EOF
require("transparent").setup({
    \ enable = true,
  \ })
EOF

" Coc mappings
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Jump between diagnostics
nmap <silent> ,g <Plug>(coc-diagnostic-prev)
nmap <silent> ;g <Plug>(coc-diagnostic-next)

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

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

