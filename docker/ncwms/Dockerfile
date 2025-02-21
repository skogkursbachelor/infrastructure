FROM ubuntu:25.04
LABEL authors="erbj"

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    default-jdk \
    sudo \
    unzip && \
    apt-get clean

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV CATALINA_HOME=/opt/tomcat
ENV PATH="$CATALINA_HOME/bin:$PATH"

# Create tomcat user and group
RUN groupadd tomcat && \
    useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat

# Download and extract Tomcat
WORKDIR /tmp
ADD https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.100/bin/apache-tomcat-9.0.100.tar.gz /tmp/apache-tomcat-9.0.100.tar.gz
RUN mkdir -p /opt/tomcat && \
    tar xzvf apache-tomcat-9.0.100.tar.gz -C /opt/tomcat --strip-components=1

# Set permissions and configure Tomcat
WORKDIR /opt/tomcat
RUN chgrp -R tomcat /opt/tomcat && \
    chmod -R g+r conf && \
    chmod g+x conf && \
    chown -R tomcat webapps/ work/ temp/ logs/ && \
    sed -i 's/port="8080"/port="3030"/' /opt/tomcat/conf/server.xml

# Expose port
EXPOSE 3030

# Download and unzip Copernicus data
WORKDIR /opt/tomcat
ADD https://swift.skyhigh.iik.ntnu.no/swift/v1/c93026420d2d49c69ac937edda870119/copernicus_historical_public/2014_2019.zip /opt/tomcat/2014_2019.zip
ADD https://swift.skyhigh.iik.ntnu.no/swift/v1/c93026420d2d49c69ac937edda870119/copernicus_historical_public/2019_2024.zip /opt/tomcat/2019_2024.zip
RUN mkdir -p copernicus && \
    unzip 2014_2019.zip -d copernicus/ && \
    unzip 2019_2024.zip -d copernicus/ && \
    rm -r copernicus/__MACOSX/ && \
    rm 2014_2019.zip 2019_2024.zip && \
    mv copernicus/2014_2019/* copernicus/ && \
    mv copernicus/2019_2024/* copernicus/ && \
    rm -r copernicus/2014_2019/ copernicus/2019_2024/

# Download ncWMS
WORKDIR /opt/tomcat/webapps
ADD https://swift.skyhigh.iik.ntnu.no/swift/v1/c93026420d2d49c69ac937edda870119/copernicus_historical_public/ncWMS2.war /opt/tomcat/webapps/ncWMS2.war

# Add tomcat-user.xml
WORKDIR /opt/tomcat/conf
COPY tomcat-users.xml /opt/tomcat/conf/tomcat-users.xml

# Start Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
