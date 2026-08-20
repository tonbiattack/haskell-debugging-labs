# Haskell `read` Partial Function Debug Lab

`Maybe`を返す関数の内部で部分関数`read`を使い、不正な再試行回数の文字列で例外が発生する不具合を再現するラボです。解析失敗を型で返すには`readMaybe`を使い、呼び出し側が例外処理を強制されない契約を作ります。

## 前提環境

| 項目 | バージョン |
|---|---:|
| GHC | 9.4.7 |
| cabal-install | 3.8.1.0 |
| Hspec | 2.10.10 |

## 不具合の再現

不具合状態では `parseRetryLimit "many"` が`Nothing`を返さず、`Prelude.read: no parse`で例外になります。

```bash
cabal test --offline --test-show-details=direct
```

失敗出力は `artifacts/failing-test-output.txt`、GHCiでの型と最小入力は `artifacts/ghci-observation.txt` に保存しています。

## 修正後の検証

修正後も同じコマンドを実行します。不正文字列と末尾文字を含む入力は`Nothing`、完全な数値は`Just`となることを確認します。

## 学べること

| 概念 | このラボで確かめること |
|---|---|
| `read` | 解析不能な入力で実行時例外となる部分関数である。 |
| `readMaybe` | 完全に解析できなければ`Nothing`を返す。 |
| `Maybe` | 戻り値の型だけでなく、実装内部も安全な変換を使う必要がある。 |

詳細な調査は `docs/debugging-record.md` に記録します。
