# `read`の解析例外を`Maybe`へ変換する調査記録

## 対象と差分

`parseRetryLimit :: String -> Maybe Int` が再試行回数を解析する。GHC 9.4.7、cabal-install 3.8.1.0、Hspec 2.10.10で検証した。既存の`head`ラボとは異なり、**文字列から値への変換が完全でないときの部分性**を扱う。

## 観測

`parseRetryLimit "many"` の期待値は`Nothing`だが、Hspecは`Prelude.read: no parse`という`ErrorCall`を観測した。`"3"`は`Just 3`となり、末尾文字を含む`"3times"`も同じ例外だった。型は`String -> Maybe Int`であり、型検査は不正な内部実装を拒否しなかった。

## 仮説の比較

| 仮説 | 予測 | 最小実験 | 結果 | 判定 |
|---|---|---|---|---|
| `Maybe`が失敗を自動処理する | 不正入力で`Nothing`になる | Hspecを実行する | 例外になった | 棄却 |
| 数字の変換全体が壊れている | `"3"`も失敗する | GHCiで正常入力を実行する | `Just 3` | 棄却 |
| `read`が部分関数である | 解析不能時に`no parse`となる | 不正入力を評価する | `ErrorCall`を観測した | 採用 |

## 根本原因と最小修正

不具合状態は`Just (read raw)`だった。`read`は入力が完全に消費できないときには安全な戻り値を作らず、`readMaybe`または`readEither`を使うべきである。[1]

```haskell
import Text.Read (readMaybe)

parseRetryLimit :: String -> Maybe Int
parseRetryLimit = readMaybe
```

元の二つの異常入力テストを残し、正常入力も実行した。修正後は3 examples, 0 failuresとなった。不具合コミットは`07d5d99`、修正コミットは`8a46d13`である。

## 参考資料

[1] [Text.Read — `read`、`readMaybe`のドキュメント](https://hackage.haskell.org/package/base/docs/Text-Read.html)
