FROM eclipse-temurin:21

LABEL maintainer="student@example.com"
LABEL description="eStore Spring Boot Microservice"
LABEL version="1.0"

WORKDIR /app

ARG JAR_FILE=target/*.jar

COPY ${JAR_FILE} estore.jar

EXPOSE 9090

ENTRYPOINT ["java", "-jar", "/app/estore.jar"]