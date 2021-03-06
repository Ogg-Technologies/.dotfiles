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
Plug 'ggandor/lightspeed.nvim' "Jump anywhere on screen (s followed by 2 letters)
Plug 'monaqa/dial.nvim' "Better c-a and c-x
Plug 'tpope/vim-repeat' "Improved . operator
Plug 'mbbill/undotree' "Tree with undo history
Plug 'chentoast/live.nvim' "Preview for :norm command
Plug 'lukas-reineke/indent-blankline.nvim' "Shows indentation
Plug 'akinsho/toggleterm.nvim' "Terminal that you can toggle in a split
Plug 'David-Kunz/treesitter-unit' "Textobject for treesitter nodes


Plug 'nvim-lua/plenary.nvim' "Required by refactoring.nvim
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} "Syntax highlighting
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

lua require('live').setup()

set completeopt=menu,menuone,noselect
lua <<EOF
    -- setup gitsigns
    require('gitsigns').setup{
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end
            map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>') -- "ih" becomes "in hunk" text object
            -- navigate to next/previous hunk (only when not in vim diff mode)
            map('n', ']h', function()
                if vim.wo.diff then return ']h' end
                vim.schedule(function() gs.next_hunk() end)
                return '<Ignore>'
            end, {expr=true})

            map('n', '[h', function()
                if vim.wo.diff then return '[h' end
                vim.schedule(function() gs.prev_hunk() end)
                return '<Ignore>'
            end, {expr=true})
        end
    }


    -- Setup toggleterm
    require('toggleterm').setup{
        -- size can be a number or function which is passed the current terminal
        size = 80,
        open_mapping = [[<c-s>]],
        hide_numbers = true, -- hide the number column in toggleterm buffers
        shade_terminals = true, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
        --shading_factor = '<number>', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
        start_in_insert = true,
        insert_mappings = true, -- whether or not the open mapping applies in insert mode
        terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
        persist_size = true,
        direction = 'vertical',
        close_on_exit = false, -- close the terminal window when the process exits
    }



    require'nvim-treesitter.configs'.setup {
        ensure_installed = { "javascript", "java", "markdown", "bash", "json", "haskell", "vim", "lua", "rust" },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        highlight = {
            -- `false` will disable the whole extension
            enable = true,

            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
        },
    }

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
            ['<C-e>'] = cmp.mapping.abort(),
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

    local servers = { "pyright", "vimls", "hls" }
    require("nvim-lsp-installer").setup {
        ensure_installed = servers
    }

    for _, server in ipairs(servers) do
        require('lspconfig')[server].setup {
            on_attach = function(client, bufnr)
                -- Mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local bufopts = { noremap=true, silent=true, buffer=bufnr }
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
                vim.keymap.set('n', '<space>lr', vim.lsp.buf.rename, bufopts)
                vim.keymap.set('n', '<space>la', vim.lsp.buf.code_action, bufopts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
                vim.keymap.set('n', '<c-m-l>', vim.lsp.buf.formatting, bufopts)
                vim.keymap.set('n', '<space>ld', vim.diagnostic.open_float, opts)
            end,
            capabilities = capabilities,
        }
    end
EOF

nnoremap <silent> [d :lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> ]d :lua vim.diagnostic.goto_next()<CR>

xnoremap iu :lua require"treesitter-unit".select()<CR>
xnoremap au :lua require"treesitter-unit".select(true)<CR>
onoremap iu :<c-u>lua require"treesitter-unit".select()<CR>
onoremap au :<c-u>lua require"treesitter-unit".select(true)<CR>

" Dial setup, create keybinds and augends
nmap  <C-a>  <Plug>(dial-increment)
nmap  <C-x>  <Plug>(dial-decrement)
vmap  <C-a>  <Plug>(dial-increment)
vmap  <C-x>  <Plug>(dial-decrement)
vmap g<C-a> g<Plug>(dial-increment)
vmap g<C-x> g<Plug>(dial-decrement)

lua <<EOF
    local augend = require("dial.augend")
    default_group = {
        augend.integer.alias.decimal,
        augend.constant.alias.bool,
        augend.integer.alias.hex,
        augend.integer.alias.binary,
        augend.date.alias["%Y-%m-%d"],
        augend.constant.new{
            elements = {"and", "or"},
            word = true,
            cyclic = true,
        },
    }
    function map(tbl, func)
        local newtbl = {}
        for i,v in pairs(tbl) do
            newtbl[i] = func(v)
        end
        return newtbl
    end
    function add_case_respecting_constants(elements, cyclic)
        lowercase_elements = map(elements, function(s) return string.lower(s) end)
        capitalized_elements = map(elements, function(s) return s:gsub("^%l", string.upper) end)
        uppercase_elements = map(elements, function(s) return string.upper(s) end)
        for _, elems in ipairs({lowercase_elements, capitalized_elements, uppercase_elements}) do
            table.insert(default_group, augend.constant.new {
                elements = elems,
                word = true,
                cyclic = cyclic,
            })
        end
    end
    add_case_respecting_constants({"true", "false"}, true)
    add_case_respecting_constants({"yes", "no"}, true)
    add_case_respecting_constants({"on", "off"}, true)
    add_case_respecting_constants({"enable", "disable"}, true)
    add_case_respecting_constants({"enabled", "disabled"}, true)
    add_case_respecting_constants({"and", "or"}, true)
    add_case_respecting_constants({"active", "inactive"}, true)
    add_case_respecting_constants({"zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen", "twenty"}, false)
    add_case_respecting_constants({"och", "eller"}, true)
    add_case_respecting_constants({"noll", "ett", "tv??", "tre", "fyra", "fem", "sex", "sju", "??tta", "nio", "tio", "elva", "tolv", "tretton", "fjorton", "femton", "sexton", "sjutton", "arton", "nitton", "tjugo"}, false)

    require("dial.config").augends:register_group { default = default_group }
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
let g:comfortable_motion_impulse_large = 250
let g:comfortable_motion_impulse_small = 160
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
set clipboard=unnamedplus "Uses the default clipboard
set ts=4
set shiftwidth=0
set linebreak "Dont break line in middle of word
set expandtab "Use spaces instead of tabs
set inccommand=split "Real time substitute and opens a window showing all changes
set mouse=a
set noshowmode
set foldmethod=indent "Folds based on indentation
set foldlevel=99 "Starting fold is at 99 levels of indentation (starts with no folds)
set scrolloff=8
set ignorecase
set smartcase


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

tnoremap <C-n> <C-\><C-n>
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

"split navigations
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
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

nnoremap <leader>u :UndotreeToggle<CR>

"Copilot settings
let g:copilot_filetypes = { '*': v:true } "Enable for all filetypes
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
"Uses <M-??> since <C-??> cannot be mapped as it does not produce an ASCII character
inoremap <M-??> <esc>:Copilot panel<CR>

"Remove last word with normal bindings
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>

"Remove highlight (run :noh) with space+n
nnoremap <leader>n :noh<cr>

lua <<EOF
    -- Swap selected text around pivot substring
    function swap_selection(pivot)
        start_mark = vim.api.nvim_buf_get_mark(0, "<")
        finish_mark = vim.api.nvim_buf_get_mark(0, ">")
        start_row = start_mark[1] - 1
        start_col = start_mark[2]
        finish_row = finish_mark[1] - 1
        finish_col = finish_mark[2] + 1
        line_length = #vim.api.nvim_buf_get_lines(0, start_row, start_row + 1, false)[1]
        if finish_col > line_length then finish_col = line_length end
        selected = vim.api.nvim_buf_get_text(0, start_row, start_col, finish_row, finish_col, {})[1]
        swapped = selected:gsub("(.*)" .. pivot .. "(.*)", "%2" .. pivot .. "%1")
        vim.api.nvim_buf_set_text(0, start_row, start_col, finish_row, finish_col, {swapped})
    end
    -- Prompt the user for a pivot point, swap selection around it
    function swap_selection_around_prompt(addSpace)
        local pivot = vim.fn.input("Swap around: ")
        if addSpace then
            pivot = " " .. pivot .. " "
        end
        swap_selection(pivot)
    end
EOF


"Swap in (excludes spaces)
vnoremap gsi :lua swap_selection_around_prompt(false)<CR>
"Swap around (includes spaces)
vnoremap gsa :lua swap_selection_around_prompt(true)<CR>


let s:fontsize = 12
" Uses this font: https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf
let s:fontName="FiraCode\\ Nerd\\ Font"
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
augroup RunCode
    autocmd!
    autocmd FileType python nmap <F5> <Esc>:w<CR>:!python<space>%<CR>
    autocmd FileType python imap <F5> <Esc>:w<CR>:!python<space>%<CR>

    autocmd FileType haskell nmap <F5> <Esc>:w<CR>:!runghc %<CR>
    autocmd FileType haskell imap <F5> <Esc>:w<CR>:!runghc %<CR>
augroup END

lua <<EOF
    function RerunHaskell()
        vim.cmd("TermExec cmd=':r' go_back=0")
        vim.cmd("TermExec cmd='main' go_back=0")
    end
EOF
