# --- Giai đoạn 1: Build ứng dụng Java (Maven) ---
# Sử dụng một image có sẵn Maven và JDK 21
FROM maven:3.9-eclipse-temurin-21-alpine AS build
# Đặt thư mục làm việc bên trong container của giai đoạn build
WORKDIR /app

# Sao chép file pom.xml trước để Docker có thể tận dụng cache
# Nếu bạn có các thư mục con khác chứa file cấu hình Maven (ví dụ: .mvn, profiles.xml), hãy sao chép chúng ở đây
COPY pom.xml ./

# Sao chép toàn bộ mã nguồn của dự án vào thư mục làm việc
# Đảm bảo bạn đã có thư mục 'src' trong repository của mình
COPY src ./src

# Chạy lệnh Maven để build project. Lệnh này sẽ tạo ra file .war trong thư mục target.
# "-DskipTests" giúp bỏ qua việc chạy các bài kiểm tra, làm quá trình build nhanh hơn.
RUN mvn clean package -DskipTests

# --- Giai đoạn 2: Tạo image Tomcat cuối cùng ---
# Sử dụng image Tomcat làm base cho image cuối cùng
FROM tomcat:11.0.8-jdk21-temurin-noble

# Đặt tác giả (tùy chọn)
LABEL maintainer="Kien Tran <muadongberlin123@gmail.com>"

# Xóa các ứng dụng mặc định có sẵn trong thư mục webapps của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Đặt biến môi trường để JVM và Tomcat sử dụng UTF-8
ENV JAVA_OPTS="-Dfile.encoding=UTF-8 -Dclient.encoding.override=UTF-8 -Ddefault.client.encoding=UTF-8"

# Sao chép file WAR đã được build từ giai đoạn 'build' vào thư mục webapps của Tomcat
# /app/target/Aishiba-1.0-SNAPSHOT.war là đường dẫn của file .war trong giai đoạn 'build'
COPY --from=build /app/target/Aishiba-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/Aishiba.war

# Mở port mà Tomcat sẽ lắng nghe
EXPOSE 8080

# Lệnh mặc định để khởi chạy Tomcat
CMD ["catalina.sh", "run"]