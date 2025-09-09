# Dockerizing Spring Boot Microservices - Student Guide

## Objective
Learn to dockerize Spring Boot microservice applications and deploy them in Docker containers for scalable, portable deployment.

## Prerequisites
- Basic Java knowledge
- Understanding of REST APIs
- Docker fundamentals (completed Lesson 2)
- Maven build tool familiarity
- Java Development Kit (JDK 21 or higher)

## What You'll Learn
- Spring Boot project creation and configuration
- RESTful microservice development
- Maven build processes
- Docker containerization of Spring Boot applications
- Parent and Base Image concepts in Docker
- Manual Image Generation with Docker Commit
- Container deployment and testing
- Port mapping and container management

## Project Overview
We'll create an "eStore" Spring Boot microservice that:
- Provides REST endpoints for welcome messages and product data
- Runs on a configurable port (9090)
- Serves static HTML content
- Returns JSON responses for product listings
- Packages as a JAR file for containerization

## Directory Structure
```
eStore/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/example/estore/
│   │   │       ├── EstoreApplication.java
│   │   │       ├── controller/
│   │   │       │   └── AppController.java
│   │   │       └── model/
│   │   │           └── Product.java
│   │   └── resources/
│   │       ├── application.properties
│   │       └── static/
│   │           └── index.html
├── target/
├── Dockerfile
├── pom.xml
└── README.md
```

## Step-by-Step Implementation

### Step 1: Create Spring Boot Project

#### 1.1 Using Spring CLI (Recommended)
```bash
# Using Spring CLI to create Maven project
spring init --dependencies=web --type=maven-project --name=estore --package-name=com.example.estore --java-version=21 --packaging=jar estore
```

#### 1.2 Project Configuration
- **Project Name**: eStore
- **Build Tool**: Maven
- **Packaging**: JAR
- **Java Version**: 21
- **Dependencies**: Spring Web

### Step 2: Configure Spring Boot Application

#### 2.1 Application Properties
Configure server settings in `src/main/resources/application.properties`:
```properties
# Server configuration
server.port=9090

# Application configuration
spring.application.name=eStore
server.servlet.context-path=/app
```

#### 2.2 Static Content
Create `src/main/resources/static/index.html`:
```html
<!DOCTYPE html>
<html>
<head>
    <title>eStore - Welcome</title>
    <meta charset="UTF-8">
</head>
<body>
    <h1>Welcome to Spring Boot</h1>
    <p>Your eStore microservice is running successfully!</p>
    <ul>
        <li><a href="/app/products">Products API</a></li>
        <li><a href="/app/products">Products API</a></li>
    </ul>
</body>
</html>
```

### Step 3: Implement Microservice Functionality

#### 3.1 REST Controller
The controller handles HTTP requests and returns responses.

#### 3.2 Model Classes
- **Product**: Represents product data structure

#### 3.3 API Endpoints
- `GET /app/` - Serves static HTML welcome page
- `GET /app/products` - Returns product list as JSON

### Step 4: Build Application JAR

#### 4.1 Maven Build Process
```bash
# Navigate to project directory
cd eStore

# Clean and package the application
./mvnw clean package

# Alternative: if mvnw is not executable
chmod +x mvnw
./mvnw clean package
```

#### 4.2 Verify JAR Creation
```bash
# Check target directory
ls -la target/
# Look for: estore-0.0.1-SNAPSHOT.jar
```

### Step 5: Understanding Docker Images

#### 5.1 Parent and Base Image Concepts

**Base Image**: The foundation layer of a Docker image, typically a minimal operating system (like Alpine Linux) or runtime environment (like OpenJDK). It's the lowest layer in the image hierarchy.

**Parent Image**: The image that your image is based on, specified in the `FROM` instruction. It can be a base image or another image built on top of a base image.

In our Dockerfile:
- **Parent Image**: `eclipse-temurin:21` - This is what we build upon
- **Base Image**: Inside `openjdk:21`, the base is typically a Linux distribution like Debian or Alpine

```dockerfile
# Parent Image: eclipse-temurin:21 contains JDK 21 and its dependencies
# Base Image: The underlying Linux OS (usually Debian/Alpine) that eclipse-temurin:21 is built on
FROM eclipse-temurin:21

# Our application layer is built on top of the parent image
# Creating an image hierarchy: Base OS -> JDK Runtime -> Our Application
```

**Image Layers Hierarchy**:
```
┌─────────────────────┐ ← Our eStore Application (Top Layer)
│  estore.jar         │
├─────────────────────┤ ← Application Layer
│  WORKDIR /app       │
│  COPY estore.jar    │
├─────────────────────┤ ← Parent Image Layer (eclipse-temurin:21)
│  OpenJDK 21         │
│  Java Runtime       │
├─────────────────────┤ ← Base Image Layer
│  Linux OS           │
│  (Debian/Alpine)    │
└─────────────────────┘
```

### Step 6: Docker Containerization

