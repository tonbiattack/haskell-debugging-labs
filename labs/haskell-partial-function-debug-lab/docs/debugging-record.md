# `head []` の実行時例外を `Maybe` の契約違反として切り分けた記録

## 対象と前提

この記録は、`src/FirstName.hs` の `firstName :: [String] -> Maybe String` が空リストを受け取ったときに `Nothing` を返さず、例外を送出する不具合を対象にする。検証は GHC 9.4.7、cabal-install 3.8.1.0、Hspec 2.10.10 で実施した。実行環境と依存関係は `haskell-partial-function-debug-lab.cabal` に固定している。

この題材は、コンテンツリポジトリ内の Java、Python、Go の既存デバッグ記事と異なり、**リスト型 `[a]` が空・非空を区別しないこと**と、非厳格評価の下で部分関数の例外が値の要求時まで遅れる契約を扱う。Haskell 専用の既存デバッグ記事・ラボは横断検索で確認できなかった。

## 期待値と実際

利用者の期待は、空リストには先頭要素がないため `firstName [] == Nothing` となることである。ところが、不具合状態の実装は次のとおりであった。

```haskell
firstName :: [String] -> Maybe String
firstName names = Just (head names)
```

`cabal test --offline --test-show-details=direct` の実行結果では、空リストのテストだけが失敗し、非空リストの対照ケースは成功した。保存済みの完全な出力は `artifacts/failing-test-output.txt` にある。

```text
firstName
  returns Nothing for an empty list instead of raising an exception [✘]
  returns the first element for a non-empty list [✔]

uncaught exception: ErrorCall
Prelude.head: empty list
```

GHCi では型が期待どおりであることも確認した。

```text
firstName :: [String] -> Maybe String
Just "*** Exception: Prelude.head: empty list
```

この観測は、`Maybe` という戻り値の型だけでは、関数本体が空リストを安全に処理していることを保証しないことを示す。Haskell の標準ライブラリは `head` を空リストで例外を送出する部分関数として明示し、パターンマッチ、`uncons`、`listToMaybe` などを代替として案内している。[1]

## 仮説の比較

| 仮説 | 予測 | 最小実験 | 結果 | 判定 |
|---|---|---|---|---|
| `Maybe` を返す型なら空リストは自動で `Nothing` になる | 型検査が失敗するか、`firstName []` が `Nothing` になる | `:t firstName` と空リストのHspecテストを実行する | 型検査は通り、テスト実行時に `Prelude.head: empty list` となった | 棄却 |
| `head` が空リストに適用されている | スタックトレースが `head` と実装行を指す | failing test のスタックトレースを確認する | `src/FirstName.hs:11:25` の `head` が記録された | 採用 |
| 非空入力のロジック全体が壊れている | 非空リストの対照ケースも失敗する | `firstName ["Ada", "Grace"]` を検証する | `Just "Ada"` となった | 棄却 |

Haskell は非厳格言語であり、評価時エラーを生じる計算は値が要求された時点で問題になる。[2] このため `Just (head names)` は外側の `Just` を書いていても、テストの比較が中身を評価した時点で `head []` のエラーを露出させる。

## 根本原因

根本原因は、空・非空のいずれも表現できる `[String]` に対して、非空であることを前提にする `head` を適用したことである。`head :: [a] -> a` の引数型は空リストを排除しないため、コンパイラはこの呼び出しを拒否できない。一方、`Maybe a` は `Just a` または `Nothing` を表すデータ型であり、オプショナルな値を例外に頼らず表現するための型である。[3]

## 最小修正

空リストと非空リストをパターンマッチで分け、部分関数を除去した。

```haskell
firstName :: [String] -> Maybe String
firstName [] = Nothing
firstName (name : _) = Just name
```

この変更は API の型を変えず、`Nothing` で表すと宣言済みだった不在ケースを実装でも守る。空リストを受け取る場合に `head` を評価する経路がなくなり、非空リストでは先頭の `name` をそのまま `Just` に包む。

## 回帰確認

不具合を再現した同じHspecテストは削除せず残した。加えて、QuickCheckにより任意の非空 `String` リストについて先頭要素が `Just` で返る性質を検証した。修正後の完全な出力は `artifacts/passing-test-output.txt` にある。

```text
firstName
  returns Nothing for an empty list instead of raising an exception [✔]
  returns the first element for a non-empty list [✔]
  returns the first element for every non-empty list [✔]
    +++ OK, passed 100 tests.

3 examples, 0 failures
```

不具合状態と修正状態は意図的に分離している。`823020a` は失敗テストを含む不具合の再現、`ab3d59e` は部分関数を除去した最小修正とQuickCheckを含む回帰確認である。

## 参考資料

[1] [Data.List — `head` のドキュメント](https://hackage.haskell.org/package/base/docs/Data-List.html#v:head)

[2] [Haskell 2010 Report, Chapter 3.1 — Errors](https://www.haskell.org/onlinereport/haskell2010/haskellch3.html)

[3] [Data.Maybe — `Maybe` のドキュメント](https://hackage.haskell.org/package/base/docs/Data-Maybe.html)
