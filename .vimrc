" 可以用zM zR zo zc等命令来操作折叠，默认没有折叠
" coc相关配置已被注释，使用时应该先解开这段注释

" 基础配置 {{{
" 菜单相关
let do_syntax_sel_menu = 1
let do_no_lazyload_menus = 1

" 添加中文支持
set fileencodings=ucs-bom,utf-8,gb18030,latin1
" utf-8兼容性比较好
set enc=utf-8
" 导入默认配置
source $VIMRUNTIME/vimrc_example.vim
" 不兼容vi
set nocompatible

set ignorecase
set smartcase

set ruler " 右下始终显示当前光标位置
set nu " 显示当前行行号
set rnu " 非当前行显示与当前行的距离
set cul " 高亮当前行
set cuc " 高亮当前列

set makeprg=make\ -j8

let g:mapleader=' '

" 显示空格和tab
set list
set listchars=tab:>-,space:.

set matchpairs+=<:>

set noswapfile
" 禁用backup文件
set nobackup
" 添加跨会话撤销功能
set undodir=~/.vim/undodir
" 跨会话撤销要保存的文件所存储的目录
if !isdirectory(&undodir)
  call mkdir(&undodir, 'p', 0700)
endif

set mouse=a
set scrolloff=0

if !has('patch-8.0.210')
  " 进入插入模式时启用括号粘贴模式
  let &t_SI .= "\<Esc>[?2004h"
  " 退出插入模式时停用括号粘贴模式
  let &t_EI .= "\<Esc>[?2004l"
  " 见到 <Esc>[200~ 就调用 XTermPasteBegin
  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

  function! XTermPasteBegin()
    " 设置使用 <Esc>[201~ 关闭粘贴模式
    set pastetoggle=<Esc>[201~
    " 开启粘贴模式
    set paste
    return ""
  endfunction
endif

if v:version >= 800
  packadd! editexisting
endif

set autoread

aug QFClose
  au!
  au WinEnter *  if winnr('$') == 1 && &buftype == "quickfix"|q|endif
aug END

" markdown里对指定语言高亮
let g:markdown_fenced_languages = [
  \'cpp'
\]

set makeprg=make\ -j8
" }}}

" 按键映射 {{{
nnoremap <silent> <C-j> 5j
vnoremap <silent> <C-j> 5j
nnoremap <silent> <C-k> 5k
vnoremap <silent> <C-k> 5k
" 在不退出vim的前期下让配置文件生效
nnoremap <silent> <leader>sv :source $HOME/.vimrc<CR>
" 多窗口切换
nnoremap <silent> <ESC>h <C-W>h
nnoremap <silent> <ESC>j <C-W>j
nnoremap <silent> <ESC>k <C-W>k
nnoremap <silent> <ESC>l <C-W>l
" 多标签页切换
nnoremap <silent><buffer> <C-H> gT
nnoremap <silent><buffer> <C-L> gt
" 停止搜索高亮的键映射
nnoremap <silent> <F2>      :nohlsearch<CR>
inoremap <silent> <F2> <C-O>:nohlsearch<CR>

" }}}

" 代码缩进 {{{
au FileType c,cpp,objc  setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4 cinoptions=>4,:0,l1,g0,N-s,E-s,t0,i.5s,(s,u0,U1,w1,W4,k4,m1,j1
au FileType json        setlocal expandtab shiftwidth=2 softtabstop=2
au FileType vue         setlocal expandtab shiftwidth=2 softtabstop=2
au FileType typescript  setlocal expandtab shiftwidth=2 softtabstop=2
au FileType vim         setlocal expandtab shiftwidth=2 softtabstop=2
au FileType html        setlocal expandtab shiftwidth=2 softtabstop=2
au FileType scss        setlocal expandtab shiftwidth=2 softtabstop=2
" }}}

" 代码折叠 {{{
au FileType vim              setlocal foldmethod=marker
au FileType c,cpp,typescript setlocal foldmethod=syntax
au FileType python           setlocal foldmethod=indent
set nofoldenable
" }}}

" 用于 quickfix、标签和文件跳转的键映射 {{{
nmap <F11>   :cn<CR>
nmap <F12>   :cp<CR>
nmap <M-F11> :copen<CR>
nmap <M-F12> :cclose<CR>
nmap <C-F11> :tn<CR>
nmap <C-F12> :tp<CR>
nmap <S-F11> :n<CR>
nmap <S-F12> :prev<CR>
" }}}


" plug {{{
call plug#begin()
Plug 'mg979/vim-visual-multi' " 多光标编辑
Plug 'tpope/vim-surround' " 选中内容两端添加字符
Plug 'tpope/vim-repeat' " 可以重复插件命令
Plug 'gcmt/wildfire.vim' " 快捷的选中一段内容
Plug 'neoclide/coc.nvim', {'branch': 'release'} " 代码补全
Plug 'morhetz/gruvbox' " 配色方案
Plug 'honza/vim-snippets' " 代码片段，需要配合coc-snippets，coc-snippets在它自
                          " 己的配置里有一个数组，可以自动安装
Plug 'mattn/emmet-vim' " html/css
Plug 'junegunn/fzf', {'do': 'yes \| ./install'}
Plug 'junegunn/fzf.vim'
Plug 'skywind3000/asyncrun.vim' " 异步支持
Plug 'tanglong3bf/csp-vim-syntax'  " csp文件语法高亮
Plug 'lervag/vimtex'
Plug 'tpope/vim-fugitive' " 更快捷的git操作
Plug 'airblade/vim-gitgutter' " git侧边栏显示
Plug 'vim-airline/vim-airline'
Plug 'mbbill/undotree' " 对于undotree的可视化
Plug 'puremourning/vimspector' " 调试
Plug 'preservim/nerdcommenter' " 注释
Plug 'voldikss/vim-floaterm' " 浮动终端
Plug 'Yggdroot/indentLine'
call plug#end()
" }}}

" " coc {{{
" let g:coc_disable_startup_warning = 1
" let g:coc_global_extensions = ['coc-marketplace']
" 
" set hidden
" set updatetime=200
" set signcolumn=yes
" set shortmess+=c
" 
" " tab自动补全 {{{
" function! CheckBackspace() abort
" let col = col('.') - 1
" return !col || getline('.')[col - 1] =~# '\s'
" endfunction
" 
" inoremap <silent><expr> <TAB>
" \ pumvisible() ? "\<C-n>" :
" \ CheckBackspace() ? "\<TAB>" :
" \ coc#refresh()
" 
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" 
" " 在某一个选项时，输入回车表示选中，而不是输入回车
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
"       \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" 
" " 在空白位置强制打开自动补全列表
" inoremap <silent><expr> <c-o> coc#refresh()
" " }}}
" 
" " 转上一个/下一个错误
" " 使用 `:CocDiagnostics` 获取当前buffer的所有错误列表
" nmap <silent><nowait> <leader>k <Plug>(coc-diagnostic-prev)
" nmap <silent><nowait> <leader>j <Plug>(coc-diagnostic-next)
" 
" " 转定义、声明、实现、引用
" nmap <silent><nowait> gd <Plug>(coc-definition)
" nmap <silent><nowait> gy <Plug>(coc-type-definition)
" nmap <silent><nowait> gi <Plug>(coc-implementation)
" nmap <silent><nowait> gr <Plug>(coc-references)
" 
" " 大K打开文档
" nnoremap <silent> K :call ShowDocumentation()<CR>
" function! ShowDocumentation()
"   if CocAction('hasProvider', 'hover')
"     call CocActionAsync('doHover')
"   else
"     call feedkeys('K', 'in')
"   endif
" endfunction
" 
" " 高亮光标下的标识符
" autocmd CursorHold * silent call CocActionAsync('highlight')
" 
" " 重命名
" nmap <leader>rn <Plug>(coc-rename)
" 
" xmap <leader>f  <Plug>(coc-format)
" nmap <leader>f  <Plug>(coc-format)
" 
" " Applying code actions to the selected code block
" " Example: `<leader>aap` for current paragraph
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)
" 
" " Remap keys for applying code actions at the cursor position
" nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" " Remap keys for apply code actions affect whole buffer
" nmap <leader>as  <Plug>(coc-codeaction-source)
" " Apply the most preferred quickfix action to fix diagnostic on the current line
" nmap <leader>qf  <Plug>(coc-fix-current)
" 
" " Remap keys for applying refactor code actions
" nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
" xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
" nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
" 
" " Run the Code Lens action on the current line
" nmap <leader>cl <Plug>(coc-codelens-action)
" 
" " 快速选中一个函数或者类的代码
" " NOTE: Requires 'textDocument.documentSymbol' support from the language server
" xmap if <Plug>(coc-funcobj-i)
" omap if <Plug>(coc-funcobj-i)
" xmap af <Plug>(coc-funcobj-a)
" omap af <Plug>(coc-funcobj-a)
" xmap ic <Plug>(coc-classobj-i)
" omap ic <Plug>(coc-classobj-i)
" xmap ac <Plug>(coc-classobj-a)
" omap ac <Plug>(coc-classobj-a)
" 
" " Remap <C-f> and <C-b> to scroll float windows/popups
" if has('nvim-0.4.0') || has('patch-8.2.0750')
"   nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"   nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"   inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
"   inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
"   vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"   vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
" endif
" 
" " Use CTRL-S for selections ranges
" " Requires 'textDocument/selectionRange' support of language server
" nmap <silent> <C-s> <Plug>(coc-range-select)
" xmap <silent> <C-s> <Plug>(coc-range-select)
" 
" " coc-explorer {{{
" nmap <silent> <leader>e <Cmd>CocCommand explorer<CR>
" " }}}
" 
" " }}}

" colorscheme {{{
colorscheme gruvbox
set background=dark
set termguicolors
highlight Normal ctermbg=NONE guibg=NONE
" }}}

" vim-gitgutter {{{
highlight! link SignColumn LineNr
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1
let g:gitgutter_set_sign_backgrounds = 1
" }}}

" airline {{{
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#overflow_marker = '…'
let g:airline#extensions#tabline#show_tab_nr = 0

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = ' '
let g:airline_right_sep = ''
let g:airline_symbols.colnr = ' ℅:'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_symbols.maxlinenr = '☰ '
let g:airline_symbols.dirty='⚡'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_alt_sep = '⮃'
let g:airline_symbols.readonly = '⭤'
let g:airline_symbols.linenr = '⭡'
" }}}

" vim-floaterm {{{
let g:floaterm_width=0.8
let g:floaterm_height=0.8
let g:floaterm_rootmarkers=['.root', '.git']
" Configuration example
let g:floaterm_keymap_new = '<leader>ta'
let g:floaterm_keymap_toggle = '<leader>tt'
let g:floaterm_keymap_kill = '<leader>tc'
autocmd FileType floaterm nnoremap <silent><buffer> <C-h> :tabprevious<CR>
autocmd FileType floaterm tnoremap <silent><buffer> <C-h> <C-\><C-n>:FloatermPrev<CR>
autocmd FileType floaterm nnoremap <silent><buffer> <C-l> :tabnext<CR>
autocmd FileType floaterm tnoremap <silent><buffer> <C-l> <C-\><C-n>:FloatermNext<CR>
" }}}

" fzf {{{
nnoremap <silent> <leader>p :FloatermNew fzf<CR>
" }}}

" indentLine {{{
let g:indentLine_defaultGroup = 'SpecialKey'
let g:indentLine_color_gui = '#504945'
let g:indentLine_char = '│'
let g:indentLine_enabled = 1
let g:vim_json_conceal=0
" }}}

autocmd FileType * setlocal formatoptions-=c formatoptions-=o
