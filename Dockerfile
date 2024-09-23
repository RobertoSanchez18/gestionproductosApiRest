# Etapa 1: Construcción del artefacto
FROM maven:3.8.6-eclipse-temurin-17-alpine AS builder

# Crear el directorio de trabajo
WORKDIR /app

# Copiar el archivo pom.xml y las dependencias
COPY pom.xml .

# Descargar las dependencias sin compilar la aplicación
RUN mvn dependency:go-offline

# Copiar el resto del código fuente
COPY src ./src

# Construir el artefacto de la aplicación
RUN mvn clean package -DskipTests

# Etapa 2: Imagen mínima para ejecutar la aplicación
FROM eclipse-temurin:17-jre-alpine

# Crear un directorio para la aplicación
WORKDIR /app

# Copiar el JAR construido desde la etapa de construcción
COPY --from=builder /app/target/Gestion-de-productos-0.0.1-SNAPSHOT.jar /app/app.jar

# Exponer el puerto
EXPOSE 8080

# Comando para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
