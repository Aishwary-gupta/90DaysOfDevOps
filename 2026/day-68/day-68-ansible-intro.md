# Day 68 — Introduction to Ansible and Inventory Setup

## 🚀 Overview

Today I started my Ansible journey as part of my #90DaysOfDevOps challenge.

Terraform is used to provision infrastructure, while Ansible is used to configure and manage servers after they are created.

In this practical, I:

* Installed Ansible on my Ubuntu control node
* Provisioned three AWS EC2 instances
* Created an Ansible inventory
* Grouped servers as Web, App, and DB
* Connected to EC2 instances using SSH
* Ran Ansible ad-hoc commands
* Installed Git remotely
* Copied files to remote servers
* Practiced inventory groups and patterns
* Configured `ansible.cfg`

---

## 🏗️ Ansible Architecture

```text
                    Ansible Control Node
                    Ubuntu / Laptop
                           |
                           | SSH
                           |
          ┌────────────────┼────────────────┐
          ↓                ↓                ↓
     Web Server       App Server       DB Server
       EC2 #1           EC2 #2           EC2 #3
```

### Control Node

The control node is the machine where Ansible is installed and executed.

For this practical, I used my Ubuntu machine as the control node.

### Managed Nodes

Managed nodes are the remote servers controlled by Ansible.

I used three AWS EC2 instances:

* Web Server
* App Server
* DB Server

### Inventory

The inventory contains the servers that Ansible manages.

### Modules

Modules are reusable units of work performed by Ansible.

Examples:

* `ping`
* `command`
* `copy`
* `apt`
* `yum`

### Playbooks

Playbooks are YAML files used to define repeatable configuration and automation tasks.

---

## 🔐 Why Ansible is Agentless

Ansible does not require an Ansible agent to be installed on the managed servers.

Ansible normally connects to Linux servers using SSH.

```text
Ansible Control Node
        |
        | SSH
        ↓
Managed EC2 Instance
```

This makes Ansible lightweight and easy to deploy.

---

## ☁️ Lab Environment

I used AWS EC2 instances for the Ansible lab.

| Server | Purpose    | OS     | Instance Type |
| ------ | ---------- | ------ | ------------- |
| EC2 #1 | Web Server | Ubuntu | t2.micro      |
| EC2 #2 | App Server | Ubuntu | t2.micro      |
| EC2 #3 | DB Server  | Ubuntu | t2.micro      |

The EC2 instances were configured with SSH access through a security group.

---

## 📁 Inventory

My inventory was created using `inventory.ini`.

```ini
[web]
web-server ansible_host=<PUBLIC_IP_1>

[app]
app-server ansible_host=<PUBLIC_IP_2>

[db]
db-server ansible_host=<PUBLIC_IP_3>

[application:children]
web
app

[all_servers:children]
application
db

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/your-key.pem
```

> Public IP addresses and private key information should be redacted before publishing the repository.

---

## ⚙️ Ansible Configuration

I created an `ansible.cfg` file to avoid specifying the inventory file and SSH details with every command.

```ini
[defaults]
inventory = inventory.ini
host_key_checking = False
remote_user = ubuntu
private_key_file = ~/your-key.pem
```

After configuring this file, I could run:

```bash
ansible all -m ping
```

instead of:

```bash
ansible all -i inventory.ini -m ping
```

---

## 🧪 Ansible Version

Command:

```bash
ansible --version
```

This verified that Ansible was installed successfully on the control node.

### Output

```text
Paste your actual output here.
```

---

## 📊 Inventory Graph

Command:

```bash
ansible-inventory --graph
```

The inventory contained:

```text
all
├── web
│   └── web-server
├── app
│   └── app-server
└── db
    └── db-server
```

---

## 🟢 First Ansible Ping

Command:

```bash
ansible all -m ping
```

Expected result:

```text
web-server | SUCCESS => {
    "ping": "pong"
}

app-server | SUCCESS => {
    "ping": "pong"
}

db-server | SUCCESS => {
    "ping": "pong"
}
```

### Screenshot

Add your screenshot here:

```text
![Ansible Ping](screenshots/ansible-ping.png)
```

---

# 🛠️ Ad-Hoc Commands

## 1. Check Server Uptime

```bash
ansible all -m command -a "uptime"
```

