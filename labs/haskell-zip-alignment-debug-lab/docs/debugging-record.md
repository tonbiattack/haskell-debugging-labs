# `zip`による予定の黙った切り捨ての調査記録

## 対象と差分

`assignSlots :: [String] -> [String] -> Maybe [(String, String)]` が人物と時刻を対応付ける。GHC 9.4.7、cabal-install 3.8.1.0、Hspec 2.10.10で検証した。本題材は、既存の部分関数・`Either`・パターン網羅性・評価戦略と異なり、**二つの入力列の対応関係を失わない契約**を扱う。

## 観測

人物2人と時刻1件を入力すると、期待した `Nothing` ではなく次を返した。

```text
expected: Nothing
 but got: Just [("Aki","09:00")]
```

GHCiでは型が `Maybe [(String, String)]` であること、件数一致なら2組が返ること、件数不一致なら1組だけの`Just`が返ることを確認した。完全な出力は`artifacts/`に保存している。

## 仮説の比較

| 仮説 | 予測 | 最小実験 | 結果 | 判定 |
|---|---|---|---|---|
| `Maybe`の型が不一致を自動処理する | 型検査または実行時に`Nothing`になる | 不一致入力を実行する | `Just`で1組を返した | 棄却 |
| `zip`が長い方を補完する | 2組目に空値が入る | GHCiで出力を確認する | 余剰の人物は出力にない | 棄却 |
| `zip`が短い方で停止する | 先頭1組だけが残る | Hspecを実行する | 1組だけを観測した | 採用 |

## 根本原因と最小修正

不具合状態は`Just (zip people slots)`だった。`zip`は二つのリストを対応付けるが、一方が短い場合は長い方の余剰要素を捨てる。[1] `Maybe`の戻り値だけでは、件数不一致を検査しない実装のデータ消失を防げない。

最小修正では二つのリストを同時に再帰し、片方だけが尽きた場合を`Nothing`にする。

```haskell
assignSlots [] [] = Just []
assignSlots (person : people) (slot : slots) =
  ((person, slot) :) <$> assignSlots people slots
assignSlots _ _ = Nothing
```

元の不一致テストを残し、件数一致と空入力の対照ケースも実行した。修正後は3 examples, 0 failuresとなった。不具合コミットは`33cb0c5`、修正コミットは`2581205`である。

## 参考資料

[1] [Data.List — `zip`のドキュメント](https://hackage.haskell.org/package/base/docs/Data-List.html#v:zip)
