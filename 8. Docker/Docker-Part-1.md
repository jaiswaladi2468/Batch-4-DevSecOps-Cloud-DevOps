# Docker

Docker is a popular platform for developing, shipping, and running applications inside containers. Containers are lightweight, isolated environments that package an application and its dependencies, making it easier to ensure consistency between different environments, from development to production. In this detailed explanation, I'll cover the key concepts of Docker and provide examples to illustrate these concepts.

### Key Docker Concepts:

1. **Images**: Docker images are read-only templates that define how a container should run. Images contain the application code, libraries, and dependencies needed to execute an application. Images are often created from a Dockerfile, which is a text file that specifies the instructions for building the image.

2. **Containers**: Containers are instances of Docker images. They are lightweight, isolated, and run in their own environment. Containers can be started, stopped, and deleted quickly. They provide a consistent runtime environment, regardless of the host system.

3. **Dockerfile**: A Dockerfile is a text file that contains a set of instructions for building a Docker image. These instructions include things like specifying the base image, copying files into the image, setting environment variables, and running commands. Here's a simple example:

   ```Dockerfile
   # Use a base image
   FROM ubuntu:20.04

   # Set an environment variable
   ENV MY_VAR=HelloDocker

   # Copy files into the image
   COPY ./app /app

   # Run a command when the container starts
   CMD ["./app/start.sh"]
   ```

4. **Docker Hub**: Docker Hub is a public registry of Docker images. It allows developers to share and distribute Docker images. You can find official images for various software and create your own images to publish.

5. **Docker Compose**: Docker Compose is a tool for defining and running multi-container Docker applications. It uses a YAML file (docker-compose.yml) to define services, networks, and volumes for your application. It simplifies the management of complex applications consisting of multiple containers.


### Brief summary of Docker's key components:

1. **Docker Daemon**:
   - The Docker daemon (also known as `dockerd`) is a background service that manages Docker containers on a host system.
   - It is responsible for building, running, and managing containers.
   - The Docker daemon listens for Docker API requests and communicates with the container runtime to execute those requests.
   - It typically runs as a system service and handles the low-level container operations.

2. **Docker Client**:
   - The Docker client (usually invoked using the `docker` command) is a command-line tool that allows users to interact with the Docker daemon.
   - Users issue commands to the Docker client to perform various tasks like creating containers, building images, managing volumes, and more.
   - The Docker client communicates with the Docker daemon via the Docker API to carry out these actions.
   - It acts as the primary interface for users to control and manage Docker containers and resources.

3. **Docker Socket**:
   - The Docker socket (typically `/var/run/docker.sock` on Unix-based systems) is a Unix socket that serves as a communication channel between the Docker client and the Docker daemon.
   - When a Docker client issues a command, it sends a request to the Docker socket.
   - The Docker daemon, in turn, listens to this socket and processes the client's request, executing the requested Docker operation.
   - This socket allows secure communication between the client and the daemon without exposing the Docker API over a network port.

In summary, the Docker daemon is responsible for managing containers, the Docker client is the user interface for interacting with Docker, and the Docker socket serves as the communication bridge between the client and the daemon, enabling users to control and manage containers and resources on a host system.




### 1. Installing Docker:

To install Docker on Ubuntu using the `docker.io` package, you can follow these steps:

1. **Update Package List**:

   Open a terminal and update the local package index to ensure you have the latest information about available packages:

   ```bash
   sudo apt update
   ```

2. **Install Docker**:

   You can install Docker using the `docker.io` package as follows:

   ```bash
   sudo apt install docker.io
   ```

3. **Start and Enable Docker Service**:

   After the installation is complete, start the Docker service and enable it to start on boot:

   ```bash
   sudo systemctl start docker
   sudo systemctl enable docker
   ```

4. **Verify Docker Installation**:

   To verify that Docker has been installed correctly, run the following command:

   ```bash
   docker --version
   ```

   You should see the Docker version information displayed in the terminal.

5. **Manage Docker Without Sudo (Optional)**:

   By default, the Docker command requires sudo privileges. If you want to use Docker without sudo, you can add your user to the "docker" group:

   ```bash
   sudo usermod -aG docker $USER
   ```

   After adding your user to the "docker" group, log out and log back in or run the following command to apply the group changes without logging out:

   ```bash
   newgrp docker
   ```

   You should now be able to run Docker commands without sudo.

That's it! Docker is now installed on your Ubuntu system using the `docker.io` package, and you can start using it to manage containers.

### 2. Dockerfile

A Dockerfile is a script used to create a Docker image. It consists of a set of instructions that Docker follows to build the image. Each instruction in the Dockerfile creates a new layer in the image, and these layers are cached for efficiency. Here's an explanation of some key Dockerfile instructions, along with examples:

