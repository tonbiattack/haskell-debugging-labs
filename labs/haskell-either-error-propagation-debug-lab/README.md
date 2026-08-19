# Haskell Either Error Propagation Debug Lab

文字列からTCPポートを読み込む処理で、`Either String Int` を返しているにもかかわらず、非数値入力を既定ポートへ静かに置き換える不具合を再現するラボです。

不具合を含むコミットは `0aa776e` です。`loadPort "http"` は `Left "port must be an integer"` を返すべきですが、`Right 8080` を返します。Hspecの失敗出力とGHCiの観測は `artifacts/` に保存しています。修正コミット `d0ad45c` は、同じテストを回帰テストとして成功させます。

## 前提環境

| 項目 | バージョン |
|---|---:|
| GHC | 9.4.7 |
| cabal-install | 3.8.1.0 |
| Hspec | 2.10.10 |
| QuickCheck | 2.14.3 |

## 不具合の再現

```bash
git switch --detach 0aa776e
cabal test --offline --test-show-details=direct
```

初期状態では、非数値入力を拒否する例と英小文字列を拒否するプロパティが失敗します。修正状態は次で検証します。

```bash
git switch --detach d0ad45c
cabal test --offline --test-show-details=direct
```

詳細な仮説比較と証拠は `docs/debugging-record.md` にあります。
