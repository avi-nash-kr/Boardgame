FROM maven:3-eclipse-temurin-17 AS build
WORKDIR /app

COPY pom.xml .
RUN mvn -B -q -DskipTests dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

# Runtime stage — use JRE image (Alpine has no Java)
FROM eclipse-temurin:17-jre-alpine

COPY --from=build /app/target/*.jar ./app.jar
EXPOSE 8085
ENTRYPOINT ["java", "-jar", "app.jar"]