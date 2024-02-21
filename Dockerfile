# Stage 1: Build the application with Maven
FROM maven:3.8.4-openjdk-17 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven project file
COPY /demo/pom.xml .

# Download dependencies and build the application
RUN mvn dependency:go-offline

# Copy the entire project source
COPY /demo/src ./src

# Build the application
RUN mvn package -DskipTests

# Stage 2: Create the final image with the built .jar file
FROM openjdk:17

# Set the working directory inside the container
WORKDIR /app

# Copy the built .jar file from the previous stage
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

# Specify the entry point for the application
ENTRYPOINT ["java", "-jar", "app.jar"]