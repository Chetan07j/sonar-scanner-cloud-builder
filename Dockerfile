FROM alpine:3.10

LABEL maintainer "Chetan Patil (chetan0779@gmail)"

ARG SONARQUBE_SCANNER_CLI_VERSION="4.4.0.2170"

ENV SONARQUBE_SCANNER_HOME /opt/sonar-scanner-${SONARQUBE_SCANNER_CLI_VERSION}-linux
ENV SONARQUBE_SCANNER_BIN ${SONARQUBE_SCANNER_HOME}/bin
ENV SONAR_SCANNER_CLI_DOWNLOAD_URL "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONARQUBE_SCANNER_CLI_VERSION}-linux.zip"

RUN apk update \
	&& apk upgrade \
	&& apk add ca-certificates \
	&& update-ca-certificates \
	&& apk add --update openjdk8-jre tzdata curl unzip bash \
	&& apk add --update nodejs npm \
	&& rm -rf /var/cache/apk/* \
    && mkdir -p /tmp/sonar-scanner  \
	&& curl -L --silent ${SONAR_SCANNER_CLI_DOWNLOAD_URL} >  /tmp/sonar-scanner/sonar-scanner-cli-${SONARQUBE_SCANNER_CLI_VERSION}-linux.zip  \
	&& mkdir -p /opt && chmod -R 777 /opt \
	&& unzip /tmp/sonar-scanner/sonar-scanner-cli-${SONARQUBE_SCANNER_CLI_VERSION}-linux.zip -d /opt  \
	&& rm -rf /tmp/sonar-scanner


ENV PATH $PATH:$SONARQUBE_SCANNER_BIN

RUN sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' $SONARQUBE_SCANNER_BIN/sonar-scanner

WORKDIR ${SONARQUBE_SCANNER_HOME}
