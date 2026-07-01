# Day 06 – Linux Fundamentals: Read and Write Text Files

## Objective

Practice creating, writing, appending, and reading text files using basic Linux commands.

---

# File Creation

## Command

```bash
touch notes.txt
```

**Purpose:** Creates an empty file named `notes.txt`.

---

# Writing to a File

## Command

```bash
echo "Day 06 - Linux File Practice" > notes.txt
```

**Purpose:** Writes the first line to the file. If the file already exists, its previous contents are replaced.

---

# Appending Text

## Commands

```bash
echo "Learning file read and write operations." >> notes.txt
echo "Using Linux redirection operators." >> notes.txt
echo "Practicing basic DevOps skills." >> notes.txt
```

**Purpose:** Adds new lines to the end of the file without overwriting existing content.

---

# Writing with tee

## Command

```bash
echo "This line was added using tee." | tee -a notes.txt
```

**Purpose:** Displays the text on the terminal and appends it to the file at the same time.

---

# Reading the File

## Display Entire File

```bash
cat notes.txt
```

**Purpose:** Displays all contents of the file.

---

## Read the First Two Lines

```bash
head -n 2 notes.txt
```

**Purpose:** Shows only the beginning of the file.

---

## Read the Last Two Lines

```bash
tail -n 2 notes.txt
```

**Purpose:** Shows only the last part of the file.

---

# Verification

## Command

```bash
wc -l notes.txt
```

**Purpose:** Counts the total number of lines in the file.

---

# Key Learnings

* `touch` creates a file.
* `>` overwrites a file.
* `>>` appends data.
* `tee` writes and displays output simultaneously.
* `cat`, `head`, and `tail` are essential commands for reading files.
* Text files are the foundation of Linux configuration, logging, and automation.

