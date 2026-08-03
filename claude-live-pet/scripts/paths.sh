#!/usr/bin/env bash
# 配布物の置き場所と、書き込み先の決め方。他のスクリプトから読み込む。
#
#   PET_ROOT       配布物の root。バージョンごとに入れ替わる
#   PET_SCRIPTS    実行するもの（バイナリ・スクリプト）
#   PET_RESOURCES  同梱の素材（ペットのコマ画像）
#   PET_DATA       書き込むもの（選んだペット・表示位置・登録したペット）
#
# **書き込み先はプラグインの外に置く。** プラグインごとの置き場所
# （`~/.claude/plugins/data/<プラグイン>-<マーケットプレイス>/`）は更新はまたげるが、
# **アンインストールで消える**（実測）。登録したペットは利用者が用意した素材で、
# プラグインを一度外しただけで失われてよいものではない。
#
# 消したいときは手で消す。プラグインの出入りとは切り離しておく。
#
# 版に依らない入口（`current`）だけはプラグインごとの置き場所に作る。
# あれは毎セッション作り直されるので、消えても次の起動で戻る（`connect` を参照）。

PET_SCRIPTS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
PET_ROOT="$(dirname "$PET_SCRIPTS")"
PET_RESOURCES="$PET_ROOT/resources"
PET_DATA="$HOME/.local/share/claude-live-pet"

mkdir -p "$PET_DATA"
