### 1. Ports Not Open in Security Group
**Issue:** VM can't connect to the internet.
**Error Message:** Connection timeout or no connection.
**Solution:** Enable all traffic in the security group settings.

### 2. No Installation Candidate of the Package
**Issue:** Unable to install a package.
**Error Message:** E: Package 'package-name' has no installation candidate.
**Solution:** Run `sudo apt update` to update the package list.

### 3. Connection Timeout
**Issue:** Unable to establish a connection.
**Error Message:** Connection timed out.
**Solution:** Check internet connectivity and target server status. Use `ping` to test connectivity.

### 4. Checking SSH Port
**Issue:** Verify if SSH port (usually 22) is open.
**Solution:** Use `telnet IP 22` to check if the SSH port is open.

### 5. Getting Detailed Info about the VM
**Issue:** Need detailed information about a VM.
**Solution:** Use `nslookup IP` to get detailed information about the VM.

### 6. Port Already in Use
**Issue:** Another service is using a specific port.
**Error Message:** Port already in use.
**Solution:** Use `sudo lsof -i :port` to find the process using the port and terminate it if necessary.

### 7. Permission Denied on a Service
**Issue:** User lacks permissions to access a service.
**Solution:** Add the user to the appropriate group, e.g., `sudo usermod -aG docker $USER`.

### 8. Incorrect File Permissions
**Issue:** Unable to perform an operation due to incorrect permissions.
**Error Message:** Operation not permitted.
**Solution:** Adjust file permissions using `chmod` command, e.g., `chmod 755 filename`.

### 9. No Space Left on Device
**Issue:** Disk space is exhausted.
**Error Message:** No space left on device.
**Solution:** Use `df -h` to check disk usage and `du -sh /path/to/directory` to identify large directories. Remove unnecessary files using `rm` or `rm -rf`.

### 10. File Not Found
**Issue:** File or directory does not exist.
**Error Message:** No such file or directory.
**Solution:** Double-check the file path and directory existence using `ls` command.

### 11. Service Not Found
**Issue:** Service failed to start due to non-existence.
**Error Message:** Failed to start service-name.service: Unit service-name.service not found.
**Solution:** Verify the service name and ensure it's installed. Use `systemctl list-units --type=service` to list all services.

### 12. Failed to Fetch
**Issue:** Unable to fetch from a repository.
**Error Message:** Failed to fetch http://archive.ubuntu.com/ubuntu/dists/bionic/InRelease.
**Solution:** Verify internet connection and repository URL correctness.

### 13. Corrupted Package
**Issue:** Package lists or status file corruption.
**Error Message:** The package lists or status file could not be parsed or opened.
**Solution:** Clean local repository with `sudo apt-get clean` and update package list with `sudo apt-get update`.

### 14. Failed to Connect
**Issue:** Connection to a server is refused.
**Error Message:** Failed to connect to server: Connection refused.
**Solution:** Ensure the server is running and listening on the correct port. Check using `netstat -tuln`.

### 15. Failed to Start
**Issue:** Service failed to start due to non-existence.
**Error Message:** Failed to start service-name.service: Unit service-name.service failed to load: No such file or directory.
**Solution:** Verify the service name and ensure it's installed. Use `systemctl list-units --type=service` to list all services.

