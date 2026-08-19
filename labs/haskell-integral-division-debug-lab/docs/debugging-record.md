# 整数除算で平均の小数部が消える不具合の調査記録

## 対象と差分

`mean :: [Int] -> Maybe Double` は平均を返す。GHC 9.4.7、cabal-install 3.8.1.0、Hspec 2.10.10で検証した。本題材は、既存の`foldl`や遅延I/Oとは異なり、**数値型の変換時点が演算の意味を決める契約**を扱う。

## 観測

`mean [1, 2]` の期待値は`Just 1.5`だが、不具合状態は`Just 1.0`を返した。GHCiでは`mean [2, 4]`が`Just 3.0`となり、割り切れる対照ケースだけでは不具合を検出できないことを確認した。

## 仮説の比較

| 仮説 | 予測 | 最小実験 | 結果 | 判定 |
|---|---|---|---|---|
| `Double`への変換が失敗している | 割り切れる平均も誤る | `[2,4]`を実行する | `Just 3.0`を返した | 棄却 |
| 空入力処理が平均に影響する | 空以外でも`Nothing`になる | `[1,2]`を実行する | `Just 1.0`を返した | 棄却 |
| `div`が小数部を切り捨てる | 合計3、件数2が整数1になる | GHCiとHspecで確認する | `Just 1.0`を観測した | 採用 |

## 根本原因と最小修正

不具合状態は先に`div`で整数除算し、その結果を`Double`へ変換していた。

```haskell
Just (fromIntegral (sum values `div` length values))
```

`div`は`Integral`型の演算、`(/)`は`Fractional`型の演算である。[1] `div`の時点で小数部は失われるため、後から`fromIntegral`しても復元できない。

最小修正は、合計と件数を除算前に`Double`へ変換することだった。

```haskell
Just (fromIntegral (sum values) / fromIntegral (length values))
```

元の小数平均テストを残し、割り切れる平均と空入力も検証した。修正後は3 examples, 0 failuresとなった。不具合コミットは`2026713`、修正コミットは`31c9af1`である。

## 参考資料

[1] [Prelude — `Integral`、`Fractional`、`div`、`(/)`の仕様](https://hackage.haskell.org/package/base/docs/Prelude.html)
