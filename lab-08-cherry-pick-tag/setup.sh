#!/usr/bin/env bash
# setup.sh — Lab 08: 在 remote 建立一個 staging branch
# staging branch 上有一個 hotfix commit 和一些 WIP commit
# 你要用 cherry-pick 只把 hotfix 撈到 main

set -e

if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "[error] 請在你的 my-blog repo 目錄內執行這個 script。"
  exit 1
fi

REMOTE_URL=$(git remote get-url origin)
TMP_DIR=$(mktemp -d /tmp/git-labs-setup-XXXX)

echo "[setup] 在 remote 建立 staging branch..."
git clone "$REMOTE_URL" "$TMP_DIR" --quiet

cd "$TMP_DIR"
git config user.name "Alice"
git config user.email "alice@example.com"

# 建立 staging branch from main
git switch -c staging --quiet

# WIP commit 1（不要 cherry-pick 這個）
cat > posts/wip-feature.md << 'POST'
# WIP Feature

這篇文章還在寫，先不要上線。
POST
git add posts/wip-feature.md
git commit -m "wip: new feature article (not ready)" --quiet

# Hotfix commit（這個要 cherry-pick 到 main）
sed -i 's/color: #333/color: #222/' style.css
git add style.css
git commit -m "fix: improve text contrast for accessibility" --quiet

# WIP commit 2（不要 cherry-pick 這個）
echo "/* experimental */" >> style.css
git add style.css
git commit -m "wip: experimental dark mode (not ready)" --quiet

git push origin staging --quiet

cd /
rm -rf "$TMP_DIR"

echo "[setup] 完成！remote 現在有一個 'staging' branch。"
echo "[setup] 上面有 3 個 commit："
echo "  1. wip: new feature article (not ready)"
echo "  2. fix: improve text contrast for accessibility  <- 你要撈這個"
echo "  3. wip: experimental dark mode (not ready)"
echo "[setup] 請先 git fetch origin，然後按 README 步驟繼續。"
