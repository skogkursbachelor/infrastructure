FROM tomcat:9
LABEL authors="erbj"

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    unzip && \
    apt-get clean

# To resolve ERROR uk.ac.rdg.resc.edal.catalogue.DataCatalogue - Problem adding features to cache
ENV JAVA_OPTS="--add-opens java.base/java.util.concurrent.locks=ALL-UNNAMED"

# Change Tomcat port to 3030
RUN sed -i 's/port="8080"/port="3030"/' /usr/local/tomcat/conf/server.xml
EXPOSE 3030

# Download and unzip Copernicus data
ADD https://swift.skyhigh.iik.ntnu.no/swift/v1/c93026420d2d49c69ac937edda870119/copernicus_historical_public/2014_2019.zip /usr/local/tomcat/2014_2019.zip
ADD https://swift.skyhigh.iik.ntnu.no/swift/v1/c93026420d2d49c69ac937edda870119/copernicus_historical_public/2019_2024.zip /usr/local/tomcat/2019_2024.zip
WORKDIR /usr/local/tomcat
RUN mkdir -p copernicus && \
    unzip 2014_2019.zip -d copernicus/ && \
    unzip 2019_2024.zip -d copernicus/ && \
    rm -r copernicus/__MACOSX/ && \
    rm 2014_2019.zip 2019_2024.zip && \
    mv copernicus/2014_2019/* copernicus/ && \
    mv copernicus/2019_2024/* copernicus/ && \
    rm -r copernicus/2014_2019/ copernicus/2019_2024/

# Download ncWMS
WORKDIR /usr/local/tomcat/webapps
ADD https://swift.skyhigh.iik.ntnu.no/swift/v1/c93026420d2d49c69ac937edda870119/copernicus_historical_public/ncWMS2.war /usr/local/tomcat/webapps/ncWMS2.war

# Add tomcat-user.xml
WORKDIR /usr/local/tomcat/conf
COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml

# Start Tomcat
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]
