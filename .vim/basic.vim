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

" 禁用backup文件
set nobackup
" 添加跨会话撤销功能
set undodir=~/.vim/undodir
" 跨会话撤销要保存的文件所存储的目录
if !isdirectory(&undodir)
  call mkdir(&undodir, 'p', 0700)
endif

" 添加鼠标支持
set mouse=nvi

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

" 启用 man 插件
source $VIMRUNTIME/ftplugin/man.vim

set keywordprg=:Man

aug QFClose
  au!
  au WinEnter *  if winnr('$') == 1 && &buftype == "quickfix"|q|endif
aug END
