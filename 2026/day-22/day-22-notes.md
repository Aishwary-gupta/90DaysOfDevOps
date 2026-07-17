# Day 22 - Introduction to Git

## What is the difference between git add and git commit?

`git add` moves changes into the staging area. `git commit` saves the staged changes permanently into the repository as a snapshot.

---

## What is the staging area?

The staging area is an intermediate place where we choose exactly which changes should be included in the next commit. It allows us to organize commits instead of committing every modification immediately.

---

## What information does git log show?

`git log` displays the complete commit history including:

- Commit ID (SHA)
- Author
- Date
- Commit message

---

## What is the .git folder?

The `.git` directory stores all repository metadata including commits, branches, tags, configuration, and history.

If this folder is deleted, Git no longer recognizes the project as a repository and all version history is lost.

---

## Difference between Working Directory, Staging Area and Repository

### Working Directory

The files you are currently editing.

### Staging Area

The temporary area where selected changes are prepared before committing.

### Repository

The permanent database containing every commit and project history.
