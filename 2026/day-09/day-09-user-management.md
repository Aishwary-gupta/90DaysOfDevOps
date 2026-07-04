# Day 09 – Linux User & Group Management Challenge

## Objective

Practice Linux user and group management by creating users, assigning groups, configuring shared directories, and verifying permissions.

---

## Users & Groups Created

### Users

* tokyo
* berlin
* professor
* nairobi

### Groups

* developers
* admins
* project-team

---

## Group Assignments

| User      | Groups                   |
| --------- | ------------------------ |
| tokyo     | developers, project-team |
| berlin    | developers, admins       |
| professor | admins                   |
| nairobi   | project-team             |

---

## Shared Directories

| Directory           | Group        | Permissions |
| ------------------- | ------------ | ----------- |
| /opt/dev-project    | developers   | 775         |
| /opt/team-workspace | project-team | 775         |

---

## Commands Used

```bash
sudo useradd -m -s /bin/bash tokyo
sudo useradd -m -s /bin/bash berlin
sudo useradd -m -s /bin/bash professor
sudo useradd -m -s /bin/bash nairobi

sudo passwd <username>

sudo groupadd developers
sudo groupadd admins
sudo groupadd project-team

sudo usermod -aG developers tokyo
sudo usermod -aG developers berlin
sudo usermod -aG admins berlin
sudo usermod -aG admins professor
sudo usermod -aG project-team tokyo
sudo usermod -aG project-team nairobi

groups tokyo
groups berlin
groups professor
groups nairobi

sudo mkdir -p /opt/dev-project
sudo chgrp developers /opt/dev-project
sudo chmod 775 /opt/dev-project

sudo mkdir -p /opt/team-workspace
sudo chgrp project-team /opt/team-workspace
sudo chmod 775 /opt/team-workspace

sudo -u tokyo touch /opt/dev-project/tokyo.txt
sudo -u berlin touch /opt/dev-project/berlin.txt
sudo -u nairobi touch /opt/team-workspace/demo.txt
```

---

## What I Learned

* Linux users and groups are the foundation of access control and system security.
* Shared directories become easier to manage by assigning group ownership instead of individual permissions.
* The `usermod -aG` command safely adds users to supplementary groups without removing existing memberships.
* Commands like `groups`, `id`, `ls -ld`, and `ls -l` are useful for verifying permissions and ownership.
* Proper user and group management is essential for secure collaboration in production environments.

---

## Screenshots Included

* User creation and password setup
* Group creation and membership verification
* Shared directory permissions
* File creation tests as different users
# Day 09 – Linux User & Group Management Challenge

## Objective

Practice Linux user and group management by creating users, assigning groups, configuring shared directories, and verifying permissions.

---

## Users & Groups Created

### Users

* tokyo
* berlin
* professor
* nairobi

### Groups

* developers
* admins
* project-team

---

## Group Assignments

| User      | Groups                   |
| --------- | ------------------------ |
| tokyo     | developers, project-team |
| berlin    | developers, admins       |
| professor | admins                   |
| nairobi   | project-team             |

---

## Shared Directories

| Directory           | Group        | Permissions |
| ------------------- | ------------ | ----------- |
| /opt/dev-project    | developers   | 775         |
| /opt/team-workspace | project-team | 775         |

---

## Commands Used

```bash
sudo useradd -m -s /bin/bash tokyo
sudo useradd -m -s /bin/bash berlin
sudo useradd -m -s /bin/bash professor
sudo useradd -m -s /bin/bash nairobi

sudo passwd <username>

sudo groupadd developers
sudo groupadd admins
sudo groupadd project-team

sudo usermod -aG developers tokyo
sudo usermod -aG developers berlin
sudo usermod -aG admins berlin
sudo usermod -aG admins professor
sudo usermod -aG project-team tokyo
sudo usermod -aG project-team nairobi

groups tokyo
groups berlin
groups professor
groups nairobi

sudo mkdir -p /opt/dev-project
sudo chgrp developers /opt/dev-project
sudo chmod 775 /opt/dev-project

sudo mkdir -p /opt/team-workspace
sudo chgrp project-team /opt/team-workspace
sudo chmod 775 /opt/team-workspace

sudo -u tokyo touch /opt/dev-project/tokyo.txt
sudo -u berlin touch /opt/dev-project/berlin.txt
sudo -u nairobi touch /opt/team-workspace/demo.txt
```

---

## What I Learned

* Linux users and groups are the foundation of access control and system security.
* Shared directories become easier to manage by assigning group ownership instead of individual permissions.
* The `usermod -aG` command safely adds users to supplementary groups without removing existing memberships.
* Commands like `groups`, `id`, `ls -ld`, and `ls -l` are useful for verifying permissions and ownership.
* Proper user and group management is essential for secure collaboration in production environments.

---

## Screenshots Included

(screenshots/Screenshot 2026-07-04 120336.png)
(screenshots/Screenshot 2026-07-04 121329.png)
(screenshots/Screenshot 2026-07-04 122710.png)
(screenshots/Screenshot 2026-07-04 123204.png)
(screenshots/Screenshot 2026-07-04 124442.png)

