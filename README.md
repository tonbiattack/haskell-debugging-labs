# Haskell Debugging Labs

Haskell固有の実行時挙動、エラー表現、パターンマッチを、**不具合の再現・観測・最小修正・回帰テスト**の順に学ぶための小さなラボ集です。各ラボはCabal、Hspec、必要に応じてQuickCheckを用い、バグ状態と修正状態を分離したGit履歴を持ちます。

## ラボ一覧

| ラボ | 扱う契約 | 不具合状態 | 修正状態 |
|---|---|---|---|
| `haskell-partial-function-debug-lab` | `[a]` と `head` の部分性、`Maybe` | `823020a` | `ab3d59e` |
| `haskell-either-error-propagation-debug-lab` | 解析失敗を`Either`の`Left`で伝播する | `524d38f` | `3962631` |
| `haskell-pattern-match-debug-lab` | 代数的データ型の全コンストラクタを網羅する | `8123267` | `a0c8e25` |

## 実行方法

まずリポジトリを取得し、対象ラボのディレクトリへ移動します。

```bash
git clone https://github.com/tonbiattack/haskell-debugging-labs.git
cd haskell-debugging-labs/labs/haskell-either-error-propagation-debug-lab
cabal test --offline --test-show-details=direct
```

各ラボのREADMEには、バグ状態を再現するコミット、修正後に成功するコミット、観測ログ、詳細な調査記録を記載しています。
