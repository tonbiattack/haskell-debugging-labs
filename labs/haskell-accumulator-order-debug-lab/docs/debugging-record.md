# 累積器で入力順が反転する不具合の調査記録

## 対象と差分

`collectLabels :: [String] -> [String]` はラベルを返す。GHC 9.4.7、cabal-install 3.8.1.0、Hspec 2.10.10で検証した。本題材は、既存の`foldl`生産性とは異なり、**先頭追加で構築する累積器と公開する出力順の契約**を扱う。

## 観測

3要素の入力に対し期待した`["first","second","third"]`ではなく`["third","second","first"]`が返った。空入力と単一要素は通過したため、境界ケースだけでは順序の不具合を検出できなかった。

## 仮説の比較

| 仮説 | 予測 | 最小実験 | 結果 | 判定 |
|---|---|---|---|---|
| 入力を逆順で受け取っている | 空入力も異常になる | 空入力を実行する | `[]` | 棄却 |
| 先頭追加が累積器を逆順にする | 3要素だけが逆順になる | GHCiで複数要素を実行する | 完全に逆順 | 採用 |
| 返却前の順序回復がある | 出力は元順になる | Hspecを実行する | 逆順のまま | 棄却 |

## 根本原因と最小修正

`label : accumulated`は各要素を累積器の先頭へ置くため、最終累積器は逆順になる。`reverse`はリストを逆順に返す標準関数である。[1] 不具合状態は逆順の累積器を直接返していた。

```haskell
collectLabels labels = reverse (go [] labels)
  where
    go accumulated [] = accumulated
    go accumulated (label : remaining) = go (label : accumulated) remaining
```

元の3要素テストを残し、空・単一要素の対照ケースも実行した。修正後は3 examples, 0 failuresとなった。不具合コミットは`2c9f7bb`、修正コミットは`0c6f8d6`である。

## 参考資料

[1] [Data.List — `reverse`のドキュメント](https://hackage.haskell.org/package/base/docs/Data-List.html#v:reverse)
