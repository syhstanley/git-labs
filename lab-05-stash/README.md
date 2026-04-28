# Lab 05 — 緊急插隊：stash

## 情境 Scenario

你正在開發 `feature/contact`（新增聯絡我頁面），已經改了一半。
這時隊友 Alice 在 Slack 上說：

> 「欸，`index.html` 的導覽列有個 typo，'首業' 應該是 '首頁'，要馬上修！」

你**不能直接 `git switch main`**，因為工作目錄有未 commit 的修改——Git 不讓你這樣做（或者會把修改帶到 main，更危險）。

**`git stash` 就是為這種情況設計的：暫時把改到一半的東西藏起來，去做緊急任務，回來再繼續。**

---

## 指令說明 Command Reference

| 指令 | 說明 |
|------|------|
| `git stash` | 把目前工作目錄和暫存區的修改全部藏起來，讓 working tree 變乾淨 |
| `git stash push -m "訊息"` | 藏起來並加上描述（推薦，方便識別） |
| `git stash list` | 列出所有 stash（最新的在最上面，`stash@{0}`） |
| `git stash pop` | 取回最新的 stash 並從列表刪除 |
| `git stash apply stash@{N}` | 取回指定的 stash，但**不刪除**（可重複套用） |
| `git stash drop stash@{N}` | 刪除指定的 stash |
| `git stash clear` | 刪除所有 stash |
| `git stash show stash@{N}` | 查看某個 stash 改了哪些檔案 |

---

## 步驟教學 Step-by-step

### 準備：建立練習環境

```bash
cp -r starter/ ~/my-blog-lab05
cd ~/my-blog-lab05
git init
git add .
git commit -m "init: base blog"
git remote add origin <your-github-repo-url>
git push -u origin main

# 執行 setup.sh 把 typo 植入 remote
git switch main
bash <path-to-lab-05>/setup.sh

# 把 typo 拉下來（現在你的 local 也有這個 typo）
git pull
```

---

### Step 1：開始開發新功能到一半

```bash
git switch -c feature/contact
cat > contact.html << 'CONTACT'
<!DOCTYPE html>
<html lang="zh-TW">
<head>
  <meta charset="UTF-8">
  <title>聯絡我 | My Blog</title>
</head>
<body>
  <h1>聯絡我</h1>
  <!-- TODO: 加上 email form -->
</body>
</html>
CONTACT

# 修改到一半，還沒完成，所以不 commit
echo "/* contact page styles */" >> style.css
git status
```

**輸出（working tree 是髒的）：**

```
On branch feature/contact
Changes not staged for commit:
        modified:   style.css

Untracked files:
        contact.html
```

---

### Step 2：嘗試直接切換到 main（會有警告）

```bash
git switch main
```

**輸出（Git 提醒你）：**

```
error: Your local changes to the following files would be overwritten by checkout:
        style.css
Please commit your changes or stash them before you switch branches.
Aborting
```

Git 說：「你的修改會被覆蓋，先 commit 或 stash 再說。」

---

### Step 3：用 stash 把修改藏起來

```bash
git stash push -m "WIP: contact page - adding form"
git status
```

**輸出（working tree 乾淨了）：**

```
On branch feature/contact
nothing to commit, working tree clean
```

---

### Step 4：查看 stash 列表

```bash
git stash list
```

**輸出：**

```
stash@{0}: On feature/contact: WIP: contact page - adding form
```

---

### Step 5：切到 main，修 typo，push

```bash
git switch main

# 修 typo
sed -i 's/首業/首頁/g' index.html
git add index.html
git commit -m "fix: correct typo in nav (首業 -> 首頁)"
git push
```

---

### Step 6：切回 feature branch，取回 stash

```bash
git switch feature/contact
git stash pop
git status
```

**輸出（你的修改回來了）：**

```
On branch feature/contact
Changes not staged for commit:
        modified:   style.css

Untracked files:
        contact.html
```

繼續你的開發 🎉

---

### Step 7（補充）：多個 stash 的管理

```bash
# 如果有多個 stash
git stash list
# stash@{0}: On feature/contact: WIP: contact form
# stash@{1}: On feature/about: WIP: about page layout

# 取回特定的
git stash apply stash@{1}

# 刪掉不需要的
git stash drop stash@{0}
```

---

## 練習題 Exercises

1. **基本流程**：在 `feature/new-post` branch 建立一個 `posts/draft.md`（內容隨意），用 `git stash push -m "draft post WIP"` 藏起來，切到 `main` 做一個無關的修改並 commit，再切回來用 `git stash pop` 取回。

2. **多個 stash**：做兩次 stash（先 stash A，再 stash B），用 `git stash list` 確認順序，然後用 `git stash apply stash@{1}` 取回 A 的修改（不是最新的那個）。

3. **清理 stash**：做完練習後，用 `git stash clear` 清空所有 stash，用 `git stash list` 確認列表是空的。

---

## 解答 Answers

### 練習 1

```bash
git switch -c feature/new-post
echo "# 新文章草稿" > posts/draft.md
echo "/* new post styles */" >> style.css
git stash push -m "draft post WIP"
git stash list
# stash@{0}: On feature/new-post: draft post WIP

git switch main
echo "<!-- footer -->" >> index.html
git add index.html
git commit -m "style: add footer comment"

git switch feature/new-post
git stash pop
ls posts/    # draft.md 回來了
```

### 練習 2

```bash
# Stash A
echo "change A" >> style.css
git stash push -m "stash A"

# Stash B
echo "change B" >> index.html
git stash push -m "stash B"

git stash list
# stash@{0}: stash B  ← 最新
# stash@{1}: stash A

git stash apply stash@{1}   # 取回 A 的修改
git diff style.css           # 確認 "change A" 回來了
```

### 練習 3

```bash
git stash clear
git stash list
# (空的，沒有輸出)
```

---

⬅️ 上一個 Lab: [Lab 04 — remote / push / pull / fetch](../lab-04-remote-push-pull/)
➡️ 下一個 Lab: [Lab 06 — reset / revert](../lab-06-reset-revert/)
