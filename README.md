# Git Labs 🧪

> 一個讓你真正學會 Git 的實戰教學專案。

透過連貫的故事情境——**你剛加入開源部落格專案 `my-blog` 的第一天**——帶你從「會 add/commit」升級到真正懂 Git 的工程師。

---

## 前置需求 Prerequisites

- Git 已安裝（`git --version` 確認）
- 有 GitHub 帳號
- SSH key 已設定（`ssh -T git@github.com` 確認）

---

## 如何開始 Getting Started

```bash
# Clone 這個 repo
git clone git@github.com:syhstanley/git-labs.git
cd git-labs

# 選一個 Lab 開始
cd lab-01-status-log-diff
cat README.md
```

---

## Lab 列表 Lab Index

| Lab | 主題 | 學到什麼 |
|-----|------|---------|
| [Lab 01](./lab-01-status-log-diff/) | `status` / `log` / `diff` | 第一天上工，讀懂 repo 的現狀 |
| [Lab 02](./lab-02-branch-switch/) | `branch` / `switch` | 開新功能 branch，安全作業 |
| [Lab 03](./lab-03-merge-conflict/) | `merge` + conflict 解決 | 與隊友 merge，遇到衝突不慌張 |
| [Lab 04](./lab-04-remote-push-pull/) | `remote` / `push` / `pull` / `fetch` | 遠端協作，同步隊友的進度 |
| [Lab 05](./lab-05-stash/) | `stash` | 臨時保存，快速切換任務 |
| [Lab 06](./lab-06-reset-revert/) | `reset` / `revert` | 搞砸了？這樣救回來 |
| [Lab 07](./lab-07-rebase-squash/) | `rebase` / `squash` | PR 前整理 commit history |
| [Lab 08](./lab-08-cherry-pick-tag/) | `cherry-pick` / `tag` | 精準撈 commit，發佈版本 |

---

## 關於 setup.sh

部分 Lab 有 `setup.sh`，用來模擬隊友在遠端推了新東西。
執行後：
- remote `main` 會比你的 local `main` 超前
- 你的本地檔案**不會被動到**
- 接著按照 Lab 說明下指令來同步

```bash
# 執行範例
bash setup.sh
```

> ⚠️ 執行前確保你在 my-blog repo 的目錄內，且已有 remote origin 設定。

---

Made with 🦐 by 蝦秘酷ㄅ
