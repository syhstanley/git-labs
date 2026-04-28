# Lab 04 — 遠端協作：remote / push / pull / fetch

## 情境 Scenario

你在本地做好了「關於我」頁面，要把它推上 GitHub 讓隊友 review。
同時，隊友 Alice 也推了一篇新文章。你需要：

1. 把你的 `feature/about` branch 推到 remote
2. 同步 Alice 的最新進度
3. 搞清楚 `pull` 和 `fetch` 的差別

---

## 指令說明 Command Reference

| 指令 | 說明 |
|------|------|
| `git remote -v` | 顯示目前所有遠端的名稱與 URL（v = verbose） |
| `git remote add <name> <url>` | 新增一個遠端（通常叫 `origin`） |
| `git push origin <branch>` | 把指定 branch 推到 remote |
| `git push -u origin <branch>` | 推並設定 upstream，之後可以直接 `git push` |
| `git fetch` | 從 remote 下載最新資料，但**不自動 merge** |
| `git pull` | `fetch` + `merge`，把 remote 的更新拉下來並合併 |
| `git pull --rebase` | `fetch` + `rebase`（保持線性歷史，進階用法） |

### fetch vs pull 的差異

```
git fetch origin
# 下載 remote 的資料，放進 origin/main 這個「遠端追蹤 branch」
# 你的 local main 不動，你可以先用 git log origin/main 看看有什麼
# 確認沒問題再 git merge origin/main 合進來

git pull
# 等於 git fetch + git merge，一步到位
# 適合你信任遠端的內容，不需要先 review
```

---

## 步驟教學 Step-by-step

### 準備：建立練習環境

```bash
cp -r starter/ ~/my-blog-lab04
cd ~/my-blog-lab04
git init
git add .
git commit -m "init: base blog"
git remote add origin <your-github-repo-url>
git push -u origin main

# 建立 feature/about branch 並做一個 commit
git switch -c feature/about
cat > about.html << 'ABOUT'
<!DOCTYPE html>
<html lang="zh-TW">
<head><meta charset="UTF-8"><title>關於我</title></head>
<body><h1>關於我</h1><p>Hi！我是部落格作者。</p></body>
</html>
ABOUT
git add about.html
git commit -m "feat: add about page"
```

---

### Step 1：查看目前的 remote 設定

```bash
git remote -v
```

**輸出：**

```
origin  git@github.com:<username>/my-blog.git (fetch)
origin  git@github.com:<username>/my-blog.git (push)
```

`origin` 是遠端的別名，預設名稱。`(fetch)` 是拉取的 URL，`(push)` 是推送的 URL（通常一樣）。

---

### Step 2：把你的 feature branch 推到 remote

```bash
git push -u origin feature/about
```

**輸出：**

```
Enumerating objects: 4, done.
...
To git@github.com:<username>/my-blog.git
 * [new branch]      feature/about -> feature/about
Branch 'feature/about' set up to track remote branch 'feature/about' from 'origin'.
```

`-u` 設定了 upstream，之後在 `feature/about` branch 上直接 `git push` 就夠了。

---

### Step 3：到 GitHub 上看看你的 branch

打開 `https://github.com/<username>/my-blog`，你應該能看到 `feature/about` branch 出現了，上面有你 push 的 `about.html`。

---

### Step 4：執行 setup.sh，模擬 Alice push 了新文章

```bash
git switch main
bash <path-to-lab-04>/setup.sh
```

---

### Step 5：用 git fetch 先看看 remote 有什麼新東西

```bash
git fetch origin
git log --oneline main         # 你的 local main
git log --oneline origin/main  # remote main
```

**輸出差異：**

```
# local main:
a1b2c3d init: base blog

# origin/main:
b2c3d4e docs: Alice adds git tips post  ← Alice 的新 commit
a1b2c3d init: base blog
```

`fetch` 把資料下載下來放在 `origin/main`，但你的 `main` 還沒動。

---

### Step 6：確認沒問題，merge 進來

```bash
git merge origin/main
```

**輸出：**

```
Updating a1b2c3d..b2c3d4e
Fast-forward
 posts/tips.md | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 posts/tips.md
```

`Fast-forward` 表示沒有衝突，只是把你的 `main` 指標往前移。

---

### Step 7：或者，直接用 git pull（等於上面兩步）

回到剛才的情境，這次改用 `pull`：

```bash
# 假設你沒有做 Step 5-6，直接：
git pull
```

**輸出相同。** `pull` = `fetch` + `merge`，一步完成。
`fetch` 的優點是讓你**先看看**對方改了什麼再決定要不要 merge。

---

## 練習題 Exercises

1. **push 新 branch**：建立一個 `feature/footer` branch，新增 `footer.html`，用 `git push -u origin feature/footer` 推上去，然後去 GitHub 網頁確認 branch 存在。

2. **fetch 再 merge**：請隊友（或再跑一次 setup.sh）在 remote main 做一個改動，你這邊用 `git fetch` + `git log origin/main` 先確認內容，再用 `git merge origin/main` 合進來。

3. **查看所有遠端 branch**：執行 `git branch -r`，看看 remote 上有哪些 branch。

---

## 解答 Answers

### 練習 1

```bash
git switch -c feature/footer
echo "<footer>© 2024 My Blog</footer>" > footer.html
git add footer.html
git commit -m "feat: add footer"
git push -u origin feature/footer
# 去 GitHub 確認：https://github.com/<username>/my-blog/branches
```

### 練習 2

```bash
git fetch origin
git log --oneline origin/main   # 看看 Alice 加了什麼
git merge origin/main            # 沒問題就 merge
git log --oneline                # 確認已更新
```

### 練習 3

```bash
git branch -r
# 輸出類似：
#   origin/feature/about
#   origin/feature/footer
#   origin/main
```

---

⬅️ 上一個 Lab: [Lab 03 — merge + conflict](../lab-03-merge-conflict/)
➡️ 下一個 Lab: [Lab 05 — stash](../lab-05-stash/)
