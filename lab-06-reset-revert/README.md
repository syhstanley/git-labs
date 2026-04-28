# Lab 06 — 搞砸了怎麼辦：reset / revert

## 情境 Scenario

你在修改 `config.js` 的時候，不小心把 API key 寫進去然後 commit 了：

```js
const config = {
  apiKey: "sk-prod-abc123xyz789",  // ← 這個不能進 repo！！
  ...
};
```

你需要**立刻撤銷這個 commit**，把 API key 從歷史中移除（或至少從最新狀態移除）。

這個 Lab 教你三種「後悔」的方法，以及什麼情況用哪個。

---

## 指令說明 Command Reference

| 指令 | 說明 |
|------|------|
| `git restore <file>` | 捨棄工作目錄的修改（還沒 `git add`）|
| `git restore --staged <file>` | 把已暫存的檔案移出暫存區（回到 modified 狀態）|
| `git reset HEAD~1` | 撤銷最後一個 commit，修改**保留**在工作目錄（`--mixed`，預設）|
| `git reset --soft HEAD~1` | 撤銷最後一個 commit，修改保留在**暫存區** |
| `git reset --hard HEAD~1` | 撤銷最後一個 commit，修改**完全刪除** ⚠️ 不可逆 |
| `git revert <hash>` | 建立一個**新 commit** 來撤銷指定的 commit（安全，適合已 push 的情境）|

### reset vs revert 的選擇

```
還沒 push 到 remote？
  → 用 git reset（直接修改歷史，乾淨俐落）

已經 push 了？
  → 用 git revert（不改歷史，用新 commit 抵消）
  → 原因：force push 會影響已拉取這個 commit 的隊友，很危險
```

---

## 步驟教學 Step-by-step

### 準備：建立練習環境

```bash
cp -r starter/ ~/my-blog-lab06
cd ~/my-blog-lab06
git init
git add .
git commit -m "init: base blog with config"
```

---

### 情境 A：捨棄未暫存的修改（git restore）

#### Step 1：修改 config.js 但還沒 add

```bash
# 模擬不小心加了 API key
sed -i 's/author: "Stanley"/author: "Stanley",\n  apiKey: "sk-prod-abc123"/' config.js
cat config.js   # 確認 apiKey 在裡面
git status      # modified: config.js
```

#### Step 2：用 restore 捨棄修改

```bash
git restore config.js
cat config.js   # apiKey 消失了
git status      # clean
```

> ⚠️ `git restore` 是不可逆的，捨棄後無法找回。

---

### 情境 B：把已暫存的修改移出暫存區（git restore --staged）

#### Step 1：修改並 add

```bash
echo "  debug: true," >> config.js
git add config.js
git status
# Changes to be committed: modified: config.js
```

#### Step 2：移出暫存區（不刪修改）

```bash
git restore --staged config.js
git status
# Changes not staged for commit: modified: config.js
# 修改還在，只是移出暫存區了
```

---

### 情境 C：撤銷最後一個 commit（git reset，還沒 push）

#### Step 1：製造一個「有問題」的 commit

```bash
# 先清掉剛才的修改
git restore config.js

# 不小心 commit 了 API key
cat >> config.js << 'CONF'
  apiKey: "sk-prod-abc123xyz789",
CONF
git add config.js
git commit -m "feat: add API config"
git log --oneline
```

**輸出：**

```
b2c3d4e feat: add API config    ← 這個要撤銷
a1b2c3d init: base blog with config
```

#### Step 2：用 reset --mixed 撤銷 commit（保留修改）

```bash
git reset HEAD~1
git log --oneline
```

**輸出：**

```
a1b2c3d init: base blog with config   ← 那個 commit 消失了
```

```bash
git status
# Changes not staged for commit: modified: config.js
# 修改還在工作目錄，你可以繼續編輯再 commit
```

#### Step 3：清掉修改，乾淨的狀態

```bash
git restore config.js
git status
# nothing to commit, working tree clean
```

---

### 情境 D：已 push 的 commit 要撤銷（git revert）

#### Step 1：製造並推一個「有問題」的 commit

```bash
git remote add origin <your-github-repo-url>
git push -u origin main

cat >> config.js << 'CONF'
  apiKey: "sk-prod-abc123xyz789",
CONF
git add config.js
git commit -m "feat: add API config"
git push

git log --oneline
```

**輸出：**

```
b2c3d4e (HEAD -> main, origin/main) feat: add API config
a1b2c3d init: base blog with config
```

#### Step 2：用 revert 建立一個「反向 commit」

```bash
git revert b2c3d4e
# 會開啟編輯器，預設訊息是 "Revert 'feat: add API config'"
# 直接存檔離開（:wq）
```

**輸出：**

```
[main c3d4e5f] Revert "feat: add API config"
 1 file changed, 1 deletion(-)
```

```bash
git log --oneline
```

```
c3d4e5f (HEAD -> main) Revert "feat: add API config"  ← 新的 commit
b2c3d4e feat: add API config                           ← 原本的 commit 仍在歷史裡
a1b2c3d init: base blog with config
```

```bash
git push
cat config.js   # apiKey 消失了，但歷史保留完整
```

> 🔑 重點：`revert` 不刪歷史，它用一個新 commit 來「抵消」效果。這樣隊友的本地就不會有問題。

---

## 練習題 Exercises

1. **restore 練習**：在 `style.css` 加幾行 CSS，用 `git restore style.css` 還原，確認修改消失。再試試先 `git add`，然後用 `git restore --staged style.css` 移出暫存區。

2. **reset 練習**：做 3 個 commit（每個改一個小東西），然後用 `git reset HEAD~2` 一次撤銷兩個 commit，確認 `git log` 只剩 1 個 commit，但修改還在工作目錄。

3. **revert 練習**：做一個 commit 並 push，然後用 `git revert <hash>` 撤銷它，再 push。用 `git log --oneline` 確認原本的 commit 還在歷史裡（沒有被刪掉）。

---

## 解答 Answers

### 練習 1

```bash
echo "body { font-size: 18px; }" >> style.css
git restore style.css
cat style.css   # 新增的那行消失了

echo "body { font-size: 18px; }" >> style.css
git add style.css
git status      # Changes to be committed: modified: style.css
git restore --staged style.css
git status      # Changes not staged for commit: modified: style.css
```

### 練習 2

```bash
echo "v1" >> index.html && git add . && git commit -m "commit 1"
echo "v2" >> index.html && git add . && git commit -m "commit 2"
echo "v3" >> index.html && git add . && git commit -m "commit 3"
git log --oneline
# commit 3
# commit 2
# commit 1
# init: base blog with config

git reset HEAD~2
git log --oneline
# commit 1
# init: base blog with config

git status
# modified: index.html  ← commit 2 和 3 的修改都在工作目錄
```

### 練習 3

```bash
echo "<!-- to be reverted -->" >> index.html
git add . && git commit -m "test: commit to revert"
git push

HASH=$(git log --oneline -1 --format="%h")
git revert $HASH
# 存檔離開編輯器
git push
git log --oneline
# Revert "test: commit to revert"  ← 新 commit
# test: commit to revert            ← 原本的 commit 還在
```

---

⬅️ 上一個 Lab: [Lab 05 — stash](../lab-05-stash/)
➡️ 下一個 Lab: [Lab 07 — rebase / squash](../lab-07-rebase-squash/)
