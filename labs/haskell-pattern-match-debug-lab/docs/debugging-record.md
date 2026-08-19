# 非網羅パターンマッチの警告を実行時例外と結び付けた調査記録

## 対象と既存題材との差分

このラボは `Delivery` の三つのコンストラクタのうち `Failed` を `deliveryMessage` が処理し忘れ、実行時に `PatternMatchFail` を起こす不具合を扱う。検証環境は GHC 9.4.7、cabal-install 3.8.1.0、Hspec 2.10.10である。

既存の部分関数ラボはライブラリ関数 `head` の前提条件違反を扱う。今回の中心は、アプリケーションが定義した代数的データ型にコンストラクタを追加した後、**自前の関数式がその状態を網羅できていない**こと、およびGHCの警告を実行時症状の予防に使うことである。

## 期待値と観測

失敗した配送はエラー理由を画面へ返すべきである。不具合状態のHspecでは `Failed "upstream timeout"` のケースだけが例外となり、`Queued` と `Sent` の対照ケースは成功した。

```text
Pattern match(es) are non-exhaustive
Patterns of type ‘Delivery’ not matched: Failed _

uncaught exception: PatternMatchFail
Non-exhaustive patterns in function deliveryMessage
```

GHCiでも `deliveryMessage :: Delivery -> String` は型検査を通る一方、`Failed` を評価すると例外を送出した。Haskell Reportは、関数のパターンが一致しない場合、その結果が ⊥ になることを説明している。[1]

## 仮説の比較

| 仮説 | 予測 | 最小実験 | 結果 | 判定 |
|---|---|---|---|---|
| `Failed` の文字列整形だけが誤っている | 文字列は返るが内容が期待値と違う | 失敗状態をHspecで評価する | 文字列比較前に例外となった | 棄却 |
| `Failed` の分岐が実装から欠けている | コンパイラ警告と例外が同じコンストラクタを示す | `-Wall` の出力とスタックトレースを確認する | 両方が `Failed _` の未一致を示した | 採用 |
| 全ての状態の表示ロジックが壊れている | `Queued` と `Sent` も失敗する | 対照ケースを実行する | 二つの対照ケースは成功した | 棄却 |

GHCの `-Wincomplete-patterns` は、実行時に失敗し得るパターンマッチを警告する。`-W` で有効になり、`-Wall` はその警告を含む。[2] 警告はコンパイルを止めないが、本件では実際の失敗ケースを正確に予告していた。

## 最小修正と回帰確認

`Failed` だけを追加した。

```haskell
deliveryMessage Queued = "queued"
deliveryMessage (Sent trackingNumber) = "sent: " ++ trackingNumber
deliveryMessage (Failed reason) = "failed: " ++ reason
```

元の失敗ケースを削除せず、三つのコンストラクタすべてをHspecで検証した。`cabal test --offline --test-show-details=direct` は3 examples, 0 failuresとなり、`-Wincomplete-patterns` の警告も出なくなった。成功出力は `artifacts/passing-test-output.txt` に保存している。

不具合状態は `710692b`、最小修正と回帰テストは `d6165fa` に分離した。

## 参考資料

[1] [Haskell 2010 Report, Chapter 3 — Pattern Matching](https://www.haskell.org/onlinereport/haskell2010/haskellch3.html)

[2] [GHC User’s Guide — `-Wincomplete-patterns`](https://ghc.gitlab.haskell.org/ghc/doc/users_guide/using-warnings.html#ghc-flag--Wincomplete-patterns)
