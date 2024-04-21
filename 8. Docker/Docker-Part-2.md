# Docker-Part-2

Docker provides a flexible networking system that allows containers to communicate with each other and with the outside world. You can create and manage Docker networks using the Docker CLI. Here are some basic Docker network commands with examples:

1. **List Docker Networks:**
   To see a list of all available Docker networks, use the `docker network ls` command.

   ```bash
   docker network ls
   ```

2. **Create a Custom Bridge Network:**
   You can create a custom bridge network to isolate containers from the host network. This is useful when you want containers to communicate with each other privately.

   ```bash
   docker network create my_custom_network
   ```

3. **Create a Container on a Specific Network:**
   When running a container, you can specify the network it should connect to using the `--network` flag.

   ```bash
   docker run --name container1 --network my_custom_network -d nginx
   ```

4. **Inspect Network Details:**
   To view details about a specific network, use the `docker network inspect` command.

   ```bash
   docker network inspect my_custom_network
   ```

5. **Create a Container with a Specific IP Address:**
   You can specify a static IP address for a container within a custom bridge network using the `--ip` flag.

   ```bash
   docker run --name container2 --network my_custom_network --ip 172.18.0.10 -d nginx
   ```

6. **Connect an Existing Container to a Network:**
   You can also connect an existing container to a network using the `docker network connect` command.

   ```bash
   docker network connect my_custom_network container1
   ```

7. **Disconnect a Container from a Network:**
   To disconnect a container from a network, use the `docker network disconnect` command.

   ```bash
   docker network disconnect my_custom_network container1
   ```

8. **Remove a Custom Network:**
   To remove a custom network, use the `docker network rm` command. Make sure no containers are using the network before removing it.

   ```bash
   docker network rm my_custom_network
   ```

   
These are some common Docker networking commands and examples. Docker provides various network drivers, such as bridge, host, overlay, and macvlan, which offer different networking capabilities. Choose the appropriate network driver based on your use case and requirements.


Docker provides various types of networks and network drivers to enable different network configurations and communication patterns for containers. Here are some of the most commonly used Docker network types and their associated network drivers:

1. **Bridge Network (bridge):**
   - **Description:** The default network mode for Docker containers when no network is specified. It creates an internal private network on the host, and containers can communicate with each other using container names.
   - **Use Cases:** Suitable for most containerized applications where containers need to communicate on the same host.

2. **Host Network (host):**
   - **Description:** Containers share the host network stack, making them directly accessible from the host and other containers without any network address translation (NAT).
   - **Use Cases:** High-performance scenarios where containers need to bind to specific host ports, but it lacks network isolation.

3. **Overlay Network (overlay):**
   - **Description:** Used in Docker Swarm mode to facilitate communication between containers running on different nodes in a swarm cluster. It uses VXLAN encapsulation for inter-node communication.
   - **Use Cases:** Multi-host, multi-container applications orchestrated with Docker Swarm.

4. **Macvlan Network (macvlan):**
   - **Description:** Allows containers to have their own MAC addresses and appear as separate devices on the host network. Each container has a unique network identity.
   - **Use Cases:** When containers need to be directly on an external network, e.g., connecting containers to physical networks or VLANs.

5. **None Network (none):**
   - **Description:** Containers on this network have no network connectivity. It's often used for isolated testing or when the container only needs loopback connectivity.
   - **Use Cases:** Limited use cases, primarily for debugging or security purposes.

6. **Custom Bridge Network (user-defined bridge):**
   - **Description:** Users can create their custom bridge networks to have better control over container connectivity, DNS resolution, and isolation.
   - **Use Cases:** Isolating containers, customizing DNS settings, or when you need multiple bridge networks on the same host.

7. **Overlay2 Network (overlay2):**
   - **Description:** Introduced in Docker 20.10, the Overlay2 network driver is optimized for container-to-container communication within the same network namespace.
   - **Use Cases:** High-performance communication between containers on the same host, especially when using the Overlay2 storage driver.

8. **Cilium Network (cilium):**
   - **Description:** Cilium is an open-source networking and security project that offers advanced networking features, including API-aware network security and load balancing.
   - **Use Cases:** Advanced networking and security requirements, often in Kubernetes environments.

