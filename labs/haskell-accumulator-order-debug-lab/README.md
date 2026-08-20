# Haskell Accumulator Order Debug Lab

末尾再帰の累積器へ要素を先頭追加したあと、そのまま返すため入力順が反転する不具合を再現するラボです。累積器は効率のため逆順で構築されることが多く、境界で順序を戻すかを契約として明示する必要があります。

## 前提環境

| 項目 | バージョン |
|---|---:|
| GHC | 9.4.7 |
| cabal-install | 3.8.1.0 |
| Hspec | 2.10.10 |

## 不具合の再現

不具合状態では `collectLabels ["first", "second", "third"]` が逆順を返します。

```bash
cabal test --offline --test-show-details=direct
```

失敗出力は `artifacts/failing-test-output.txt`、GHCiでの型と対照入力は `artifacts/ghci-observation.txt` に保存しています。

## 修正後の検証

修正後も同じコマンドを実行します。複数要素、空入力、単一要素について、入力順が保たれることを確認します。

## 学べること

| 概念 | このラボで確かめること |
|---|---|
| 累積器 | `x : acc` は累積器を逆順で構築する。 |
| 順序契約 | 返却前に`reverse`するか、別の構築方法を選ぶ必要がある。 |
| 対照ケース | 空・単一要素だけでは順序反転を検出できない。 |

詳細な調査は `docs/debugging-record.md` に記録します。
