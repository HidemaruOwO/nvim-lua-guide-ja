# Getting started using Lua in Neovim

## はじめに

Neovimの[ファーストクラス言語](https://github.com/neovim/neovim/wiki/FAQ#why-embed-lua-instead-of-x)としての[Lua](https://www.youtube.com/watch?v=IP3J56sKtn0)はキラー機能の1つになりつつあります。
しかし、Luaでプラグインを書くための教材はVim script程多くありません。これは、Luaを始めるための基本的な情報を提供する試みです。

このガイドは少なくともNeovim 0.5を使用していることを前提としています。

### Luaを学ぶ

まだLuaについて詳しくない場合、学ぶためのリソースはたくさんあります。:

- [Learn X in Y minutes page about Lua](https://learnxinyminutes.com/docs/lua/)は基本的な概要を説明します。
- [このガイド](https://github.com/medwatt/Notes/blob/main/Lua/Lua_Quick_Guide.ipynb)も素早く始めるのに良いチュートリアルです。
- 動画が好きなら、Derek Banasの動画があります。[1-hour tutorial on the language](https://www.youtube.com/watch?v=iMacxZQMPXs)
- 実行できるサンプルを使い、対話的に学びたいですか？[LuaScript tutorial](https://www.luascript.dev/learn)を試してみてください。
- [lua-users wiki](http://lua-users.org/wiki/LuaDirectory)にはLua関連のトピックごとの便利な情報がたくさんあります。
- [official reference manual for Lua](https://www.lua.org/manual/5.1/)には最も包括的な情報があります。(エディタで快適に読みたいなら、Vimdocプラグインがあります。:[wsdjeg/luarefvim](https://github.com/wsdjeg/luarefvim))

Luaはとてもクリーンでシンプルな言語であることに注意してください。JavaScriptのようなスクリプト言語の経験があれば、学ぶことは簡単です。あなたはもう自分で思っているよりLuaについて知っているかもしれません！

Note: Neovimに埋め込まれているLuaは[LuaJIT](https://staff.fnwi.uva.nl/h.vandermeer/docs/lua/luajit/luajit_intro.html) 2.1.0でLua 5.1と互換性を維持しています。

### Luaを書くための既存のチュートリアル

Luaでプラグインを書くためのチュートリアルが既にいくつかあります。それらはこのガイドを書くのに役に立ちました。筆者に感謝します。

- [teukka.tech - init.vimからinit.luaへ](https://teukka.tech/luanvim.html)
- [dev.to - プラグインをLuaで書く方法](https://dev.to/2nit/how-to-write-neovim-plugins-in-lua-5cca)
- [dev.to - プラグインのUIをLuaで作る方法](https://dev.to/2nit/how-to-make-ui-for-neovim-plugins-in-lua-3b6e)
- [ms-jpq - Neovim Async Tutorial](https://github.com/ms-jpq/neovim-async-tutorial)
- [oroques.dev - Neovim 0.5の機能とinit.luaへの切り替え](https://oroques.dev/notes/neovim-init/)

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

### init.lua

Neovimは、`init.vim`の代わりに設定ファイルとして`init.lua`を読み込むことをサポートしています。

Note: `init.lua`は*完全に*オプションです。`init.vim`は廃止されず、設定として有効です。
いくつかの機能は、まだ100%Luaに公開されていないので注意してください。

参照:
- `:help config`

### モジュール

Luaモジュールは、`runtimepath`内の`lua/`フォルダにあります(ほとんどの場合、\*nixでは`~/.config/nvim/lua`、Windowsでは`~/AppData/Local/nvim/lua`を意味します)。
このフォルダにあるファイルをLuaモジュールとして`require()`できます。

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

存在しないモジュール、構文エラーを含むモジュールをrequireすると実行中のスクリプトは停止します。
エラーを防ぐために、`pcall()`を使用できます。

```lua
local ok, _ = pcall(require, 'module_with_error')
if not ok then
  -- not loaded
end
```

参照:
- `:help lua-require`

#### Tips

いくつかのLuaプラグインは`lua/`フォルダ内に同じ名前のファイルがあるかもしれません。これにより、名前空間の衝突を起こす可能性があります。

異なる2つのプラグインに`lua/main.lua`がある場合、`require('main')`は曖昧です。: どのファイルを読み込みますか？

トップレベルのフォルダで名前空間をつけることをお勧めします。: `lua/plugin_name/main.lua`

#### Runtime files

Vim scriptと同様に、`runtimepath`内にある特定のフォルダからLuaファイルを自動的に読み込めます。
現在、次のフォルダがサポートされています。:

- `colors/`
- `compiler/`
- `ftplugin/`
- `ftdetect/`
- `indent/`
- `plugin/`
- `syntax/`

Note: runtimeデイレクトリでは、すべての`*.vim`ファイルは`*.lua`ファイルの前に読み込まれます。


参照:
- `:help 'runtimepath'`
- `:help load-plugins`

#### Tips

ランタイムファイルはLuaのモジュールシステムをベースとしていないため、2つのプラグインは`plugin/main.lua`を問題なく持つことができます。

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

Note: 各`:lua`コマンドは独自のスコープを持っており、`local`を付けた変数はコマンドの外からアクセスできません。
次の例は動作しません。:

```vim
:lua local foo = 1
:lua print(foo)
" '1'ではなく'nil'が出力されます。
```

Note 2: Luaの`print()`は`:echomsg`と同じように動作します。出力はメッセージ履歴に保存されます。また、`:silent`で抑制できます。

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

### Luaファイルの読み込み

NeovimはLuaファイルを読み込むためのEXコマンドを3つ提供しています。

- `:luafile`
- `:source`
- `:runtime`

`:luafile`と`:source`はとてもよく似ています。:

```vim
:luafile ~/foo/bar/baz/myluafile.lua
:luafile %
:source ~/foo/bar/baz/myluafile.lua
:source %
```

`:source`は範囲指定もサポートしており、スクリプトの一部を実行するのに役立ちます。:

```vim
:1,10source
```

`:runtime`は少し異なります。: `'runtimepath'`オプションで読み込むファイルを指定します。詳細は`:help :runtime`を参照してください。

参照:

- `:help :luafile`
- `:help :source`
- `:help :runtime`

#### Sourcing a lua file vs calling require():

`require()`関数を呼ぶこととLuaファイルの読み込みの違いは何か、どちらを使うべきかを疑問に思うかもしれません。
それらには異なるユースケースがあります。:

- `require()`:
    - Luaの組込み関数です。Luaのモジュールを読み込むのに使用します。
    - `'runtimepath'`内にある`lua/`フォルダからモジュールを探します。
    - どのモジュールをロードしたかを記憶し、多重に実行されるのを防ぎます。Neovim実行中に、モジュールに含まれるコードを変更し、もう一度`require()`を実行してもモジュールは更新されません。
- `:luafile`, `:source`, `runtime`:
    - Exコマンドです。モジュールには対応していません。
    - 以前に実行されたかどうかに関わらず実行されます。
    - `:luafile`と`:source`は現在のウィンドウのディレクトリに対して相対パス・絶対パスを取ります。
    - `runtime`は、`'rutimepath'`オプションを使用してファイルを探します。

`:source`や`:runtime`、ランタイムディレクトリから自動的に読み込まれたファイルも`scriptnames`と`--startuptime`に表示されます。

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

Vimのグローバル変数です。Vim scriptからLuaのグローバル名前空間([`_G`](https://www.lua.org/manual/5.1/manual.html#pdf-_G)) 内の関数を直接呼ぶことができます。
この場合でも、Vim scriptの型はLuaの型に変換されます。逆も同様です。

```vim
call v:lua.print('Hello from Lua!')
" 'Hello from Lua!'

let scream = v:lua.string.rep('A', 10)
echo scream
" 'AAAAAAAAAA'

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
    local col = vim.api.nvim_win_get_cursor(0)[2]
    return (col == 0 or vim.api.nvim_get_current_line():sub(col, col):match('%s')) and true
end
EOF

inoremap <silent> <expr> <Tab>
    \ pumvisible() ? "\<C-n>" :
    \ v:lua.check_back_space() ? "\<Tab>" :
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

設定ファイルに、`let g:vimsyn_embed = 'l'`を追加すると.vimファイル内のLuaを構文ハイライトできます。
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
または、`:lua print(vim.inspect(vim))`を実行してすべてのモジュールのリストを取得できます。

#### Tips

オブジェクトの中身を検査するのに毎回`print(vim.inspect(x)`を書くのは面倒です。設定にグローバルなラッパー関数を含めることは価値があるかもしれません。:

```lua
function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
    return ...
end
```

コードまたはコマンドラインからとても早くオブジェクトの中身を検査できます。

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

Vim scriptのチャンクを実行します。実行するソースコートを含む文字列と、コードの出力を返すかどうかを決めるbool値を受け取ります(例えば、出力を変数に格納できます)。

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

### vim.cmd()

`vim.api.nvim_exec()`のエイリアスです。コマンドの引数のみを必要とし、`output`は常に`false`に設定されます。

```lua
vim.cmd('buffers')
vim.cmd([[
let g:multiline =<< EOF
foo
bar
baz
EOF
]])
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

### vim.api.nvim_replace_termcodes()

このAPI関数はターミナルコードとVimのキーコードをエスケープできます。

次のようなマッピングを見たことがあるかもしれません。:

```vim
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
```

同じことをLuaでやると大変です。次のようにやるかもしれません。:

```lua
function _G.smart_tab()
    return vim.fn.pumvisible() == 1 and [[\<C-n>]] or [[\<Tab>]]
end

vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.smart_tab()', {expr = true, noremap = true})
```

マッピングに `\<Tab>` と `\<C-n>` が挿入されているのを知るためだけに...

キーコードをエスケープできるのは、Vim scriptの機能です。`\r`, `\42` や `\x10` のような多くのプログラミング言語に共通する通常のエスケープシーケンスとは別に、Vim scriptの `expr-quotes` (ダブルクォートで囲まれる文字列)を使用すると、人間が読める表現のVimキーコードをエスケープします。

Luaにはそのような機能は組み込まれていません。嬉しいことに、NeovimにはターミナルコードとキーコードをエスケープするAPI関数 `nvim_replace_termcodes()` があります。:

```lua
print(vim.api.nvim_replace_termcodes('<Tab>', true, true, true))
```

これは少し冗長です。再利用できるラッパーを作ると便利です。:

```lua
-- `termcodes` 専用の `t` 関数です
-- この名前で呼ばなくてもいいですが、この簡潔さが便利です
local function t(str)
    -- 必要に応じてboolean引数で調整します
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

print(t'<Tab>')
```

先程の例はこれで期待通りに動きます:

```lua
local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function _G.smart_tab()
    return vim.fn.pumvisible() == 1 and t'<C-n>' or t'<Tab>'
end

vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.smart_tab()', {expr = true, noremap = true})
```

参照:
- `:help keycodes`
- `:help expr-quote`
- `:help nvim_replace_termcodes()`

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

- `vim.o.{option}`: `:set`のように動作します
- `vim.go.{option}`: `:setglobal`のように動作します
- `vim.bo.{option}`: バッファローカルオプションの場合`:setlocal`のように動作します
- `vim.wo.{option}`: ウィンドウローカルオプションの場合`:setlocal`のように動作します

```lua
vim.o.smarttab = false
print(vim.o.smarttab) -- false
vim.o.isfname = vim.o.isfname .. ',@-@' -- on Linux: set isfname+=@-@
print(vim.o.isfname) -- '@,48-57,/,.,-,_,+,,,#,$,%,~,=,@-@'

vim.bo.shiftwidth = 4
print(vim.bo.shiftwidth) -- 4
```

バッファとウィンドウの番号を指定できます。0を指定した場合、カレントバッファ/ウィンドウが使用されます。:

```lua
vim.bo[4].expandtab = true -- same as vim.api.nvim_buf_set_option(4, 'expandtab', true)
vim.wo.number = true -- same as vim.api.nvim_win_set_option(0, 'number', true)
```

これらには、Luaで設定するのに便利なより洗練されたラッパーとして`vim.opt`があります。
`init.vim`で慣れているものと似ています。:

- `vim.opt.{option}`: `:set`のように動作します
- `vim.opt_global.{option}`: `:setglobal`のように動作します
- `vim.opt_local.{option}`: `:setlocal`のように動作します

```lua
vim.opt.smarttab = false
print(vim.opt.smarttab:get()) -- false
```

いくつかのオプションはLuaのテーブルを使用して設定できます。:

```lua
vim.opt.completeopt = {'menuone', 'noselect'}
print(vim.inspect(vim.opt.completeopt:get())) -- { "menuone", "noselect" }
```

list、map、setのようなオプションのラッパーには、Vim scriptの`:set+=`, `:set^=`, `:set-=`と同じように動作するメソッドとメタメソッドが用意されています。

```lua
vim.opt.shortmess:append({ I = true })
-- どちらも等価です:
vim.opt.shortmess = vim.opt.shortmess + { I = true }

vim.opt.whichwrap:remove({ 'b', 's' })
-- どちらも等価です:
vim.opt.whichwrap = vim.opt.whichwrap - { 'b', 's' }
```

詳細は、必ず`:help vim.opt`を参照してください。

参照:
- `:help lua-vim-options`

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

Vimの定義済み変数を除いて、削除できます(Vim scriptの`:unlet`と同様です)。
ローカル変数(`l:`)、スクリプト変数(`s:`)、関数の引数(`a:`)はVim script内でのみ意味があるため操作できません。
Luaには独自のスコープルールがあります。

これらの変数が不慣れな場合、`:h internal-variables`に説明があります。

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

内部の変数はメタアクセサーを使用し、もっと直感的に操作できます。:

- `vim.g.{name}`: グローバル変数
- `vim.b.{name}`: バッファ変数
- `vim.w.{name}`: ウィンドウ変数
- `vim.t.{name}`: タブ変数
- `vim.v.{name}`: Vimの定義済み変数
- `vim.env.{name}`: 環境変数

```lua
vim.g.some_global_variable = {
    key1 = 'value',
    key2 = 300
}

print(vim.inspect(vim.g.some_global_variable)) -- { key1 = "value", key2 = 300 }
```

一部の変数名には、Luaの識別子に使用できない文字が含まれている場合があります。
この構文を使用してこれらの変数を操作できます。: `vim.g['my#variable']`

変数を削除するには単に`nil`を代入します。:

```lua
vim.g.some_global_variable = nil
```

#### 警告

オプションのメタアクセサーと違い、バッファ/ウィンドウ/タブの変数に番号を指定できません。

さらに、辞書の1つのキーを追加/更新/削除できません。例えば、次のVim scriptは期待通りに動きません。:

```vim
let g:variable = {}
lua vim.g.variable.key = 'a'
echo g:variable
" {}
```

一時的な変数を使用する回避策があります:

```vim
let g:variable = {}
lua << EOF
local tmp = vim.g.variable
tmp.key = 'a'
vim.g.variable = tmp
EOF
echo g:variable
" {'key': 'a'}
```

既知のissue:

- [Issue #12544](https://github.com/neovim/neovim/issues/12544)

## Vim scriptの関数を呼び出す

### vim.fn.{function}()

`vim.fn`は、Vim script組込みの関数を呼び出せます。
型はVimとLuaとで変換されます。

```lua
print(vim.fn.printf('Hello from %s', 'Lua'))

local reversed_list = vim.fn.reverse({ 'a', 'b', 'c' })
print(vim.inspect(reversed_list)) -- { "c", "b", "a" }

local function print_stdout(chan_id, data, name)
    print(data[1])
end

vim.fn.jobstart('ls', { on_stdout = print_stdout })
```

ハッシュ(`#`)はLuaで有効な識別子ではないため、autoload関数は次の構文で呼び出す必要があります。:

```lua
vim.fn['my#autoload#function']()
```

`vim.fn`は`vim.call`と同じ動作ですが、よりLuaらしい構文を使用できます。

`vim.api.nvim_call_function`とは、Vim/Luaオブジェクトを自動で変換する点が異なります。:
`vim.api.nvim_call_function`は浮動小数点数のテーブルを返しLuaのクロージャーを受け入れませんが、`vim.fn`はこれらの型を扱えます。

参照:
- `:help vim.fn`

#### Tips

Neovimにはプラグインに便利な強力な組込み関数を含むライブラリがあります。
アルファベット順のリストは`:help vim-function`を参照してください。
`:help function-list`は機能別に分類されたリストです。

NeovimのAPI関数は`vim.api{..}`のように直接使用できます。
詳細は`:help api`を参照してください。

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
vim.api.nvim_set_keymap('n', '<Leader><Space>', ':set hlsearch!<CR>', { noremap = true, silent = true })
-- :nnoremap <silent> <Leader><Space> :set hlsearch<CR>
vim.api.nvim_set_keymap('n', '<Leader>tegf',  [[<Cmd>lua require('telescope.builtin').git_files()<CR>]], { noremap = true, silent = true })
-- :nnoremap <silent> <Leader>tegf <Cmd>lua require('telescope.builtin').git_files()<CR>

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
vim.api.nvim_del_keymap('n', '<Leader><Space>')
-- :nunmap <Leader><Space>
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

いまのところ、Vim scriptで作成するか、ラッパープラグイン([norcalli/nvim_utils](https://github.com/norcalli/nvim_utils/blob/master/lua/nvim_utils.lua#L554-L567))を使用できます。

## 構文ハイライトを定義する

syntax APIはまだ作業中です。いくつかのポインターがあります。:

- [Issue #9876](https://github.com/neovim/neovim/issues/9876)
- [tjdevries/colorbuddy.vim, a library for creating colorschemes in Lua](https://github.com/tjdevries/colorbuddy.vim)
- `:help lua-treesitter`

## 一般的なTipsと推奨

### キャッシュされたモジュールのリロード

Luaでは、`require()`関数がモジュールをキャッシュします。
これはパフォーマンスには良いですが、後から`require()`を呼んでもモジュールは更新されないため少し面倒です。

特定のモジュールのキャッシュを更新する場合、`package.loaded`グローバルテーブルを変更する必要があります。:

```lua
package.loaded['modname'] = nil
require('modname') -- 新しい'modname'モジュールを読み込みます
```

[nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)には、これを行う[関数](https://github.com/nvim-lua/plenary.nvim/blob/master/lua/plenary/reload.lua)があります。

### Vim script <--> Lua 型変換の注意

#### 変数を変換するとコピーが作られます:

VimからLua、LuaからVimのオブジェクトの参照を直接操作できません。
例えば、Vim scriptの`map()`は変数をその場で変更します(破壊的)。

```vim
let s:list = [1, 2, 3]
let s:newlist = map(s:list, {_, v -> v * 2})

echo s:list
" [2, 4, 6]
echo s:newlist
" [2, 4, 6]
```

Luaからこの関数を使用すると、代りにコピーが作られます

```lua
local tbl = {1, 2, 3}
local newtbl = vim.fn.map(tbl, function(_, v) return v * 2 end)

print(vim.inspect(tbl)) -- { 1, 2, 3 }
print(vim.inspect(newtbl)) -- { 2, 4, 6 }
```

#### 変換を常にできるとは限りません

これは主に関数とテーブルに影響します。

Luaのリストと辞書が混在するテーブルは変換できません。

```lua
print(vim.fn.count({1, 1, number = 1}, 1))
-- E5100: Cannot convert given lua table: table should either have a sequence of positive integer keys or contain only string keys
```

Luaで`vim.fn`を使用してVim関数を呼べますが、それらの参照を保持できません。
それは不測の動作の原因になります。:

```lua
local FugitiveHead = vim.fn.funcref('FugitiveHead')
print(FugitiveHead) -- vim.NIL

vim.cmd("let g:test_dict = {'test_lambda': {-> 1}}")
print(vim.g.test_dict.test_lambda) -- nil
print(vim.inspect(vim.g.test_dict)) -- {}
```

Luaの関数をVimの関数に渡せますが、Vimの変数に格納できません。

```lua
-- This works:
vim.fn.jobstart({'ls'}, {
    on_stdout = function(chan_id, data, name)
        print(vim.inspect(data))
    end
})

-- This doesn't:
vim.g.test_dict = {test_lambda = function() return 1 end} -- Error: Cannot convert given lua type
```

ただし、Vim scriptから`luaeval()`を使用して同じことをすると**動作します**。:

```vim
let g:test_dict = {'test_lambda': luaeval('function() return 1 end')}
echo g:test_dict
" {'test_lambda': function('<lambda>4714')}
```

#### Vim booleans
Vim scriptの一般的なパターンではbool値の代わりに`1`と`0`を使用します。
実際、Vimにはバージョン7.4.1154まで区別されたbool型がありませんでした。

Luaのbool値は数値ではなく、Vim scriptの実際のbool値に変換されます。:

```vim
lua vim.g.lua_true = true
echo g:lua_true
" v:true
lua vim.g.lua_false = false
echo g:lua_false
" v:false
```

### リンターと言語サーバーの設定

Luaのプロジェクトでリンターや言語サーバーを使用して、診断と自動補完を利用している場合、Neovim固有の設定が必要になる場合があります。人気のあるツールの推奨設定は次のとおりです。:

#### luacheck

次の設定を `~/.luacheckrc` (もしくは `$XDG_CONFIG_HOME/luacheck/.luacheckrc`)に配置すれば、[luacheck](https://github.com/mpeterv/luacheck/)でvimモジュールを認識できます。:


```lua
globals = {
    "vim",
}
```

言語サーバーの[Alloyed/lua-lsp](https://github.com/Alloyed/lua-lsp/)は `luacheck` を使用してリンティングを提供し、同じファイルを読み込みます。

`luacheck` の設定方法の詳細は[ドキュメント](https://luacheck.readthedocs.io/en/stable/config.html)を参照してください。

#### sumneko/lua-language-server

[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig/)リポジトリに[sumneko/lua-language-serverの設定方法](https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#sumneko_lua)があります（例は組込みのLSPクライアントを使っていますが、他のLSPクライアントでも同じ設定である必要があります）。

[sumneko/lua-language-server](https://github.com/sumneko/lua-language-server/)の設定方法の詳細は["Setting without VSCode"](https://github.com/sumneko/lua-language-server/wiki/Setting-without-VSCode)を見てください。

#### coc.nvim

[coc.nvim](https://github.com/neoclide/coc.nvim/)の補完ソースである[rafcamlet/coc-nvim-lua](https://github.com/rafcamlet/coc-nvim-lua/)はNeovim stdlibの項目を提供しています。

### Luaコードのデバッグ

別のNeovimインスタンスで実行しているLuaコードを[jbyuki/one-small-step-for-vimkind](https://github.com/jbyuki/one-small-step-for-vimkind)でデバッグできます。

このプラグインは[Debug Adapter Protocol](https://microsoft.github.io/debug-adapter-protocol/)を使用しています。
デバッグアダプターに接続するには、[mfussenegger/nvim-dap](https://github.com/mfussenegger/nvim-dap/)や[puremourning/vimspector](https://github.com/puremourning/vimspector/)のようなDAPクライアントが必要です。

### Luaコードのテスト

- [plenary.nvim: test harness](https://github.com/nvim-lua/plenary.nvim/#plenarytest_harness)
- [notomo/vusted](https://github.com/notomo/vusted)

### Luarocksパッケージを使用する

[wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim)はLuarocksパッケージをサポートしています。
使い方は[README](https://github.com/wbthomason/packer.nvim/#luarocks-support)にあります。

## その他

### vim.loop

`vim.loop`はLibUV APIを公開するモジュールです。いくつかのリソース:

- [Official documentation for LibUV](https://docs.libuv.org/en/v1.x/)
- [Luv documentation](https://github.com/luvit/luv/blob/master/docs.md)
- [teukka.tech - Using LibUV in Neovim](https://teukka.tech/posts/2020-01-07-vimloop/)

参照:
- `:help vim.loop`

### vim.lsp

`vim.lsp`は組込みのLSPクライアントを操作するためのモジュールです。
[neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig/)は有名なLanguage Serverの設定集です。

クライアントの動作は"lsp-handlers"を使用して設定できます。詳細はこちら:
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
