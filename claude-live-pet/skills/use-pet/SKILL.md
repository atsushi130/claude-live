---
name: use-pet
description: >
  claude-live-pet で表示するペットを切り替える。見た目（大きさ・左右反転・動きの速さ）も変える。
  「ペットを変えて」「9s に戻して」「もう少し小さく」「走りが速すぎる」
  と言われたときに使う。
argument-hint: [ペットの名前]
user-invocable: true
---

# ペットを切り替える

```bash
"${CLAUDE_PLUGIN_ROOT}"/scripts/use-pet            # いま選んでいるものと、選べるもの
"${CLAUDE_PLUGIN_ROOT}"/scripts/use-pet 9s         # 切り替える
```

**起動し直さなくてよい。** 設定は 0.2 秒ごとに読み直され、ペットが変わればコマを
読み込み直して窓も作り直す。位置は左下を固定するのでずれない。

無い名前を渡すと、選べるものを並べて終わる。登録は `add-pet` スキル。

## 見た目を変える

書き込み用の `config.json` を書き換える。置き場所は次で分かる。

```bash
"${CLAUDE_PLUGIN_ROOT}"/scripts/use-pet | head -1
```

`config.json` に書ける項目。

| 項目 | 意味 |
| --- | --- |
| `pet` | 表示するペットの名前 |
| `height` | 表示する高さ（px） |
| `flipped` | 左右反転 |
| `idle` | 沈黙中に選ばれる動き。**同じ名前を複数書くと出やすくなる** |
| `sequences` | 動きごとに、使うコマ番号と 1 コマの表示時間（秒） |

`idle` と `sequences` の既定はペット側の `pet.json` にある。**素材ごとにコマ数も
速さも違うため**で、`config.json` に書いたものが動きごとに上書きする。
1 つ直したいだけなら、その動きだけ書けばよい。

```json
{ "pet": "clawd", "sequences": { "run": { "frames": [0,1,2,3,4,5,6,7], "interval": 0.18 } } }
```

## 反映のタイミング

| 変えたもの | 反映 |
| --- | --- |
| `config.json` | 0.2 秒以内 |
| ペット側の `pet.json` | **起動し直しが必要**（監視しているのは `config.json` だけ） |
| コマ画像そのもの | **起動し直しが必要** |

送りの速さを試しながら決めるときは、`pet.json` ではなく `config.json` 側に書く。
決まってから `pet.json` へ移すと、次に切り替えたときも同じ速さで出る。