This executed the `uptime` command on all managed nodes.

### Output

```text
Paste actual output here.
```

---

## 2. Check Memory

```bash
ansible web -m command -a "free -h"
```

This checked available memory on the web server.

### Output

```text
Paste actual output here.
```

---

## 3. Check Disk Space

```bash
ansible all -m command -a "df -h"
```

This displayed filesystem and disk usage on all servers.

### Output

```text
Paste actual output here.
```

---

## 4. Install Git

For Ubuntu:

```bash
ansible web -m apt -a "name=git state=present" --become
```

The `--become` option allows Ansible to execute the task with elevated privileges.

I verified the installation using:

```bash
ansible web -m command -a "git --version"
```

---

## 5. Copy a File

I created a local file:

```bash
echo "Hello from Ansible" > hello.txt
```

Then copied it to all managed nodes:

```bash
ansible all -m copy -a "src=hello.txt dest=/tmp/hello.txt"
```

I verified the contents using:

```bash
ansible all -m command -a "cat /tmp/hello.txt"
```

Expected output:

```text
Hello from Ansible
```

---

# 👥 Inventory Groups

I created a parent group using:

```ini
[application:children]
web
app
```

This means the `application` group contains both:

* Web servers
* App servers

I also created:

```ini
[all_servers:children]
application
db
```

This includes all servers.

---

# 🎯 Ansible Patterns

### Web OR App

```bash
ansible 'web:app' -m ping
```

### Everything except DB

```bash
ansible 'all:!db' -m ping
```

### Only DB

```bash
ansible db -m ping
```

---

# ⚔️ Command vs Shell Module

## Command Module

```bash
ansible all -m command -a "uptime"
```

The command module executes commands directly without going through a shell.

It is preferred when shell features are not required.

## Shell Module

```bash
ansible all -m shell -a "df -h | grep /"
```

The shell module executes commands through a shell and supports shell features such as:

* Pipes `|`
* Redirects `>`
* Command chaining

### Comparison

| Feature                       | Command | Shell |
| ----------------------------- | ------- | ----- |
| Simple commands               | ✅       | ✅     |
| Shell processing              | ❌       | ✅     |
| Pipes                         | ❌       | ✅     |
| Redirects                     | ❌       | ✅     |
| Preferred for simple commands | ✅       |       |
| More flexible                 |         | ✅     |

---

# 🔑 What Does `--become` Do?

`--become` enables privilege escalation.

It is similar to using:

```bash
sudo
```

on Linux.

For example, installing a package normally requires root privileges:

```bash
sudo apt install git
```

With Ansible:

```bash
ansible web -m apt -a "name=git state=present" --become
```

---

# 🧠 What I Learned

Today I learned:

* What configuration management means
* How Ansible works
* Ansible's agentless architecture
* Control nodes and managed nodes
* Inventory files
* Inventory groups
* Ansible modules
* Ad-hoc commands
* SSH-based management
* Privilege escalation with `--become`
* Inventory patterns
* `ansible.cfg`
* Difference between `command` and `shell`

---

# 🏗️ Terraform + Ansible

This practical also showed me how Terraform and Ansible work together.

```text
Terraform
   ↓
Provision AWS Infrastructure
   ↓
EC2 Instances
   ↓
Ansible
   ↓
Configure Servers
   ↓
Install Packages
   ↓
Deploy Applications
   ↓
Manage Services
```

Terraform answers:

> "What infrastructure should exist?"

Ansible answers:

> "How should that infrastructure be configured?"

---

# 📂 Project Structure

```text
day-68/
│
├── ansible.cfg
├── inventory.ini
├── hello.txt
└── day-68-ansible-intro.md
```

Private SSH keys are intentionally excluded from Git.

---

# 🚀 Conclusion

Day 68 introduced me to Ansible and configuration management.

I successfully configured an Ansible control node, connected to three AWS EC2 managed nodes over SSH, created grouped inventories, and executed ad-hoc commands remotely.

The biggest takeaway was understanding the combination of:

**Terraform → Infrastructure**

**Ansible → Configuration**

This creates a strong foundation for automation and Infrastructure as Code.

---

## 📌 Next Step

The next stage is to move from ad-hoc commands to **Ansible Playbooks**, where infrastructure configuration can be automated in a repeatable and declarative way.
