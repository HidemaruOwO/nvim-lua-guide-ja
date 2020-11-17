# Getting started using Lua in Neovim

## 目次
* [はじめに](#はじめに)
   * [Luaを学ぶ](#luaを学ぶ)
   * [Luaを書くための既存のチュートリアル](#luaを書くための既存のチュートリアル)
   * [関連するプラグイン](#関連するプラグイン)
* [Luaファイルを置く場所](#luaファイルを置く場所)
      * [警告](#警告)
      * [Tips](#tips)
      * [パッケージについての注意](#パッケージについての注意)
* [Vim scriptからLuaを使用する](#vim-scriptからluaを使用する)
   * [:lua](#lua)
   * [:luado](#luado)
   * [:luafile](#luafile)
      * [luafile vs require():](#luafile-vs-require)
   * [luaeval()](#luaeval)
   * [v:lua](#vlua)
      * [警告](#警告-1)
   * [Tips](#tips-1)
* [vim名前空間](#vim名前空間)
      * [Tips](#tips-2)
* [LuaからVim scriptを使用する](#luaからvim-scriptを使用する)
   * [vim.api.nvim_eval()](#vimapinvim_eval)
      * [警告](#警告-2)
   * [vim.api.nvim_exec()](#vimapinvim_exec)
   * [vim.api.nvim_command()](#vimapinvim_command)
      * [Tips](#tips-3)
* [vimオプションを管理する](#vimオプションを管理する)
   * [API関数を使用する](#api関数を使用する)
   * [メタアクセサーを使用する](#メタアクセサーを使用する)
      * [警告](#警告-3)
* [vim内部の変数を管理する](#vim内部の変数を管理する)
   * [API関数を使用する](#api関数を使用する-1)
   * [メタアクセサーを使用する](#メタアクセサーを使用する-1)
      * [警告](#警告-4)
* [Vim scriptの関数を呼び出す](#vim-scriptの関数を呼び出す)
   * [vim.call()](#vimcall)
   * [vim.fn.{function}()](#vimfnfunction)
      * [Tips](#tips-4)
      * [警告](#警告-5)
* [マッピングを定義する](#マッピングを定義する)
* [ユーザーコマンドを定義する](#ユーザーコマンドを定義する)
* [autocommandを定義する](#autocommandを定義する)
* [構文ハイライトを定義する](#構文ハイライトを定義する)
* [一般的なTipsと推奨](#一般的なtipsと推奨)
* [その他](#その他)
   * [vim.loop](#vimloop)
   * [vim.lsp](#vimlsp)
   * [vim.treesitter](#vimtreesitter)
   * [トランスパイラ](#トランスパイラ)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

## はじめに

Neovimのファーストクラス言語としてのLuaはキラー機能の1つになりつつあります。しかし、Luaでプラグインを書くための教材はVim script程多くありません。これは、Luaを始めるための基本的な情報を提供する試みです。

このガイドは最新の[nightly build](https://github.com/neovim/neovim/releases/tag/nightly)を使用していることを前提としています。Neovim 0.5は開発中で一部のAPIは正式リリース前に変更される可能性があることに注意してください。

### Luaを学ぶ

まだLuaについて詳しくない場合、学ぶためのリソースはたくさんあります。:

- [Learn X in Y minutes page about Lua](https://learnxinyminutes.com/docs/lua/)は基本的な概要を説明します。
- 動画が好きなら、Derek Banasの動画があります。[1-hour tutorial on the language](https://www.youtube.com/watch?v=iMacxZQMPXs)
- [lua-users wiki](http://lua-users.org/wiki/LuaDirectory)にはLua関連のトピックごとの便利な情報がたくさんあります。
- [official reference manual for Lua](https://www.lua.org/manual/5.1/)には最も包括的な情報があります。

Luaはとてもクリーンでシンプルな言語であることに注意してください。JavaScriptのようなスクリプト言語の経験があれば、学ぶことは簡単です。あなたはもう自分で思っているよりLuaについて知っているかもしれません！

Note: Neovimに埋め込まれているLuaはLuaJIT 2.1.0でLua 5.1(と、いくつかの5.2拡張)と互換性を維持しています。

### Luaを書くための既存のチュートリアル

Luaでプラグインを書くためのチュートリアルが既にいくつかあります。それらはこのガイドを書くのに役に立ちました。筆者に感謝します。

- [teukka.tech - init.vimからinit.luaへ](https://teukka.tech/luanvim.html)
- [2n.pl - プラグインをLuaで書く方法](https://www.2n.pl/blog/how-to-write-neovim-plugins-in-lua.md)
- [2n.pl - プラグインのUIをLuaで作る方法](https://www.2n.pl/blog/how-to-make-ui-for-neovim-plugins-in-lua)
- [ms-jpq - Neovim Async Tutorial](https://ms-jpq.github.io/neovim-async-tutorial/)

### 関連するプラグイン

- [Vimpeccable](https://github.com/svermeulen/vimpeccable) - .vimrc内でLuaを書くのに役に立つプラグイン
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) - 二度書きたくないLua関数のすべて
- [popup.nvim](https://github.com/nvim-lua/popup.nvim) - vimのPopup APIのNeovimでの実装
- [nvim_utils](https://github.com/norcalli/nvim_utils)
- [nvim-luadev](https://github.com/bfredl/nvim-luadev) - REPL/debugコンソール
- [nvim-luapad](https://github.com/rafcamlet/nvim-luapad) - 組込みLuaエンジンのインタラクティブなリアルタイムスクラッチパッド
- [nlua.nvim](https://github.com/tjdevries/nlua.nvim) - NeovimのLua開発
- [BetterLua.vim](https://github.com/euclidianAce/BetterLua.vim) - Vim/Neovimより良いシンタックスハイライト

## Luaファイルを置く場所

Luaファイルは通常、`runtimepath`にある`lua/`フォルダにあります(ほとんどの場合、\*nixでは`~/.config/nvim/lua`、Windowsでは`~/AppData/Local/nvim/lua`を意味します)。
`package.path`と`package.cpath`はこのフォルダにLuaファイルが含まれるように自動的に調整されます。
これは、Luaモジュールとして`require()`できることを意味します。

例として次のフォルダ構造を取り上げましょう。:

```text
📂 ~/.config/nvim
├── 📁 after
├── 📁 ftplugin
├── 📂 lua
│  ├── 🌑 myluamodule.lua
│  └── 📂 other_modules
│     ├── 🌑 anothermodule.lua
│     └── 🌑 init.lua
├── 📁 pack
├── 📁 plugin
├── 📁 syntax
└── 🇻 init.vim
```

次のLuaコードは`myluamodule.lua`をロードします。:

```lua
require('myluamodule')
```

`.lua`拡張子がないことに注意してください。

同様に、`other_modules/anothermodule.lua` のロードは次のように行います。:

```lua
require('other_modules.anothermodule')
-- or
require('other_modules/anothermodule')
```

パスの区切りはドット`.`またはスラッシュ`/`で示されます。

フォルダに`init.lua`が含まれている場合、ファイル名を指定せずにロードできます。

```lua
require('other_modules') -- other_modules/init.luaをロード
```

詳細は`:help lua-require`を参照してください。

#### 警告

.vimファイルと違い、.luaファイルは`runtimepath`から自動的に読み込まれません。
代りに、Vim scriptから読み込む必要があります。
`init.vim`の代りに`init.lua`をロードするオプションを追加する計画があります。:

- [Issue #7895](https://github.com/neovim/neovim/issues/7895)
- [Corresponding pull request](https://github.com/neovim/neovim/pull/12235)

#### Tips

いくつかのLuaプラグインは`lua/`フォルダ内に同じ名前のファイルがある場合があります。これにより、名前空間の衝突がおこる可能性があります。

異なる2つのプラグインに`lua/main.lua`がある場合、`require('main')`は曖昧です。: どのファイルを読み込みますか？

トップレベルのフォルダで名前空間をつけることをお勧めします。: `lua/plugin_name/main.lua`

#### パッケージについての注意

**UPDATE**: 最新のnightlyビルドを使用している場合、[問題](https://github.com/neovim/neovim/pull/13119)は解決しているので、このセクションを安全に飛ばすことができます。

`packages`機能やそれをベースとしたパッケージマネージャ([packer.nvim](https://github.com/wbthomason/packer.nvim), [minpac](https://github.com/k-takata/minpac),  [vim-packager](https://github.com/kristijanhusak/vim-packager/)等)を使用している場合、Luaプラグインを使用する際に注意することがあります。

`start`フォルダ内のパッケージは`init.vim`の後に読み込まれます。これは、Neovimの処理が終わるまで`runtimepath`にパッケージが追加されないことを意味します。
プラグインがLuaモジュールを`require`するかautoload関数を呼ぶことを期待している場合に問題を起す可能性があります。

`start/foo`に`lua/bar.lua`があるとします。`init.vim`から下記を行うと`runtimepath`がまだ更新されていないためエラーになります。:

```vim
lua require('bar')
```

モジュールを`require`する前に`packadd! foo`を行う必要があります。

```vim
packadd! foo
lua require('bar')
```

`packadd`に`!`を付けると、`plugin`または`ftdetect`のスクリプトが読みこまれず、`runtimepath`にパッケージが追加されます。

参照:
- `:help :packadd`
- [Issue #11409](https://github.com/neovim/neovim/issues/11409)

## Vim scriptからLuaを使用する

### :lua

Luaのチャンクを実行します。

```vim
:lua require('myluamodule')
```

ヒアドキュメント構文を使用すると複数行に書くことができます。:

```vim
echo "Here's a bigger chunk of Lua code"

lua << EOF
local mod = require('mymodule')
local tbl = {1, 2, 3}

for k, v in ipairs(tbl) do
    mod.method(v)
end

print(tbl)
EOF
```

参照:

- `:help :lua`
- `:help :lua-heredoc`

### :luado

このコマンドはカレントバッファの範囲行にLuaチャンクを実行します。範囲を指定しない場合、バッファ全体に作用します。
チャンクから`return`された文字列は、各行を置き換えるために使用されます。

次のコマンドは、カレントバッファのすべての行を`hello world`に置き換えます。:

```vim
:luado return 'hello world'
```

2つの暗黙的な変数`line`と`liner`が提供されます。`line`は対象行のテキストで、`liner`はその行数です。
次のコマンドは、すべての偶数行のテキストを大文字にします。

```vim
:luado if linenr % 2 == 0 then return line:upper() end
```

参照:

- `:help :luado`

### :luafile

Luaファイルを読み込みます。

```vim
:luafile ~/foo/bar/baz/myluafile.lua
```

これは、.vimファイルの`:source`コマンド、Luaの`dofile()`関数と似ています。

参照:

- `:help :luafile`

#### luafile vs require():

`lua require()`と`luafile`の違いは何か、どちらを使うべきかを疑問に思うかもしれません。
それらには異なるユースケースがあります。:

- `require()`:
    - Luaの組込み関数です。Luaのモジュールを読み込むのに使用します。
    - `package.path`変数を使ってモジュールを探します。(前述のように、`runtimepath`にある`lua/`フォルダから`requie()`することができます。)
    - どのモジュールをロードしたかを記憶し、多重に実行されるのを防ぎます。Neovim実行中に、モジュールに含まれるコードを変更し、もう一度`require()`を実行してもモジュールは更新されません。
- `:luafile`:
    - Exコマンドです。モジュールには対応していません。
    - カレンドウィンドウのカレントディレクトリに対する絶対パスか相対パスを指定します。
    - 以前に実行されたかどうかに関わらず実行されます。

`:luafile`は編集中のLuaファイルを実行することにも役立ちます。:

```vim
:luafile %
```

### luaeval()

Vim scriptの組込み関数です。文字列のLua式を評価して返します。
Luaの型は自動的にVim scriptの型に変換されます。(その逆も同様です。)

```vim
" 変数に結果を代入することができます。
let variable = luaeval('1 + 1')
echo variable
" 2
let concat = luaeval('"Lua".." is ".."awesome"')
echo concat
" 'Lua is awesome'

" リストのようなテーブルはVimのリストに変換されます。
let list = luaeval('{1, 2, 3, 4}')
echo list[0]
" 1
echo list[1]
" 2
" 注意 Luaのテーブルと違い、Vimのリストは0インデックスです。 

" 辞書のようなテーブルはVimの辞書に変換されます。
let dict = luaeval('{foo = "bar", baz = "qux"}')
echo dict.foo
" 'bar'

" bool値とnilも同様です。
echo luaeval('true')
" v:true
echo luaeval('nil')
" v:null

" Lua関数のエイリアスをVim scriptで作ることができます。
let LuaMathPow = luaeval('math.pow')
echo LuaMathPow(2, 2)
" 4
let LuaModuleFunction = luaeval('require("mymodule").myfunction')
call LuaModuleFunction()

" Vimの関数にLuaの関数を値として渡すこともできます。
lua X = function(k, v) return string.format("%s:%s", k, v) end
echo map([1, 2, 3], luaeval("X"))
```

`luaeval()`は式にデータを渡すことのできる任意の2つ目の引数があります。Luaからは`_A`としてアクセスできます。

```vim
echo luaeval('_A[1] + _A[2]', [1, 1])
" 2

echo luaeval('string.format("Lua is %s", _A)', 'awesome')
" 'Lua is awesome'
```

参照:
- `:help luaeval()`

### v:lua

Vimのグローバル変数です。Vim scriptからLuaのグローバル関数を直接呼ぶことができます。
この場合でも、Vim scriptの型はLuaの型に変換されます。逆も同様です。

```vim
call v:lua.print('Hello from Lua!')
" 'Hello from Lua!'

let scream = v:lua.string.rep('A', 10)
echo scream
" 'AAAAAAAAAA'

" Requiring modules works
call v:lua.require('mymodule').myfunction()

" How about a nice statusline?
lua << EOF
function _G.statusline()
    local filepath = '%f'
    local align_section = '%='
    local percentage_through_file = '%p%%'
    return string.format(
        '%s%s%s',
        filepath,
        align_section,
        percentage_through_file
    )
end
EOF

set statusline=%!v:lua.statusline()

" Also works in expression mappings
lua << EOF
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end
EOF

inoremap <silent> <expr> <Tab>
    \ pumvisible() ? '\<C-n>' :
    \ v:lua.check_back_space() ? '\<Tab>' :
    \ completion#trigger_completion()
```

参照:
- `:help v:lua`
- `:help v:lua-call`

#### 警告

この変数は関数呼び出しにのみ使用できます。次の例はエラーになります。:

```vim
" 関数のエイリアスは動作しません
let LuaPrint = v:lua.print

" 辞書アクセスは動作しません
echo v:lua.some_global_dict['key']

" 関数を値として使用できません
echo map([1, 2, 3], v:lua.global_callback)
```

### Tips

設定ファイルに、`let g:vimsyn_embed = 'l'`を追加すると.vimファイル内のLuaを構文ハイライトすることができます。
詳細は`:h g:vimsyn_embed`を参照してください。

## vim名前空間

NeovimはLuaからAPIを使うためのエントリーポイントとして、`vim`グーローバル変数を公開しています。
これは、拡張された標準ライブラリやさまざまなサブモジュールを提供します。

いくつかの注目すべき関数とモジュール:

- `vim.inspect`: 読みやすい形式のLuaオブジェクト(テーブルを調べるのに便利です。)
- `vim.regex`: LuaからVimの正規表現を使う
- `vim.api`: API関数を公開するモジュール(リモートプラグインで使うAPIと同じです)
- `vim.loop`: Neovimのイベントループ機能を公開するモジュール(LibUVを使います)
- `vim.lsp`: 組込みのLSPクライアントを操作するモジュール
- `vim.treesitter`: tree-sitterライブラリの機能を公開するモジュール

このリストは決して包括的なリストではありません。`vim`変数で何かできるかを詳しく知りたい場合は、`:h lua-stdlib`と`:help lua-vim`が最適です。
または、`:lua print(vim.inspect(vim))`を実行してすべてのモジュールのリストを取得することもできます。

#### Tips

オブジェクトの中身を検査するのに毎回`print(vim.inspect(x)`を書くのは面倒です。設定にグローバルなラッパー関数を含めることは価値があるかもしれません。:

```lua
function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end
```

コードまたはコマンドラインからとても早くオブジェクトの中身を検査することができます。

```lua
dump({1, 2, 3})
```

```vim
:lua dump(vim.loop)
```

加えて、他の言語と比較して組込みのLua関数が不足している場合があります(例えば、`os.clock`はミリ秒ではなく秒数のみを返します)。
必ず、Neovim stdlib(それと`vim.fn`。詳しくは後述します。)を見てください。おそらく、探しものはそこにあります。

## LuaからVim scriptを使用する

### vim.api.nvim_eval()

文字列で与えられたVim scriptの式を評価してその値を返します。Vim scriptの型は自動的にLuaの型に変換されます。(その逆も同様です。)

これは、Vim scriptの`luaeval()`と同様です。

```lua
-- 型は正しく変換されます。
print(vim.api.nvim_eval('1 + 1')) -- 2
print(vim.inspect(vim.api.nvim_eval('[1, 2, 3]'))) -- { 1, 2, 3 }
print(vim.inspect(vim.api.nvim_eval('{"foo": "bar", "baz": "qux"}'))) -- { baz = "qux", foo = "bar" }
print(vim.api.nvim_eval('v:true')) -- true
print(vim.api.nvim_eval('v:null')) -- nil
```

**TODO**: is it possible for `vim.api.nvim_eval()` to return a `funcref`?

#### 警告

`luaeval()`と違い、式にデータを渡すための暗黙的な変数`_A`を提供しません。

### vim.api.nvim_exec()

Vim scriptのチャンクを実行します。実行するソースコートを含む文字列と、コードの出力を返すかどうかを決めるbool値を受け取ります(例えば、出力を変数に格納することができます)。

```lua
local result = vim.api.nvim_exec(
[[
let mytext = 'hello world'

function! MyFunction(text)
    echo a:text
endfunction

call MyFunction(mytext)
]],
true)

print(result) -- 'hello world'
```

**TODO**: The docs say that script-scope (`s:`) is supported, but running this snippet with a script-scoped variable throws an error. Why?

### vim.api.nvim_command()

Exコマンドを実行します。実行するコマンドを含む文字列を受け取ります。

```lua
vim.api.nvim_command('new')
vim.api.nvim_command('wincmd H')
vim.api.nvim_command('set nonumber')
vim.api.nvim_command('%s/foo/bar/g')
```

Note: `vim.cmd`はこの関数のエイリアスです。

```lua
vim.cmd('buffers')
```

#### Tips

これらの関数は文字列を渡すため、多くの場合、バックスラッシュをエスケープする必要があります。:

```lua
vim.cmd('%s/\\Vfoo/bar/g')
```

文字列リテラルはエスケープが必要ないため使いやすいです。:

```lua
vim.cmd([[%s/\Vfoo/bar/g]])
```

## vimオプションを管理する

### API関数を使用する

Neovimは、オプションの値を読み書きできるAPI関数を提供しています。

- グローバルオプション:
    - `vim.api.nvim_set_option()`
    - `vim.api.nvim_get_option()`
- バッファオプション:
    - `vim.api.nvim_buf_set_option()`
    - `vim.api.nvim_buf_get_option()`
- ウィンドウオプション:
    - `vim.api.nvim_win_set_option()`
    - `vim.api.nvim_win_get_option()`

それらはオプションの名前と設定したい値を含む文字列を受け取ります。

boolな(`(no)number`のような)オプションは`true`か`false`のどちらかに設定する必要があります。:

```lua
vim.api.nvim_set_option('smarttab', false)
print(vim.api.nvim_get_option('smarttab')) -- false
```

当然ながら、文字列のオプションには文字列を設定する必要があります。:

```lua
vim.api.nvim_set_option('selection', 'exclusive')
print(vim.api.nvim_get_option('selection')) -- 'exclusive'
```

数値のオプションは数値を受け取ります。:

```lua
vim.api.nvim_set_option('updatetime', 3000)
print(vim.api.nvim_get_option('updatetime')) -- 3000
```

バッファローカルとウィンドウローカルなオプションはそれぞれの番号も必要です。(`0`を指定した場合、カレントバッファ/ウィンドウが対象になります。):

```lua
vim.api.nvim_win_set_option(0, 'number', true)
vim.api.nvim_buf_set_option(10, 'shiftwidth', 4)
print(vim.api.nvim_win_get_option(0, 'number')) -- true
print(vim.api.nvim_buf_get_option(10, 'shiftwidth')) -- 4
```

### メタアクセサーを使用する

もっと使い慣れた方法でオプションを設定したい場合、いくつかのメタアクセサーを使用できます。それらは、上記のAPI関数をラップしたものでオプションを変数のように操作できます。:

- `vim.o.{option}`: グローバルオプション
- `vim.bo.{option}`: バッファオプション
- `vim.wo.{option}`: ウィンドウオプション

```lua
vim.o.smarttab = false
print(vim.o.smarttab) -- false

vim.bo.shiftwidth = 4
print(vim.bo.shiftwidth) -- 4
```

バッファとウィンドウの番号を指定することができます。0を指定した場合、カレントバッファ/ウィンドウが使用されます。:

```lua
vim.bo[4].expandtab = true -- same as vim.api.nvim_buf_set_option(4, 'expandtab', true)
vim.wo.number = true -- same as vim.api.nvim_win_set_option(0, 'number', true)
```

参照:
- `:help lua-vim-internal-options`

#### 警告

**WARNING**: The following section is based on a few experiments I did. The docs don't seem to mention this behavior and I haven't checked the source code to verify my claims.  
**TODO**: Can anyone confirm this?

`:set`コマンドしか使ったことがないなら、いくつかのオプションの挙動に驚くかもしれません。

基本的に、オプションはグローバルとローカル(バッファ/ウィンドウ)の片方か両方を持つことができます。

`:setglobal`はグローバルの値を設定します。
`:setlocal`はローカルの値を設定します。
`:set`はグローバルとローカルの値を設定します。

`:help :setglobal`から便利な表:

|                 Command | global value | local value |
| ----------------------: | :----------: | :---------: |
|       :set option=value |     set      |     set     |
|  :setlocal option=value |      -       |     set     |
| :setglobal option=value |     set      |      -      |

Luaでは`:set`相当のものはなく、グローバルかローカルのどちらかを設定します。

`number`はグローバルオプションだと思うかもしれませんが、ドキュメントではウィンドウについてローカルと説明されています。
そのようなオプションは実際は"sticky"です。: 新しいウィンドウを開いた時に現在のウィンドウからコピーされます。

よって、`init.lua`でオプションを設定するには次のようにします。

```lua
vim.wo.number = true
```

`shiftwidth`、`expandtab`、`undofile`などのバッファについてローカルなオプションはもっと紛らわしいです。
`init.lua`に次のコードが含まれているとします。:

```lua
vim.bo.expandtab = true
```

Neovimを起動した直後には問題ありません。: `<Tab>`を押すとタブの変わりにスペースが挿入されます。
別のバッファを開くと、突然タブに戻ります…。

グローバルに設定すると逆の問題が起こります。:

```lua
vim.o.expandtab = true
```

これでは、最初にNeovimを起動した時はタブが挿入されます。別のバッファを開いて`<Tab>`を押すと期待通りになります。

つまり、バッファについてローカルなオプションを正しく動作させるには次のようにします。:

```lua
vim.bo.expandtab = true
vim.o.expandtab = true
```

参照:
- `:help :setglobal`
- `:help global-local`

**TODO**: Why does this happen? Do all buffer-local options behave this way? Might be related to [neovim/neovim#7658](https://github.com/neovim/neovim/issues/7658) and [vim/vim#2390](https://github.com/vim/vim/issues/2390). Also for window-local options: [neovim/neovim#11525](https://github.com/neovim/neovim/issues/11525) and [vim/vim#4945](https://github.com/vim/vim/issues/4945)

## vim内部の変数を管理する

### API関数を使用する

オプションのように、内部変数にもAPI関数があります。

- グローバル変数 (`g:`):
    - `vim.api.nvim_set_var()`
    - `vim.api.nvim_get_var()`
    - `vim.api.nvim_del_var()`
- バッファ変数 (`b:`):
    - `vim.api.nvim_buf_set_var()`
    - `vim.api.nvim_buf_get_var()`
    - `vim.api.nvim_buf_del_var()`
- ウィンドウ変数 (`w:`):
    - `vim.api.nvim_win_set_var()`
    - `vim.api.nvim_win_get_var()`
    - `vim.api.nvim_win_del_var()`
- タブ変数 (`t:`):
    - `vim.api.nvim_tabpage_set_var()`
    - `vim.api.nvim_tabpage_get_var()`
    - `vim.api.nvim_tabpage_del_var()`
- Vimの定義済み変数 (`v:`):
    - `vim.api.nvim_set_vvar()`
    - `vim.api.nvim_get_vvar()`

Vimの定義済み変数を除いて、削除することもできます(Vim scriptの`:unlet`と同様です)。
ローカル変数(`l:`)、スクリプト変数(`s:`)、関数の引数(`a:`)はVim script内でのみ意味があるため操作できません。
Luaには独自のスコープルールがあります。

これらの変数に不慣れな場合、`:h internal-variables`に説明があります。

これらの関数は対象の変数名と、設定したい値を含む文字列を受け取ります。

```lua
vim.api.nvim_set_var('some_global_variable', { key1 = 'value', key2 = 300 })
print(vim.inspect(vim.api.nvim_get_var('some_global_variable'))) -- { key1 = "value", key2 = 300 }
vim.api.nvim_del_var('some_global_variable')
```

バッファ、ウィンドウ、タブページなスコープを持つ変数はそれぞれの番号を受け取ります(0を指定した場合は現在のバッファ/ウィンドウ/タブページが使われます。)。:

```lua
vim.api.nvim_win_set_var(0, 'some_window_variable', 2500)
vim.api.nvim_tab_set_var(3, 'some_tabpage_variable', 'hello world')
print(vim.api.nvim_win_get_var(0, 'some_window_variable')) -- 2500
print(vim.api.nvim_buf_get_var(3, 'some_tabpage_variable')) -- 'hello world'
vim.api.nvim_win_del_var(0, 'some_window_variable')
vim.api.nvim_buf_del_var(3, 'some_tabpage_variable')
```

### メタアクセサーを使用する

内部の変数はメタアクセサーを使用し、もっと直感的に操作することができます。:

- `vim.g.{name}`: グローバル変数
- `vim.b.{name}`: バッファ変数
- `vim.w.{name}`: ウィンドウ変数
- `vim.t.{name}`: タブ変数
- `vim.v.{name}`: Vimの定義済み変数

```lua
vim.g.some_global_variable = {
    key1 = 'value',
    key2 = 300
}

print(vim.inspect(vim.g.some_global_variable)) -- { key1 = "value", key2 = 300 }
```

変数を削除するには単に`nil`を代入します。:

```lua
vim.g.some_global_variable = nil
```

#### 警告

オプションのメタアクセサーと違い、バッファ/ウィンドウ/タブの変数に番号を指定できません。

さらに、辞書の1つのキーを追加/更新/削除することはできません。例えば、次のVim scriptは期待通りに動きません。:

```vim
let g:variable = {}
lua vim.g.variable.key = 'a'
echo g:variable
" {}
```

既知のissue:

- [Issue #12544](https://github.com/neovim/neovim/issues/12544)

## Vim scriptの関数を呼び出す

### vim.call()

`vim.call()`はVim scriptの関数を呼び出します。Vimの組込み関数とユーザー定義関数のどちらかで使用できます。
この場合でも、データ型はLuaからVim scriptに変換されます。

対象の関数名とその引数を受け取ります。:

```lua
print(vim.call('printf', 'Hello from %s', 'Lua'))

local reversed_list = vim.call('reverse', { 'a', 'b', 'c' })
print(vim.inspect(reversed_list)) -- { "c", "b", "a" }

local function print_stdout(chan_id, data, name)
    print(data[1])
end

vim.call('jobstart', 'ls', { on_stdout = print_stdout })

vim.call('my#autoload#function')
```

参照:
- `:help vim.call()`

### vim.fn.{function}()

`vim.fn`は`vim.call()`と同じですが、ネイティブなLua関数を呼んでいるように見えます。:

```lua
print(vim.fn.printf('Hello from %s', 'Lua'))

local reversed_list = vim.fn.reverse({ 'a', 'b', 'c' })
print(vim.inspect(reversed_list)) -- { "c", "b", "a" }

local function print_stdout(chan_id, data, name)
    print(data[1])
end

vim.fn.jobstart('ls', { on_stdout = print_stdout })
```

`#`はLuaで有効な識別子ではないため、autoload関数は次の構文で呼び出す必要があります。:

```lua
vim.fn['my#autoload#function']()
```

参照:
- `:help vim.fn`

#### Tips

Neovimにはプラグインに便利な強力な組込み関数を含むライブラリがあります。
アルファベット順のリストは`:help vim-function`を参照してください。
`:help function-list`は機能別に分類されたリストです。

#### 警告

いくつかのVim関数はbool値の変わりに`1`か`0`を返します。これは、Vim scriptでは`1`は真で`0`は偽になるため問題ありません。
次のようなことが可能です。:

```vim
if has('nvim')
    " do something...
endif
```

しかし、Luaで偽になるのは`false`と`nil`のみで、数値は値に関係なく常に`true`と評価されます。
明示的に`1`か`0`かをチェックする必要があります。:

```lua
if vim.fn.has('nvim') == 1 then
    -- do something...
end
```

## マッピングを定義する

Neovimはマッピングを設定、取得、削除するためのAPI関数を提供します。:

- グローバルマッピング:
    - `vim.api.nvim_set_keymap()`
    - `vim.api.nvim_get_keymap()`
    - `vim.api.nvim_del_keymap()`
- バッファローカルマッピング:
    - `vim.api.nvim_buf_set_keymap()`
    - `vim.api.nvim_buf_get_keymap()`
    - `vim.api.nvim_buf_del_keymap()`

`vim.api.nvim_set_keymap()`と`vim.api.nvim_buf_set_keymap()`から始めましょう。

最初の引数には有効にするモードの名前を含む文字列を渡します。:

| String value           | Help page     | Affected modes                           | Vimscript equivalent |
| ---------------------- | ------------- | ---------------------------------------- | -------------------- |
| `''` (an empty string) | `mapmode-nvo` | Normal, Visual, Select, Operator-pending | `:map`               |
| `'n'`                  | `mapmode-n`   | Normal                                   | `:nmap`              |
| `'v'`                  | `mapmode-v`   | Visual and Select                        | `:vmap`              |
| `'s'`                  | `mapmode-s`   | Select                                   | `:smap`              |
| `'x'`                  | `mapmode-x`   | Visual                                   | `:xmap`              |
| `'o'`                  | `mapmode-o`   | Operator-pending                         | `:omap`              |
| `'!'`                  | `mapmode-ic`  | Insert and Command-line                  | `:map!`              |
| `'i'`                  | `mapmode-i`   | Insert                                   | `:imap`              |
| `'l'`                  | `mapmode-l`   | Insert, Command-line, Lang-Arg           | `:lmap`              |
| `'c'`                  | `mapmode-c`   | Command-line                             | `:cmap`              |
| `'t'`                  | `mapmode-t`   | Terminal                                 | `:tmap`              |

2つ目の引数は、左側のマッピングを含む文字列(マッピングで定義されたコマンドを起動するためのキー)です。
空の文字列は`<Nop>`と同じで、キーを無効にします。

3つ目の引数は、右側のマッピングを含む文字列(実行するコマンド)です。

最後の引数は、`:help :map-arguments`で定義されているbool型のオプションのテーブルです(`noremap`を含み、`buffer`を除く)。

バッファローカルなマッピングは、バッファ番号を引数の最初に受け取ります(`0`を指定した場合、カレントバッファです)。

```lua
vim.api.nvim_set_keymap('n', '<leader><Space>', ':set hlsearch!<CR>', { noremap = true, silent = true })
-- :nnoremap <silent> <leader><Space> :set hlsearch<CR>

vim.api.nvim_buf_set_keymap(0, '', 'cc', 'line(".") == 1 ? "cc" : "ggcc"', { noremap = true, expr = true })
-- :noremap <buffer> <expr> cc line('.') == 1 ? 'cc' : 'ggcc'
```

`vim.api.nvim_get_keymap()`は、モードの省略名(上記の表を参照)を含む文字列を受け取ります。
そのモードにあるすべてのグローバルマッピングのテーブルを返します。

```lua
print(vim.inspect(vim.api.nvim_get_keymap('n')))
-- :verbose nmap
```

`vim.api.nvim_buf_get_keymap()`は、最初の引数に追加でバッファ番号を受け取ります(`0`を指定した場合、カレントバッファです)。

```lua
print(vim.inspect(vim.api.nvim_buf_get_keymap(0, 'i')))
-- :verbose imap <buffer>
```

`vim.api.nvim_del_keymap()`は、モードと左側のマッピングを受け取ります。

```lua
vim.api.nvim_del_keymap('n', '<leader><Space>')
-- :nunmap <leader><Space>
```

この場合でも、`vim.api.nvim_buf_del_keymap()`は最初の引数にバッファ番号を受け取ります。`0`を指定した場合、カレントバッファです。

```lua
vim.api.nvim_buf_del_keymap(0, 'i', '<Tab>')
-- :iunmap <buffer> <Tab>
```

## ユーザーコマンドを定義する

現在、Luaにはユーザーコマンドを作成するインターフェイスはありません。しかし、計画はあります。:

- [Pull request #11613](https://github.com/neovim/neovim/pull/11613)

いまのところ、Vim scriptでコマンドを作成したほうが良いです。

## autocommandを定義する

augroupsとautocommandのインターフェイスはまだありません。しかし、計画はあります。:

- [Pull request #12378](https://github.com/neovim/neovim/pull/12378)

いまのところ、Vim scriptで作成するか、ラッパープラグイン([norcalli/nvim_utils](https://github.com/norcalli/nvim_utils/blob/master/lua/nvim_utils.lua#L554-L567))を使用することができます。

## 構文ハイライトを定義する

syntax APIはまだ作業中です。いくつかのポインターがあります。:

- [Issue #9876](https://github.com/neovim/neovim/issues/9876)
- [tjdevries/colorbuddy.vim, a library for creating colorschemes in Lua](https://github.com/tjdevries/colorbuddy.vim)
- `:help lua-treesitter`

## 一般的なTipsと推奨

**TODO**:
- Hot-reloading of modules
- `vim.validate()`?
- Add stuff about unit tests? I know Neovim uses the [busted](https://olivinelabs.com/busted/) framework, but I don't know how to use it for plugins
- Best practices? I'm not a Lua wizard so I wouldn't know
- How to use LuaRocks packages ([wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim)?)

## その他

### vim.loop

`vim.loop`はLibUV APIを公開するモジュールです。いくつかのリソース:

- [Official documentation for LibUV](https://docs.libuv.org/en/v1.x/)
- [Luv documentation](https://github.com/luvit/luv/blob/master/docs.md)
- [teukka.tech - Using LibUV in Neovim](https://teukka.tech/vimloop.html)

参照:
- `:help vim.loop`

### vim.lsp

`vim.lsp`は組込みのLSPクライアントを操作するためのモジュールです。
[neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig/)は有名なLanguage Serverの設定集です。

クライアントの動作は"lsp-handlers"を使用して設定することができます。詳細はこちら:
- `:help lsp-handler`
- [neovim/neovim#12655](https://github.com/neovim/neovim/pull/12655)
- [How to migrate from diagnostic-nvim](https://github.com/nvim-lua/diagnostic-nvim/issues/73#issue-737897078)


LSPクライアントを利用したプラグインも見たいかもしれません。:
- [nvim-lua/completion-nvim](https://github.com/nvim-lua/completion-nvim)
- [RishabhRD/nvim-lsputils](https://github.com/RishabhRD/nvim-lsputils)

参照:
- `:help lsp`

### vim.treesitter

`vim.treesitter`はNeovim内の[Tree-sitter](https://tree-sitter.github.io/tree-sitter/)ライブラリを操作するためのモジュールです。
Tree-sitterについてもっと知りたいなら、この[プレゼン (38:37)](https://www.youtube.com/watch?v=Jes3bD6P0To)に興味があるかもしれません。

[nvim-treesitter](https://github.com/nvim-treesitter/)オリジネーションは、ライブラリを利用して様々なプラグインをホストしています。

参照:
- `:help lua-treesitter`

### トランスパイラ

Luaを使用する利点の1つは実際にLuaを書く必要がないことです！利用できるトランスパイラはたくさんあります。

- [Moonscript](https://moonscript.org/)

おそらく、最も知られているLuaのトランスパイラです。クラス、リスト内包表記、関数リテラルなどの便利な機能を多数追加します。
[svermeulen/nvim-moonmaker](https://github.com/svermeulen/nvim-moonmaker)はNeovimのプラグインと設定をMoonscriptで直接書けるようにします。

- [Fennel](https://fennel-lang.org/)

lispをLuaにコンパイルします。[Olical/aniseed](https://github.com/Olical/aniseed)を使用するとNeovimのプラグインと設定を書くことができます。
さらに、[Olical/conjure](https://github.com/Olical/conjure)は対話的な開発環境を提供します(他の言語の中で)。

その他の興味深いプロジェクト:
- [TypeScriptToLua/TypeScriptToLua](https://github.com/TypeScriptToLua/TypeScriptToLua)
- [teal-language/tl](https://github.com/teal-language/tl)
- [Haxe](https://haxe.org/)
- [SwadicalRag/wasm2lua](https://github.com/SwadicalRag/wasm2lua)
- [hengestone/lua-languages](https://github.com/hengestone/lua-languages)