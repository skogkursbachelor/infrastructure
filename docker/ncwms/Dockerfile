FROM ubuntu:latest
LABEL authors="erbj"

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    default-jdk \
    sudo \
    unzip

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV CATALINA_HOME=/opt/tomcat
ENV PATH="$CATALINA_HOME/bin:$PATH"

# Create tomcat user and group
RUN groupadd tomcat && \
    useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat

# Download and extract Tomcat
WORKDIR /tmp
RUN curl -O https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.100/bin/apache-tomcat-9.0.100.tar.gz && \
    mkdir -p /opt/tomcat && \
    tar xzvf apache-tomcat-9.0.100.tar.gz -C /opt/tomcat --strip-components=1

# Set permissions
WORKDIR /opt/tomcat
RUN chgrp -R tomcat /opt/tomcat && \
    chmod -R g+r conf && \
    chmod g+x conf && \
    chown -R tomcat webapps/ work/ temp/ logs/

# Change Tomcat port to 3030
RUN sed -i 's/port="8080"/port="3030"/' /opt/tomcat/conf/server.xml

# Expose port
EXPOSE 3030

# Download and unzip Copernicus data
WORKDIR /opt/tomcat
RUN mkdir -p copernicus && \
    curl -O https://swift.skyhigh.iik.ntnu.no/swift/v1/c93026420d2d49c69ac937edda870119/copernicus_historical_public/2014_2019.zip && \
    curl -O https://swift.skyhigh.iik.ntnu.no/swift/v1/c93026420d2d49c69ac937edda870119/copernicus_historical_public/2019_2024.zip && \
    unzip 2014_2019.zip -d copernicus/ && \
    unzip 2019_2024.zip -d copernicus/ && \
    rm -r copernicus/__MACOSX/ && \
    rm 2014_2019.zip 2019_2024.zip && \
    mv copernicus/2014_2019/* copernicus/ && \
    mv copernicus/2019_2024/* copernicus/ && \
    rm -r copernicus/2014_2019/ copernicus/2019_2024/

# Download ncWMS
WORKDIR /opt/tomcat/webapps
RUN curl -O https://swift.skyhigh.iik.ntnu.no/swift/v1/c93026420d2d49c69ac937edda870119/copernicus_historical_public/ncWMS2.war

# Add tomcat-user.xml
WORKDIR /opt/tomcat/conf
COPY tomcat-users.xml /opt/tomcat/conf/tomcat-users.xml

# Start Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
