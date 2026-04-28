# Lab 03 — 解決衝突：merge + conflict

## 情境 Scenario

你在 `feature/about` branch 上把 `index.html` 的 `<nav>` 加上了「關於我」連結。
同時，隊友 Alice 也在 `main` 上改了 `index.html` 的 `<title>`。
你要把 `feature/about` merge 回 `main`——但兩個人都改了同一個檔案，**衝突（conflict）爆發了**。

---

## 指令說明 Command Reference

| 指令 | 說明 |
|------|------|
| `git merge <branch>` | 把指定 branch 的修改合併到目前所在的 branch |
| `git status` | merge 衝突時，用這個看哪些檔案有衝突 |
| `git add <file>` | 解完衝突後，標記為「已解決」 |
| `git merge --abort` | 後悔了？用這個取消 merge，回到衝突前的狀態 |
| `git log --oneline --graph --all` | 看所有 branch 的分叉與合併圖 |

### 衝突標記說明

```
<<<<<<< HEAD
你目前 branch 的內容
=======
對方 branch 的內容
>>>>>>> feature/about
```

- `<<<<<<< HEAD` 到 `=======` 是你**目前所在 branch**（main）的版本
- `=======` 到 `>>>>>>>` 是要被 merge 進來的 branch（feature/about）的版本
- 你要手動決定保留哪個（或兩個都要），並刪掉這三行標記

---

## 步驟教學 Step-by-step

### 準備：建立練習環境

**1. 先建立一個 GitHub repo 供練習（或用你已有的）**，然後：

```bash
cp -r starter/ ~/my-blog-lab03
cd ~/my-blog-lab03
git init
git add .
git commit -m "init: base blog"
git remote add origin <your-repo-url>
git push -u origin main
```

**2. 建立 feature branch 並修改 index.html**

```bash
git switch -c feature/about

# 在 index.html 的 <nav> 加上「關於我」連結
sed -i 's|<a href="index.html">首頁</a>|<a href="index.html">首頁</a> \| <a href="about.html">關於我</a>|' index.html
git add index.html
git commit -m "feat: add about link to nav"
```

**3. 執行 setup.sh，模擬 Alice 修改 main**

```bash
# 回到 main 才能執行 setup（setup.sh 從目前 repo 拿 remote URL）
git switch main
bash <path-to-lab-03-setup.sh>
```

setup.sh 執行後：
- Alice 已把 `index.html` 的 `<title>` 改成 `My Blog | 技術筆記` 並 push 到 remote
- 你的 local main 還是舊版本

**4. 把 Alice 的更新拉下來**

```bash
git pull
git log --oneline
# 輸出：
# b2c3d4e (HEAD -> main, origin/main) style: update page title  ← Alice 的 commit
# a1b2c3d init: base blog
```

---

### Step 1：嘗試 merge，觸發衝突

```bash
git merge feature/about
```

**輸出（衝突！）：**

```
Auto-merging index.html
CONFLICT (content): Merge conflict in index.html
Automatic merge failed; fix conflicts and then commit the result.
```

---

### Step 2：用 git status 確認哪些檔案衝突

```bash
git status
```

**輸出：**

```
On branch main
You have unmerged paths.
  (fix conflicts and run "git commit")
  (use "git merge --abort" to abort the merge)

Unmerged paths:
  (use "git add <file>..." to mark resolution)
        both modified:   index.html
```

`both modified: index.html` — 兩邊都改了這個檔案，Git 無法自動決定要用哪個版本。

---

### Step 3：打開 index.html，看衝突標記

```bash
cat index.html
```

你會在 `<head>` 和 `<nav>` 區域看到類似這樣的內容：

```html
<<<<<<< HEAD
  <title>My Blog | 技術筆記</title>
=======
  <title>My Blog</title>
>>>>>>> feature/about
```

以及：

```html
<<<<<<< HEAD
    <nav><a href="index.html">首頁</a></nav>
=======
    <nav><a href="index.html">首頁</a> | <a href="about.html">關於我</a></nav>
>>>>>>> feature/about
```

---

### Step 4：手動解決衝突

用任何編輯器打開 `index.html`，把衝突標記刪掉，決定最終要的內容。
這個例子中，兩邊的改動都要保留：

```html
<!-- <title>：保留 Alice 的版本（更完整） -->
<title>My Blog | 技術筆記</title>

<!-- <nav>：保留你的版本（加了 About 連結） -->
<nav><a href="index.html">首頁</a> | <a href="about.html">關於我</a></nav>
```

確保 `index.html` 裡**不再有任何** `<<<<<<<`、`=======`、`>>>>>>>` 標記。

---

### Step 5：標記衝突已解決並完成 merge

```bash
git add index.html
git status
```

**輸出：**

```
On branch main
All conflicts fixed but you are still merging.
  (use "git commit" to conclude merge)
```

```bash
git commit
# 會開啟編輯器，預設訊息是 "Merge branch 'feature/about'"
# 直接存檔離開即可（:wq 或 Ctrl+X）
```

---

### Step 6：查看 merge 結果

```bash
git log --oneline --graph --all
```

**輸出（看到 merge commit）：**

```
*   d5e6f7g (HEAD -> main) Merge branch 'feature/about'
|\
| * c4d5e6f (feature/about) feat: add about link to nav
* | b2c3d4e (origin/main) style: update page title
|/
* a1b2c3d init: base blog
```

---

## 練習題 Exercises

1. **練習 abort**：重做一次 merge 製造衝突，然後用 `git merge --abort` 取消，確認 `index.html` 恢復到衝突前的狀態。

2. **新的衝突**：建立一個 `feature/style` branch，在兩個 branch（main 和 feature/style）分別修改 `style.css` 的同一行，製造衝突並手動解決。

3. **全保留策略**：建立衝突情境，解衝突時選擇同時保留兩邊的內容（不丟棄任何一方的修改），完成 merge。

---

## 解答 Answers

### 練習 1

```bash
# 先確保有可 merge 的 branch（feature/about 仍存在）
git switch -c feature/another-change
echo "<!-- change -->" >> index.html
git add . && git commit -m "test: trigger conflict"
git switch main
echo "<!-- main change -->" >> index.html
git add . && git commit -m "test: main also changed"
git merge feature/another-change
# 衝突後：
git merge --abort
git status
# 輸出：nothing to commit, working tree clean
```

### 練習 2

```bash
git switch -c feature/style
sed -i 's/color: #333/color: #222/' style.css
git add . && git commit -m "style: darken text on feature branch"

git switch main
sed -i 's/color: #333/color: #444/' style.css
git add . && git commit -m "style: darken text on main"

git merge feature/style
# 衝突！打開 style.css 解決，選一個顏色值
git add style.css
git commit
```

### 練習 3

```bash
# 假設 index.html 兩邊都加了不同的 meta tag
# 解衝突時把兩行都保留，刪掉衝突標記
# 然後 git add 、git commit
```

---

上一個 Lab: [Lab 02 — branch / switch](../lab-02-branch-switch/)
下一個 Lab: [Lab 04 — remote / push / pull / fetch](../lab-04-remote-push-pull/)
