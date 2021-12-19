{ sources }:
''
"--------------------------------------------------------------------
" Fix vim paths so we load the vim-misc directory
let g:vim_home_path = "~/.vim"

" Enable true color support
set termguicolors

colorscheme solarized8

" Change vertical split character to be a space (essentially hide it)
set fillchars+=vert:.

" Set floating window to be slightly transparent
set winbl=10

" Editor theme
set background=dark

" Some plugin is remapping y to y$, this prevents it
nnoremap Y Y

nmap ; :b<SPACE>

"vnoremap <leader>y :OSCYank<CR>
nmap <leader>y <Plug>OSCYank

let g:mkdp_open_to_the_world = 1
let g:mkdp_port = '9879'

" vim wiki use markdown
let g:vimwiki_list = [
      \ {'path': '~/projects/paddle/vimwiki/', 'syntax': 'markdown', 'ext': '.md'},
      \ {'path': '~/projects/paymentsense/vimwiki/', 'syntax': 'markdown', 'ext': '.md'},
      \ {'path': '~/projects/lance/vimwiki/', 'syntax': 'markdown', 'ext': '.md'},
      \ ]

" Enable spellcheck for markdown files
autocmd BufRead,BufNewFile *.md setlocal spell

" Support for comments in jsonc files
autocmd FileType json syntax match Comment +\/\/.\+$+

" FZF
nnoremap <C-p> :FZF<CR>

" Set relative line numbers
set relativenumber

" Clear Highlighting
nmap ,c :noh<CR>

" Use alt + > / alt + < to increase/decrease window width
nnoremap ≥ <C-w>>
nnoremap ≤ <C-w><

" Quick window switching
" Use alt keys to navigate windows
" In terminal mode
tnoremap ˙ <C-\><C-N><C-w>h
tnoremap ∆ <C-\><C-N><C-w>j
tnoremap ˚ <C-\><C-N><C-w>k
tnoremap ¬ <C-\><C-N><C-w>l
" In normal mode
nnoremap ˙ <C-w>h
nnoremap ∆ <C-w>j
nnoremap ˚ <C-w>k
nnoremap ¬ <C-w>l


try
  colorscheme solarized8
  " colorscheme OceanicNext
catch
  colorscheme slate
endtry

" === Nerdtree shorcuts === "
"  <leader>n - Toggle NERDTree on/off
"  <leader>f - Opens current file location in NERDTree
nnoremap <leader>n :NERDTreeFind<CR>
nnoremap <leader>N :NERDTreeClose<CR>

" Open current working dir in nerdtree
nmap .. :e.<CR>
" Open parent dir of file in current buffer in nerdtree
nmap § :e %:h<CR>

" Gwip
command Gwip !git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify -m "--wip-- [skip ci]"
" Gunwip
command Gunwip !git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1

" This works on NixOS 21.05
let vim_misc_path = split(&packpath, ",")[0] . "/pack/home-manager/start/vim-misc/vimrc.vim"
if filereadable(vim_misc_path)
  execute "source " . vim_misc_path
endif

" This works on NixOS 21.11pre
let vim_misc_path = split(&packpath, ",")[0] . "/pack/home-manager/start/vimplugin-vim-misc/vimrc.vim"
if filereadable(vim_misc_path)
  execute "source " . vim_misc_path
endif

lua <<EOF
---------------------------------------------------------------------
-- Add our custom treesitter parsers
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()

parser_config.proto = {
  install_info = {
    url = "${sources.tree-sitter-proto}", -- local path or git repo
    files = {"src/parser.c"}
  },
  filetype = "proto", -- if filetype does not agrees with parser name
}

---------------------------------------------------------------------
-- Add our treesitter textobjects
require'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },

    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
}

EOF

colorscheme solarized8
''
