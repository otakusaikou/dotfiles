" vi非互換モードに設定
set nocompatible

" Dein ベースを設定 (必須)
let s:dein_base = '/usr/local/google/home/scottlschen/.vim/dein'

" Dein ソースを設定 (必須)
let s:dein_src = '/usr/local/google/home/scottlschen/.vim/dein/repos/github.com/Shougo/dein.vim'

" Dein 実行パスを設定 (必須)
execute 'set runtimepath+=' . s:dein_src

" Deinの初期化 (必須)
call dein#begin(s:dein_base)

call dein#add(s:dein_src)

" ここからプラグインを指定していく
"call dein#add('Shougo/neosnippet.vim')
"call dein#add('Shougo/neosnippet-snippets')

" かっこいいステータスライン
call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')

" python PEP8コーディングスタイルチェックプラグイン
call dein#add('nvie/vim-flake8')

" 構文エラーをチェックするプラグイン
" call dein#add('kevinw/pyflakes-vim')

" ディレクトリツリーを表示するプラグイン
call dein#add('scrooloose/nerdtree')

" 入力自動補完プラグイン
call dein#add('Valloric/YouCompleteMe')
call dein#add('honza/vim-snippets')
call dein#add('SirVer/ultisnips')
call dein#add('vim-scripts/javacomplete')
call dein#add('davidhalter/jedi-vim')

" 括弧自動補完プラグイン
call dein#add('jiangmiao/auto-pairs')

" アンドゥツリープラグイン
call dein#add('mbbill/undotree')

" コマンドを連続で入力するプラグイン
call dein#add('kana/vim-submode')

" カラーテーマ
call dein#add('altercation/vim-colors-solarized')

" Deinの初期化完了 (必須)
call dein#end()

" ファイルタイプの対応のプラグイン、インデント設定を自動で検出し、読み込むようにする
if has('filetype')
  filetype indent plugin on
endif

" 起動時にインストールされていないプラグインをインストールする場合は、コメントを外してください
"if dein#check_install()
" call dein#install()
"endif
"
"====================基本的な設定====================
"----------履歴保存関係
" 情報保存の行数を50に限定
set viminfo='20,\"50

" コマンド,検索履歴の上限値を50に限定
set history=50

" ファイルを保存するときにアンドゥファイル情報を保存
set undofile

" アンドゥ情報の保存先
if !isdirectory(expand('$HOME/.vim/tmp/undo'))
    call mkdir(expand('$HOME/.vim/tmp/undo'), 'p')
endif
set undodir=$HOME/.vim/tmp/undo

" バックアップファイルを作らない
set nobackup

" 前回終了したカーソル行に移動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

"----------検索関係
" 一文字入力するたびに一致する候補を絞りこんでいく
set incsearch

" 検索の時に大文字小文字を区別しない
set ignorecase

" 検索の結果をハイライト表示
set hlsearch

"----------インデント
" タブ入力を複数の空白に置き換える
set expandtab

" タブ文字が占める空白の幅
set tabstop=4

" タブキーやバックスペースキーでカーソルが動く幅
set softtabstop=4

" 自動インデントを有効化
set autoindent

" 自動インデントの際にずれる空白の幅
set shiftwidth=4

" 行頭でタブを入力するとshiftwidthで定義した数の空白を入力
set smarttab

"----------その他
" コマンドラインのファイル名補完
set wildmenu

" コマンドラインでの補完を開始するキーをタブキーにする
set wildchar=<tab>

" エラーメッセージの表示時にビープを鳴らさない
set visualbell t_vb=
set noerrorbells

" ヤンクしたテキストをクリップボードにコピー
let s:uname=system("uname -s")
if s:uname == "Darwin\n"
    set clipboard=unnamed
else
    set clipboard=unnamedplus,autoselect
endif

" 保存されていないファイルがあるときは終了前に保存確認
" set confirm

" 保存されていないファイルがあるときでも別のファイルを開くことが出来る
set hidden

"================================================

"====================画面表示関係====================
" 行番号を表示
set number

" 画面最下行にカーソルの位置を表示
set ruler

" カーソル位置の行を常にハイライト表示
set cursorline

" カーソル位置の列を常にハイライト表示
set cursorcolumn

" ステータスラインを常に表示
set laststatus=2

" バックスペースキーでインデントを削除可能にする
" indent : 行頭の空白
" eol : 改行
" start : 挿入モード開始位置より手前の文字
set backspace=indent,eol,start

" ファイルタイプに応じて構文の色を適用
syntax enable

