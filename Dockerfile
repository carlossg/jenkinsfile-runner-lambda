FROM lambci/lambda-base:build as build

# Install the jdk
# https://github.com/lambci/lambci/blob/master/home/init/java

ARG OPENJDK_VERSION=1.8
# For some reason, libjvm.so needs to be physically present
# Can't symlink it, have to copy, but everything else can be symlinks
RUN curl -sSL https://lambci.s3.amazonaws.com/binaries/java-${OPENJDK_VERSION}.0-openjdk-devel.tgz | tar -xz -C /opt && \
  export JAVA_HOME=$(echo /opt/usr/lib/jvm/java-${OPENJDK_VERSION}.0-openjdk-${OPENJDK_VERSION}*) && \
  cp -as /usr/lib/jvm/java-${OPENJDK_VERSION}*/jre $JAVA_HOME/ && \
  rm $JAVA_HOME/jre/lib/amd64/server/libjvm.so && \
  cp /usr/lib/jvm/java-${OPENJDK_VERSION}*/jre/lib/amd64/server/libjvm.so $JAVA_HOME/jre/lib/amd64/server/


# Install git in /opt
# https://github.com/lambci/lambci/blob/master/build/git/Dockerfile
ARG GIT_VERSION=2.20.0

ENV NO_GETTEXT=1 NO_PERL=1 NO_TCLTK=1 NO_PYTHON=1 INSTALL_SYMLINKS=1

RUN curl https://mirrors.edge.kernel.org/pub/software/scm/git/git-${GIT_VERSION}.tar.xz | tar -xJ && \
  cd git-${GIT_VERSION} && \
  make prefix=/opt && \
  make prefix=/opt strip && \
  make prefix=/opt install && \
  rm -rf /opt/share/git-core/templates/*

RUN cd /opt && \
  find . ! -perm -o=r -exec chmod +400 {} \; && \
  zip -yr /tmp/git-${GIT_VERSION}.zip ./*

# Install maven
FROM maven:alpine as maven
RUN mkdir -p /opt/bin && mv /usr/share/maven /opt/maven && ln -s /opt/maven/bin/mvn /opt/bin/mvn

# Package jenkinsfile runner and plugins
FROM csanchez/jenkinsfile-runner:1.0-beta-6-2.150.2 as jenkinsfile-runner
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
# workaround https://github.com/jenkinsci/docker/pull/587
RUN mkdir /usr/share/jenkins/ref/plugins/tmp.lock && \
  /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Build final image
FROM lambci/lambda:java8
USER root
COPY --from=build /opt /opt
COPY --from=maven /opt /opt
COPY --from=jenkinsfile-runner /app /opt
COPY --from=jenkinsfile-runner /usr/share/jenkins/ref/plugins /opt/plugins

ENTRYPOINT ["/opt/bin/jenkinsfile-runner", \
            "-w", "/app/jenkins",\
            "-p", "/app/plugins",\
            "-f", "/workspace"]
