set termguicolors "Allows for more than 16 colors
set background=dark

" Sets leader to space
let mapleader = " "
nnoremap <space> <Nop>

call plug#begin()
Plug 'tpope/vim-surround' "Surround
Plug 'joshdick/onedark.vim' "Color scheme
Plug 'AndrewRadev/undoquit.vim' "Lets you reopen closed window
Plug 'yuttie/comfortable-motion.vim' "Smooth scrolling for ctrl-f/b/d/u
Plug 'github/copilot.vim' "Copilot autocomplete
Plug 'junegunn/goyo.vim' "Centers text
Plug 'ctrlpvim/ctrlp.vim' "Fuzzy file finder
Plug 'lilydjwg/colorizer' "Shows the color of hex/hsla codes
Plug 'tommcdo/vim-lion' "Align rows with gl and gL
Plug 'vim-scripts/argtextobj.vim' "Adds ia/aa argument text objects
Plug 'lewis6991/gitsigns.nvim' "Like gitgutter, shows changed lines in sign column


Plug 'nvim-lua/plenary.nvim' "Required by refactoring.nvim
Plug 'nvim-treesitter/nvim-treesitter' "Required by refactoring.nvim
Plug 'ThePrimeagen/refactoring.nvim' "Adds refactoring support


" nvim-cmp requirements
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

Plug 'williamboman/nvim-lsp-installer' "Installs LSP clients
call plug#end()

lua require('gitsigns').setup()

