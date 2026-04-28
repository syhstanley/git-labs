# Lab 01 — 讀懂現狀：status / log / diff

## 情境 Scenario

你剛拿到 `my-blog` 的 GitHub 帳號，第一件事是把 repo clone 下來。
打開資料夾一看，有幾個 HTML、CSS 和 Markdown 檔案——但你完全不知道**現在的狀態**是什麼、**最近有什麼改動**、**誰改了什麼**。

這個 Lab 教你用三個指令快速掌握 repo 的現況。

---

## 指令說明 Command Reference

| 指令 | 說明 |
|------|------|
| `git status` | 顯示工作目錄與暫存區的狀態（哪些檔案被修改、新增、刪除） |
| `git log` | 顯示完整的 commit 歷史（作者、時間、訊息） |
| `git log --oneline` | 每個 commit 只顯示一行（hash + 訊息），快速瀏覽 |
| `git log --oneline --graph` | 加上分支圖形，看出 branch 結構 |
| `git diff` | 顯示**尚未暫存**的修改內容（工作目錄 vs 最後一個 commit） |
| `git diff --staged` | 顯示**已暫存但未 commit** 的修改內容 |
| `git diff <hash1> <hash2>` | 比較任意兩個 commit 之間的差異 |

---

## 步驟教學 Step-by-step

### 準備：初始化練習用 repo

```bash
# 複製 starter 資料夾到你的工作區
cp -r starter/ ~/my-blog
cd ~/my-blog
git init
git add .
git commit -m "init: first commit"
```

> 這模擬你剛 clone 下來一個已有 commit 歷史的 repo。

---

### Step 1：用 git status 看現在的狀態

```bash
git status
```

**目前什麼都沒改，所以輸出是：**

```
On branch main
nothing to commit, working tree clean
```

這表示工作目錄是乾淨的（clean），沒有任何未追蹤或已修改的檔案。

---

### Step 2：修改一個檔案，再看 status

```bash
echo "<!-- updated -->" >> index.html
git status
```

**輸出：**

```
On branch main
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)

        modified:   index.html

no changes added to commit (use "git add" and/or "git commit -a")
```

`modified: index.html` — Git 偵測到你改了這個檔案，但還沒 `git add`。

---

### Step 3：把修改加進暫存區，再看一次 status

```bash
git add index.html
git status
```

**輸出：**

```
On branch main
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)

        modified:   index.html
```

現在檔案從 `Changes not staged` 變成 `Changes to be committed`，代表已進入暫存區，等待 commit。

---

### Step 4：新增一個未被追蹤的檔案

```bash
echo "# draft" > posts/draft.md
git status
```

**輸出（新增 Untracked files 區塊）：**

```
On branch main
Changes to be committed:
        modified:   index.html

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        posts/draft.md
```

`Untracked files` = 新建立的檔案，Git 從來沒追蹤過。

---

### Step 5：用 git log 看 commit 歷史

```bash
git log
```

**輸出範例：**

```
commit a1b2c3d4e5f6... (HEAD -> main)
Author: You <you@example.com>
Date:   Tue Apr 29 10:00:00 2026 +0800

    init: first commit
```

---

### Step 6：用 --oneline 看精簡版

```bash
git log --oneline
```

**輸出：**

```
a1b2c3d init: first commit
```

多個 commit 時，這個格式最好用。

---

### Step 7：用 git diff 看修改內容

先把暫存區的東西清掉，回到「已修改但未暫存」的狀態：

```bash
git restore --staged index.html
git diff
```

**輸出（顯示 index.html 的修改）：**

```diff
diff --git a/index.html b/index.html
index xxxxxxx..xxxxxxx 100644
--- a/index.html
+++ b/index.html
@@ -12,4 +12,5 @@
   </main>
 </body>
 </html>
+<!-- updated -->
```

`+` 開頭的行是新增的內容，`-` 開頭是被刪除的內容。

---

### Step 8：用 git diff --staged 看暫存區的修改

```bash
git add index.html
git diff --staged
```

輸出和 `git diff` 格式相同，但看的是**已暫存**的內容。

---

## 練習題 Exercises

1. **觀察**：在 `style.css` 裡修改 `color: #333` 為 `color: #111`，然後用 `git status` 和 `git diff` 確認你改了什麼。

2. **比較**：多做幾個 commit（每次改一個小東西），然後用 `git log --oneline` 列出所有 commit，再用 `git diff <舊hash> <新hash>` 比較第一個和最新的 commit 有什麼差異。

3. **清理**：用 `git restore index.html` 還原 index.html 的修改，再用 `git status` 確認它已經變回 clean。

---

## 解答 Answers

### 練習 1

```bash
# 修改 style.css
sed -i 's/color: #333/color: #111/' style.css

# 查看狀態
git status
# 輸出：modified: style.css

# 查看差異
git diff style.css
# 輸出會顯示 -  color: #333; 和 +  color: #111;
```

### 練習 2

```bash
# 做幾個 commit
echo "/* v2 */" >> style.css && git add . && git commit -m "style: tweak color"
echo "# new post" > posts/new.md && git add . && git commit -m "docs: add new post draft"

# 看歷史
git log --oneline
# 輸出類似：
# c3d4e5f docs: add new post draft
# b2c3d4e style: tweak color
# a1b2c3d init: first commit

# 比較第一個和最新的
git diff a1b2c3d c3d4e5f
```

### 練習 3

```bash
git restore index.html
git status
# 輸出：nothing to commit, working tree clean（index.html 那行消失了）
```

---

⬅️ 上一個 Lab: 無
➡️ 下一個 Lab: [Lab 02 — branch / switch](../lab-02-branch-switch/)
