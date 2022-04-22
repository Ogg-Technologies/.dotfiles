set termguicolors "Allows for more than 16 colors
set background=dark

" Sets leader to space
let mapleader = " "
nnoremap <space> <Nop>

call plug#begin()
Plug 'tpope/vim-surround' "Surround
Plug 'joshdick/onedark.vim' "Color scheme
Plug 'ctrlpvim/ctrlp.vim' "Fuzzy file finder
"Plug 'ms-jpq/chadtree' "File explorer
"Plug 'vim-airline/vim-airline' "status line
"Plug 'mhinz/vim-startify' "Fancy start screen for vim
Plug 'AndrewRadev/undoquit.vim' "Lets you reopen closed window
Plug 'lilydjwg/colorizer' "Shows the color of hex/hsla codes
Plug 'tommcdo/vim-lion' "Align rows with gl and gL
Plug 'vim-scripts/argtextobj.vim' "Adds ia/aa argument text objects
Plug 'yuttie/comfortable-motion.vim' "Smooth scrolling for ctrl-f/b/d/u
call plug#end()

"Open chadtree binding
nnoremap <leader>f <cmd>CHADopen<cr>
let g:chadtree_settings = { 
    \ "theme.text_colour_set" : "nerdtree_syntax_dark" 
    \ }

" Adds font symbols to vim-airline
let g:airline_powerline_fonts = 1

"nnoremap <leader>s <cmd>Startify<cr>

let g:undoquit_mapping = '' "remove the default <c-w>u mapping
" Use ctrl shift t as the mapping like browsers do
map <c-s-t> :Undoquit<cr> 

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
endif



set guicursor=i-c:hor20-Cursor "Changes cursor to _ in insert and command mode. Removes weird flashing cursor when using space or backspace in insert mode.
colorscheme onedark
let g:neovide_transparency=0.99 "slight transparency
let g:neovide_refresh_rate=144 "144 fps editor!!!

"Sets the style of the parenthesis matcher
hi MatchParen guibg=NONE guifg=orange gui=bold

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
set nohlsearch


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
nnoremap <leader>sf [s1z=<C-o>

"Remove last word with normal bindings
:imap <C-BS> <C-W>

"Remove highlight (run :noh) with space+n
nnoremap <leader>n :noh<cr>


let s:fontsize = 10
" Uses this font: https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf
let s:fontName="FiraCode\\ Nerd\\ Font\\ Mono"
function! AdjustFontSize(amount)
  let s:fontsize = s:fontsize+a:amount
  :execute "set guifont=" . s:fontName . ":h" . s:fontsize
endfunction
"set guifont=FiraCode\ NF:h14 "Not needed, done dynamically by next line
call AdjustFontSize(0)

noremap <C-+> :call AdjustFontSize(1)<CR>
noremap <C--> :call AdjustFontSize(-1)<CR>
inoremap <C-+> <Esc>:call AdjustFontSize(1)<CR>a
inoremap <C--> <Esc>:call AdjustFontSize(-1)<CR>a

"Save and run file
autocmd FileType python nmap <F5> <Esc>:w<CR>:!cls<space>&&<space>%<CR>
autocmd FileType python imap <F5> <Esc>:w<CR>:!cls<space>&&<space>%<CR>
