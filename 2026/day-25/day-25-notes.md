# 🔄 Day 25 – Git Reset vs Revert & Branching Strategies

> Part of my **#90DaysOfDevOps** Challenge 🚀

## 📖 Overview

Today I learned how to safely undo mistakes in Git and explored branching strategies used by software teams around the world.

I practiced the differences between **Git Reset** and **Git Revert**, recovered commits using **Git Reflog**, and studied the most popular Git workflows including **GitFlow**, **GitHub Flow**, and **Trunk-Based Development**.

---

# 📚 Topics Covered

- Git Reset
  - Soft Reset
  - Mixed Reset
  - Hard Reset
- Git Revert
- Git Reflog
- Reset vs Revert Comparison
- GitFlow
- GitHub Flow
- Trunk-Based Development

---

# 🛠️ Hands-on Tasks

## ✅ Git Reset

Created multiple commits and experimented with:

- `git reset --soft`
- `git reset --mixed`
- `git reset --hard`

Observed how each option affects:

- Commit History
- Staging Area
- Working Directory

---

## ✅ Git Reflog

Recovered commits after performing a hard reset using:

```bash
git reflog
git reset --hard <commit-hash>
```

---

## ✅ Git Revert

Created multiple commits and safely reverted a previous commit without rewriting history.

Example:

```bash
git revert <commit-hash>
```

---

## ✅ Branching Strategies

Studied three commonly used Git workflows:

### GitFlow

```
main
 │
 ├── develop
 │     ├── feature/*
 │     ├── release/*
 │     └── hotfix/*
```

Best For

- Enterprise Applications
- Large Teams
- Scheduled Releases

---

### GitHub Flow

```
main
 │
 └── feature branch
        │
   Pull Request
        │
      Merge
```

Best For

- Startups
- Open Source
- Continuous Deployment

---

### Trunk-Based Development

```
main
 │
 ├── Short Feature Branch
 ├── Bug Fix
 └── Merge Quickly
```

Best For

- CI/CD
- Agile Teams
- Frequent Releases

---

# 📊 Git Reset Comparison

| Command | Commit History | Staging Area | Working Directory |
|----------|---------------|--------------|-------------------|
| `git reset --soft` | Moves HEAD | Keeps Changes Staged | Keeps Changes |
| `git reset --mixed` | Moves HEAD | Unstages Changes | Keeps Changes |
| `git reset --hard` | Moves HEAD | Clears Staging | Deletes Changes |

---

# 📊 Reset vs Revert

| Feature | Git Reset | Git Revert |
|----------|-----------|------------|
| Rewrites History | ✅ Yes | ❌ No |
| Creates New Commit | ❌ No | ✅ Yes |
| Removes Commit | ✅ Yes | ❌ No |
| Safe for Shared Branches | ❌ No | ✅ Yes |
| Best Used For | Local Mistakes | Public/Shared Repositories |

---

# 📌 Commands Practiced

## Reset

```bash
git reset --soft HEAD~1
git reset --mixed HEAD~1
git reset --hard HEAD~1
```

---

## Revert

```bash
git revert <commit-hash>
```

---

## Recovery

```bash
git reflog
git reset --hard <commit-hash>
```

---

## History

```bash
git log --oneline
git log --graph --oneline --all
git show
```

---

# 📂 Repository Workflow

```
Commit A
     │
Commit B
     │
Commit C
     │
──────────────

Soft Reset
     │
Commit A
Commit B

Changes Staged

──────────────

Mixed Reset
     │
Commit A
Commit B

Changes Unstaged

──────────────

Hard Reset
     │
Commit A
Commit B

Commit C Removed

──────────────

Git Revert

Commit A
Commit B
Commit C
Revert Commit B
```

---

# 🎯 Key Learnings

- Learned the difference between **Soft**, **Mixed**, and **Hard** reset.
- Understood why **Git Revert** is the safest way to undo changes on shared repositories.
- Used **Git Reflog** to recover commits after a hard reset.
- Compared **GitFlow**, **GitHub Flow**, and **Trunk-Based Development**.
- Learned when to use each branching strategy in real-world projects.

---

# 💡 Real-World Use Cases

### Use Git Reset

- Fix local mistakes
- Combine recent commits
- Remove unwanted commits before pushing

### Use Git Revert

- Undo production bugs
- Reverse bad commits safely
- Work on shared repositories

### Use Git Reflog

- Recover accidentally deleted commits
- Restore after hard reset
- Recover detached HEAD work

---

# 🖥️ Tools Used

- Git
- GitHub
- Linux Terminal
- VS Code

---

# 📸 Suggested Screenshots

- Git Reset (Soft)
- Git Reset (Mixed)
- Git Reset (Hard)
- Git Reflog Output
- Git Revert Commit
- Git History Graph
- Branching Strategy Diagram

---

# 🚀 Challenge Progress

**Day 25 / 90**

**90 Days of DevOps Challenge**

---

## 🔗 Connect With Me

- 💼 LinkedIn: *Your LinkedIn Profile*
- 🐙 GitHub: *Your GitHub Profile*

---

⭐ If you found this repository helpful, consider giving it a **Star**!
