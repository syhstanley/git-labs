# Lab 08 — 精準操作：cherry-pick / tag

## 情境 Scenario

`staging` branch 上有三個 commit：兩個還沒好的 WIP 功能，以及一個**修好 accessibility contrast 的 hotfix**。

你需要只把那個 hotfix 撈到 `main`，其他兩個 WIP 的不要。
完成後，這個版本就可以對外發佈了——你要打上 `v1.0` 的 tag。

---

## 指令說明 Command Reference

### cherry-pick

| 指令 | 說明 |
|------|------|
| `git cherry-pick <hash>` | 把指定 commit 的修改複製到目前 branch |
| `git cherry-pick <hash1> <hash2>` | 一次 cherry-pick 多個 commit |
| `git cherry-pick <hash1>..<hash2>` | cherry-pick 一個範圍（不含 hash1，含 hash2）|
| `git cherry-pick --abort` | 取消進行中的 cherry-pick |
| `git cherry-pick --continue` | 解完衝突後繼續 cherry-pick |

### tag

| 指令 | 說明 |
|------|------|
| `git tag` | 列出所有 tag |
| `git tag v1.0` | 建立輕量 tag（只是一個指標，無額外資訊）|
| `git tag -a v1.0 -m "訊息"` | 建立 annotated tag（有作者、日期、訊息，推薦）|
| `git push origin v1.0` | 推單一 tag 到 remote |
| `git push origin --tags` | 推所有本地 tag 到 remote |
| `git tag -d v1.0` | 刪除本地 tag |
| `git show v1.0` | 查看 tag 的詳細資訊 |

---

## 步驟教學 Step-by-step

### 準備：建立練習環境

```bash
cp -r starter/ ~/my-blog-lab08
cd ~/my-blog-lab08
git init
git add .
git commit -m "init: base blog v0.9"
git remote add origin <your-github-repo-url>
git push -u origin main

# 執行 setup.sh，建立 staging branch
bash <path-to-lab-08>/setup.sh
```

---

### Step 1：查看 staging branch 有什麼

```bash
git fetch origin
git log --oneline origin/staging
```

**輸出：**

```
g7h8i9j wip: experimental dark mode (not ready)
f6g7h8i fix: improve text contrast for accessibility  ← 這個要撈
e5f6g7h wip: new feature article (not ready)
xxxxxxx init: base blog v0.9
```

---

### Step 2：找到 hotfix 的 commit hash

```bash
# 找到 "fix: improve text contrast" 的 hash
git log --oneline origin/staging | grep "fix:"
```

**輸出（記下這個 hash）：**

```
f6g7h8i fix: improve text contrast for accessibility
```

---

### Step 3：在 main 上執行 cherry-pick

```bash
git switch main
git cherry-pick f6g7h8i
```

**輸出：**

```
[main h8i9j0k] fix: improve text contrast for accessibility
 Date: Tue Apr 29 10:30:00 2026 +0800
 1 file changed, 1 insertion(+), 1 deletion(-)
```

---

### Step 4：確認 cherry-pick 的結果

```bash
git log --oneline
```

```
h8i9j0k fix: improve text contrast for accessibility  ← 複製過來的 commit
xxxxxxx init: base blog v0.9
```

```bash
grep "color" style.css
# 輸出：color: #222;  ← 確認修改確實帶過來了
```

> 注意：cherry-pick 產生的是一個**新的 commit**（hash 不同），內容和原本的一樣。

---

### Step 5：Push 到 remote main

```bash
git push
```

---

### Step 6：建立 v1.0 的 annotated tag

```bash
git tag -a v1.0 -m "Release v1.0 - first stable version with accessibility fix"
git tag
```

**輸出：**

```
v1.0
```

---

### Step 7：查看 tag 詳細資訊

```bash
git show v1.0
```

**輸出：**

```
tag v1.0
Tagger: You <you@example.com>
Date:   Tue Apr 29 10:35:00 2026 +0800

Release v1.0 - first stable version with accessibility fix

commit h8i9j0k (HEAD -> main, tag: v1.0, origin/main)
Author: You <you@example.com>
...
```

---

### Step 8：把 tag 推到 remote

```bash
git push origin v1.0
```

**輸出：**

```
To git@github.com:<username>/my-blog.git
 * [new tag]         v1.0 -> v1.0
```

去 GitHub 的 repo 頁面，點 "Releases" 或 "Tags"，你會看到 `v1.0`！

---

## 練習題 Exercises

1. **cherry-pick 練習**：在 staging branch 再加兩個 commit（一個有用，一個 wip），用 cherry-pick 只把有用的那個撈到 main。

2. **tag 練習**：建立一個輕量 tag `v1.0-beta`（不用 `-a`），再建立一個 annotated tag `v1.1`（用 `-a` 加上訊息），用 `git tag` 列出兩個，用 `git show v1.1` 確認 annotated tag 有額外資訊。

3. **推所有 tag**：用 `git push origin --tags` 把所有本地 tag 一次推到 remote，去 GitHub 確認。

---

## 解答 Answers

### 練習 1

```bash
# 在 staging 加兩個 commit
git fetch origin
git switch -c staging-local origin/staging

echo "useful change" >> style.css
git add . && git commit -m "fix: useful CSS fix"

echo "wip stuff" >> index.html
git add . && git commit -m "wip: not ready"

# 找到 useful 的 hash
HASH=$(git log --oneline | grep "useful" | awk '{print $1}')

# cherry-pick 到 main
git switch main
git cherry-pick $HASH
git log --oneline   # 確認那個 commit 在 main 上
```

### 練習 2

```bash
# 輕量 tag
git tag v1.0-beta
git show v1.0-beta
# 只顯示 commit 資訊，沒有 tag 作者/日期/訊息

# Annotated tag
git tag -a v1.1 -m "v1.1 - minor improvements"
git show v1.1
# 有 tag 作者、日期、訊息

git tag
# v1.0
# v1.0-beta
# v1.1
```

### 練習 3

```bash
git push origin --tags
# 輸出：
# * [new tag]         v1.0-beta -> v1.0-beta
# * [new tag]         v1.1 -> v1.1
# (v1.0 已經推過了，不會重複)
```

---

⬅️ 上一個 Lab: [Lab 07 — rebase / squash](../lab-07-rebase-squash/)
➡️ 恭喜你完成所有 Lab！🎉 繼續探索：`git bisect`、`git worktree`、`git submodule`...
