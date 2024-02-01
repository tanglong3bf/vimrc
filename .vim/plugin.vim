call plug#begin()
Plug 'yegappan/mru' " 最近编辑文件
Plug 'tpope/vim-eunuch' " 提供一些末行命令
Plug 'mg979/vim-visual-multi' " 多光标编辑
Plug 'tpope/vim-surround' " 选中内容两端添加字符
Plug 'tpope/vim-repeat' " .可以重复插件命令
Plug 'gcmt/wildfire.vim' " 快捷的选中一段内容
Plug 'neoclide/coc.nvim', {'branch': 'fix/inlayHint-buffer-debounce'} " 代码补全
Plug 'morhetz/gruvbox' " 配色方案
Plug 'honza/vim-snippets' " 代码片段，需要配合coc-snippets，coc-snippets在它自
                          " 己的配置里有一个数组，可以自动安装
Plug 'mattn/emmet-vim' " html/css
Plug 'majutsushi/tagbar' " 侧边栏显示当前文件的类、函数、全局变量
Plug 'junegunn/fzf', {'do': 'yes \| ./install'}
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree' " 侧边栏文件列表
Plug 'skywind3000/asyncrun.vim' " 异步支持
Plug 'tanglong3bf/csp-vim-syntax'  " csp文件语法高亮
Plug 'lervag/vimtex'
Plug 'tpope/vim-fugitive' " 更快捷的git操作
Plug 'airblade/vim-gitgutter' " git侧边栏显示
Plug 'vim-airline/vim-airline'
Plug 'mbbill/undotree' " 对于undotree的可视化
Plug 'puremourning/vimspector' " 调试
Plug 'vim-utils/vim-alt-mappings' " 启用 alt 键映射
Plug 'preservim/nerdcommenter' " 注释
call plug#end()

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

" nerdtree {{{
nnoremap <F3> :NERDTreeToggle<CR>

" 忽略掉的目录
let g:NERDTreeIgnore = ['.git', 'node_modules', 'dist', 'build']
" }}}

" tagbar {{{
" 开关 Tagbar 插件的键映射
nnoremap <F9>      :TagbarToggle<CR>
inoremap <F9> <C-O>:TagbarToggle<CR>
" }}}

let s:root_dir_tag = [
      \ '.git'
      \ , 'build'
      \ ]
let s:root_file_tag = [
      \ '.root'
      \ ]
" 获取当前项目的根目录
" 从当前目录开始向上逐层查找指定目录或文件，前几行指定的数组
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

nnoremap <SHIFT-F5>  :if g:asyncrun_status != 'running'<bar>
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

nnoremap <F7>  :exec vimspector#Continue()<CR>

" }}}

" fzf {{{
nnoremap <F8> :execute 'Files ' FindRoot()<CR>

let $FZF_DEFAULT_COMMAND='find . \( -name node_modules -o -name .git \) -prune -o -print'
" }}}

" " coc {{{
" let g:coc_disable_startup_warning = 1
" 
" let g:coc_global_extensions = ['coc-marketplace']
" 
" " 下列lsp通过:CocList marketplace来进行安装
" " coc-clangd coc-volar coc-vimlsp
" 
" set hidden
" set nobackup
" set nowritebackup
" set updatetime=100
" set shortmess+=c
" set signcolumn=yes " 左边如何显示
" 
" " tab自动补全 {{{
" function! CheckBackspace() abort
" let col = col('.') - 1
" return !col || getline('.')[col - 1] =~# '\s'
" endfunction
" inoremap <silent><expr> <TAB>
" \ pumvisible() ? "\<C-n>" :
" \ CheckBackspace() ? "\<TAB>" :
" \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" 
" " 在某一个选项时，输入回车表示选中，而不是输入回车
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
      " \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" 
" " 在空白位置强制打开自动补全列表
" inoremap <silent><expr> <leader>o coc#refresh()

" " }}}
" 
" " 编程相关 {{{
" " 跳转到错误
" nmap <silent> [g <Plug>(coc-diagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)
" 
" " 跳转到定义、实现、引用
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)
" 
" " 高亮光标下函数或变量或别的什么东西的所有引用
" autocmd CursorHold * silent call CocActionAsync('highlight')
" 
" " 重命名
" nmap <leader>rn <Plug>(coc-rename)
" 
" " 代码格式化
" xmap <leader>f  <Plug>(coc-format)
" nmap <leader>f  <Plug>(coc-format)
" 
" augroup mygroup
" autocmd!
" " Setup formatexpr specified filetype(s).
" autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
" " Update signature help on jump placeholder.
" autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" augroup end
" " }}}

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
let g:airline_right_sep = '"'
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
