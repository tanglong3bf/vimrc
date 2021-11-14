" 基础配置 {{{
set enc=utf-8
set nocompatible
source $VIMRUNTIME/vimrc_example.vim

set mouse=nvi

set nobackup
set undodir=~/.vim/undodir
if !isdirectory(&undodir)
  call mkdir(&undodir, 'p', 0700)
endif

set fileencodings=ucs-bom,utf-8,gb18030,latin1

set ruler " 右下始终显示当前光标位置
set nu " 显示当前行行号
set rnu " 非当前行显示与当前行的距离
set cul " 高亮当前行
set cuc " 高亮当前列

set scrolloff=0

let do_syntax_sel_menu = 1
let do_no_lazyload_menus = 1


" 停止搜索高亮的键映射
nnoremap <silent> <F2>      :nohlsearch<CR>
inoremap <silent> <F2> <C-O>:nohlsearch<CR>

set makeprg=make\ -j16

nnoremap <leader>ev <Cmd>tabnew $HOME/.vimrc<CR>
nnoremap <leader>sv <Cmd>source $HOME/.vimrc<CR>
" }}}

" vim-plug 管理插件{{{
call plug#begin()
Plug 'yianwillis/vimcdoc' " 中文文档
Plug 'mg979/vim-visual-multi' " 多光标编辑
Plug 'tpope/vim-surround' " 选中内容两端添加字符
Plug 'tpope/vim-repeat' " .可以重复插件命令
Plug 'gcmt/wildfire.vim' " 快捷的选中一段内容
Plug 'neoclide/coc.nvim', {'branch': 'release'} " 代码补全
Plug 'morhetz/gruvbox' " 配色方案
Plug 'honza/vim-snippets' " 代码片段，需要配合coc-snippets
Plug 'mattn/emmet-vim' " html/css 
Plug 'tpope/vim-eunuch' " 提供一些末行命令 
Plug 'yegappan/mru' " 最近编辑文件
Plug 'majutsushi/tagbar'
Plug 'junegunn/fzf', {'do': 'yes \| ./install'}
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree' " 侧边栏文件列表
Plug 'frazrepo/vim-rainbow' " 括号配对高亮显示
call plug#end()
" }}}

colorscheme gruvbox
set background=dark

let g:markdown_fenced_languages = [
  \'cpp'
  \]

" 代码缩进 {{{
au FileType c,cpp,objc  setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=2 cinoptions=:0,g0,(0,w1
au FileType json        setlocal expandtab shiftwidth=2 softtabstop=2
au FileType vim         setlocal expandtab shiftwidth=2 softtabstop=2
au FileType html        setlocal expandtab shiftwidth=2 softtabstop=2
au FileType scss        setlocal expandtab shiftwidth=2 softtabstop=2
" }}}

" 代码折叠 {{{
au FileType vim         setlocal foldmethod=marker
au FileType c,cpp       setlocal foldmethod=syntax
au FileType python      setlocal foldmethod=indent
" }}}


if !has('patch-8.0.210')
  "  进入插入模式时启用括号粘贴模式
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

" coc {{{
let g:coc_global_extensions = [
      \'coc-marketplace',
      \'coc-yaml',
      \'coc-xml',
      \'coc-vimlsp',
      \'coc-sql',
      \'coc-snippets',
      \'coc-phpls',
      \'coc-json',
      \'coc-html',
      \'coc-cmake',
      \'coc-clangd',
      \]
set hidden
set nobackup
set nowritebackup
set updatetime=100
set shortmess+=c
set signcolumn=yes " 左边如何显示

" tab自动补全 {{{
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" 在某一个选项时，输入回车表示选中，而不是输入回车
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" 在空白位置强制打开自动补全列表，貌似只在非行首有用
inoremap <silent><expr> <leader>o coc#refresh()
  
" }}}

" 编程相关 {{{
" 跳转到错误
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" 跳转到定义实现引用
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" 高亮光标下函数或变量或别的什么东西的所有引用
autocmd CursorHold * silent call CocActionAsync('highlight')

" 重命名变量
nmap <leader>rn <Plug>(coc-rename)

" 代码格式化
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
" }}}

" 显示文档 {{{
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
" }}}


" 类似于右键菜单
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" coc-snippets {{{
imap <C-l> <Plug>(coc-snippets-expand)
imap <C-j> <Plug>(coc-snippets-selected)
let g:coc_snippet_next = '<c-j>'
let g:coc_snippet_prev = '<c-k>'
imap <C-j> <Plug>(coc-snippets-expand-jump)
let g:snips_author = 'tanglong3bf'
" }}}

" }}}

" mru 最近编辑文件 {{{

if !has('gui_running')
  " 设置文本菜单
  if has('wildmenu')
    set wildmenu
    set cpoptions-=<
    set wildcharm=<C-Z>
    nnoremap <F10>      :emenu <C-Z>
    inoremap <F10> <C-O>:emenu <C-Z>
  endif
endif
" }}}

" tagbar {{{
" 开关 Tagbar 插件的键映射
nnoremap <F9>      :TagbarToggle<CR>
inoremap <F9> <C-O>:TagbarToggle<CR>
" }}}

" nerdtree {{{
nmap <F3> <Cmd>NERDTreeToggle<CR>
let g:NERDTreeIgnore = ['build']
" }}}

" rainbow
au BufRead * :RainbowLoad
