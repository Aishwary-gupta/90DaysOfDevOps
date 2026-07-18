# Day 23 – Git Branching & Working with GitHub

## What is a branch in Git?

A branch is an independent line of development. It allows developers to work on new features or fixes without affecting the main project.

---

## Why do we use branches?

Branches isolate changes so developers can experiment, develop features, and fix bugs safely before merging them into the main branch.

---

## What is HEAD?

HEAD is a pointer that refers to the current branch and latest commit you are working on.

---

## What happens when you switch branches?

Git updates the working directory to match the selected branch. Files unique to another branch disappear until you switch back.

---

## Difference between git switch and git checkout

`git switch` is designed only for switching branches.

`git checkout` can switch branches and restore files, making it more versatile but also more confusing.

---

## Difference between origin and upstream

**origin** is your own GitHub repository (usually your fork).

**upstream** is the original repository from which you forked.

---

## Difference between git fetch and git pull

`git fetch` downloads the latest commits but does not merge them.

`git pull` downloads and automatically merges the changes into your current branch.

---

## Difference between clone and fork

Clone is a Git operation that copies a repository to your local machine.

Fork is a GitHub feature that creates your own copy of someone else's repository.

---

## When should I use clone?

Clone repositories when you have direct access or simply want a local copy.

---

## When should I use fork?

Fork repositories when contributing to open-source projects where you don't have write access.

---

## How do you keep a fork updated?

Add the original repository as an upstream remote, fetch changes, merge them into your local branch, then push the updates to your fork.
