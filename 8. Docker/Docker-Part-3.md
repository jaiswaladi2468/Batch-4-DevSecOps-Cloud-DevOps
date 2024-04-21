# DOCKER VOLUMES

Docker volumes are a way to persist data generated or used by Docker containers. They provide a means to store and manage data separately from the container itself, ensuring that data persists even if the container is stopped or removed. Docker volumes are commonly used for scenarios where you need to share data between containers or when you want to keep data separate from the container's file system.

Here are some key aspects of Docker volumes:

1. **Persistent Data**: Docker containers are typically ephemeral, meaning their file systems are isolated and any data generated within a container is lost when the container is removed. Volumes provide a way to store data outside of containers, ensuring that it persists across container lifecycle events.

2. **Types of Volumes**: Docker supports several types of volumes, including named volumes, host-mounted volumes, and anonymous volumes.

   - **Named Volumes**

   - **Host-Mounted Volumes**

   - **Anonymous Volumes**

3. **Volume Management**: You can create, list, inspect, and remove volumes using Docker CLI commands like `docker volume create`, `docker volume ls`, `docker volume inspect`, and `docker volume rm`.

4. **Using Volumes**: To use a volume in a Docker container, you specify the volume's name or mount point in the container's configuration, typically in a Docker Compose file or when running `docker run` with the `-v` or `--volume` option.

Here's an example of how to create and use a named volume in Docker:

```bash
# Create a named volume
docker volume create mydata

# Run a container and mount the volume
docker run -d --name mycontainer -v mydata:/app/data myimage

# Data in /app/data inside the container is stored in the 'mydata' volume
```

Using Docker volumes is a common practice for managing data in Dockerized applications, especially in scenarios where you need to ensure data persistence and share data between containers.

Docker volumes are used to persist data when containers are created, removed, or stopped. Here's when data persists when using Docker volumes:

1. **Container Restart**: If a container is stopped and then restarted, the data stored in volumes associated with that container will persist. This is useful for ensuring that your application's data survives container restarts.

2. **Container Removal**: When you remove a container using `docker rm`, the data within the container itself is lost. However, if you have mapped a Docker volume to store data, that data will persist even after the container is removed. Volumes are separate from containers, so they can outlive the containers that use them.

3. **Container Replacement**: If you replace a container with a new one (e.g., updating to a new version of your application), you can attach the same volume to the new container, allowing it to access and manipulate the same data.

4. **Host System Reboot**: Even if the host machine running Docker is rebooted, the data stored in Docker volumes should remain intact. Docker manages volumes independently from the host's filesystem.

5. **Scaling Containers**: When you use Docker Compose or orchestration tools like Docker Swarm or Kubernetes to scale your application by creating multiple containers, each container can use the same volume to access and share data.


## Docker volume types

Docker supports three main types of volumes for managing persistent data in containers: **host-mounted volumes**, **anonymous volumes**, and **named volumes**. Here are examples of each:

1. **Host-Mounted Volumes**:
   - Host-mounted volumes allow you to specify a directory from the host machine that is mounted into the container. This can be useful when you want to share data between the host and container.

   ```bash
   docker run -v /path/on/host:/path/in/container myapp
   ```

   Example: Mount the `/var/data` directory on the host machine to the `/data` directory in the container.

   ```bash
   docker run -v /var/data:/data myapp
   ```

2. **Anonymous Volumes**:
   - Anonymous volumes are created automatically by Docker and are managed for you. They are typically used when you don't need to manage the volume explicitly, such as for temporary or cache data.

   ```bash
   docker run -v /path/in/container myapp
   ```

   Example: Create an anonymous volume for a PostgreSQL database container.

   ```bash
   docker run -v /var/lib/postgresql/data postgres
   ```

3. **Named Volumes**:
   - Named volumes are explicitly created and given a name, making it easier to manage and share data between containers. They are useful for maintaining data between container restarts and for sharing data between multiple containers.

   ```bash
   docker volume create mydata
   docker run -v mydata:/path/in/container myapp
   ```

   Example: Create a named volume called `mydata` and use it to persist data for a web application container.

   ```bash
   docker volume create mydata
   docker run -v mydata:/app/data myapp
   ```

These are the three main types of Docker volumes, each with its own use cases. You can choose the one that best fits your requirements based on whether you need to manage the volume explicitly, share data with the host, or share data between containers.


## EXAMPLE

You can use Docker Compose to set up a MongoDB container and a MongoDB Express (Mongo-Express) container. This example assumes you already have Docker and Docker Compose installed.

Create a directory for your project and create a `docker-compose.yml` file inside it with the following content:

```yaml
version: '3'

services:
  mongodb:
    image: mongo
    container_name: mongodb
    networks:
      - mongo-network
    ports:
      - "27017:27017"
    environment:
      - MONGO_INITDB_ROOT_USERNAME=admin
      - MONGO_INITDB_ROOT_PASSWORD=123

  mongo-express:
    image: mongo-express
    container_name: mongo-express
    networks:
      - mongo-network
    ports:
      - "8081:8081"
    environment:
      - ME_CONFIG_MONGODB_SERVER=mongodb
      - ME_CONFIG_MONGODB_ADMINUSERNAME=admin
      - ME_CONFIG_MONGODB_ADMINPASSWORD=123
      - ME_CONFIG_BASICAUTH_USERNAME=admin
      - ME_CONFIG_BASICAUTH_PASSWORD=123

networks:
  mongo-network:
    driver: bridge

```

In this `docker-compose.yml` file:

- We define two services: `mongodb` and `mongo-express`.
- The `mongodb` service uses the official MongoDB image and specifies a named volume `mongodb_data` for persisting MongoDB data.
- We set environment variables for the MongoDB container to create an initial admin user with a username and password.
- The `mongo-express` service uses the official Mongo Express image and connects to the `mongodb` service using the `ME_CONFIG_MONGODB_SERVER` environment variable.
- We also set environment variables for the Mongo Express container to configure it.

Now, navigate to the directory containing the `docker-compose.yml` file in your terminal and run:

```bash
docker-compose up
```

Docker Compose will download the necessary images (if not already downloaded) and start the MongoDB and Mongo Express containers. You can access the MongoDB Express web interface at `http://localhost:8081` and log in using the MongoDB admin credentials you specified in the `docker-compose.yml` file.

The data for MongoDB will be stored in a Docker named volume named `mongodb_data`, ensuring that it persists even if you stop and remove the containers.

To stop the containers, press `Ctrl+C` in the terminal where they are running, and then run:

```bash
docker-compose down
```

This will stop and remove the containers, but the data will remain in the named volume for future use.
