# Haskell Pattern Match Debug Lab

配送状態を表示する関数が `Failed` コンストラクタを処理し忘れ、型検査を通過した後に実行時のパターンマッチ例外を起こす不具合を再現するラボです。

不具合を含むコミットは `710692b` です。`deliveryMessage (Failed "upstream timeout")` は表示文字列を返すべきですが、`Non-exhaustive patterns` の例外を送出します。`-Wall` に含まれる `-Wincomplete-patterns` の警告とHspecの失敗出力を `artifacts/` に保存しています。修正コミット `d6165fa` は、同じテストを回帰テストとして成功させます。

## 前提環境

| 項目 | バージョン |
|---|---:|
| GHC | 9.4.7 |
| cabal-install | 3.8.1.0 |
| Hspec | 2.10.10 |

## 不具合の再現

```bash
git switch --detach 710692b
cabal test --offline --test-show-details=direct
```

初期状態では、失敗状態を表示するテストだけが例外で失敗し、待機中・送信済みの対照ケースは成功します。修正状態は次で検証します。

```bash
git switch --detach d6165fa
cabal test --offline --test-show-details=direct
```

詳細な仮説比較と証拠は `docs/debugging-record.md` にあります。
