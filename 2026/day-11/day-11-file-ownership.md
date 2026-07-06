# Day 11 – File Ownership Challenge (chown & chgrp)

## Objective

Learn how to manage Linux file and directory ownership using `chown` and `chgrp`, verify ownership changes, and apply ownership recursively.

---

## Files & Directories Created

### Files

* devops-file.txt
* team-notes.txt
* project-config.yaml
* bank-heist/access-codes.txt
* bank-heist/blueprints.pdf
* bank-heist/escape-plan.txt
* heist-project/vault/gold.txt
* heist-project/plans/strategy.conf

### Directories

* app-logs/
* heist-project/
* heist-project/vault/
* heist-project/plans/
* bank-heist/

---

## Users & Groups Used

### Users

* tokyo
* berlin
* professor
* nairobi

### Groups

* heist-team
* planners
* vault-team
* tech-team

---

## Ownership Changes

| File/Directory      | Before            | After                          |
| ------------------- | ----------------- | ------------------------------ |
| devops-file.txt     | aishwary:aishwary | berlin:aishwary                |
| team-notes.txt      | aishwary:aishwary | aishwary:heist-team            |
| project-config.yaml | aishwary:aishwary | professor:heist-team           |
| app-logs/           | aishwary:aishwary | berlin:heist-team              |
| heist-project/      | aishwary:aishwary | professor:planners (recursive) |
| access-codes.txt    | aishwary:aishwary | tokyo:vault-team               |
| blueprints.pdf      | aishwary:aishwary | berlin:tech-team               |
| escape-plan.txt     | aishwary:aishwary | nairobi:vault-team             |

---

## Commands Used

```bash
touch devops-file.txt
touch team-notes.txt
touch project-config.yaml

mkdir app-logs

mkdir -p heist-project/vault
mkdir -p heist-project/plans

touch heist-project/vault/gold.txt
touch heist-project/plans/strategy.conf

mkdir bank-heist
touch bank-heist/access-codes.txt
touch bank-heist/blueprints.pdf
touch bank-heist/escape-plan.txt

sudo groupadd heist-team
sudo groupadd planners
sudo groupadd vault-team
sudo groupadd tech-team

sudo chown tokyo devops-file.txt
sudo chown berlin devops-file.txt

sudo chgrp heist-team team-notes.txt

sudo chown professor:heist-team project-config.yaml
sudo chown berlin:heist-team app-logs

sudo chown -R professor:planners heist-project

sudo chown tokyo:vault-team bank-heist/access-codes.txt
sudo chown berlin:tech-team bank-heist/blueprints.pdf
sudo chown nairobi:vault-team bank-heist/escape-plan.txt

ls -l
ls -ld app-logs
ls -lR heist-project
ls -l bank-heist
```

---

## What I Learned

* Every file in Linux has an owner and an associated group that determine who can access it.
* The `chown` command changes the owner, while `chgrp` changes only the group.
* Using `chown owner:group` allows changing both owner and group in a single command.
* The `-R` option applies ownership changes recursively to all files and subdirectories.
* Correct ownership is critical for application deployments, shared directories, containers, and CI/CD pipelines.

---

## Screenshots Included

* Ownership before and after using `chown`
* Group changes using `chgrp`
* Recursive ownership of `heist-project`
* Final ownership verification using `ls -l`

