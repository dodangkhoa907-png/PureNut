# --- Giai đoạn 1: Build file .war bằng Maven ---
# Dùng ảnh chứa Maven và JDK mới nhất (tương thích ngược với mã của bạn)
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Copy file cấu hình maven và source code vào
COPY pom.xml .
COPY src ./src

# Chạy lệnh build ra file .war (bỏ qua test để build nhanh hơn)
RUN mvn clean package -DskipTests

# --- Giai đoạn 2: Chạy ứng dụng trên Tomcat ---
# Dùng Tomcat 10 (hỗ trợ tốt các bản JDK mới)
FROM tomcat:10.1-jdk21

# Xóa sạch các app rác của Tomcat mặc định
RUN rm -rf /usr/local/tomcat/webapps/*

# Đổi cổng mặc định của Tomcat từ 8080 sang 8081
RUN sed -i 's/port="8080"/port="8081"/' /usr/local/tomcat/conf/server.xml

# Lấy file .war vừa build ở bước 1, đổi tên thành ROOT.war để chạy thẳng trang chủ
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Mở cổng 8081
EXPOSE 8081

# Lệnh khởi động Tomcat
CMD ["catalina.sh", "run"]