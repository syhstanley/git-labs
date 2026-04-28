#!/usr/bin/env bash
# setup.sh — Lab 03: 模擬隊友 Alice 修改了 index.html 的 <title> 並 push 到 main
# 執行後：remote main 比你的 local main 多一個 commit
# 你的 local 不受影響，需要 git pull 才能同步

set -e

# 確認目前在 my-blog repo 內
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "[error] 請在你的 my-blog repo 目錄內執行這個 script。"
  exit 1
fi

REMOTE_URL=$(git remote get-url origin)
TMP_DIR=$(mktemp -d /tmp/git-labs-setup-XXXX)

echo "[setup] Alice 正在 clone repo..."
git clone "$REMOTE_URL" "$TMP_DIR" --quiet

cd "$TMP_DIR"
git config user.name "Alice"
git config user.email "alice@example.com"

# Alice 修改 index.html 的 <title>（和你等一下要改的 nav 在同一個檔案）
sed -i 's/<title>My Blog<\/title>/<title>My Blog | 技術筆記<\/title>/' index.html
git add index.html
git commit -m "style: update page title" --quiet

git push origin main --quiet

cd /
rm -rf "$TMP_DIR"

echo "[setup] 完成！Alice 已把 index.html 的 <title> 改掉並 push 到 remote main。"
echo "[setup] 你的 local main 還是舊版本。"
echo "[setup] 現在請按照 README 的步驟繼續。"
