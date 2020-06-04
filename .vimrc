runtime! archlinux.vim


"-----------------------------------------------------------------------------------------------
"开启默认设置
		"indention option"
		set autoindent " New lines inherit the indentation of previous lines.
		set expandtab " Convert tabs to spaces.
		filetype plugin indent on " Enable indentation rules that are file-type specific.
        set shiftround " When shifting lines, round the indentation to the nearest multiple of “shiftwidth.”
        set shiftwidth=4 " When shifting, indent using four spaces.
        set smarttab " Insert “tabstop” number of spaces when the “tab” key is pressed.
		set tabstop=4 " Indent using four spaces.
		set softtabstop=4
		set textwidth=140

      	"search option"
		set hlsearch " Enable search highlighting.
		set ignorecase " Ignore case when searching.
		set incsearch " Incremental search that shows partial matches.
		set smartcase " Automatically switch search to case-sensitive when search query contains an uppercase letter.

      	"performance optimize"
      	""set complete-=i " Limit the files searched for auto-completes.
      	""set lazyredraw " Don’t update screen during macro and script execution.

      	"text rendering option"
      	set display+=lastline " Always try to show a paragraph’s last line.
		set fileencodings=utf-8,gb18030,gbk "windows使用的是gbk编码，linux使用的是utf-8编码。解决windows上保存的文件在vim打开乱码的问题
		""set encoding=utf-8 " Use an encoding that supports unicode.
		set linebreak " Avoid wrapping a line in the middle of a word.
		set scrolloff=1 " The number of screen lines to keep above and below the cursor.                                        
		set sidescrolloff=5 " The number of screen columns to keep to the left and right of the cursor.
		syntax enable " Enable syntax highlighting.
		set wrap " Enable line wrapping.

		"user interface option"
		set laststatus=2 " Always display the status bar.
		set ruler " Always show cursor position.
		set wildmenu " Display command line’s tab complete options as a menu.
		set tabpagemax=50 " Maximum number of tab pages that can be opened from the command line.
		set cursorline " Highlight the line currently under cursor.
		set number " Show line numbers on the sidebar.
		set relativenumber " Show line number on the current line and relative numbers on all other lines.
		set errorbells " enable beep on errors.
		set mouse=a " Enable mouse for scrolling and resizing.
		set title " Set the window’s title, reflecting the file currently being edited.

		"code folding option"
		set foldmethod=indent " Fold based on indention levels.
		""set fdm=marker "设置标志折叠{{{ }}}
		set foldnestmax=3 " Only fold up to three nested levels.
		set nofoldenable " Disable folding by default.

		"Miscellaneous Options"
		set autoread " Automatically re-read files if unmodified inside Vim.
		set backspace=indent,eol,start " Allow backspacing over indention, line breaks and insertion start.
		set confirm " Display a confirmation dialog when closing an unsaved file.
		set formatoptions+=j " Delete comment characters when joining lines.
		set nomodeline " Ignore file’s mode lines; use vimrc configurations instead.
		set nrformats-=octal " Interpret octal as decimal when incrementing numbers.
		""set spell " Enable spellchecking.
		set wildignore+=.pyc,.swp " Ignore files matching these patterns when opening files based on a glob pattern.

		set linespace=6
		""set showcmd

"-----------------------------------------------------------------------------------------------
"colorscheme desert
		hi CursorLine cterm=NONE ctermbg=black ctermfg=NONE guibg=NONE guifg=NONE
		hi LineNr term=underline ctermfg=lightblue ctermbg=black
		hi cursorLineNr term=underline ctermbg=black ctermfg=red