set completeopt=menu,menuone,noselect
lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require('cmp')

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<ESC>'] = cmp.mapping(cmp.mapping.abort(), { 'i', 'c' }),
      ['<CR>'] = cmp.mapping(function(fallback)
          if cmp.visible() and cmp.get_selected_entry() then
             cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
          else
             fallback()
          end
        end, { 'i', 'c' }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

  local servers = { "pyright", "vimls" }
  require("nvim-lsp-installer").setup {
    ensure_installed = servers
  }

  for _, server in ipairs(servers) do
    opt = {}
    opt.capabilities = capabilities
    require('lspconfig')[server].setup(opt)
  end
EOF


vnoremap <leader>rr :lua require('refactoring').select_refactor()<CR>

let g:undoquit_mapping = '' "remove the default <c-w>u mapping
" Use ctrl shift t as the mapping like browsers do
noremap <c-s-t> :Undoquit<cr> 
inoremap <c-s-t> :Undoquit<cr>

nnoremap <leader>g :Goyo<cr>

" Makes the comfortable_motion move faster (e.g in ctrl-f)
let g:comfortable_motion_friction = 500
let g:comfortable_motion_air_drag = 2
let g:comfortable_motion_no_default_key_mappings = 1
let g:comfortable_motion_impulse_large = 300
let g:comfortable_motion_impulse_small = 180
nnoremap <silent> <C-d> :call comfortable_motion#flick(g:comfortable_motion_impulse_small)<CR>
nnoremap <silent> <C-u> :call comfortable_motion#flick(-g:comfortable_motion_impulse_small)<CR>
nnoremap <silent> <C-f> :call comfortable_motion#flick(g:comfortable_motion_impulse_large)<CR>
nnoremap <silent> <C-b> :call comfortable_motion#flick(-g:comfortable_motion_impulse_large)<CR>

if exists('g:neovide')
    " Fixes bug where some alt-gr characters are not written
    " Workaround SDL2 AltGr keys not properly read :
    " See https://github.com/Kethku/neovide/issues/151#issuecomment-682123519
    imap <M-C-\> \
    imap <M-C-[> [
    imap <M-C-]> ]
    imap <M-C-`> `
    imap <M-C-@> @
    " for normal mode:
    map <M-C-\> \
    map <M-C-[> [
    map <M-C-]> ]
    map <M-C-`> `
    map <M-C-@> @
    " for command mode:
    cmap <M-C-\> \
    cmap <M-C-[> [
    cmap <M-C-]> ]
    cmap <M-C-`> `
    cmap <M-C-@> @

    let g:neovide_transparency=0.99 "slight transparency
    let g:neovide_refresh_rate=144 "144 fps editor!!!
else

    "Allows for transparent background in terminal, does not work in neovide
    augroup user_colors
      autocmd!
      autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
    augroup END
endif


colorscheme onedark

set guicursor=i-c:hor20-Cursor "Changes cursor to _ in insert and command mode. Removes weird flashing cursor when using space or backspace in insert mode.

"Sets the style of the parenthesis matcher
hi MatchParen guibg=NONE guifg=orange gui=bold

set autochdir "Automatically change the current directory to the one of the file you are editing
set browsedir=current "Always open Explorer in the current directory
set signcolumn=yes "Always show left column (for e.g warnings)
set langmenu=eng_US.UTF-8
language en_GB.utf8
set belloff=all "No microsoft bell sound
set number
set relativenumber
set clipboard=unnamedplus "Uses the default clipboard
set ts=4
set shiftwidth=4
set linebreak "Dont break line in middle of word
set expandtab "Use spaces instead of tabs
set inccommand=split "Real time substitute and opens a window showing all changes
set mouse=a
set noshowmode
set nohlsearch "Does not keep the highlights when finished searching
set foldmethod=indent "Folds based on indentation
set foldlevel=99 "Starting fold is at 99 levels of indentation (starts with no folds)
set scrolloff=3


"Saves undo, backups and swap files in a separate directory
let nvim_data_dir="~/.local/share/nvim"
execute "set undodir=" . nvim_data_dir . "/.undo//"
execute "set backupdir=" . nvim_data_dir . "/.backup//"
execute "set directory=" . nvim_data_dir . "/.swp//"
set undofile

" Highlights the text when yanked
augroup LuaHighlight
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END


"nnoremap <leader>pa :let<space>g:neovide_cursor_vfx_mode="pixiedust"<cr>
command! FlexOn let g:neovide_cursor_vfx_mode="railgun"
command! FlexOff let g:neovide_cursor_vfx_mode=""
"let g:neovide_cursor_vfx_mode = "pixiedust" "particle type
let g:neovide_cursor_vfx_particle_density=20 "amount of particles

"Open or reload vimrc from any file
map <leader>vco :tabnew $MYVIMRC<cr>
map <leader>vcs :silent so $MYVIMRC<cr>

"Make C-c equivalent to esc. Normally C-c does not trigger InsertLeave event
imap <C-c> <Esc>

"split navigations
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

"Resize splits using arrow keys
nnoremap <Up>    :resize +5<CR>
nnoremap <Down>  :resize -5<CR>
nnoremap <Left>  :vertical resize -5<CR>
nnoremap <Right> :vertical resize +5<CR>


"Toggle spell check and set language
nnoremap <leader>st :set spell!<CR>
nnoremap <leader>ss :set spelllang=sv<CR>
nnoremap <leader>se :set spelllang=en<CR>
nnoremap <leader>sf [s1z=

"Copilot mappings
function! CopilotToggle()
  redir => status
  silent execute 'Copilot status'
  redir END
  if status =~ 'Enabled'
    execute 'Copilot disable'
  else
    execute 'Copilot enable'
  endif
  execute 'Copilot status'
endfunction
nnoremap <leader>ct :call CopilotToggle()<CR>
"Uses <M-ä> since <C-ä> cannot be mapped as it does not produce an ASCII character
inoremap <M-ä> <esc>:Copilot panel<CR>

"Remove last word with normal bindings
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>

"Remove highlight (run :noh) with space+n
nnoremap <leader>n :noh<cr>

"Swap selected text around pivot substring
function! SwapSelection(pivot)
    "Get the right visual selection:
    "Select the last selection
    normal! gv
    "If the cursor is at the start, move it to the end
    if getpos('.') == getpos("'<")
        normal! o
    endif
    "Select one more char to the right. \%V will otherwise miss the last char
    normal! l

    "Swap the two parts around the pivot
    execute 's/\%V\(.*\)' . a:pivot . '\(.*\)\%V/\2' . a:pivot . '\1'
    "Deselect text
    call feedkeys("\<esc>")
    "Move cursor to the pivot point
    call search(a:pivot, 'W', line('.'))
endfunction

"Prompt the user for a pivot point, swap selection around it
function! SwapSelectionAroundPrompt(addSpace)
    let pivot = input('Swap around: ')
    if a:addSpace
        let pivot = ' ' . pivot . ' '
    endif
    call SwapSelection(pivot)
endfunction

"Swap in (excludes spaces)
vnoremap gsi :call SwapSelectionAroundPrompt(0)<CR>
"Swap around (includes spaces)
vnoremap gsa :call SwapSelectionAroundPrompt(1)<CR>


let s:fontsize = 14
" Uses this font: https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf
let s:fontName="FiraCode\\ Nerd\\ Font\\ Mono"
function! AdjustFontSize(amount)
  let s:fontsize = s:fontsize+a:amount
  :execute "set guifont=" . s:fontName . ":h" . s:fontsize
endfunction
call AdjustFontSize(0)

noremap <C-+> :call AdjustFontSize(1)<CR>
noremap <C--> :call AdjustFontSize(-1)<CR>
inoremap <C-+> <Esc>:call AdjustFontSize(1)<CR>a
inoremap <C--> <Esc>:call AdjustFontSize(-1)<CR>a

"Save and run file
autocmd FileType python nmap <F5> <Esc>:w<CR>:!python<space>%<CR>
autocmd FileType python imap <F5> <Esc>:w<CR>:!python<space>%<CR>