" カラーテーマを適用
let g:solarized_termcolors=256
set t_Co=256
set term=screen-256color
set background=dark
colorscheme solarized

" フォント設定と文字化け対策
set guifont=Consolas:h16":cSHIFTJIS

" カーソルの点滅を止める
set gcr=a:block-blinkon0

" 左右のスクロールバーを非表示
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R

" メニューとツールバーを非表示
set guioptions-=m
set guioptions-=T

"================================================

"=====================エンコード======================
" 改行コードの設定
if has('unix')
    set fileformat=unix

    " 改行コード自動判別の順番
    set fileformats=unix,dos,mac
elseif has('win32')
    set fileformat=dos
    set fileformats=dos,unix,mac
endif

" vim自身の文字コード,グローバルオプション
set encoding=utf-8

" バッファ保存時に用いる文字コード,バッファローカルオプション
set fileencoding=utf-8

" ファイルを開く時に用いる文字コード自動判別の順番,開けなかったらencodingで設定した文字コードでファイルを開く,グローバルオプション
set fileencodings=utf-8,sjis,big5,gbk,ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,,cp932,gb2312,euc-kr

" vimのメッセージの言語を英語に変更
" let $LANG='en_US'

" 日本語MSシステムのvimメッセージ文字化け対策
" let $LANG='ja_JP.UTF-8'

" gvimのメニュー言語を英語に変更
" set langmenu=en

" gvimのウィンドウのメニューと右クリックのメニューの文字化けを解決する
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

"================================================

"==================キーボードショートカット==================
" Leaderキー
let mapleader=';'

" jjを押すと挿入モードから抜ける
imap jj <esc>

" オムニ補完を行う
imap <Leader>c <c-x><c-o>

" jjを押すとコマンドラインモードから抜ける
cno jj <c-c>

" 行頭、行末移動
nmap <Leader>b 0
nmap <Leader>e $

" 分割したウィンドウあるいはvimを終了
nmap <Leader>q :q<CR>

" vimを強制終了
nmap <Leader>Q :qa!<CR>

" ファイルを保存
nmap <Leader>w :w<CR>

" すべてのファイルを保存
nmap <Leader>WQ :wa<CR>:q<CR>

" ペーストモードに切り替え
nmap <Leader>p :set paste<CR>

" ペーストモードを無効にする
nmap <Leader>np :set nopaste<CR>

" 下のウィンドウに移動
map <c-j> <c-w>j

" 上のウィンドウに移動
map <c-k> <c-w>k

" 右のウィンドウに移動
map <c-l> <c-w>l

" 左のウィンドウに移動
map <c-h> <c-w>h

" 分割したウィンドウの拡大と縮小(プラグインvim-submodeが必要)
" 分割ウィンドウの幅を増やす
call submode#enter_with('winsize', 'n', '', '<C-w>L', '<C-w>>')
call submode#map('winsize', 'n', '', 'L', '<C-w>>')

" 分割ウィンドウの幅を減らす
call submode#enter_with('winsize', 'n', '', '<C-w>H', '<C-w><')
call submode#map('winsize', 'n', '', 'H', '<C-w><')

" 分割ウィンドウの高さを増やす
call submode#enter_with('winsize', 'n', '', '<C-w>K', '<C-w>-')
call submode#map('winsize', 'n', '', 'K', '<C-w>-')

" 分割ウィンドウの高さを減らす
call submode#enter_with('winsize', 'n', '', '<C-w>J', '<C-w>+')
call submode#map('winsize', 'n', '', 'J', '<C-w>+')

" ディレクトリツリーを開く/閉じる
map <Leader>n :NERDTreeToggle<CR>

" アンドゥツリーを開く/閉じる
nnoremap <F5> :UndotreeToggle<CR>

" 末尾の無駄なスペースを自動削除
nnoremap <silent> <F6> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

" 次のバッファに切り替える
map <Leader>a :bn<cr>

" 前のバッファに切り替える
map <Leader>s :bp<cr>

" 今のバッファを削除
map <Leader>d :bw<cr>

" vimrcの再読み込み
map <Leader>r :so $MYVIMRC<CR>

" vimrcを開ける
map <Leader>rc :e $MYVIMRC<CR>

" gvimrcを開ける
map <Leader>rgc :e $MYGVIMRC<CR>

" pythonスクリプトの実行
autocmd BufNewFile,BufRead *.py map <F9> :w<CR>:!python3 %<CR>

