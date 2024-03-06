# Використовуємо офіційний образ Maven з Java 17 для збірки проекту
FROM maven:3.8.5-openjdk-17 as build

# Встановлюємо робочу директорію у контейнері для збірки
WORKDIR /app

# Копіюємо файл pom.xml та джерельний код проекту
COPY pom.xml /app/
COPY src /app/src/

# Виконуємо збірку проекту
RUN mvn clean package -DskipTests

# Використовуємо базовий образ OpenJDK для запуску
FROM openjdk:17

# Встановлюємо робочу директорію у контейнері для запуску
WORKDIR /app

# Копіюємо виконуваний JAR файл з попереднього етапу збірки
COPY --from=build /app/target/neovision_server-0.0.1-SNAPSHOT.jar .

# Відкриваємо порт 8080
EXPOSE 8080

# Запускаємо JAR файл
ENTRYPOINT ["java", "-jar", "neovision_server-0.0.1-SNAPSHOT.jar"]