#### Example Dockerfile:

```dockerfile
# Use an official base image
FROM ubuntu:20.04

# Set the working directory
WORKDIR /app

# Copy application code to the container
COPY . /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Expose a port
EXPOSE 8080

# Define environment variables
ENV APP_NAME=myapp \
    VERSION=1.0

# Run the application
CMD ["python3", "app.py"]
```

#### Dockerfile Keywords:

1. **FROM:** Specifies the base image for the new image. It is the starting point for the Dockerfile.
   - Example: `FROM ubuntu:20.04`

2. **WORKDIR:** Sets the working directory for subsequent instructions.
   - Example: `WORKDIR /app`

3. **COPY:** Copies files from the host to the container. It is often used to copy application source code into the image.
   - Example: `COPY . /app`

4. **RUN:** Executes a command in a new layer on top of the current image and commits the results.
   - Example: `RUN apt-get update && apt-get install -y python3`

5. **EXPOSE:** Informs Docker that the container will listen on the specified network ports at runtime.
   - Example: `EXPOSE 8080`

6. **ENV:** Sets environment variables in the image.
   - Example: `ENV APP_NAME=myapp VERSION=1.0`

7. **CMD:** Provides default command and/or parameters for the container when it's run.
   - Example: `CMD ["python3", "app.py"]`

#### Difference between `ADD` and `COPY`:

- **COPY:** Copies files from the host to the container. It is a straightforward file copy operation.
  - Example: `COPY . /app`

- **ADD:** Similar to `COPY` but has some additional features. It can also fetch remote URLs and extract tarballs.
  - Example: `ADD http://example.com/file.tar.gz /tmp/`

In general, it's recommended to use `COPY` unless you specifically need the additional functionality provided by `ADD`.

#### Difference between `ENTRYPOINT` and `CMD`:

- **CMD:** Specifies the default command and parameters for the container. It can be overridden at runtime.
  - Example: `CMD ["python3", "app.py"]`

- **ENTRYPOINT:** Configures a container that will run as an executable. It provides the default application to run.
  - Example: `ENTRYPOINT ["python3", "app.py"]`

When using both `ENTRYPOINT` and `CMD`, the `CMD` values are passed as arguments to the `ENTRYPOINT` command. `ENTRYPOINT` is often used when you want to define a container as an executable and `CMD` to provide default arguments.

### 3. Building a Docker Image:

The Dockerfile snippet you provided is used to build a Docker image for a Java application based on the Alpine Linux image with OpenJDK 17. It copies your application's JAR file into the image and specifies how to run it as a container. However, there's a small issue with the `ENTRYPOINT` line. It should reference `app.jar`, not `your-app.jar`. Here's the corrected Dockerfile snippet:

```Dockerfile
# Use the OpenJDK 17 Alpine Linux image as the base image
FROM openjdk:17-alpine

# Copy the JAR file from your local system to the image
COPY target/database_service_project-0.0.1.jar app.jar

# Expose port 8080 to the outside world (for networking)
EXPOSE 8080

# Set the entry point for running the application
ENTRYPOINT ["java", "-jar", "app.jar"]
```

With this Dockerfile, you can build an image for your Java application using the `docker build` command, and then run containers based on that image to host your application. Make sure that the `database_service_project-0.0.1.jar` file is in the `target` directory of your project before building the Docker image.

Here's how you can build the Docker image:

```bash
docker build -t my-java-app .
```

And then you can run a container from the image:

```bash
docker run -p 8080:8080 my-java-app
```

This will start your Java application inside a Docker container, and it will be accessible on port 8080 of your host machine.

### 4. Running a Docker Container:

Now that we have our Docker image, we can run a container from it:

```bash
docker run -d -p 8080:80 my-python-app
```

This command starts a container in detached mode (`-d`), mapping port 8080 on your host to port 80 in the container. Your Python web app should be accessible at `http://localhost:8080`.


### 5. Docker Hub and Pulling Images:

You can find and use existing Docker images from Docker Hub. For example, to pull an official Nginx image:

```bash
docker pull nginx:latest
```

This command downloads the Nginx image from Docker Hub, making it available for you to run as a container.

These examples cover the basics of Docker. Docker is a powerful tool that simplifies application deployment and management, especially in a containerized and microservices architecture. It allows you to package applications and their dependencies, ensuring consistency and ease of deployment across different environments.

# MultiStage Dockerfiles

A multi-stage Dockerfile is a feature introduced in Docker to optimize the size of the final Docker image by using multiple build stages. It helps reduce the size of the resulting image by allowing you to discard unnecessary files and dependencies from the final image, which might have been needed during the build process but are not required for the runtime. This is particularly useful when building applications that have multiple dependencies or require build tools.

