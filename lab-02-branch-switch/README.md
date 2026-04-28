# Lab 02 — 安全開發新功能：branch / switch

## 情境 Scenario

你已經熟悉基本狀態讀取了。今天 PM 傳訊說：

> 「能幫我在部落格加一個『關於我』頁面嗎？」

你的本能是直接在 `main` 上改——但這樣很危險：萬一做到一半有問題，或者要緊急修別的 bug，`main` 就變成一個半成品的狀態。

**正確做法：開一個新的 branch，在上面安心作業。**

---

## 指令說明 Command Reference

| 指令 | 說明 |
|------|------|
| `git branch` | 列出所有本地 branch，目前所在的 branch 前面有 `*` |
| `git branch <name>` | 建立新 branch（但不切換過去） |
| `git switch <name>` | 切換到指定 branch |
| `git switch -c <name>` | 建立並立刻切換（最常用） |
| `git branch -d <name>` | 刪除已 merge 的 branch |
| `git branch -D <name>` | 強制刪除 branch（未 merge 也刪） |
| `git branch -v` | 列出所有 branch 及其最新 commit |

> **`switch` vs `checkout`**：`checkout` 是舊指令，功能更多但容易混淆。`switch` 是 Git 2.23 後的新指令，只做「切換 branch」這件事，比較直覺。兩個都會遇到，但推薦用 `switch`。

---

## 步驟教學 Step-by-step

### 準備：初始化練習用 repo

```bash
cp -r starter/ ~/my-blog-lab02
cd ~/my-blog-lab02
git init
git add .
git commit -m "init: base blog"
```

---

### Step 1：先看現在有哪些 branch

```bash
git branch
```

**輸出：**

```
* main
```

目前只有 `main`，`*` 表示你在這個 branch 上。

---

### Step 2：建立新 branch

```bash
git branch feature/about
git branch
```

**輸出：**

```
  feature/about
* main
```

新 branch 建立了，但你**還在 main** 上（`*` 還在 main）。

---

### Step 3：切換到新 branch

```bash
git switch feature/about
git branch
```

**輸出：**

```
* feature/about
  main
```

現在你在 `feature/about` 上了。

---

### Step 4：在新 branch 上新增 about.html

```bash
cat > about.html << 'ABOUT'
<!DOCTYPE html>
<html lang="zh-TW">
<head>
  <meta charset="UTF-8">
  <title>關於我 | My Blog</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <header>
    <h1>My Blog</h1>
    <nav>
      <a href="index.html">首頁</a> |
      <a href="about.html">關於我</a>
    </nav>
  </header>
  <main>
    <h2>關於我</h2>
    <p>Hi！我是一個喜歡寫程式的工程師，這個部落格用來記錄學習筆記。</p>
  </main>
</body>
</html>
ABOUT

git add about.html
git commit -m "feat: add about page"
```

---

### Step 5：切回 main，確認 main 沒被動到

```bash
git switch main
ls
```

**輸出（沒有 about.html）：**

```
index.html  posts/  style.css
```

`main` 上沒有 `about.html`，因為你是在 `feature/about` 上做的改動。
這就是 branch 的核心用途：**隔離開發中的功能，不影響穩定的 main**。

---

### Step 6：用捷徑同時建立並切換

```bash
# 等同於 git branch + git switch
git switch -c feature/contact
git branch
```

**輸出：**

```
  feature/about
* feature/contact
  main
```

---

### Step 7：刪掉不需要的 branch

```bash
git switch main
git branch -d feature/contact
git branch
```

**輸出：**

```
  feature/about
* main
```

> `feature/contact` 因為沒有 merge 回 main，所以 `-d` 會警告，但這裡我們確定不需要它了。
> 如果看到警告說「not fully merged」，改用 `-D` 強制刪除。

---

## 練習題 Exercises

1. **建立 branch**：建立一個叫 `feature/dark-mode` 的 branch，在上面新增一個 `dark.css` 檔案（內容隨意），commit 後切回 `main` 確認 `main` 上沒有 `dark.css`。

2. **同時建立並切換**：用 `git switch -c feature/footer` 建立並切換到新 branch，新增一個 `footer.html`，commit 後回到 `main`。

3. **整理 branch**：用 `git branch -D` 刪除 `feature/dark-mode` 和 `feature/footer`，最後用 `git branch -v` 確認只剩 `main` 和 `feature/about`。

---

## 解答 Answers

### 練習 1

```bash
git switch -c feature/dark-mode
echo "body { background: #111; color: #eee; }" > dark.css
git add dark.css
git commit -m "feat: add dark mode CSS"
git switch main
ls   # dark.css 不存在
```

### 練習 2

```bash
git switch -c feature/footer
echo "<footer>© 2024 My Blog</footer>" > footer.html
git add footer.html
git commit -m "feat: add footer"
git switch main
```

### 練習 3

```bash
git branch -D feature/dark-mode
git branch -D feature/footer
git branch -v
# 輸出：
#   feature/about  xxxxxxx feat: add about page
# * main           xxxxxxx init: base blog
```

---

⬅️ 上一個 Lab: [Lab 01 — status / log / diff](../lab-01-status-log-diff/)
➡️ 下一個 Lab: [Lab 03 — merge + conflict](../lab-03-merge-conflict/)
