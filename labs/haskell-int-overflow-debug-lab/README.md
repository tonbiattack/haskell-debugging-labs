# Haskell Int Overflow Debug Lab

`Int`の最大値へ1を加えたとき、GHCでは未検査のオーバーフローにより最小の負数へラップする不具合を再現するラボです。識別子のように負数を許容しない値では、発番前に上限を検査して失敗を`Maybe`で伝播します。

## 前提環境

| 項目 | バージョン |
|---|---:|
| GHC | 9.4.7 |
| cabal-install | 3.8.1.0 |
| Hspec | 2.10.10 |
| 実行環境 | 64-bit `Int` |

## 不具合の再現

不具合コミットは `2c8c0ed` です。不具合状態では `nextIdentifier maxBound` が`Nothing`ではなく負数の識別子を返します。

```bash
cabal test --offline --test-show-details=direct
```

失敗出力は `artifacts/failing-test-output.txt`、GHCiでの型と最大値入力は `artifacts/ghci-observation.txt` に保存しています。

## 修正後の検証

修正コミットは `e83941f` です。修正後も同じコマンドを実行します。`maxBound`は`Nothing`、通常値とゼロは正しく増分されることを確認します。

## 学べること

| 概念 | このラボで確かめること |
|---|---|
| `Int` | 範囲が有限であり、実行環境ごとの`minBound`と`maxBound`を持つ。 |
| GHCの算術 | `Int`の算術はオーバーフローを検査せず、ビット幅でラップする。 |
| 発番契約 | 負数を許さない値では、増分前に上限を検査する必要がある。 |

詳細な調査は `docs/debugging-record.md` に記録します。
