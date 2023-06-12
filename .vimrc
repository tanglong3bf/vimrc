" 基础配置 {{{
set enc=utf-8
set nocompatible
source $VIMRUNTIME/vimrc_example.vim

set mouse=nvi

set ignorecase
set smartcase

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

nnoremap <silent> <leader>ev :tabnew $HOME/.vimrc<CR>
nnoremap <silent> <leader>sv :source $HOME/.vimrc<CR>
" }}}

let s:root_dir_tag = [
      \ '.git'
      \ , 'build'
      \ ]
let s:root_file_tag = [
      \ '.root'
      \ ]
" 获取当前项目的根目录
" 从当前目录开始向上逐层查找指定目录或文件
" 一直没找到，就直接返回当前目录
function! FindRoot()
  let current_dir = getcwd()
  while current_dir != '/'
    let list = readdir(current_dir)
    for item in list
      if isdirectory(current_dir . '/' . item) == 1 && index(s:root_dir_tag, item) >= 0 ||
          \ isdirectory(current_dir . '/' . item) == 0 && index(s:root_file_tag, item) >= 0
        return current_dir
      endif
    endfor
    let length = strridx(current_dir, '/')
    if length != 0
      let current_dir = strcharpart(current_dir, 0, length)
    else
      let current_dir = '/'
    endif
  endwhile
  if current_dir == '/'
    let current_dir = getcwd()
  endif
  return current_dir
endfunction

" vim-plug 管理插件{{{
call plug#begin()
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
Plug 'skywind3000/asyncrun.vim' " 异步支持
" Plug 'tanglong3bf/csp-vim-syntax'  csp文件语法高亮
Plug 'lervag/vimtex'
Plug 'tpope/vim-fugitive' " 更快捷的git操作
Plug 'airblade/vim-gitgutter' " git侧边栏显示
Plug 'vim-airline/vim-airline'
Plug 'mbbill/undotree'
call plug#end()
" }}}

colorscheme gruvbox
set background=dark

let g:markdown_fenced_languages = [
  \'cpp'
\]

" 代码缩进 {{{
au FileType c,cpp,objc  setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4 cinoptions=>4,:0,l1,g0,N-s,E-s,t0,i.5s,(s,u0,U1,w1,W4,k4,m1,j1
au FileType json        setlocal expandtab shiftwidth=2 softtabstop=2
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

" coc {{{

let g:coc_disable_startup_warning = 1

let g:coc_global_extensions = ['coc-marketplace']

set hidden
set nobackup
set nowritebackup
set updatetime=100
set shortmess+=c
set signcolumn=yes " 左边如何显示

" tab自动补全 {{{
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" 在某一个选项时，输入回车表示选中，而不是输入回车
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" 在空白位置强制打开自动补全列表
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

function! s:cocActionsOpenFromSelected(type) abort
  execute 'CocCommand actions.open ' . a:type
endfunction
xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
xmap <silent> <leader>a :<C-u>set operatorFunc=<SID>cocActionsOpenFromSelected<CR>g@

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
nmap <F3> :NERDTreeToggle<CR>
let g:NERDTreeIgnore = ['node_modules', 'dist', 'build']

nmap <Leader>r :NERDTreeFocus<cr>R<c-w><c-p>

" }}}

" 和 asyncrun 一起用的异步 make 命令
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

let g:asyncrun_open = 10

" ts
" nnoremap <F5> :AsyncRun -mode=term -reuse npm run push<CR><C-W>j<C-W>J<C-W>:resize 8<cr><C-W>k

" cpp
" 映射按键来快速启停构建 {{{
let cmakeFile = findfile("CMakeLists.txt", FindRoot() . ";")
let projectName = ''
if cmakeFile != ''
  let lines = readfile(cmakeFile)
  for line in lines
    if stridx(line, 'project') != -1
      let lp = stridx(line, '(')
      let rp = stridx(line, ' ')
      let projectName = strcharpart(line, lp+1, rp-lp)
      break
    endif
  endfor
endif

nnoremap <F5>  :if g:asyncrun_status != 'running'<bar>
                 \if &modifiable<bar>
                   \update<bar>
                 \endif<bar>
                 \let cwd = getcwd()<bar>
                 \let build = FindRoot() . '/build'<bar>
                 \exec 'chdir ' . build<bar>
                 \exec 'Make'<bar>
                 \exec 'chdir ' . cwd<bar>
               \else<bar>
                 \AsyncStop<bar>
               \endif<CR>

nnoremap <S-F5>  :if g:asyncrun_status != 'running'<bar>
                   \if &modifiable<bar>
                     \update<bar>
                   \endif<bar>
                   \let cwd = getcwd()<bar>
                   \let build = FindRoot() . '/build'<bar>
                   \exec 'chdir ' . build<bar>
                   \exec 'AsyncRun cmake ..'<bar>
                   \exec 'chdir ' . cwd<bar>
                 \else<bar>
                   \AsyncStop<bar>
                 \endif<CR>

nnoremap <F6>  :if g:asyncrun_status != 'running'<bar>
                 \if &modifiable<bar>
                   \update<bar>
                 \endif<bar>
                 \let cwd = getcwd()<bar>
                 \let build = FindRoot() . '/build'<bar>
                 \exec 'chdir ' . build<bar>
                 \exec 'AsyncRun ./' . projectName<bar>
                 \exec 'chdir ' . cwd<bar>
               \else<bar>
                 \AsyncStop<bar>
               \endif<CR>

" packadd termdebug
" nnoremap <F7> :Termdebug<CR> <C-W>j<C-W>j<C-W>L<C-W>
" }}}

" 用于 quickfix、标签和文件跳转的键映射
nmap <F11>   :cn<CR>
nmap <F12>   :cp<CR>
nmap <M-F11> :copen<CR>
nmap <M-F12> :cclose<CR>
nmap <C-F11> :tn<CR>
nmap <C-F12> :tp<CR>
nmap <S-F11> :n<CR>
nmap <S-F12> :prev<CR>

set makeprg=make\ -j8

" 只在wsl有用
vmap "+y : !/mnt/c/Windows/System32/clip.exe<cr>u

" fzf {{{

nnoremap <F8> :execute 'Files ' FindRoot()<CR>

let $FZF_DEFAULT_COMMAND='find . \( -name node_modules -o -name .git \) -prune -o -print'

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

" }}}

nnoremap <C-T> :tab term<CR>
