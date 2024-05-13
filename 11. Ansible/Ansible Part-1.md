# Ansible

Ansible is an open-source automation tool that allows you to automate tasks such as configuration management, application deployment, and task orchestration on multiple servers. Here are some key concepts related to Ansible:

1. **Agentless**:
   - Ansible is agentless, which means it doesn't require any software or agents to be installed on the managed nodes (servers you want to manage). It uses SSH (Secure Shell) to connect to the nodes and perform tasks.

2. **SSH Connection**:
   - Ansible uses SSH for secure communication between the control node (the machine where Ansible is installed and from which you run Ansible commands) and the managed nodes.

3. **Inventory**:
   - An inventory file (often named `inventory` or `hosts`) lists the managed nodes you want to automate. It can be a simple text file or a dynamic script that generates the list. The inventory file also allows you to group nodes for easier management.

4. **Control Node**:
   - The control node is the machine where Ansible is installed. It's the system from which you manage and execute Ansible commands and playbooks.

5. **Managed Node**:
   - A managed node is a remote server or device that Ansible manages. These are the servers you want to automate tasks on. Ansible connects to managed nodes via SSH.

6. **Modules**:
   - Ansible modules are small programs that Ansible uses to perform tasks on managed nodes. Each module is responsible for a specific type of task, such as installing a package, copying files, or starting a service. Modules are executed on the managed nodes and report back to the control node.

7. **Playbook**:
   - A playbook is a YAML file that defines a set of tasks to be executed on the managed nodes. Playbooks are used for automation and orchestration. They can include multiple tasks, variables, and even conditionals.

8. **Tasks**:
   - A task is a single action to be performed on a managed node. It can be as simple as copying a file, or more complex like installing software or configuring services.

9. **Roles**:
   - Roles provide a way to organize playbooks and share them across different projects. A role includes tasks, variables, and templates in a defined structure. Roles make it easier to manage and reuse configurations.

10. **Handlers**:
    - Handlers are special tasks that are only executed if a task notifies them. They are typically used to restart services or perform other actions that should only happen if a change has been made.

11. **Modules and Facts**:
    - Modules provide the functionality to carry out tasks, while facts are information about the managed nodes. Ansible gathers facts about the managed nodes before executing tasks. Facts can be used in playbooks to make them dynamic and adaptable.

12. **Idempotence**:
    - Ansible is designed to be idempotent, meaning if a task is executed multiple times, it will have the same effect as if it were executed once. This ensures that running playbooks multiple times won't cause unintended side effects.

## Setup Ansible in Control Node

To install Ansible on Ubuntu, you can use the following steps:

1. **Update Package Lists**:
   Open a terminal window and run the following command to update the package lists:

   ```bash
   sudo apt-get update
   ```

2. **Install Ansible**:
   Once the package lists are updated, you can install Ansible by running the following command:

   ```bash
   sudo apt-get install ansible
   ```

   You'll be prompted to confirm the installation. Press `Y` to proceed.

3. **Verify Installation**:
   After the installation is complete, you can verify if Ansible was installed correctly by checking its version:

   ```bash
   ansible --version
   ```

## Setup SSH connection between Control Nodes & Managed Nodes


#### Step 3: Generate SSH Key Pair (On Control Node)
```bash
ssh-keygen
```

#### Step 4: Copy Public Key (On Control Node)
- Navigate to `/root/.ssh`
- View the public key with:
```bash
cat id_rsa.pub
```
- Copy the displayed public key.

#### Step 5: Paste Public Key (On Managed Nodes)
- Go to each managed node (e.g., node1, node2)
- Navigate to `/root/.ssh`
- Open or create the `authorized_keys` file and paste the public key.

#### Step 6: Set Permissions (On Managed Nodes)
```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

You have now installed Ansible on your control node and set up SSH key-based authentication between the control node and managed nodes. This allows Ansible to communicate securely without the need for passwords.

#### step 7: Add IP in /etc/hosts file

```bash
vi /etc/ansible/hosts

[webservers]
IP1 ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_user=root
IP2 ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_user=root

[dbservers]
IP3 ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_user=root
IP4 ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_user=root
```


### Ansible ad-hoc commands that you can use for various tasks:

1. **Ping all hosts**:

   ```bash
   ansible all -m ping
   ```

   This checks if all hosts in your inventory file are reachable.

2. **Get system information**:

   ```bash
   ansible all -m setup
   ```

   This command gathers facts about remote hosts. It provides detailed information about the system.

3. **Update package cache**:

   ```bash
   ansible all -m apt -a "update_cache=yes"
   ```

   This updates the package cache on Debian-based systems.

4. **Install a package**:

   ```bash
   ansible all -m apt -a "name=package_name state=present"
   ```

   This installs a package on Debian-based systems. Replace `package_name` with the actual package name.

5. **Restart a service**:

   ```bash
   ansible all -m service -a "name=service_name state=restarted"
   ```

   This restarts a service. Replace `service_name` with the actual service name.

6. **Create a directory**:

   ```bash
   ansible all -m file -a "path=/path/to/directory state=directory"
   ```

   This creates a directory on remote hosts.

7. **Copy a file to remote hosts**:

   ```bash
   ansible all -m copy -a "src=/local/path/to/file dest=/remote/path/"
   ```

   This copies a file from the control node to remote hosts.

8. **Execute a shell command**:

   ```bash
   ansible all -m shell -a "command"
   ```

   Replace `command` with the actual shell command you want to execute.

9. **Set up a cron job**:

   ```bash
   ansible all -m cron -a "name=job_name minute=30 hour=2 job='/path/to/script.sh'"
   ```

   This sets up a cron job on the remote hosts.

10. **Check free disk space**:

    ```bash
    ansible all -m command -a "df -h"
    ```

