# Script

Sure! Here is your Ansible playbook converted to Markdown (md) format:


```yaml
- name: Install java and net-tools
  hosts: servers
  tasks:
    - name: Update apt repo and cache
      ansible.builtin.apt: update_cache=yes force_apt_get=yes cache_valid_time=3600
    - name: Install Java 8
      ansible.builtin.apt: name=openjdk-8-jre-headless
    - name: Install net-tools
      ansible.builtin.apt: name=net-tools

- name: Download and unpack Nexus installer
  hosts: servers
  tasks:
    - name: Check nexus folder stats
      ansible.builtin.stat:
        path: /opt/nexus
      register: stat_result
    - name: Download Nexus
      ansible.builtin.get_url:
        url: https://download.sonatype.com/nexus/3/nexus-3.60.0-02-unix.tar.gz
        dest: /opt/
      register: download_result
    - name: Untar nexus installer
      ansible.builtin.unarchive:
        src: "{{download_result.dest}}"
        dest: /opt/
        remote_src: yes
      when: not stat_result.stat.exists
    - name: Find nexus folder
      ansible.builtin.find:
        paths: /opt
        pattern: "nexus-*"
        file_type: directory
      register: find_result
    - name: Rename nexus folder
      command: mv /opt/nexus-3.60.0-02 /opt/nexus
      when: not stat_result.stat.exists

- name: Create nexus user to own nexus folders
  hosts: servers
  tasks:
    - name: Ensure group nexus exists
      ansible.builtin.group:
        name: nexus
        state: present
    - name: Create nexus user
      ansible.builtin.user:
        name: nexus
        group: nexus
    - name: Make nexus user owner of nexus folder
      ansible.builtin.file:
        path: /opt/nexus
        state: directory
        owner: nexus
        group: nexus
        recurse: yes
    - name: Make nexus user owner of sonatype-work folder
      ansible.builtin.file:
        path: /opt/sonatype-work
        state: directory
        owner: nexus
        group: nexus
        recurse: yes

- name: Start nexus with nexus user
  hosts: servers
  become: True
  become_user: nexus
  tasks:
    - name: Set run_as_user nexus
      ansible.builtin.lineinfile:
        path: /opt/nexus/bin/nexus.rc
        regexp: '^#run_as_user=""'
        line: run_as_user="nexus"
    - name: Start nexus
      command: /opt/nexus/bin/nexus start
```

# Verify Nexus | Some Issue so run till previous stage

```yaml
- name: Verify Nexus
  hosts: servers
  tasks:
    - name: Check Nexus process status
      ansible.builtin.shell: ps aux | grep nexus
      register: app_status
    - ansible.builtin.debug: msg={{ app_status.stdout_lines }}
    - name: Wait for a minute
      ansible.builtin.pause:
        minutes: 2
    - name: Check netstat
      ansible.builtin.shell: netstat -plnt
      register: netstat_result
    - ansible.builtin.debug: msg={{ netstat_result.stdout_lines }}

```


