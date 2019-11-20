source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

"set writebackup
set nobackup
set noswapfile
set noundofile

"set encoding=cp932
"set fileencodings=ucs-bom,utf-8,cp932,euc-jp,shift_jis,iso-2022-jp,cp936,gb2312,gb18030,big5,euc-kr,latin1
"set encoding=japan
"set fileencodings=ucs-bom,utf-8,cp932,iso-2022-jp,euc-jp,sjis,cp936,gb2312,gb18030,big5,euc-kr,latin1
"
set encoding=utf-8
set langmenu=zh_CN.utf-8
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
language messages zh_CN.utf-8
set fileencodings=ucs-bom,utf-8,cp932,iso-2022-jp,euc-jp,sjis,cp936,gb2312,gb18030,big5,euc-kr,latin1
set fileformats=dos,unix,mac

set tabstop=4
set shiftwidth=4
set nu
colorscheme torte
syntax on
set autochdir

set listchars=tab:>-,trail:-,eol:$,nbsp:%,extends:>,precedes:<

set browsedir=buffer

"set clipboard+=unnamed

let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1
let Tlist_WinWidth=30

let NERDTreeWinSize=30
let NERDTreeWinPos="right"

function! LoadCscope()
	if (executable("cscope") && has("cscope"))
		let s:CurrentDir = getcwd()
		if filereadable("cscope.out")
"			let s:CscopeAddString = "cs add " . s:CurrentDir . "/cscope.out" . " ". s:CurrentDir
			let s:CscopeAddString = "cs add " . s:CurrentDir . "/cscope.out" . " ". s:CurrentDir . " -C"
			execute s:CscopeAddString
		else
			let UpperPath=findfile("cscope.out", ".;")
			if (!empty(UpperPath))
				let path = strpart(UpperPath, 0, match(UpperPath, "cscope.out$") - 1)
				if (!empty(path))
					let s:CurrentDir = getcwd()
					"Bugfix: the strpart function can't match the string which contains character '/' 
					"let direct = strpart(s:CurrentDir, 0, match(s:CurrentDir, path) - 1)
					let direct = strpart(s:CurrentDir, 0, 2)
					let s:FullPath = direct . path
					let s:AFullPath = globpath(s:FullPath, "cscope.out")
"					let s:CscopeAddString = "cs add " . s:AFullPath . " " . s:FullPath
					let s:CscopeAddString = "cs add " . s:AFullPath . " " . s:FullPath . " -C"
					execute s:CscopeAddString
				endif
			endif
		endif

		if filereadable("tags")
" 2018-01-04
" The standard using way is like: [set tags=ctags;], so notice that the ";" at
" the end of statement. Or the ctags command will not excecuted correctly.
"			let s:CtagsAddString = "set tags=" . s:CurrentDir . "/tags"
			let s:CtagsAddString = "set tags=" . s:CurrentDir . "/tags;"
			execute s:CtagsAddString
		else
			let UpperPath=findfile("tags", ".;")
			if (!empty(UpperPath))
				let path = strpart(UpperPath, 0, match(UpperPath, "tags$") - 1)
				if (!empty(path))
					let s:CurrentDir = getcwd()
					let direct = strpart(s:CurrentDir, 0, match(s:CurrentDir, path) - 1)
					let s:FullPath = direct . path
					let s:AFullPath = globpath(s:FullPath, "tags")
" 2018-01-04
" The standard using way is like: [set tags=ctags;], so notice that the ";" at
" the end of statement. Or the ctags command will not excecuted correctly.
"					let s:CtagsAddString = "set tags=" . s:AFullPath
					let s:CtagsAddString = "set tags=" . s:AFullPath . ";"
					execute s:CtagsAddString
				endif
			endif
		endif
	endif
endfunction
command LoadCscope call LoadCscope()

""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree
" https://stackoverflow.com/questions/7692233/nerdtree-reveal-file-in-tree
" http://vimcdoc.sourceforge.net/doc/autocmd.html
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Check if NERDTree is open or active
function! IsNERDTreeOpen()        
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif

endfunction

" Highlight currently open buffer in NERDTree
"autocmd BufEnter * call SyncTree()
"""""""""""""""""""""""""""""""""""""""
" BufWinEnter for the windows gvim use
autocmd BufWinEnter * call SyncTree()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! MapNERDTree()
		NERDTree 
	"wincmd p
	"wincmd w
endfunction
command  Nt call MapNERDTree()
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p
""""""""""""""""""""""""""""""""""""""""""""""""""""
" Force the quickfix window ocuppy the full width of the bottom
au FileType qf wincmd J

""""""""""""""""""""""""""""""""""""""""""""""""""""
"Link: https://blog.csdn.net/G_BrightBoy/article/details/19498983
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
let OmniCpp_SelectFirstItem = 2
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

