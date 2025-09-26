# syntax=docker/dockerfile:1

FROM gradle:8.10-jdk21 AS builder
WORKDIR /home/gradle/project
COPY . .
RUN ./gradlew clean bootJar --no-daemon \
    && JAR_FILE=$(ls build/libs | grep -E '\\.jar$' | grep -v 'plain') \
    && cp build/libs/$JAR_FILE app.jar

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=builder /home/gradle/project/app.jar app.jar
COPY --from=builder /home/gradle/project/uploads ./uploads
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
