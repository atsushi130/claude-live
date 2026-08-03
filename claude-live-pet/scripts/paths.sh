#!/usr/bin/env bash
# 配布物の置き場所と、書き込み先の決め方。他のスクリプトから読み込む。
#
#   PET_ROOT       配布物の root。バージョンごとに入れ替わる
#   PET_SCRIPTS    実行するもの（バイナリ・スクリプト）
#   PET_RESOURCES  同梱の素材（ペットのコマ画像）
#   PET_DATA       このプラグインの持ち物（登録簿・選んだペット・表示位置）
#
# **PET_DATA はアンインストールで消える。それでよい。**
# ここに置くのは「どのペットをどこから読むか」「どれを選んでいるか」「どこに出すか」で、
# どれもプラグインの持ち物。プラグインを外せば一緒に消えるのが筋が通る。
#
# **コマ画像は複製せず、利用者が置いた場所から読む**（`add-pet` を参照）。
# 消えて困るのは素材の方で、それはこの下に無い。登録簿を失っても
# `add-pet <名前> <パス>` で戻せる。
#
# **環境変数に頼らない。** CLAUDE_PLUGIN_DATA はプラグインのフックや MCP サーバーには
# 渡るが、ここは claude-live 側の on-start から呼ばれることがあり、その場合は
# 別のプラグイン（claude-live）の値が入っている。取り違えると他人の置き場へ書く。
#
# 代わりに自分の居場所から決める。プラグインとして入っていれば
#   ~/.claude/plugins/cache/<マーケットプレイス>/<プラグイン>/<版>/scripts/
# に居るので、対になる置き場所は
#   ~/.claude/plugins/data/<プラグイン>-<マーケットプレイス>/
# になる。
#
# リポジトリから直接動かしているときは ~/.local/share/claude-live-pet/ に書く。
# 配布物の隣にすると、設定や登録簿がリポジトリの中に出来てしまう。

PET_SCRIPTS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
PET_ROOT="$(dirname "$PET_SCRIPTS")"
PET_RESOURCES="$PET_ROOT/resources"

case "$PET_ROOT" in
  */.claude/plugins/cache/*)
    _plugin="$(basename "$(dirname "$PET_ROOT")")"
    _marketplace="$(basename "$(dirname "$(dirname "$PET_ROOT")")")"
    PET_DATA="$HOME/.claude/plugins/data/${_plugin}-${_marketplace}"
    ;;
  *)
    PET_DATA="$HOME/.local/share/claude-live-pet"
    ;;
esac

mkdir -p "$PET_DATA"