9. **Gossip Network (gossip):**
   - **Description:** Used in Docker Swarm mode to enable gossip-based cluster management for container orchestration and service discovery.
   - **Use Cases:** Docker Swarm cluster communication and coordination.

These network types and drivers provide flexibility and cater to different use cases and requirements in containerized applications. Choosing the right network type and driver depends on your application's architecture, networking needs, and deployment environment.

# Docker-Compose

Docker Compose is a tool for defining and running multi-container Docker applications. It allows you to define your application's services, networks, and volumes in a single `docker-compose.yml` file, making it easier to manage complex Docker setups. Here's a guide on how to use Docker Compose with examples:

### Install Docker Compose
Before you begin, make sure you have Docker Compose installed. You can download it from the [official Docker Compose website](https://docs.docker.com/compose/install/).

### Creating a Docker Compose File
Create a `docker-compose.yml` file in your project directory. This file will define your Docker services and their configurations.

Here's a simple example that defines two services, a web application using Nginx and a backend using Node.js:

```yaml
version: '3'
services:
  web:
    image: nginx:latest
    ports:
      - "80:80"
  backend:
    image: node:14
    working_dir: /app
    volumes:
      - ./backend:/app
    command: npm start
```

In this example:

- `version: '3'` specifies the Docker Compose file version.
- `services` section defines two services: `web` and `backend`.
- `web` uses the official Nginx image and maps port 80 of the host to port 80 of the container.
- `backend` uses the official Node.js image, sets a working directory, mounts a local directory as a volume, and specifies a command to run when the container starts.

### Docker Compose Commands
Here are some common Docker Compose commands you can use:

1. **Start Containers:** Start your services defined in the `docker-compose.yml` file.

   ```bash
   docker-compose up
   ```

   Add the `-d` flag to run in detached mode (in the background).

   ```bash
   docker-compose up -d
   ```

2. **Stop Containers:** Stop the containers defined in the `docker-compose.yml` file.

   ```bash
   docker-compose down
   ```

3. **View Logs:** View the logs of your running containers.

   ```bash
   docker-compose logs
   ```

4. **Build Services:** Build or rebuild services (useful when you make changes to your Dockerfile or source code).

   ```bash
   docker-compose build
   ```

5. **Scale Services:** You can scale services by specifying the desired number of replicas. For example, to run two instances of the `backend` service:

   ```bash
   docker-compose up -d --scale backend=2
   ```

6. **Execute a Command in a Service:** You can execute commands within a specific service using `docker-compose exec`. For example, to run a shell in the `backend` service:

   ```bash
   docker-compose exec backend sh
   ```

### Cleaning Up
To remove all containers and networks created by Docker Compose, use:

```bash
docker-compose down --volumes
```

This will also remove the volumes associated with your services.

These are some of the basic Docker Compose commands and examples to get you started. Docker Compose is a powerful tool for managing containerized applications, and you can define more complex configurations and dependencies in your `docker-compose.yml` file as your project evolves.

## SAMPLE


```bash
# Start MongoDB container

docker run -d -p 27017:27017 --network mongo-network --name mongodb \
-e MONGO_INITDB_ROOT_USERNAME=admin \
-e MONGO_INITDB_ROOT_PASSWORD=123 \
mongo

# Start Mongo-Express Container

docker run -d -p 8081:8081 \
  --network mongo-network \
  --name mongo-express \
  -e ME_CONFIG_MONGODB_SERVER=mongodb \
  -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin \
  -e ME_CONFIG_MONGODB_ADMINPASSWORD=123 \
  -e ME_CONFIG_BASICAUTH_USERNAME=admin \
  -e ME_CONFIG_BASICAUTH_PASSWORD=123 \
  mongo-express

```



### Here's the equivalent Docker Compose file for your setup

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

This Docker Compose file defines two services, `mongodb` and `mongo-express`, just like your original Docker commands. It also specifies the necessary environment variables, ports, and network configurations. To use it, create a `docker-compose.yml` file in your project directory 
and run `docker-compose up -d` to start the services.


## Practice Repo

https://github.com/DanielMichalski/responsive-personal-website

