---
name: add-pet
description: >
  claude-live-pet に自分のペット（ドット絵）を登録する。コマ一式のディレクトリからでも、
  スプライトシート 1 枚からでも登録できる。
  「ペットを追加したい」「このドット絵をペットにして」「スプライトシートから切り出して」
  と言われたときに使う。
argument-hint: [名前と、コマの在り処]
user-invocable: true
---

# ペットを登録する

`${CLAUDE_PLUGIN_ROOT}/scripts/add-pet` を使う。登録先は書き込み用のディレクトリで、
プラグインを更新しても消えない。

## 何を持っているかを先に見る

```bash
"${CLAUDE_PLUGIN_ROOT}"/scripts/add-pet
```

登録済みと同梱のペットが並ぶ。**同じ名前で登録すると同梱のものより優先される**ので、
差し替えたいのか別名で増やしたいのかを、名前が既にある場合は確かめる。

## コマ一式から登録する

`manifest.json` があるディレクトリをそのまま渡す。

```bash
"${CLAUDE_PLUGIN_ROOT}"/scripts/add-pet 9s ~/somewhere/9s-frames
```

## スプライトシートから登録する

1 枚の画像を行ごとに切り出す。**まず格子を確かめてから**切り出す。

```bash
"${CLAUDE_PLUGIN_ROOT}"/scripts/slice-sheet --inspect ~/Downloads/clawd.webp
```

シートの大きさ・格子・各行のコマ数が出るので、**利用者に行と動きの対応を確かめる**。
どの行が何の動きかは画像を見ないと決められないので、勝手に決めない。
`--inspect` の結果が想定と合わない場合は `--cols` `--rows` で格子を指定する。

対応が決まったら登録する。行番号は 1 始まり。

```bash
"${CLAUDE_PLUGIN_ROOT}"/scripts/add-pet clawd --sheet ~/Downloads/clawd.webp \
  stand=1 run=6 talk=4 walk=5 think=9
```

## 動きの名前

| 名前 | 使われ方 |
| --- | --- |
| `stand` | **必須。** 無いと起動できない。窓の大きさもこのコマから決まる |
| `talk` | 読み上げているとき |
| `think` | 考えているとき |
| `walk` `run` | 沈黙中にランダムで選ばれる |

`stand` を欠かしたまま切り替えると起動に失敗するので、必ず含める。
これ以外の名前も登録できるが、`pet.json` の `idle` に並べないと出番がない。

## 登録しただけでは変わらない

表示の切り替えは別。続けて切り替えるなら `use-pet` スキル、または直接:

```bash
"${CLAUDE_PLUGIN_ROOT}"/scripts/use-pet <名前>
```

## 確かめる

切り出した結果は画像として読んで確かめる。**コマ数が合っていても中身が違うことがある**
（走りのつもりが別の動きだった、など）。`stand` と、指定した動きのうち特徴が出る 1 枚を見る。
