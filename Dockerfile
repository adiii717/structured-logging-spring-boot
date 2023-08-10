# Use an official Maven image as the base image
FROM maven:3.8.4-openjdk-11 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the project's pom.xml to the container
COPY pom.xml .

# Download the project dependencies
RUN mvn dependency:go-offline

# Copy the project source code to the container
COPY src/ /app/src/

# Build the application
RUN mvn clean install

# Create a new Docker image with a JRE base image
FROM openjdk:11-jre-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the compiled application from the build image
COPY --from=build /app/target/structured-logging-demo-*.jar /app/structured-logging-demo.jar

# Define the command to run the application
CMD ["java", "-jar", "structured-logging-demo.jar"]
