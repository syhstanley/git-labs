# Lab 07 — 整理歷史：rebase / squash

## 情境 Scenario

你的 `feature/contact` branch 開發了一陣子，commit 歷史長這樣：

```
feat: add contact page
fix typo
fix typo again
adjust layout
wip
```

開 PR 給隊友 review 之前，這些 commit 看起來非常不專業。
而且 main 在你開發期間也往前走了幾個 commit，你的 branch 已經落後。

這個 Lab 教你：
1. 用 `rebase` 把 feature branch 的基礎接到最新的 main
2. 用 `squash` 把多個零碎 commit 合成一個清楚的 commit

---

## 指令說明 Command Reference

| 指令 | 說明 |
|------|------|
| `git rebase <branch>` | 把目前 branch 的 commits 移到指定 branch 的最新點之後 |
| `git rebase origin/main` | rebase 到 remote main 的最新狀態 |
| `git rebase -i HEAD~N` | 互動式 rebase：整理最近 N 個 commit |
| `git rebase --abort` | 取消進行中的 rebase |
| `git rebase --continue` | 解完衝突後繼續 rebase |

### rebase 互動式指令

在 `git rebase -i` 打開的編輯器裡，每行開頭可以改成：

| 指令 | 縮寫 | 說明 |
|------|------|------|
| `pick` | `p` | 保留這個 commit（預設）|
| `squash` | `s` | 合併到上一個 commit，**保留 commit 訊息** |
| `fixup` | `f` | 合併到上一個 commit，**丟棄 commit 訊息** |
| `reword` | `r` | 保留 commit，但讓你重新編輯訊息 |
| `drop` | `d` | 刪除這個 commit |

### rebase vs merge

```
merge：保留所有歷史，多一個 merge commit，分叉圖比較複雜
rebase：讓歷史變成一條直線，更乾淨，但會改寫 commit hash

推薦做法：
- feature branch 在 PR 前用 rebase 整理
- 已 push 到 remote 的 branch 要小心 rebase（需要 force push）
```

---

## 步驟教學 Step-by-step

### 準備：建立練習環境

```bash
cp -r starter/ ~/my-blog-lab07
cd ~/my-blog-lab07
git init
git add .
git commit -m "init: base blog"
git remote add origin <your-github-repo-url>
git push -u origin main

# 建立 feature branch，做幾個零碎的 commit
git switch -c feature/contact

echo "<!-- contact page -->" > contact.html
git add contact.html
git commit -m "feat: add contact page skeleton"

echo "<h1>聯絡我</h1>" >> contact.html
git add contact.html
git commit -m "fix typo"

echo "<p>Email: me@example.com</p>" >> contact.html
git add contact.html
git commit -m "fix typo again"

echo "<p>GitHub: github.com/me</p>" >> contact.html
git add contact.html
git commit -m "wip"

echo "/* contact styles */" >> style.css
git add style.css
git commit -m "adjust layout"

# 查看目前的 commit 歷史
git log --oneline
```

**輸出（5 個零碎 commit）：**

```
e5f6g7h adjust layout
d4e5f6g wip
c3d4e5f fix typo again
b2c3d4e fix typo
a1b2c3d feat: add contact page skeleton
xxxxxxx init: base blog
```

---

### Step 1：執行 setup.sh，讓 main 往前走

```bash
git switch main
bash <path-to-lab-07>/setup.sh
git fetch origin
git log --oneline origin/main
```

**輸出：**

```
y9z0a1b docs: add weekly digest post  ← Alice 的新 commit
xxxxxxx init: base blog
```

---

### Step 2：用 rebase 把 feature branch 接到最新的 main

```bash
git switch feature/contact
git rebase origin/main
git log --oneline
```

**輸出（你的 commits 移到 Alice 的 commit 之後）：**