Here's an example of a simple multi-stage Dockerfile:

```dockerfile
# Build Stage
FROM node:14 as builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Final Stage
FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

In this example, there are two stages:

1. **Build Stage (`FROM node:14 as builder`):**
   - Sets up a build environment using the Node.js base image.
   - Copies the `package.json` and `package-lock.json` files, installs dependencies, and then copies the application code.
   - Runs the build process (e.g., compilation).

2. **Final Stage (`FROM nginx:alpine`):**
   - Uses a lightweight Nginx image as the final image.
   - Copies only the necessary artifacts (e.g., the compiled output from the build stage) from the previous stage using `COPY --from=builder`.
   - Exposes port 80 and sets the default command to start the Nginx server.

Key benefits of using a multi-stage Dockerfile:

1. **Reduced Image Size:**
   - The final image only contains the necessary files and dependencies, resulting in a smaller image size.
  
2. **Improved Security:**
   - Unnecessary build dependencies and tools are not included in the final image, reducing the attack surface.

3. **Cleaner Images:**
   - The final image only contains the runtime artifacts, making it easier to manage and distribute.

To build the Docker image using this multi-stage Dockerfile, you can run:

```bash
docker build -t myapp .
```

This example is for a Node.js application, but the concept of multi-stage builds can be applied to other types of applications and programming languages as well.


#### This Dockerfile demonstrates the use of multi-stage builds to build a Java web application using Maven and then deploy it to an Apache Tomcat server. Let's break down each stage:

### Stage-1: Build
```dockerfile
# Use Maven as the base image
FROM maven as maven

# Create a directory and set it as the working directory
RUN mkdir /usr/src/mymaven
WORKDIR /usr/src/mymaven

# Copy the entire application to the working directory
COPY . .

# Build the application using Maven (skip tests for faster build)
RUN mvn install -DskipTests
```

- **`FROM maven as maven`:** Specifies the Maven base image for the build stage.
- **`RUN mkdir /usr/src/mymaven`:** Creates a directory for the Maven build in the container.
- **`WORKDIR /usr/src/mymaven`:** Sets the working directory to the Maven build directory.
- **`COPY . .`:** Copies the contents of the local directory (where the Dockerfile is located) to the container's working directory.
- **`RUN mvn install -DskipTests`:** Runs the Maven build, installing dependencies and building the application. The `-DskipTests` flag skips running tests during the build.

### Stage-2: Deploy
```dockerfile
# Use Tomcat as the base image for the deployment stage
FROM tomcat 

# Set the working directory to Tomcat's webapps directory
WORKDIR /usr/local/tomcat/webapps 

# Copy the built WAR file from the Maven build stage to Tomcat's webapps directory
COPY --from=maven /usr/src/mymaven/target/java-tomcat-maven-example.war .

