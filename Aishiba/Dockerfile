From tomcat:11.0.8-jdk21-temurin-noble

# Đặt tác giả (tùy chọn)
LABEL maintainer="Kien Tran <muadongberlin123@gmail.com>"

# 2. Xóa các ứng dụng mặc định có sẵn trong thư mục webapps của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Đặt biến môi trường để JVM và Tomcat sử dụng UTF-8
ENV JAVA_OPTS="-Dfile.encoding=UTF-8 -Dclient.encoding.override=UTF-8 -Ddefault.client.encoding=UTF-8"

# 3. Copy WAR của bạn vào container với tên mong muốn là Aishiba.war
COPY target/Aishiba-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/Aishiba.war

# Mở port mà Tomcat sẽ lắng nghe
EXPOSE 8080

# Lệnh mặc định để khởi chạy Tomcat
# Lệnh này thường là mặc định của image tomcat base, không cần phải viết lại
# Tuy nhiên, việc có nó ở đây cũng không gây hại.
CMD ["catalina.sh", "run"]