#### 6.1 Dockerfile Creation
Create optimized Dockerfile with detailed comments:

```dockerfile
# Use Eclipse Temurin 21 as base image for Spring Boot application
FROM eclipse-temurin:21

# Set metadata for the image
LABEL maintainer="student@example.com"
LABEL description="eStore Spring Boot Microservice"

# Create application directory
WORKDIR /app

# Define build argument for JAR file location
# This allows flexibility in specifying the JAR file path during build
ARG JAR_FILE=target/*.jar

# Copy the JAR file from target directory to container
# Rename it to a consistent name for easier management
COPY ${JAR_FILE} estore.jar

# Expose the port that the application runs on
# This documents which port the container listens on
EXPOSE 9090

# Define the command to run when container starts
# Use ENTRYPOINT for executable containers that always run the same command
ENTRYPOINT ["java", "-jar", "/app/estore.jar"]
```

#### 6.2 Build Docker Image
```bash
# Build image with tag
docker build -t estore:1.0 .

# Verify image creation
docker images estore
```

#### 6.3 Run Docker Container
```bash
# Run container with port mapping and detached mode
docker run --name estore -d -p 9090:9090 estore:1.0

# Verify container is running
docker ps

# Check container logs
docker logs estore
```


### Local Testing (Before Docker)
```bash
# Run Spring Boot application locally
./mvnw spring-boot:run

# Application runs on port 9090 as configured
# Test basic functionality:
curl http://localhost:9090/app/
```

### Container Testing
```bash
# Test products endpoint
curl http://localhost:9090/app/products

# Test products endpoint
curl http://localhost:9090/app/products

# Test static HTML page
open http://localhost:9090/app/
```

## Docker Commands Reference

| Command | Purpose |
|---------|---------|
| `docker build -t <name>:<tag> .` | Build image from Dockerfile |
| `docker run -d -p <host>:<container> <image>` | Run container with port mapping |
| `docker ps` | List running containers |
| `docker logs <container>` | View container logs |
| `docker stop <container>` | Stop running container |
| `docker rm <container>` | Remove stopped container |
| `docker rmi <image>` | Remove image |

## Common Issues and Solutions

### Build Failures
1. **Maven Build Issues**
   - Ensure Java 21 is installed
   - Check internet connectivity for dependencies
   - Verify `pom.xml` syntax
   - **Fixed Issue**: The generated `pom.xml` had an invalid `<artifactId>.</artifactId>` which has been corrected to `<artifactId>estore</artifactId>`

2. **Docker Build Issues**
   - Confirm JAR file exists in target directory
   - Check Dockerfile syntax
   - Verify base image availability

### Runtime Issues
1. **Port Conflicts**
   - Use different host port: `-p 8080:9090`
   - Check if port 9090 is already in use

2. **Container Startup Issues**
   - Check logs: `docker logs <container>`
   - Verify application.properties configuration
   - Ensure sufficient memory allocation

### Debugging Commands
```bash
# Access container shell for debugging
docker exec -it estore /bin/bash

# Check Java processes in container
docker exec estore ps aux

# Monitor container resource usage
docker stats estore
```

## Best Practices

### Spring Boot
- Use externalized configuration
- Implement proper logging
- Add health check endpoints
- Handle exceptions gracefully
- Use appropriate HTTP status codes

### Docker
- Use multi-stage builds for production
- Minimize image layers
- Use .dockerignore for build optimization
- Don't run as root user in production
- Use specific image tags, not `latest`

### Security Considerations
- Don't expose unnecessary ports
- Use environment variables for sensitive data
- Implement proper authentication/authorization
- Regular security updates for base images

## Learning Outcomes

After completing this lesson, students will:
- Understand Spring Boot microservice architecture
- Know how to create RESTful APIs with Spring Boot
- Be able to containerize Spring Boot applications
- Understand Docker port mapping and networking
- Have experience with Maven build processes
- Know debugging techniques for containerized applications

## Advanced Topics

### Multi-stage Docker Builds
```dockerfile
# Build stage
FROM eclipse-temurin:21 AS builder
WORKDIR /app
COPY pom.xml .
COPY mvnw .
COPY mvnw.cmd .
COPY .mvn .mvn
COPY src src
RUN ./mvnw package -DskipTests

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=builder /app/target/*jar estore.jar
ENTRYPOINT ["java", "-jar", "/app/estore.jar"]

```

### Environment Configuration
```bash
# Run with environment variables
docker run -d -p 9090:9090 \
  -e SERVER_PORT=9090 \
  -e SPRING_PROFILES_ACTIVE=docker \
  estore:1.0
```

### Health Checks
Add to Dockerfile:
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:9090/app/actuator/health || exit 1
```

## Next Steps
- Learn Docker Compose for multi-container applications
- Explore Spring Boot Actuator for monitoring
- Study microservice communication patterns
- Investigate container orchestration with Kubernetes
- Learn about CI/CD pipelines for containerized applications