#!/usr/bin/env bash
# setup.sh — Lab 07: 模擬 Alice 在 main 推了新的 commit
# 讓你的 feature branch 需要 rebase 才能跟上 main

set -e

if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "[error] 請在你的 my-blog repo 目錄內執行這個 script。"
  exit 1
fi

REMOTE_URL=$(git remote get-url origin)
TMP_DIR=$(mktemp -d /tmp/git-labs-setup-XXXX)

echo "[setup] Alice 正在 main 上推新 commit..."
git clone "$REMOTE_URL" "$TMP_DIR" --quiet

cd "$TMP_DIR"
git config user.name "Alice"
git config user.email "alice@example.com"

cat > posts/weekly-digest.md << 'POST'
# 週報 #1

本週完成事項：
- 修好了 nav typo
- 新增了 About 頁面
- 整理了 CSS 架構

下週計畫繼續優化效能。
POST

git add posts/weekly-digest.md
git commit -m "docs: add weekly digest post" --quiet
git push origin main --quiet

cd /
rm -rf "$TMP_DIR"

echo "[setup] 完成！Alice 已在 main 上新增一個 commit。"
echo "[setup] 你的 feature branch 現在落後 main，需要 rebase。"
echo "[setup] 請先 git fetch origin，然後按 README 繼續。"
