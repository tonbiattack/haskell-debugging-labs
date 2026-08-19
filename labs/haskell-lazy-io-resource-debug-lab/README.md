# Haskell Lazy I/O Resource Debug Lab

`withFile` のスコープ内で `hGetContents` を取得し、その遅延文字列をスコープ外で消費すると、クローズ済みハンドルを読もうとして失敗する不具合を再現するラボです。I/Oアクションが終わったことと、返された値が完全に評価済みであることの違いを小さなHspecテストで確認します。

## 前提環境

| 項目 | バージョン |
|---|---:|
| GHC | 9.4.7 |
| cabal-install | 3.8.1.0 |
| Hspec | 2.10.10 |

## 不具合の再現

不具合状態は `0a53a2d` です。不具合状態では、`readGreeting` は `String` を返したように見えても、文字数を要求した時点で `hGetContents: illegal operation (delayed read on closed handle)` を送出します。

```bash
cabal test --offline --test-show-details=direct
```

完全な出力は `artifacts/failing-test-output.txt`、型とGHCiでの最小入力は `artifacts/ghci-observation.txt` に保存しています。

## 修正後の検証

修正コミットは `0adcaa7` です。修正後も同じコマンドを実行します。返された文字列を `withFile` の外で完全に消費できることを回帰テストとして確認します。

## 学べること

| 概念 | このラボで確かめること |
|---|---|
| `withFile` | アクション終了時にハンドルを閉じるため、ハンドルを使う読み込みはスコープ内で完了させる必要があります。 |
| `hGetContents` | 遅延文字列を返すため、値の取得直後にはファイル内容がすべて読まれているとは限りません。 |
| `hGetContents'` | 内容を返す前に完全に読むため、`withFile` の外で文字列を消費する契約を満たせます。 |

詳細な仮説比較と根本原因は `docs/debugging-record.md` に記録します。