# Remove the existing ROOT directory in Tomcat and rename the WAR file to ROOT.war
RUN rm -rf ROOT && mv java-tomcat-maven-example.war ROOT.war
```

- **`FROM tomcat`:** Specifies the Tomcat base image for the deployment stage.
- **`WORKDIR /usr/local/tomcat/webapps`:** Sets the working directory to Tomcat's webapps directory.
- **`COPY --from=maven /usr/src/mymaven/target/java-tomcat-maven-example.war .`:** Copies the WAR file generated in the Maven build stage to Tomcat's webapps directory.
- **`RUN rm -rf ROOT && mv java-tomcat-maven-example.war ROOT.war`:** Removes the existing `ROOT` directory in Tomcat (the default web application) and renames the WAR file to `ROOT.war`. This effectively deploys the application as the default web application in Tomcat.

In summary, this Dockerfile uses two stages: the first for building the Java web application with Maven, and the second for deploying the built WAR file to an Apache Tomcat server. This approach optimizes the final image size by excluding build dependencies and artifacts not needed for runtime.


# Top 50 Docker commands, grouped by their primary functions:

### Managing Containers:

1. **Run a Container**:
   ```
   docker run [OPTIONS] IMAGE [COMMAND] [ARGS]
   ```

2. **List Running Containers**:
   ```
   docker ps
   ```

3. **List All Containers** (including stopped ones):
   ```
   docker ps -a
   ```

4. **Start a Stopped Container**:
   ```
   docker start CONTAINER_ID
   ```

5. **Stop a Running Container**:
   ```
   docker stop CONTAINER_ID
   ```

6. **Restart a Container**:
   ```
   docker restart CONTAINER_ID
   ```

7. **Remove a Container** (stop and delete):
   ```
   docker rm CONTAINER_ID
   ```

8. **Execute a Command in a Running Container**:
   ```
   docker exec [OPTIONS] CONTAINER_ID|NAME [COMMAND] [ARGS]
   ```

9. **Inspect Container Details**:
   ```
   docker inspect CONTAINER_ID
   ```

10. **Attach to a Running Container's STDIN, STDOUT, and STDERR**:
    ```
    docker attach CONTAINER_ID
    ```

### Managing Images:

11. **List Docker Images**:
    ```
    docker images
    ```

12. **Pull an Image from a Registry**:
    ```
    docker pull IMAGE_NAME[:TAG]
    ```

13. **Build an Image from a Dockerfile**:
    ```
    docker build [OPTIONS] PATH_TO_DOCKERFILE
    ```

14. **Tag an Image**:
    ```
    docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]
    ```

15. **Remove an Image**:
    ```
    docker rmi IMAGE_ID
    ```

16. **Search for Images on Docker Hub**:
    ```
    docker search IMAGE_NAME
    ```

17. **Save an Image to a Tarball File**:
    ```
    docker save -o OUTPUT_FILE.tar IMAGE_NAME[:TAG]
    ```

18. **Load an Image from a Tarball File**:
    ```
    docker load -i INPUT_FILE.tar
    ```

### Managing Docker Volumes:

19. **List Docker Volumes**:
    ```
    docker volume ls
    ```

20. **Create a Docker Volume**:
    ```
    docker volume create VOLUME_NAME
    ```

21. **Inspect a Docker Volume**:
    ```
    docker volume inspect VOLUME_NAME
    ```

22. **Remove a Docker Volume**:
    ```
    docker volume rm VOLUME_NAME
    ```

### Managing Networks:

23. **List Docker Networks**:
    ```
    docker network ls
    ```

24. **Create a Docker Network**:
    ```
    docker network create NETWORK_NAME
    ```

25. **Inspect a Docker Network**:
    ```
    docker network inspect NETWORK_NAME
    ```

26. **Remove a Docker Network**:
    ```
    docker network rm NETWORK_NAME
    ```

### Managing Docker Compose:

27. **Start Docker Compose Services**:
    ```
    docker-compose up [OPTIONS] [SERVICE...]
    ```

28. **Stop Docker Compose Services**:
    ```
    docker-compose down [OPTIONS]
    ```

29. **Build or Rebuild Docker Compose Services**:
    ```
    docker-compose build [SERVICE...]
    ```

30. **View Docker Compose Logs**:
    ```
    docker-compose logs [SERVICE...]
    ```

### Docker Registry and Authentication:

31. **Login to a Docker Registry**:
    ```
    docker login [OPTIONS] [SERVER]
    ```

32. **Logout from a Docker Registry**:
    ```
    docker logout [SERVER]
    ```

### Miscellaneous Commands:

33. **View Docker Version Info**:
    ```
    docker version
    ```

34. **Check Docker System Information**:
    ```
    docker info
    ```

35. **Display Docker Disk Usage**:
    ```
    docker system df
    ```

36. **Monitor Docker Events**:
    ```
    docker events [OPTIONS]
    ```

37. **Pull and Apply Updates to Docker Swarm Services**:
    ```
    docker service update [OPTIONS] SERVICE
    ```

38. **Clean Up Unused Resources (Containers, Images, Volumes, Networks)**:
    ```
    docker system prune
    ```

39. **Pause a Running Container**:
    ```
    docker pause CONTAINER_ID
    ```

40. **Unpause a Paused Container**:
    ```
    docker unpause CONTAINER_ID
    ```

41. **Inspect Docker Daemon Logs**:
    ```
    docker logs docker
    ```

### Docker Swarm (Container Orchestration):

42. **Initialize a Docker Swarm**:
    ```
    docker swarm init [OPTIONS]
    ```

43. **Join a Node to a Docker Swarm**:
    ```
    docker swarm join [OPTIONS] HOST:PORT
    ```

44. **List Nodes in a Docker Swarm**:
    ```
    docker node ls
    ```

45. **Create a Docker Service**:
    ```
    docker service create [OPTIONS] IMAGE [COMMAND] [ARGS]
    ```

46. **List Docker Services**:
    ```
    docker service ls
    ```

47. **Scale a Docker Service**:
    ```
    docker service scale SERVICE=REPLICAS
    ```

48. **Inspect a Docker Service**:
    ```
    docker service inspect SERVICE
    ```

49. **Remove a Docker Service**:
    ```
    docker service rm SERVICE
    ```

50. **Leave a Docker Swarm (Node)**:
    ```
    docker swarm leave [OPTIONS]
    ```

These are some of the most commonly used Docker commands for managing containers, images, volumes, networks, and Docker Swarm. Depending on your specific use case, you may need to use additional commands and options to tailor Docker to your needs.
