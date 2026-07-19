# 🚀 Day 24 – Advanced Git: Merge, Rebase, Stash & Cherry-Pick

> Part of my **#90DaysOfDevOps** challenge.

## 📌 Overview

Today I explored advanced Git workflows that are widely used in professional software development and DevOps teams. I practiced integrating feature branches, maintaining a clean commit history, temporarily saving work, and selectively applying commits.

---

## 📚 Topics Covered

- Git Merge
- Fast-Forward Merge
- Merge Commit
- Merge Conflicts
- Git Rebase
- Squash Merge
- Git Stash
- Git Cherry-Pick
- Git History Visualization

---

## 🛠️ Hands-on Tasks

### ✅ Git Merge
- Created feature branches
- Performed Fast-Forward Merge
- Created Merge Commits
- Resolved Merge Conflicts

### ✅ Git Rebase
- Rebased feature branches onto `main`
- Compared Merge vs Rebase history
- Learned why rebasing shared commits is dangerous

### ✅ Squash Merge
- Combined multiple commits into one clean commit
- Compared Squash Merge with Regular Merge

### ✅ Git Stash
- Saved work-in-progress
- Listed multiple stashes
- Applied and popped stashes
- Switched branches safely

### ✅ Cherry Pick
- Selected a single commit from another branch
- Applied it to the `main` branch
- Verified commit history

---

# 📂 Commands Practiced

```bash
git switch
git branch
git merge
git merge --squash
git rebase
git stash
git stash list
git stash pop
git stash apply
git cherry-pick
git log --graph --oneline --all
git merge --abort
git rebase --continue
git rebase --abort
```

---

# 📖 Merge vs Rebase

| Merge | Rebase |
|--------|---------|
| Preserves complete branch history | Creates a linear history |
| May create merge commits | Rewrites commit history |
| Safe for shared branches | Avoid on shared branches |
| Easier for collaboration | Cleaner commit history |

---

# 📖 Git Stash

Useful when:

- Switching tasks quickly
- Emergency bug fixes
- Saving unfinished work
- Avoiding unnecessary commits

Useful Commands

```bash
git stash
git stash list
git stash apply
git stash pop
```

---

# 📖 Cherry Pick

Cherry-pick copies a specific commit from one branch to another without merging the entire branch.

Example:

```bash
git cherry-pick <commit-hash>
```

---

# 📖 Squash Merge

Instead of adding every commit from a feature branch,

```
Feature Branch

Commit 1
Commit 2
Commit 3
Commit 4
```

Squash Merge produces

```
Main

One Clean Commit
```

Perfect for keeping Git history clean.

---

# 📈 Git Workflow Practiced

```
main
 │
 ├──────── feature-login
 │              │
 │              ├── Commit
 │              ├── Commit
 │              ▼
 │──────────── Merge
 │
 ├──────── feature-dashboard
 │              │
 │              ├── Commit
 │              ├── Commit
 │              ▼
 │──────────── Rebase
 │
 ├──────── feature-profile
 │              │
 │              ├── Commit
 │              ├── Commit
 │              ├── Commit
 │              ▼
 │──────────── Squash Merge
 │
 └──────── feature-hotfix
                │
                ├── Commit
                ├── Commit
                ├── Commit
                ▼
           Cherry Pick
```

---

# 🎯 Key Learnings

- Understood Fast-Forward and Merge Commits
- Learned to resolve Merge Conflicts
- Practiced Git Rebase for clean history
- Used Squash Merge for better commit organization
- Saved unfinished work using Git Stash
- Applied individual commits using Cherry Pick
- Visualized Git history using graph view

---

# 📸 Suggested Screenshots

- Git Branches
- Merge Conflict Resolution
- Git Log Graph
- Git Stash List
- Cherry Pick Success
- GitHub Branches

---

## 🛠️ Tech Stack

- Git
- GitHub
- Linux
- Bash

---

## 📅 Challenge

**Day 24 / 90**

**90 Days of DevOps Challenge**

---

## 🔗 Connect With Me

- GitHub: **Your GitHub Profile**
- LinkedIn: **Your LinkedIn Profile**

---

⭐ If you found this repository helpful, consider giving it a **Star**.
