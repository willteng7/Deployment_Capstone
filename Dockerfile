FROM eclipse-temurin:21

LABEL maintainer="willteng@example.com"
LABEL description="Spring Boot app for Deployment Capstone"
LABEL version="1.0"

WORKDIR /app

ARG JAR_FILE=target/*.jar

COPY ${JAR_FILE} estore.jar

EXPOSE 9090

ENTRYPOINT ["java", "-jar", "/app/estore.jar"]