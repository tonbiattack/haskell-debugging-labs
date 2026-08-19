# 負数入力で停止しない再帰の調査記録

## 対象と差分

`countDown :: Int -> Maybe [Int]` は正数からゼロまでの列を返す。GHC 9.4.7、cabal-install 3.8.1.0、Hspec 2.10.10で検証した。本題材は、既存の非網羅パターンとは異なり、**再帰節へ入る全入力が必ず基底条件に到達するか**という停止契約を扱う。

## 観測

`countDown (-1)` は`Nothing`を返すべきだったが、タイムアウト付きテストは1秒後に`Nothing`（タイムアウト結果）となった。GHCiでは正数の`countDown 3`が`Just [3,2,1,0]`を返す一方、負数入力は2秒後も評価が終わらなかった。

## 仮説の比較

| 仮説 | 予測 | 最小実験 | 結果 | 判定 |
|---|---|---|---|---|
| `Maybe`が負数を自動的に失敗扱いにする | 型検査か実行で`Nothing`になる | 負数を評価する | 終了しない | 棄却 |
| 正数の再帰式も壊れている | `countDown 3`が失敗する | 正数の対照入力を実行する | 正しい列を返した | 棄却 |
| 負数が基底条件へ到達しない | `n - 1`で無限に減少する | GHCiを2秒実行する | タイムアウトした | 採用 |

## 根本原因と最小修正

不具合状態は`0`だけを基底条件にしていた。

```haskell
countDown 0 = Just [0]
countDown n = (n :) <$> countDown (n - 1)
```

負数は再帰節に入り、`-1, -2, ...`と`0`から離れていく。Haskellの`case`代替は上から順に試行され、どの代替にも一致しなければ結果はbottomになる。[1] 再帰関数でも、不正入力を再帰節より先に分岐する必要がある。

```haskell
countDown n | n < 0 = Nothing
countDown 0 = Just [0]
countDown n = (n :) <$> countDown (n - 1)
```

元のタイムアウト付きテストを残し、ゼロと正数の対照ケースも実行した。修正後は3 examples, 0 failuresとなった。不具合コミットは`76456f2`、修正コミットは`23b42c9`である。

## 参考資料

[1] [Haskell 2010 Report — Case Expressionsとパターンマッチ](https://www.haskell.org/onlinereport/haskell2010/haskellch3.html)
