# Haskell Recursion Base-Case Debug Lab

`0`だけを終了条件にした再帰が、負数入力で永遠に減少して停止しない不具合を再現するラボです。再帰関数では「どの入力領域で終了するか」を明示的に定義し、型にある`Maybe`の失敗経路を実装する必要があります。

## 前提環境

| 項目 | バージョン |
|---|---:|
| GHC | 9.4.7 |
| cabal-install | 3.8.1.0 |
| Hspec | 2.10.10 |

## 不具合の再現

不具合コミットは `76456f2` です。不具合状態では `countDown (-1)` が`Nothing`を返さず、`n - 1`を繰り返します。

```bash
cabal test --offline --test-show-details=direct
```

失敗出力は `artifacts/failing-test-output.txt`、GHCiでの型と最小入力は `artifacts/ghci-observation.txt` に保存しています。

## 修正後の検証

修正コミットは `23b42c9` です。修正後も同じコマンドを実行します。負数は`Nothing`、ゼロと正数はゼロまでの列を返すことを確認します。

## 学べること

| 概念 | このラボで確かめること |
|---|---|
| 基底条件 | 終了条件が入力領域全体を覆わなければ再帰は停止しない。 |
| パターン順序 | より具体的な負数ガードを再帰節より先に置き、失敗経路を選択する。 |
| `Maybe` | 型だけでなく、不正な入力を`Nothing`へ分岐する実装が必要である。 |

詳細な調査は `docs/debugging-record.md` に記録します。
