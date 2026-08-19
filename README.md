# Haskell Debugging Labs

Haskell固有の実行時挙動、エラー表現、パターンマッチを、**不具合の再現・観測・最小修正・回帰テスト**の順に学ぶための小さなラボ集です。各ラボはCabal、Hspec、必要に応じてQuickCheckを用い、バグ状態と修正状態を分離したGit履歴を持ちます。

## ラボ一覧

| ラボ | 扱う契約 | 不具合状態 | 修正状態 |
|---|---|---|---|
| `haskell-partial-function-debug-lab` | `[a]` と `head` の部分性、`Maybe` | `823020a` | `ab3d59e` |
| `haskell-either-error-propagation-debug-lab` | 解析失敗を`Either`の`Left`で伝播する | `524d38f` | `3962631` |
| `haskell-pattern-match-debug-lab` | 代数的データ型の全コンストラクタを網羅する | `8123267` | `a0c8e25` |
| `haskell-foldl-strictness-debug-lab` | 無限入力に対する畳み込みの生産性と短絡評価 | `6bbdd3e` | `d8f8ec8` |
| `haskell-lazy-io-resource-debug-lab` | 遅延I/Oと`withFile`のハンドル寿命を一致させる | `0a53a2d` | `0adcaa7` |
| `haskell-zip-alignment-debug-lab` | `zip`の件数不一致によるデータ切り捨てを防ぐ | `33cb0c5` | `2581205` |
| `haskell-recursion-base-case-debug-lab` | 負数入力での再帰停止条件を保証する | `76456f2` | `23b42c9` |
| `haskell-integral-division-debug-lab` | 整数除算で平均の小数部を失わない | `2026713` | `31c9af1` |

## 実行方法

まずリポジトリを取得し、対象ラボのディレクトリへ移動します。

```bash
git clone https://github.com/tonbiattack/haskell-debugging-labs.git
cd haskell-debugging-labs/labs/haskell-either-error-propagation-debug-lab
cabal test --offline --test-show-details=direct
```

各ラボのREADMEには、バグ状態を再現するコミット、修正後に成功するコミット、観測ログ、詳細な調査記録を記載しています。
