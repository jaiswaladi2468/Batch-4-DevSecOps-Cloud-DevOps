An Ansible playbook is a file or a set of files that contain a series of tasks that need to be executed on one or more remote hosts. Playbooks are written in YAML format and are used to automate configuration, deployment, and management tasks using Ansible.

A typical Ansible playbook includes the following elements:

1. **Name**: A descriptive name for the playbook. This is a human-readable label that helps identify the purpose of the playbook.

2. **Hosts**: Specifies the target hosts or groups of hosts where the tasks in the playbook will be executed.

3. **Become**: Defines whether to escalate privileges on the remote host, typically to perform tasks that require administrative permissions.

4. **Tasks**: Contains a list of tasks to be executed on the target hosts. Each task consists of a name, module name, and module-specific parameters.

   - **Name**: A descriptive label for the task.
   - **Module**: Specifies the Ansible module to use for the task (e.g., `apt`, `copy`, `service`, etc.).
   - **Module Options**: Parameters specific to the chosen module, which define the behavior of the task.

Here's an example of a simple Ansible playbook that installs the Apache web server on a group of hosts:

```yaml
---
- name: Install Apache
  hosts: web_servers
  become: yes

  tasks:
    - name: Update package cache
      apt:
        update_cache: yes
    
    - name: Install Apache
      apt:
        name: apache2
        state: present
```

In this example:

- **Name**: "Install Apache" is the name of the playbook.
- **Hosts**: The playbook targets hosts in the group named `web_servers`.
- **Become**: It's set to `yes`, indicating that the tasks will be executed with escalated privileges.
- **Tasks**: There are two tasks defined:
  - The first task updates the package cache using the `apt` module.
  - The second task installs the Apache web server using the `apt` module with specific parameters.

You can save this playbook in a YAML file (e.g., `install_apache.yml`) and run it using the `ansible-playbook` command:

```bash
ansible-playbook install_apache.yml
```

This will execute the tasks defined in the playbook on the specified hosts.

## Sample Playbook-1 from Video

```yaml

---
- name: webserver configuration
  hosts: webservers
  become: yes
  tasks:
    - name: update package cache 
      apt:
        update_cache: yes 

    
    - name: Install Apache
      apt:
        name: apache2
        state: present

    - name: Install Maven
      apt:
        name: maven
        state: present

- name: Database server configuration
  hosts: dbservers
  become: yes 
  tasks:
    - name: install postgressql
      apt:
        name: postgresql 
        state: present

```


The provided text is an Ansible playbook written in YAML format. It defines a set of tasks to be executed on two groups of hosts: `webservers` and `dbservers`. Let's break down the playbook:

1. **Playbook Structure**:
   - `---`: This denotes the start of a YAML document.
   - The document contains two plays (sections), each specifying a different set of hosts and tasks.

2. **First Play**:
   - **Name**: "webserver configuration" is a label that describes the purpose of this play.
   - **Hosts**: This play targets hosts belonging to the group `webservers`.
   - **Become**: It's set to `yes`, indicating that the tasks will be executed with escalated privileges.

   - **Tasks**:
     - **Task 1**: "update package cache"
       - **Module**: `apt`
       - **Module Options**:
         - `update_cache: yes`: Instructs `apt` to update the package cache.

     - **Task 2**: "Install Apache"
       - **Module**: `apt`
       - **Module Options**:
         - `name: apache2`: Specifies the name of the package to install.
         - `state: present`: Ensures that the package is present (installed).

     - **Task 3**: "Install Maven"
       - **Module**: `apt`
       - **Module Options**:
         - `name: maven`: Specifies the name of the package to install.
         - `state: present`: Ensures that the package is present (installed).