" flake8でpythonコーディングスタイルチェックを実行
autocmd BufNewFile,BufRead *.py map <leader>c :call flake8#Flake8()<CR>
autocmd BufNewFile,BufRead *.py map <leader>C :call flake8#Flake8UnplaceMarkers()<CR>

" Javaプログラムをコンパイル
autocmd FileType java :map <F8> :!javac %<CR>

" コンパイルされたJavaプログラムを実行
autocmd FileType java :map <F9> :!java %<<CR>

" C/C++プログラムをコンパイル
autocmd FileType c,cpp :map <F8> :!make clean<CR>:!make %<<CR>

" コンパイルされたC/C++プログラムを実行
autocmd FileType c,cpp :map <F9> :!./%<<CR>

" Altキーをターミナルのメタキーとして使う
let c='a'
while c <= 'z'
  exec "set <A-".c.">=\e".c
  exec "imap \e".c." <A-".c.">"
  let c=nr2char(1+char2nr(c))
endw

" マッピングされたキー列の反応時間を50ミリ秒に短縮
set timeout ttimeoutlen=50

"================================================

"====================プラグィン関係====================
"----------vim-flake8
" コーディングスタイルエラーを行番号にマーク
let g:flake8_show_in_gutter=1

" コーディングスタイルエラーをハイライト表示
let g:flake8_show_in_file=1

" ハイライトグループを指定する
highlight link Flake8_Error      Error
highlight link Flake8_Warning    WarningMsg
highlight link Flake8_Complexity WarningMsg
highlight link Flake8_Naming     WarningMsg
highlight link Flake8_PyFlake    WarningMsg

"----------pyflakes-vim
" pyflakes-vimのquickfix機能を無効化
" let g:pyflakes_use_quickfix=0

"----------vim-airline
let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=1

" airlineのテーマ
let g:airline_theme='base16'

"----------YouCompleteMe
" YouCompleteMe初期設定スクリプトを読み込む
let g:ycm_global_ycm_extra_conf=expand('$HOME/.vim/dein/repos/github.com/Valloric/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py')

" 初期設定スクリプト適用前の確認を無効化
let g:ycm_confirm_extra_conf=0

" Ctrl+n or Ctrl+pキーでポップアップメニューを次の候補に進む
let g:ycm_key_list_select_completion=['<C-n>', '<C-j>']

" Ctrl+p or Ctrl+kキーでポップアップメニューを前の候補に戻る
let g:ycm_key_list_previous_completion=['<C-p>', '<C-k>']

" シンタックスをキャッシュするときの最小文字数を2にする
let g:ycm_min_num_of_chars_for_completion=2

" オムニ補完のキャッシュ機能を無効化
let g:ycm_cache_omnifunc=0

" 識別子補完機能を有効化
let g:ycm_seed_identifiers_with_syntax=1

" コメント内の自動補完を有効化
let g:ycm_complete_in_comments=1

" 左側のガーターエリアを隠す
let g:ycm_enable_diagnostic_signs=0

" 関数補完の後、自動的に説明プレビューウィンドウを閉じる
let g:ycm_autoclose_preview_window_after_completion = 1

"----------Ultisnips
" YCMとの衝突を解決
function! g:UltiSnips_Complete()
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res == 0
        " ポップアップメニューが開いていない時、ポップアップメニューを開き、次の候補に進む
        if pumvisible()
            return "\<C-n>"
        " ポップアップが開いていたら次の補完候補に進む
        else
            call UltiSnips#JumpForwards()
            if g:ulti_jump_forwards_res == 0
               return "\<TAB>"
            endif
        endif
    endif
    return ""
endfunction
au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"

" Ultisnipのキーバインド
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

"----------vim-snippets
" snipMateとの互換性を有効化
"let g:neosnippet#enable_snipmate_compatibility=1

" snipMate用スニペット集の場所を指定
let g:neosnippet#snippets_directory=expand('$HOME/.vim/dein/repos/github.com/honza/vim-snippets/snippets')

"----------jedi-vim
" Pydocを表示
let g:jedi#documentation_command='K'

" 変数の宣言場所へジャンプ
let g:jedi#goto_assignments_command='<leader>g'

" . で補完が始まるという設定を解除
let g:jedi#popup_on_dot=0

" 使われてないコマンドを無効化
let g:jedi#goto_definitions_command=''
let g:jedi#goto_command=''
let g:jedi#usages_command=''
let g:jedi#rename_command=''

" タブキーで次の補完候補に進む(コンフリクトあり、効かない)
let g:jedi#use_tabs_not_buffers=1

" ポップアップを表示しない
autocmd FileType python,c,cpp setlocal completeopt-=preview

"================================================
