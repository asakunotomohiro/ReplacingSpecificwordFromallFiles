# 引数の全ファイルから特定単語の置き換え。

※モジュール作成失敗中、、、置き換え進行中・・・ではなく、断念。  

プログラムのファイルを渡すだけで、特定の単語を置き換えてくれる。  

プログラムにファイルを渡すことで特定の単語をキャメル形式に変換し、それを目的の場所に置き換える。


## 動作への説明

以下、[参考](https://docs.microsoft.com/ja-jp/dotnet/standard/serialization/system-text-json-how-to)
```json
public DateTimeOffset Date { get; set; }
　　　・
　　　・
　　　・
xxx = DateTime.Parse("2019-08-01"),
```
昔見たのはこんなのではなく、以下の形式だった。
```json
文字列 = "xxx"
public string 関数名 {}
```
こんな感じだった。  
そのため、これを基準に動くようにしている。  

具体的には、ファイルの中から**"xxx"**を探しだし、見つけたことにより、次の行の関数名を取り出す。  
取り出した関数名がスネーク形式の命名(abc_def)になっている前提により、それをキャメル形式に置き換える(abcDef)。  
そして、その単語をxxxに置き換える。  
以下、具体例）
```text
json jsonHoge = "xxx"	←☆ここのxxxが検索対象。
public string abc_def {}	←☆ここのabc_defが抜き出し対象(2行にあることも前提)。
　　　↓　プログラム実行
json jsonHoge = "abcDef"	←☆xxxが置き換わった。
public string abc_def {}
```
こんな感じになる。  

ファイルの中から検索を掛けているのは、**xxx**であり、他の文言は検索対象外。  
そして、関数名として、**関数名 {**と言う形式になっている必要がある(括弧付きで検索しているため)。  
そして、英字を大小文字化させているため、多バイト文字を含んでいる場合は、変換結果が文字化けするだろう。  


## ライセンス
GNU Lesser General Public License v3.0


以上。
<!-- vim: set ts=4 sts=4 sw=4 tw=0 ff=unix fenc=utf-8 ft=markdown expandtab: -->
