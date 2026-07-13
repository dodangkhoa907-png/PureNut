# --- Giai đoạn 1: Build file .war bằng Maven ---
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

COPY pom.xml .
# Cache Maven dependencies trước khi copy source → build lại nhanh hơn
RUN mvn dependency:go-offline -B
COPY src ./src

# Build .war (skip tests)
RUN mvn clean package -DskipTests

# --- Giai đoạn 2: Chạy ứng dụng trên Tomcat ---
FROM tomcat:10.1-jdk21

# Xóa app mặc định
RUN rm -rf /usr/local/tomcat/webapps/*

# Đổi port sang 8081
RUN sed -i 's/port="8080"/port="8081"/' /usr/local/tomcat/conf/server.xml

# Deploy .war
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# JVM tuning cho Render free tier (512MB RAM)
ENV JAVA_OPTS="-Xms128m -Xmx384m -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -XX:+UseStringDeduplication -Djava.security.egd=file:/dev/urandom"
ENV CATALINA_OPTS="${JAVA_OPTS}"

EXPOSE 8081

CMD ["catalina.sh", "run"]
