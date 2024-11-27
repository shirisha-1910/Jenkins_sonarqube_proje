# Stage 1: Build the project using Gradle with JDK 11
FROM gradle:7.4-jdk11 AS build

# Set the working directory inside the container
WORKDIR /project

# Copy the local project files into the container
COPY . /project

# Run Gradle build (this will compile your Java code)
RUN gradle build --no-daemon --no-parallel --debug

# Stage 2: Use a distroless image for the runtime
FROM gcr.io/distroless/java11

# Set the working directory inside the runtime container
WORKDIR /app

# Copy the built artifact (e.g., a JAR file) from the build stage
COPY --from=build /project/build/libs/*.jar /app/

# Expose the port the application will run on
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]

