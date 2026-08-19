# `foldl`が先頭一致の無限入力で停止しない不具合の調査記録

## 対象と既存題材との差分

このラボは、ロール列から `"admin"` の有無を求める `containsAdmin :: [String] -> Bool` が、先頭要素に一致があっても無限リストで結果を返さない問題を扱う。GHC 9.4.7、cabal-install 3.8.1.0、Hspec 2.10.10で検証した。

既存ラボは部分関数、`Either`の失敗伝播、非網羅パターンを扱う。本題材は、例外や型ではなく、**遅延評価の下で畳み込みが無限入力に対して生産的か**という契約を扱う。

## 期待値と観測

`"admin" : repeat "viewer"` では先頭要素だけで答えが `True` と確定するため、1秒以内に結果を返すべきである。しかし不具合状態のHspecは `Nothing` を観測した。

```text
expected: Just True
 but got: Nothing

Finished in 1.0006 seconds
2 examples, 1 failure
```

GHCiで型が `containsAdmin :: [String] -> Bool` であること、有限入力 `['admin', 'viewer']` では `True` になることを確認した。一方、無限入力の評価は2秒でタイムアウトした。完全な出力は `artifacts/` に保存している。

## 仮説の比較

| 仮説 | 予測 | 最小実験 | 結果 | 判定 |
|---|---|---|---|---|
| 文字列比較が壊れている | 有限入力の `"admin"` も `False` になる | 有限リストを実行する | `True` を返した | 棄却 |
| タイムアウト値が短すぎる | より長く待てば結果が返る | GHCiで2秒評価する | 2秒後も結果なし | 棄却 |
| `foldl` が末尾まで必要とする | 先頭一致でも無限末尾で停止しない | 最小の無限リストをHspecで評価する | `Nothing` を観測した | 採用 |

## 根本原因と最小修正

不具合状態は次の左畳み込みだった。

```haskell
containsAdmin = foldl (\found role -> found || role == "admin") False
```

`foldl` は左から畳むが、リスト全体の畳み込みを完了してから最終結果を返す。そのため、後続を評価しない短絡演算子 `||` があっても、無限の末尾には到達できない。`Data.List`は、リスト上の効率的な厳格左畳み込みには `foldl'` を検討するよう説明するが、本件の契約は蓄積器のstrictnessではなく、**無限リストで先頭から答えを出すこと**である。[1]

最小修正は右畳み込みに置き換えることだった。

```haskell
containsAdmin = foldr (\role found -> role == "admin" || found) False
```

`foldr` は結合関数が第2引数を要求しない場合、残りのリストを評価せずに結果を返せる。[2] 元のタイムアウト付きテストを残し、有限入力の対照ケースも実行した。修正後は2 examples, 0 failuresとなった。

不具合状態は `6bbdd3e`、最小修正と成功出力は `d8f8ec8` に分離した。

## 参考資料

[1] [Data.List — `foldl` と `foldl'` のドキュメント](https://hackage.haskell.org/package/base/docs/Data-List.html#v:foldl)

[2] [Data.Foldable — `foldr` と遅延評価のドキュメント](https://hackage.haskell.org/package/base/docs/Data-Foldable.html#v:foldr)
