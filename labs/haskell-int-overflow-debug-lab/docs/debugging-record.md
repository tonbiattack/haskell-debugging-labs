# `Int`最大値で識別子がラップする不具合の調査記録

## 対象と差分

`nextIdentifier :: Int -> Maybe Int` は次の識別子を返す。GHC 9.4.7、cabal-install 3.8.1.0、Hspec 2.10.10、64-bit環境で検証した。本題材は、既存の整数除算とは異なり、**固定幅整数の上限を超えたときの値域契約**を扱う。

## 観測

`nextIdentifier maxBound` は`Nothing`を返すべきだが、GHCiでは`Just (-9223372036854775808)`を返した。通常値`41`は`Just 42`、ゼロは`Just 1`となるため、上限境界だけが失敗条件だった。

## 仮説の比較

| 仮説 | 予測 | 最小実験 | 結果 | 判定 |
|---|---|---|---|---|
| `Int`は任意精度である | `maxBound + 1`も正数になる | `maxBound`を表示する | 64-bitの有限値 | 棄却 |
| 通常の増分実装が壊れている | 41も増分できない | 通常入力を実行する | `Just 42` | 棄却 |
| GHCの`Int`が上限でラップする | 次の値が最小負数になる | maxBound入力を実行する | 負数を観測した | 採用 |

## 根本原因と最小修正

`Int`は固定精度の整数で、実装ごとの範囲は`minBound`と`maxBound`で取得できる。[1] GHCでは`Int`演算のオーバーフローは未検査で、ビット幅を法として演算される。[2] 不具合状態は無条件で`current + 1`を実行していた。

```haskell
nextIdentifier :: Int -> Maybe Int
nextIdentifier current
  | current == maxBound = Nothing
  | otherwise = Just (current + 1)
```

元の上限テストを残し、通常値とゼロの対照ケースを実行した。修正後は3 examples, 0 failuresとなった。不具合コミットは`2c8c0ed`、修正コミットは`e83941f`である。

## 参考資料

[1] [GHC.Int — `Int`の範囲と`Bounded`のドキュメント](https://hackage.haskell.org/package/base/docs/GHC-Int.html)
[2] [GHC User's Guide — `Int`オーバーフローの実装仕様](https://ghc.gitlab.haskell.org/ghc/doc/users_guide/bugs.html)
