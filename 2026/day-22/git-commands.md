# Git Commands Reference

---

# Setup & Configuration

## Check Git Version

```bash
git --version
```

Displays the installed Git version.

---

## Configure Username

```bash
git config --global user.name "Aishwary Gupta"
```

Sets your global Git username.

---

## Configure Email

```bash
git config --global user.email "your-email@example.com"
```

Sets your global email.

---

## Show Configuration

```bash
git config --list
```

Shows all Git configuration values.

---

# Basic Workflow

## Initialize Repository

```bash
git init
```

Creates a new Git repository.

---

## Check Status

```bash
git status
```

Shows tracked, untracked and modified files.

---

## Stage Files

```bash
git add file.txt
```

Stages a specific file.

```bash
git add .
```

Stages all modified files.

---

## Commit

```bash
git commit -m "Initial commit"
```

Creates a snapshot of staged changes.

---

# Viewing Changes

## View Commit History

```bash
git log
```

Shows detailed commit history.

---

## Compact History

```bash
git log --oneline
```

Shows one-line commit history.

---

## Show Changes

```bash
git diff
```

Shows unstaged changes.

---

## Show Staged Changes

```bash
git diff --cached
```

Shows staged changes.
