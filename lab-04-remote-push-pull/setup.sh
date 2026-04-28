#!/usr/bin/env bash
# setup.sh — Lab 04: 模擬隊友 Alice 新增了一篇文章並 push 到 main
# 執行後：remote main 有一個新的 posts/tips.md，你的 local 沒有

set -e

if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "[error] 請在你的 my-blog repo 目錄內執行這個 script。"
  exit 1
fi

REMOTE_URL=$(git remote get-url origin)
TMP_DIR=$(mktemp -d /tmp/git-labs-setup-XXXX)

echo "[setup] Alice 正在新增文章..."
git clone "$REMOTE_URL" "$TMP_DIR" --quiet

cd "$TMP_DIR"
git config user.name "Alice"
git config user.email "alice@example.com"

mkdir -p posts
cat > posts/tips.md << 'TIPS'
# Git 小技巧

收集一些好用的 Git 指令。

## 查看 remote 狀態

```bash
git remote -v
git fetch --all
```

## 快速查看某個檔案的修改歷史

```bash
git log --follow -p -- <filename>
```
TIPS

git add posts/tips.md
git commit -m "docs: Alice adds git tips post" --quiet
git push origin main --quiet

cd /
rm -rf "$TMP_DIR"

echo "[setup] 完成！Alice 已新增 posts/tips.md 到 remote main。"
echo "[setup] 你的 local main 還沒有這個檔案。"
echo "[setup] 現在按照 README 的步驟繼續。"
