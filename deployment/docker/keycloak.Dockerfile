# Maven build
FROM maven:3.8.6-jdk-11 AS MAVEN_TOOL_CHAIN
ARG VERSION
# COPY pom*.xml /tmp/
# This allows Docker to cache most of the maven dependencies
# COPY dockerize/settings-docker.xml /usr/share/maven/ref/
# RUN mvn -s /usr/share/maven/ref/settings-docker.xml dependency:resolve-plugins dependency:resolve dependency:go-offline -B
WORKDIR /keycloak/
COPY /keycloak /keycloak
# RUN mvn -s /usr/share/maven/ref/settings-docker.xml package -P default
RUN mvn -f pom.xml install

#FROM scratch AS export-stage
#ARG VERSION
#COPY --from=MAVEN_TOOL_CHAIN /tmp/target/tny-admin-${VERSION}.war .
