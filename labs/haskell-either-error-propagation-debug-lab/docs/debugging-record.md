# `Either`の失敗経路を既定値で隠した不具合の調査記録

## 対象と既存題材との差分

このラボは `loadPort :: String -> Either String Int` が、非数値入力をエラーとして返さず `Right 8080` に置き換える不具合を扱う。GHC 9.4.7、cabal-install 3.8.1.0、Hspec 2.10.10、QuickCheck 2.14.3で検証した。

既存の `haskell-partial-function-debug-lab` は `head []` の部分関数が例外を起こす問題である。今回は例外ではなく、**型が失敗を表現できていても実装が失敗値を成功値へ変換し、入力不備を隠す**契約違反を対象にする。

## 期待値と観測

不正な設定値は既定値ではなく診断として呼び出し元へ返す必要がある。失敗状態のHspec出力は `artifacts/failing-test-output.txt` に保存した。

```text
expected: Left "port must be an integer"
 but got: Right 8080

Falsified (after 1 test):
"g"
```

GHCiでは型が `String -> Either String Int` でありながら、`loadPort "http"` が `Right 8080` を返ることを確認した。`Either a b` は `Left a` または `Right b` の二つの可能性を表し、慣例として `Left` はエラー、`Right` は正しい値に使われる。[1]

## 仮説の比較

| 仮説 | 予測 | 最小実験 | 結果 | 判定 |
|---|---|---|---|---|
| `readMaybe` が英字をポート番号として解析する | `readMaybe "http"` が数値になる | GHCiとHspecの入力を確認する | 関数は解析失敗の分岐へ入る | 棄却 |
| 解析失敗が既定値へ変換される | 非数値入力で `Right 8080` になる | `loadPort "http"` を実行する | `Right 8080` を観測した | 採用 |
| 範囲検証が失敗を成功に変える | `70000` も成功する | 範囲外の具体例を実行する | `Left "port must be between 1 and 65535"` になった | 棄却 |

`readMaybe` は `Read a => String -> Maybe a` を提供するため、解析失敗は `Nothing` として処理できる。[2] 根本原因はその `Nothing` を `Left` に変換せず、成功を意味する `Right 8080` に変換したことだった。

## 最小修正と回帰確認

修正では解析失敗の経路だけを変更した。

```haskell
loadPort raw =
  case readMaybe raw of
    Nothing -> Left "port must be an integer"
    Just port -> validatePort port
```

元の失敗テストを残し、任意の非空英小文字列を拒否するQuickCheckプロパティも残した。`cabal test --offline --test-show-details=direct` は4 examples, 0 failures、QuickCheckは100件成功となった。成功出力は `artifacts/passing-test-output.txt` に保存している。

不具合状態は `0aa776e`、最小修正と回帰テストは `d0ad45c` に分離した。

## 参考資料

[1] [Data.Either — `Either` のドキュメント](https://hackage.haskell.org/package/base/docs/Data-Either.html)

[2] [Text.Read — `readMaybe` のドキュメント](https://hackage.haskell.org/package/base/docs/Text-Read.html#v:readMaybe)
