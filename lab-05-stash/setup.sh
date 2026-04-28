#!/usr/bin/env bash
# setup.sh — Lab 05: 模擬 index.html 有一個 typo 被 Alice 發現並回報
# 這個 script 在 remote main 放入一個有 typo 的版本
# 等一下你要修掉這個 typo 並 push 回去

set -e

if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "[error] 請在你的 my-blog repo 目錄內執行這個 script。"
  exit 1
fi

REMOTE_URL=$(git remote get-url origin)
TMP_DIR=$(mktemp -d /tmp/git-labs-setup-XXXX)

echo "[setup] 植入 typo 到 remote main..."
git clone "$REMOTE_URL" "$TMP_DIR" --quiet

cd "$TMP_DIR"
git config user.name "Alice"
git config user.email "alice@example.com"

# 植入 typo：把 "首頁" 改成 "首業" (誤植)
sed -i 's/首頁/首業/g' index.html
git add index.html
git commit -m "oops: typo in nav (首業 should be 首頁)" --quiet
git push origin main --quiet

cd /
rm -rf "$TMP_DIR"

echo "[setup] 完成！remote main 的 index.html 有一個 typo（'首業' 應為 '首頁'）。"
echo "[setup] 你的 local 還是舊版本。"
echo "[setup] 先 git pull 把 typo 拉下來，然後按照 README 步驟繼續。"