```
e5f6g7h adjust layout
d4e5f6g wip
c3d4e5f fix typo again
b2c3d4e fix typo
a1b2c3d feat: add contact page skeleton
y9z0a1b docs: add weekly digest post  ← Alice 的 commit 現在在你的下面
xxxxxxx init: base blog
```

---

### Step 3：用互動式 rebase 整理最近 5 個 commit

```bash
git rebase -i HEAD~5
```

**這會開啟編輯器，內容類似：**

```
pick a1b2c3d feat: add contact page skeleton
pick b2c3d4e fix typo
pick c3d4e5f fix typo again
pick d4e5f6g wip
pick e5f6g7h adjust layout
```

**修改成（把後面 4 個都 fixup 到第一個）：**

```
pick a1b2c3d feat: add contact page skeleton
fixup b2c3d4e fix typo
fixup c3d4e5f fix typo again
fixup d4e5f6g wip
fixup e5f6g7h adjust layout
```

存檔離開（`:wq`）。

> `fixup` 會合併並丟棄這些 commit 的訊息，只保留第一個 `pick` 的訊息。
> 如果你想編輯合併後的訊息，用 `squash` 取代 `fixup`。

---

### Step 4：查看整理後的結果

```bash
git log --oneline
```

**輸出（5 個 commit 合成 1 個）：**

```
f6g7h8i feat: add contact page skeleton  ← 一個乾淨的 commit
y9z0a1b docs: add weekly digest post
xxxxxxx init: base blog
```

---

### Step 5：Push（因為 rebase 改寫了歷史，需要 force push）

```bash
# 如果這個 branch 已經 push 過
git push --force-with-lease origin feature/contact
```

> `--force-with-lease` 比 `--force` 安全：只有在 remote 沒有你不知道的新 commit 時才允許 force push。

---

## 練習題 Exercises

1. **rebase 到 main**：建立一個新的 feature branch，做 2 個 commit。然後在 main 上做 1 個 commit（模擬隊友的更新）。用 `git rebase main` 把 feature branch 接到最新的 main，用 `git log --oneline --graph` 確認歷史是直線（不是分叉）。

2. **squash 練習**：在一個 branch 上做 4 個 commit，用 `git rebase -i HEAD~4` 把它們 squash 成 1 個，並用 `reword` 改成一個清楚的 commit 訊息。

3. **處理 rebase 衝突**：製造一個會衝突的 rebase 情境（兩邊都改了同一個檔案），解完衝突後用 `git rebase --continue` 繼續。

---

## 解答 Answers

### 練習 1

```bash
git switch -c feature/test-rebase
echo "test A" >> index.html && git add . && git commit -m "test: change A"
echo "test B" >> index.html && git add . && git commit -m "test: change B"

git switch main
echo "main update" >> style.css && git add . && git commit -m "style: main update"

git switch feature/test-rebase
git rebase main
git log --oneline --graph
# 歷史是直線，test A 和 test B 在 main update 的後面
```

### 練習 2

```bash
git switch -c feature/squash-test
for i in 1 2 3 4; do
  echo "change $i" >> style.css
  git add . && git commit -m "wip $i"
done
git rebase -i HEAD~4
# 把第 2、3、4 行改成 squash，第 1 行保留 pick
# 存檔後會打開訊息編輯器，改成清楚的訊息
# 例如："feat: complete style overhaul"
git log --oneline   # 只剩 1 個 commit
```

### 練習 3

```bash
git switch main
echo "main line" >> style.css && git add . && git commit -m "main: change style"

git switch -c feature/conflict-rebase
echo "feature line" >> style.css && git add . && git commit -m "feat: change style"

git rebase main
# CONFLICT in style.css
# 手動解決衝突，刪掉 <<< === >>> 標記
git add style.css
git rebase --continue
# 存檔訊息後完成
```

---

⬅️ 上一個 Lab: [Lab 06 — reset / revert](../lab-06-reset-revert/)
➡️ 下一個 Lab: [Lab 08 — cherry-pick / tag](../lab-08-cherry-pick-tag/)
