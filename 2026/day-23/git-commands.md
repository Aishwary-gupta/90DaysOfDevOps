# Branching

## List Branches

```bash
git branch
```

Lists all local branches.

---

## Create Branch

```bash
git branch feature-1
```

Creates a new branch.

---

## Switch Branch

```bash
git switch feature-1
```

Moves to another branch.

---

## Create & Switch

```bash
git switch -c feature-2
```

Creates and switches in one command.

---

## Delete Branch

```bash
git branch -d feature-2
```

Deletes a merged branch.

---

# Remote Repositories

## Add Remote

```bash
git remote add origin URL
```

Connects local repository to GitHub.

---

## View Remotes

```bash
git remote -v
```

Shows configured remote repositories.

---

## Push

```bash
git push -u origin main
```

Uploads commits.

---

## Pull

```bash
git pull origin main
```

Downloads and merges changes.

---

## Fetch

```bash
git fetch origin
```

Downloads changes without merging.

---

## Clone

```bash
git clone URL
```

Copies an existing repository.
