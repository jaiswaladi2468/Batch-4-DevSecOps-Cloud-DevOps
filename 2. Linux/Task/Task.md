**Linux Task Assignment**

---

**Objective:**  
To demonstrate proficiency in AWS EC2 instance management, user and group administration, file system operations, and script creation and execution in a Linux environment.

**Task Description:**

1. **AWS EC2 Instance Setup:**
   - Launch a t2.medium Ubuntu instance in AWS.
   - Configure security group settings to allow inbound traffic on ports 22, 443, 80, and 8080.

2. **SSH Access:**
   - Generate a private key for SSH access.
   - Connect to the AWS EC2 instance using SSH via MobaXterm.

3. **User and Group Administration:**
   - Create a user named 'john'.
   - Create a group named 'xyz'.
   - Assign the group 'xyz' as a secondary group for the user 'john'.

4. **User Deletion:**
   - Delete the user 'john' from the system.
   - Remove the home directory associated with the user 'john'.

5. **File System Operations:**
   - Create a directory named 'myfolder'.
   - Create a file named 'myfile.txt' inside 'myfolder'.
   - Change the ownership of 'myfile.txt' to user 'john' and group 'xyz'.
   - Change the permissions of 'myfile.txt' to 640.

6. **Docker Installation Script:**
   - Create a script named 'docker_installation.sh'.
   - Add the necessary commands to install Docker within the script.
   - Ensure the script is executable.
   - Execute the script to install Docker on the system.

