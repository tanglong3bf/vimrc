" 可以用zM zR zo zc等命令来操作折叠，默认没有折叠
" coc相关配置（位于./.vim/plugin.vim文件中）已被注释，使用时应该先解开这段注释
source ~/.vim/init.vim

" 基础配置 {{{

set ignorecase
set smartcase

set iskeyword-=_

set ruler " 右下始终显示当前光标位置
set nu " 显示当前行行号
set rnu " 非当前行显示与当前行的距离
set cul " 高亮当前行
set cuc " 高亮当前列

set makeprg=make\ -j16

" 快速编辑配置文件
nnoremap <silent> <leader>ev :tabnew $HOME/.vimrc<CR>
" 在不退出vim的前期下让配置文件生效
nnoremap <silent> <leader>sv :source $HOME/.vimrc<CR>

" 透明背景，帅的雅痞
au FileType * hi Normal guibg=NONE ctermbg=NONE
" }}}

" 配色方案
colorscheme gruvbox
set background=dark

" markdown里对指定语言高亮
let g:markdown_fenced_languages = [
  \'cpp'
\]

set makeprg=make\ -j8

" 只在wsl有用
vmap "+y : !/mnt/c/Windows/System32/clip.exe<cr>u

nnoremap <C-T> :tab term<CR>

" 显示空格和tab
set list
set listchars=tab:>-,space:.

set matchpairs+=<:>
