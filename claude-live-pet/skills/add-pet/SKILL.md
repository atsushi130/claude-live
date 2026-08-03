---
name: add-pet
description: >
  claude-live-pet に自分のペット（ドット絵）を登録する。コマ一式のディレクトリからでも、
  スプライトシート 1 枚からでも登録できる。登録を外すこともできる。
  自動では起動しないので `/claude-live-pet:add-pet` で明示的に呼ぶ。
argument-hint: [名前と、コマの在り処]
user-invocable: true
disable-model-invocation: true
---

# ペットを登録する

`${CLAUDE_PLUGIN_ROOT}/scripts/add-pet` を使う。**コマ画像は複製せず、置いた場所を
そのまま覚える**（登録簿に名前とパスだけを書く）。素材は利用者のもので、
どこで管理するかも利用者が決める。

## 何を持っているかを先に見る

```bash
"${CLAUDE_PLUGIN_ROOT}"/scripts/add-pet
```

登録済み（パス付き）と同梱のペットが並ぶ。**同じ名前で登録すると同梱のものより
優先される**ので、名前が既にある場合は差し替えたいのか別名で増やしたいのかを確かめる。
`← 見つからない` が付いていれば、そのペットは移動か削除されている。

## コマ一式から登録する

`manifest.json` があるディレクトリをそのまま渡す。**そこに置いたままで動く。**

```bash
"${CLAUDE_PLUGIN_ROOT}"/scripts/add-pet 9s ~/somewhere/9s-frames
```

移動したら登録し直す。登録を外すなら次（コマ画像は消さない）。

```bash
"${CLAUDE_PLUGIN_ROOT}"/scripts/add-pet --forget 9s
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

切り出したコマの置き場所は、既定ではプラグインの持ち物の下になる。**そこは
アンインストールで消える**ので、残したい場合は `--out` で利用者の場所を指定する。
シートから作るときは、残したいかどうかを確かめてから決める。

```bash
"${CLAUDE_PLUGIN_ROOT}"/scripts/add-pet clawd --sheet ~/Downloads/clawd.webp \
  --out ~/pets/clawd stand=1 run=6 talk=4 walk=5 think=9
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

表示の切り替えは別。続けて切り替えるなら `/claude-live-pet:select-pet`、または直接:

```bash
"${CLAUDE_PLUGIN_ROOT}"/scripts/select-pet <名前>
```

## 確かめる

切り出した結果は画像として読んで確かめる。**コマ数が合っていても中身が違うことがある**
（走りのつもりが別の動きだった、など）。`stand` と、指定した動きのうち特徴が出る 1 枚を見る。