3. **Second Play**:
   - **Name**: "Database server configuration"
   - **Hosts**: This play targets hosts belonging to the group `dbservers`.
   - **Become**: It's set to `yes`, indicating that the tasks will be executed with escalated privileges.

   - **Tasks**:
     - **Task 4**: "install PostgreSQL"
       - **Module**: `apt`
       - **Module Options**:
         - `name: postgresql`: Specifies the name of the package to install.
         - `state: present`: Ensures that the package is present (installed).

**Explanation**:

- This playbook is designed to configure two types of servers: web servers and database servers.
- For web servers (`webservers` group):
  - It updates the package cache.
  - Installs Apache and Maven if they are not already present.

- For database servers (`dbservers` group):
  - It installs PostgreSQL if it is not already present.

- The `become: yes` setting allows the tasks to be executed with administrative privileges, which may be necessary for tasks like installing packages.

You can run this playbook using the `ansible-playbook` command, specifying the playbook file's location. For example:

```bash
ansible-playbook your_playbook.yml
```


## Simple Build & Deploy Playbook

``` yaml

---
- name: webserver configuration
  hosts: webservers
  become: yes
  tasks:
    - name: update package cache
      apt:
        update_cache: yes

    - name: Install Maven
      apt:
        name: maven
        state: present
    - name: Copy the Application to webserver
      synchronize:
        src: /home/ubuntu/BoardgameListingWebApp
        dest: /home/ubuntu/

- name: Build & Deploy
  hosts: webservers
  become: yes
  tasks:
    - name: Build the Application
      shell: |
        cd /home/ubuntu/BoardgameListingWebApp
        mvn package
    - name: Deploy The Application
      shell: |
        cd /home/ubuntu/BoardgameListingWebApp/target
        nohup java -jar *.jar &

```

This Ansible playbook is designed to configure and deploy a web application on a group of hosts labeled as `webservers`. It consists of two plays:

#### Play 1: Webserver Configuration
- **Name**: "webserver configuration" is a label that describes the purpose of this play.
- **Hosts**: This play targets hosts belonging to the group `webservers`.
- **Become**: It's set to `yes`, indicating that the tasks will be executed with escalated privileges.

##### Tasks:
1. **Task 1**: "update package cache"
   - **Module**: `apt`
   - **Module Options**:
     - `update_cache: yes`: This instructs `apt` to update the package cache.

2. **Task 2**: "Install Maven"
   - **Module**: `apt`
   - **Module Options**:
     - `name: maven`: Specifies the name of the package to install.
     - `state: present`: Ensures that the package is present (installed).

3. **Task 3**: "Copy the Application to webserver"
   - **Module**: `synchronize`
   - **Module Options**:
     - `src`: Specifies the source directory (`/home/ubuntu/BoardgameListingWebApp`) on the control machine.
     - `dest`: Specifies the destination directory (`/home/ubuntu/`) on the target host.

#### Play 2: Build & Deploy
- **Name**: "Build & Deploy"
- **Hosts**: This play targets hosts belonging to the group `webservers`.
- **Become**: It's set to `yes`, indicating that the tasks will be executed with escalated privileges.

##### Tasks:
1. **Task 4**: "Build the Application"
   - **Module**: `shell`
   - **Task Description**: This task navigates to the application directory, `/home/ubuntu/BoardgameListingWebApp`, and runs the Maven command `mvn package` to build the application.

2. **Task 5**: "Deploy The Application"
   - **Module**: `shell`
   - **Task Description**: This task navigates to the target directory, `/home/ubuntu/BoardgameListingWebApp/target`, and runs the command `nohup java -jar *.jar &` to execute the application in the background.

**Explanation**:

- This playbook automates the deployment process of a web application.
- The first play sets up the necessary environment on the target servers by updating the package cache, installing Maven, and copying the application files to the server.
- The second play focuses on building and deploying the application. It uses shell commands to navigate to the application directory, build it using Maven, and then deploy it using `java -jar`.

You can run this playbook using the `ansible-playbook` command, specifying the playbook file's location:

```bash
ansible-playbook your_playbook.yml
```
