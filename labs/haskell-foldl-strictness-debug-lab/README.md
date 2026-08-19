# Haskell foldl Productivity Debug Lab

先頭要素で答えが確定するロール列に対して、`foldl` を使った検索が無限入力で停止しない不具合を再現するラボです。有限リストでは正しく見えるため、遅延評価と畳み込み方向の境界をHspecで固定します。

## 前提環境

| 項目 | バージョン |
|---|---:|
| GHC | 9.4.7 |
| cabal-install | 3.8.1.0 |
| Hspec | 2.10.10 |

## 不具合の再現

不具合状態は `6bbdd3e` です。不具合状態では、最初の要素が `"admin"` であっても、無限に続く残りのリストを読み終えるまで `foldl` が結果を返せません。

```bash
cabal test --offline --test-show-details=direct
```

`returns True when admin is the first element of an infinite role stream` は1秒で `Nothing` になり失敗し、有限入力の対照ケースは成功します。完全な出力は `artifacts/failing-test-output.txt`、型と最小入力の観測は `artifacts/ghci-observation.txt` にあります。

## 修正後の検証

修正コミットは `d8f8ec8` です。修正後も同じコマンドを実行します。先頭一致の無限ストリームがただちに `True` となり、有限入力の対照ケースも成功することを確認します。

## 学べること

| 概念 | このラボで確かめること |
|---|---|
| `foldl` | 左畳み込みはリスト末尾まで到達しないと最終結果を返せないため、先頭一致でも無限入力では停止しない。 |
| `foldr` | 結合関数が第2引数を要求しない場合、必要な接頭辞だけを評価して答えを返せる。 |
| 生産性 | 無限入力に対しても有限時間で必要な出力を返せるかを、タイムアウト付きテストで確認する。 |

詳細な仮説比較と根本原因は `docs/debugging-record.md` に記録します。