"-----------------------------------------------------------------------------------------------
"map
		"设置自动给单词添加括号
				:map S :shell<Return> 
				:map \p i(<Esc>lxep
				:map \c i{<Esc>lxep
				:map \" bi"<Esc>lxep
				:map \' bi'<Esc>lxep
				:map \( bi(<Esc>lxep)
				:map \{ bi{<Esc>lxep}
				:map \[ bi[<Esc>lxep]
				:map <C-CR> :w<CR>,r
		"设置自动补全括号
		   "" 	inoremap ' ''<ESC>i
		   "" 	inoremap " ""<ESC>i
		   "" 	inoremap ( ()<ESC>i
		   "" 	inoremap [ []<ESC>i
		   "" 	inoremap { {}<ESC>i
		   "" 	inoremap < <><ESC>i

        "自动保存以及运行python
				inoremap <C-CR> <ESC>:w<CR>,r   
        "运行脚本
				:map \r :w<Return>:!./%
        "添加注释
                :map \3 I#<ESC>
                :map \# :s/^/#/g<Return>/<Return>
		"设置/Enter关闭hlsearch的高亮
				noremap /<CR> :nohlsearch<CR>
		"设置>来缩进代码块
				vnoremap > >gv
				vnoremap < <gv
		"自动加载保存vimrc
				autocmd! bufwritepost .vimrc source %
				

"-----------------------------------------------------------------------------------------------
"use vim-plug to manage plugin|所有插件都放在这个里面
		call plug#begin('~/.vim/plugged')
		Plug 'vim-airline/vim-airline' "底部状态栏
		Plug 'vim-airline/vim-airline-themes' "底部状态栏主题
		Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } "文件管理器,文件目录树
		Plug 'connorholyday/vim-snazzy' "vim主题
		Plug 'lilydjwg/colorizer' "颜色代码直接显示颜色
		Plug 'kien/rainbow_parentheses.vim' "彩虹括号
		Plug 'Yggdroot/indentLine' "python代码分隔线
""		Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' } "用来提供python语法检查
        "Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --system-libclang' } "自动补全
        Plug 'mattn/emmet-vim'
        Plug 'jiangmiao/auto-pairs'
		call plug#end()

"-----------------------------------------------------------------------------------------------
"airline theme's setting
		"let g:airline_theme='bubblegum'
		let g:airline_theme='deus'
		let g:airline#extensions#tabline#enabled = 1
		let g:airline#extensions#tabline#left_sep = ' '
		let g:airline#extensions#tabline#left_alt_sep = '|'
		let g:airline#extensions#tabline#formatter = 'default'
		let g:airline_powerline_fonts = 1

"-----------------------------------------------------------------------------------------------
"python indent line more beautiful
		let g:indentLine_char_list = ['|', '¦', '┆', '┊']

"let pymode use python3
""		let g:pymode_python = 'python3'
"remap leader key and can run python with ,r
		let mapleader = ","
"-----------------------------------------------------------------------------------------------
"theme
		colorscheme snazzy
		"transparent
		let g:SnazzyTransparent = 1
		" enable lightline
		let g:lightline = {
		\ 'colorscheme': 'snazzy',
		\ }

"-----------------------------------------------------------------------------------------------
"---------------"自定义tab补全路径功能，而不需要按ctrl+x,ctrl+f这么麻烦----------
		map <C-n> :NERDTreeToggle<CR>
"		inoremap <tab> <c-r>=Smart_TabComplete()<CR>
"
"		function! Smart_TabComplete()
"		  let line = getline('.')                         " current line
"
"		  let substr = strpart(line, -1, col('.')+1)      " from the start of the current
"														  " of the cursor
"		  let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
"		  if (strlen(substr)==0)                          " nothing to match on empty string
"			return "\<tab>"
"		  endif
"		  let has_period = match(substr, '\.') != -1      " position of period, if any
"		  let has_slash = match(substr, '\/') != -1       " position of slash, if any
"		  if (!has_period && !has_slash)
"			return "\<C-X>\<C-P>"                         " existing text matching
"		  elseif ( has_slash )
"			return "\<C-X>\<C-F>"                         " file matching
"		  else
"			return "\<C-X>\<C-O>"                         " plugin matching
"		  endif
"		endfunction
"-----------------------------------------------------------------------------------------------
"设置括号颜色
		let g:rbpt_colorpairs = [
			\ ['brown',       'RoyalBlue3'],
			\ ['Darkblue',    'SeaGreen3'],
			\ ['darkgray',    'DarkOrchid3'],
			\ ['darkgreen',   'firebrick3'],
			\ ['darkcyan',    'RoyalBlue3'],
			\ ['darkred',     'SeaGreen3'],
			\ ['darkmagenta', 'DarkOrchid3'],
			\ ['brown',       'firebrick3'],
			\ ['gray',        'RoyalBlue3'],
			\ ['darkmagenta', 'DarkOrchid3'],
			\ ['Darkblue',    'firebrick3'],
			\ ['darkgreen',   'RoyalBlue3'],
			\ ['darkcyan',    'SeaGreen3'],
			\ ['darkred',     'DarkOrchid3'],
			\ ['red',         'firebrick3'],
			\ ]

		let g:rbpt_max = 16
		let g:rbpt_loadcmd_toggle = 0
		au VimEnter * RainbowParenthesesToggle
		au Syntax * RainbowParenthesesLoadRound
		au Syntax * RainbowParenthesesLoadSquare
		au Syntax * RainbowParenthesesLoadBraces





"used to automatically generate ctags when save buffer to file
		""au BufWritePost *.sh,*.py silent! !ctags -R &


"used to change vim cursor shape depend on different mode
		""let &t_SI = "\e[5 q"
		""let &t_EI = "\e[2 q"
		""" optional reset cursor on start:
		""augroup myCmds
		""au!
		""au VimEnter * silent !echo -ne "\e[2 q"
		""au VimLeave * silent !echo -ne "\e[5 q"
		""augroup END

		"Ps = 0  -> blinking block.
		"Ps = 1  -> blinking block (default).
		"Ps = 2  -> steady block.
		"Ps = 3  -> blinking underline.
		"Ps = 4  -> steady underline.
		"Ps = 5  -> blinking bar (xterm).
		"Ps = 6  -> steady bar (xterm).
		"which can change the cursor color but can not change shape
		""let &t_SI = "\<Esc>]12;red\x7"
		""let &t_EI = "\<Esc>]12;orange\x7"
		""au VimLeave * silent !echo -ne "\e[5 q"
