# Haskell Partial Function Debug Lab

`head` が型検査を通過しても、空リストを受け取ると実行時例外になることを再現し、`Maybe` を返す関数の契約をパターンマッチで守るまでを学ぶ最小プロジェクトです。

この作業ツリーの初期コミットは意図的に不具合を含みます。`firstName []` は `Nothing` を返すべきですが、実装が `head` を評価するため `Prelude.head: empty list` で失敗します。後続の修正コミットでは、同じテストを回帰テストとして成功させます。

## 前提環境

| 項目 | バージョン |
|---|---:|
| GHC | 9.4.7 |
| Cabal | 3.8.1.0 |
| Hspec | 2.10.10 |

## 不具合の再現

不具合を含むコミットをチェックアウトしてから、次を実行します。

```bash
cabal test --offline --test-show-details=direct
```

`returns Nothing for an empty list instead of raising an exception` が `Prelude.head: empty list` で失敗し、非空リストの対照ケースは成功します。観測済みの出力は `artifacts/failing-test-output.txt` と `artifacts/ghci-observation.txt` に保存しています。

## 修正後の検証

修正コミットをチェックアウトした状態で同じコマンドを実行すると、すべてのテストが成功します。

## 学べること

| 概念 | このラボで確かめること |
|---|---|
| 部分関数 | `head :: [a] -> a` は空リストを型から除外できず、実行時に失敗し得ます。 |
| 遅延評価 | `Just (head names)` は `Just` を構築するだけでは例外を起こさず、内側の値がテストで評価された時点で失敗します。 |
| `Maybe` | 空リストという失敗可能性を `Nothing` として戻り値の型に表します。 |
| パターンマッチ | `[]` と `(x:_)` を分け、空リストに部分関数を適用しないようにします。 |

詳細な調査記録は `docs/debugging-record.md`、記事用原稿はコンテンツリポジトリ側にあります。
