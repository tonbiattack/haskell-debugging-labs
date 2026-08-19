# Haskell Integral Division Debug Lab

平均値を`Double`で返す関数が、合計を先に`div`で割るため小数部を失う不具合を再現するラボです。Haskellでは`div`が整数除算、`(/)`が小数を扱う除算であり、変換する順序が結果の精度を決めます。

## 前提環境

| 項目 | バージョン |
|---|---:|
| GHC | 9.4.7 |
| cabal-install | 3.8.1.0 |
| Hspec | 2.10.10 |

## 不具合の再現

不具合コミットは `2026713` です。不具合状態では `mean [1, 2]` が `Just 1.5` ではなく `Just 1.0` を返します。

```bash
cabal test --offline --test-show-details=direct
```

失敗出力は `artifacts/failing-test-output.txt`、GHCiでの型と対照入力は `artifacts/ghci-observation.txt` に保存しています。

## 修正後の検証

修正コミットは `31c9af1` です。修正後も同じコマンドを実行します。小数部を持つ平均、整数になる平均、空入力を検証します。

## 学べること

| 概念 | このラボで確かめること |
|---|---|
| `div` | `Integral`の整数除算であり、小数部を返さない。 |
| `(/)` | `Fractional`の除算であり、小数を保持できる。 |
| `fromIntegral` | 除算の前に変換すれば、計算全体を`Double`で実行できる。 |

詳細な調査は `docs/debugging-record.md` に記録します。
