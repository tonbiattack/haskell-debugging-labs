# `withFile`の外で遅延文字列を消費した不具合の調査記録

## 対象と既存題材との差分

このラボは `readGreeting :: FilePath -> IO String` が、`withFile` の中で `hGetContents` を呼び、返した文字列をスコープ外で評価すると例外になる問題を扱う。GHC 9.4.7、cabal-install 3.8.1.0、Hspec 2.10.10で検証した。

既存のHaskellラボは純粋関数とパターンマッチを中心に扱う。本題材は、**`IO String` が返ったことと、その文字列が完全に消費できることは別であり、遅延評価とハンドルの寿命を一致させる必要がある**という境界を扱う。

## 期待値と観測

利用者は `readGreeting` の返した値を `withFile` の外で消費できると期待する。Hspecで `length contents` を評価すると、次の例外を観測した。

```text
artifacts/greeting.txt: hGetContents: illegal operation
(delayed read on closed handle)
```

GHCiでも `readGreeting :: FilePath -> IO String` と型検査は通る一方、`contents <- readGreeting "artifacts/greeting.txt"` の後に `length contents` を要求すると同じ例外になった。完全な出力は `artifacts/` に保存している。

## 仮説の比較

| 仮説 | 予測 | 最小実験 | 結果 | 判定 |
|---|---|---|---|---|
| ファイルパスまたは内容が不正 | `withFile` の中でただちに失敗する | 固定のテキスト入力を読む | 文字列を取得する段階では成功した | 棄却 |
| `withFile` がハンドルを閉じていない | 後からも遅延読み込みできる | 外側で `length` を評価する | クローズ済みハンドル例外になった | 棄却 |
| `hGetContents` の遅延読み込みが閉鎖後に発生する | 内容を要求した時点で例外になる | HspecとGHCiで `length` を評価する | 同じ例外を観測した | 採用 |

## 根本原因と最小修正

不具合状態の実装は次のとおりだった。

```haskell
readGreeting path = withFile path ReadMode hGetContents
```

`withFile` はアクションを実行した後にハンドルを閉じる。[1] 一方、`hGetContents` と `readFile` は内容を要求時に読む遅延I/Oである。[2] したがって、`withFile` のアクションが返すのは、まだハンドルに依存する遅延文字列である。

最小修正は、完全に読んでから返す `hGetContents'` を使うことだった。

```haskell
readGreeting path = withFile path ReadMode hGetContents'
```

`hGetContents'` は内容を返す前に完全に読む。[3] 元の失敗テストを削除せず、返した文字列の長さを `withFile` の外で評価する回帰テストとして残した。修正後は1 example, 0 failuresとなった。

不具合状態は `0a53a2d`、最小修正と成功出力は `0adcaa7` に分離した。

## 参考資料

[1] [System.IO — `withFile` のドキュメント](https://hackage.haskell.org/package/base/docs/System-IO.html#v:withFile)

[2] [System.IO — `hGetContents` と遅延I/Oのドキュメント](https://hackage.haskell.org/package/base/docs/System-IO.html#v:hGetContents)

[3] [System.IO — `hGetContents'` のドキュメント](https://hackage.haskell.org/package/base/docs/System-IO.html#v:hGetContents-39-)
