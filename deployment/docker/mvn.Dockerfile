# Maven build
FROM maven:3.8.1-openjdk-17-slim AS MAVEN_TOOL_CHAIN
COPY pom*.xml /tmp/
COPY settings-docker.xml /usr/share/maven/ref/
WORKDIR /tmp/
# This allows Docker to cache most of the maven dependencies
RUN mvn -s /usr/share/maven/ref/settings-docker.xml dependency:resolve-plugins dependency:resolve dependency:go-offline -B
COPY src /tmp/src/
#RUN mvn -s /usr/share/maven/ref/settings-docker.xml package -P default
ENTRYPOINT ["sleep", "infinity"]