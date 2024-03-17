

1. **Launch an EC2 Instance**:
   - Launch a t2.medium Ubuntu instance in AWS.
   - Make sure to assign an appropriate security group with ports 22, 443, 80, and 8080 opened.

2. **Create a Private Key**:
   - Generate a private key if you haven't already using `ssh-keygen` command.

3. **Connect to the Instance via SSH**:
   - Use MobaXterm or any SSH client to connect to the instance using the private key.

4. **Create User 'john'**:
   ```bash
   sudo adduser john
   ```

5. **Create Group 'xyz'**:
   ```bash
   sudo groupadd xyz
   ```

6. **Add 'xyz' as a Secondary Group for User 'john'**:
   ```bash
   sudo usermod -aG xyz john
   ```

7. **Delete User 'john' and Remove Its Home Directory**:
   ```bash
   sudo deluser --remove-home john
   ```

8. **Create Folders and Files**:
   ```bash
   sudo mkdir /myfolder
   sudo touch /myfolder/myfile.txt
   ```

9. **Change File Permissions & Ownership**:
   ```bash
   sudo chown john:xyz /myfolder/myfile.txt
   sudo chmod 640 /myfolder/myfile.txt
   ```

10. **Create Docker Installation Script**:
    ```bash
    touch docker_installation.sh
    ```

11. **Edit Script with Docker Installation Steps**:
    ```bash
    #!/bin/bash

    # Update apt package index
    sudo apt update

    # Install dependencies
    sudo apt install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Set up stable repository
    echo \
        "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker Engine
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io

    # Add current user to the docker group
    sudo usermod -aG docker $USER

    # Start and enable Docker service
    sudo systemctl start docker
    sudo systemctl enable docker
    ```

12. **Make the Script Executable**:
    ```bash
    chmod +x docker_installation.sh
    ```

13. **Execute the Script to Install Docker**:
    ```bash
    ./docker_installation.sh
    ```

