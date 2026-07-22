# 📅 Day 28 – Revision Day (Days 1–27)

## 📌 Objective
Today was dedicated to revising everything I learned during the first 27 days of the #90DaysOfDevOps challenge. Instead of learning something new, I reviewed my notes, practiced weak areas, and reinforced important concepts.

---

# ✅ Task 1 – Self Assessment Checklist

## Linux

| Topic | Status |
|--------|--------|
| Navigate file system | ✅ Can do confidently |
| File & directory management | ✅ Can do confidently |
| Process management | ✅ Can do confidently |
| Systemd services | ✅ Can do confidently |
| Edit text files | ✅ Can do confidently |
| CPU/Memory/Disk troubleshooting | ✅ Can do confidently |
| Linux File System Hierarchy | ✅ Can do confidently |
| User & Group Management | ✅ Can do confidently |
| File Permissions (chmod) | ✅ Can do confidently |
| Ownership (chown/chgrp) | ✅ Can do confidently |
| LVM | ⚠ Need more practice |
| Networking Commands | ✅ Can do confidently |
| DNS, IP & Subnetting | ⚠ Need more practice |

---

## Shell Scripting

| Topic | Status |
|--------|--------|
| Variables & User Input | ✅ |
| Arguments | ✅ |
| If/Else | ✅ |
| Case Statements | ✅ |
| Loops | ✅ |
| Functions | ✅ |
| grep, awk, sed | ⚠ Need more practice |
| Error Handling | ✅ |
| Crontab | ✅ |

---

## Git & GitHub

| Topic | Status |
|--------|--------|
| Git Init & Commit | ✅ |
| Branching | ✅ |
| Push & Pull | ✅ |
| Clone vs Fork | ✅ |
| Merge | ✅ |
| Rebase | ⚠ Need more practice |
| Git Stash | ✅ |
| Cherry Pick | ✅ |
| Squash Merge | ⚠ Need more practice |
| Git Reset & Revert | ✅ |
| Branching Strategies | ✅ |
| GitHub CLI | ✅ |

---

# 🔁 Task 2 – Topics Revisited

## 1. LVM

### Re-learned

- Physical Volume (PV)
- Volume Group (VG)
- Logical Volume (LV)
- Creating and extending logical volumes
- Formatting and mounting LVM partitions

---

## 2. Git Rebase

### Re-learned

- Rebase rewrites commit history.
- Keeps history linear.
- Never rebase shared commits.
- Use rebase before opening Pull Requests.

---

## 3. awk & sed

### Re-learned

Useful commands:

```bash
awk '{print $1}' file.txt
```

```bash
awk -F: '{print $1}' /etc/passwd
```

```bash
sed 's/error/warning/g' file.txt
```

```bash
sed -i 's/old/new/g' file.txt
```

---

# ⚡ Task 3 – Quick Fire Questions

## 1. What does chmod 755 script.sh do?

It gives:

- Owner → Read, Write, Execute
- Group → Read, Execute
- Others → Read, Execute

Equivalent to:

```
rwxr-xr-x
```

---

## 2. Difference between Process and Service

Process

- Running instance of a program.
- Can be temporary.

Service

- Background process managed by systemd.
- Starts automatically if configured.

---

## 3. Find which process is using port 8080

```bash
sudo ss -tulpn | grep 8080
```

or

```bash
sudo lsof -i :8080
```

---

## 4. What does set -euo pipefail do?

- set -e → Exit immediately if any command fails.
- set -u → Error on undefined variables.
- set -o pipefail → Pipeline fails if any command fails.

Makes shell scripts safer.

---

## 5. Difference between git reset --hard and git revert

git reset --hard

- Removes commits.
- Deletes changes permanently.
- Dangerous on shared branches.

git revert

- Creates a new commit that undoes previous changes.
- Safe for shared repositories.

---

## 6. Best branching strategy for a team shipping weekly

GitHub Flow.

Because it is simple, lightweight, and supports continuous delivery.

---

## 7. What does git stash do?

Temporarily saves uncommitted changes without creating a commit.

Useful when switching branches quickly.

---

## 8. Run a script every day at 3 AM

```cron
0 3 * * * /home/user/script.sh
```

---

## 9. Difference between git fetch and git pull

git fetch

Downloads latest changes without merging.

git pull

Fetches + merges changes automatically.

---

## 10. What is LVM?

LVM (Logical Volume Manager) provides flexible storage management.

Advantages:

- Resize disks
- Extend partitions
- Snapshot support
- Easier storage management

---

# 📂 Task 4 – Repository Check

Completed:

- All Day 1–27 folders pushed.
- Git Commands reference updated.
- Shell Scripting Cheat Sheet completed.
- GitHub Profile optimized.
- Repository READMEs updated.
- Pinned repositories organized.

---

# 📚 Task 5 – Teach It Back

## Git Branching Explained

Imagine a group of students writing one assignment together.

Instead of everyone editing the same document at once, each student creates their own copy to work on independently.

After finishing their work, they merge their changes back into the main document.

Git branches work the same way. Every feature or bug fix is developed on a separate branch, allowing developers to work safely without affecting the main codebase. Once the feature is complete and tested, it is merged back into the main branch.

This makes collaboration easier, reduces conflicts, and keeps the project stable.

---

# 📖 Key Takeaways

- Linux has become much more comfortable after daily practice.
- Shell scripting now feels logical instead of difficult.
- Git workflows finally make sense after practicing branching and rebasing.
- GitHub is more than code storage—it is my developer portfolio.
- Consistency every day is producing noticeable improvement.

---

## 🎯 Goals for the Next Phase

- Learn Docker deeply.
- Build CI/CD pipelines.
- Master GitHub Actions.
- Start Kubernetes.
- Build production-ready DevOps projects.
