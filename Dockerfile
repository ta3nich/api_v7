FROM node:16


# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r mysql && useradd -r -g mysql mysql

RUN apt-get update && apt-get install -y --no-install-recommends gnupg dirmngr && rm -rf /var/lib/apt/lists/*


RUN mkdir /docker-entrypoint-initdb.d

RUN apt-get update && apt-get install -y --no-install-recommends \
# for MYSQL_RANDOM_ROOT_PASSWORD
        pwgen \
# for mysql_ssl_rsa_setup
        openssl \
# FATAL ERROR: please install the following Perl modules before executing /usr/local/mysql/scripts/mysql_install_db:
# File::Basename
# File::Copy
# Sys::Hostname
# Data::Dumper
        perl \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex; \
# gpg: key 5072E1F5: public key "MySQL Release Engineering <mysql-build@oss.oracle.com>" imported
    key='A4A9406876FCBD3C456770C88C718D3B5072E1F5'; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys "$key"; \
    gpg --export "$key" > /etc/apt/trusted.gpg.d/mysql.gpg; \
    rm -rf "$GNUPGHOME"; \
    apt-key list > /dev/null

ENV MYSQL_MAJOR=8.0
ENV MYSQL_VERSION=8.0.30-1.el8


RUN echo "deb http://repo.mysql.com/apt/debian/ stretch mysql-${MYSQL_MAJOR}" > /etc/apt/sources.list.d/mysql.list


RUN { \
        echo mysql-community-server mysql-community-server/data-dir select ''; \
        echo mysql-community-server mysql-community-server/root-pass password '00110011'; \
        echo mysql-community-server mysql-community-server/re-root-pass password '00110011'; \
        echo mysql-community-server mysql-community-server/remove-test-db select false; \
    } | debconf-set-selections \
    && apt-get update && apt-get install -y mysql-server="${MYSQL_VERSION}" && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql /var/run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
# ensure that /var/run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
    && chmod 777 /var/run/mysqld \
# comment out a few problematic configuration values
    && find /etc/mysql/ -name '*.cnf' -print0 \
        | xargs -0 grep -lZE '^(bind-address|log)' \
        | xargs -rt -0 sed -Ei 's/^(bind-address|log)/#&/' \
# dont reverse lookup hostnames, they are usually another container
    && echo '[mysqld]\nskip-host-cache\nskip-name-resolve' > /etc/mysql/conf.d/docker.cnf



# Install required packages ko4
#RUN apt-get update
#RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python
#RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source .
COPY . .

EXPOSE 3000 3306 10000


CMD [ "node", "server.js" ]