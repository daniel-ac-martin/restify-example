FROM quay.io/ukhomeofficedigital/nodejs-base:v6

RUN yum install nmap-ncat java-1.8.0-openjdk-headless -y -q

USER nodejs
WORKDIR /app
ENV NODE_ENV production

RUN curl https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/4.2.0/flyway-commandline-4.2.0.tar.gz | tar -xz \
 && mv flyway-4.2.0/ flyway/

COPY sql/ /app/flyway/sql/
COPY entrypoint.sh /app/
COPY package.json /app/
RUN npm install --only production > .npm-install.log 2>&1 \
 && rm .npm-install.log \
 || ( EC=$?; cat .npm-install.log; exit $EC )
COPY src/ /app/src/
COPY config.js /app/

USER root
RUN yum clean -q all \
 && yum update -y -q \
 && yum clean -q all \
 && rpm --rebuilddb --quiet \
 && chown -R nodejs:nodejs .

USER nodejs
CMD ["./entrypoint.sh"]