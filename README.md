# 🛡️ IAM Automation Lab – Bash Scripting for User & Group Management on Linux

This project contains a Bash script that automates Identity and Access Management (IAM) tasks such as creating users, groups, setting password policies, and managing permissions on a Linux system. It's ideal for system administrators and DevOps engineers looking to streamline user provisioning.

---

## 📌 Lab Objective

The aim of this lab is to:

- Understand how to automate IAM tasks using Bash scripting.
- Create and manage users and groups from a `.csv` file.
- Apply security policies like forced password change on first login.
- Implement permission settings on user home directories.
- Optionally: send email notifications to users and enforce password complexity.

---

## 🖥️ Prerequisites

- A Linux environment (Ubuntu, WSL, or VM).
- Sudo privileges.
- Basic Bash scripting knowledge.
- Familiarity with:
  - `useradd`, `groupadd`, `usermod`, `chage`, `passwd`, `chmod`
  - Optional: `mail` command for sending emails

---

## 📂 Project Structure

IAM-Automation-Lab/
├── users.csv # Input file containing users to create
├── iam_setup.sh # Main automation script
├── iam_setup.log # Log file of all operations
└── screenshots/ # Screenshots of script execution

## ⚙️ How to Run the Script

### Step 1: Make the Script Executable

```bash
chmod +x iam_setup.sh
```

### Step 2: Run the script

```bash
sudo ./iam_setup.sh users.csv
```
