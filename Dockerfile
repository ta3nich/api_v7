FROM node:16


# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r mysql && useradd -r -g mysql mysql

RUN apt-get update && apt-get install -y --no-install-recommends lsb-release  debian-keyring debian-archive-keyring gnupg dirmngr && rm -rf /var/lib/apt/lists/*


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
#apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 605C66F00D6C9793
#RUN wget https://storage.googleapis.com/tensorflow-serving-apt/tensorflow-serving.release.pub.gpg
#RUN  apt-key add tensorflow-serving.release.pub.gpg
#RUN set -ex; \
# gpg: key 5072E1F5: public key "MySQL Release Engineering <mysql-build@oss.oracle.com>" imported
   # key='A4A9406876FCBD3C456770C88C718D3B5072E1F5'; \
#    key='8C718D3B5072E1F5'; \
#    export GNUPGHOME="$(mktemp -d)"; \
#    gpg --keyserver keyserver.ubuntu.com --recv-keys "$key"; \
 #   gpg --export "$key" > /etc/apt/trusted.gpg.d/mysql.gpg; \
 #   rm -rf "$GNUPGHOME"; \
  #  apt-key list > /dev/null

#RUN  apt-key adv --keyserver keys.gnupg.net --recv-keys A4A9406876FCBD3C456770C88C718D3B5072E1F5
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8C718D3B5072E1F5
#RUN apt-key adv --keyserver hkp://pool.sks-keyservers.net:80 --recv-keys AA8E81B4331F7F50 && \
#    apt-key adv --keyserver hkp://pool.sks-keyservers.net:80 --recv-keys 7638D0442B90D010
#RUN  apt-key adv --keyserver pgp.mit.edu --recv-keys 467B942D3A79BD29
#RUN  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8C718D3B5072E1F5
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		bzip2 \
		openssl \
# FATAL ERROR: please install the following Perl modules before executing /usr/local/mysql/scripts/mysql_install_db:
# File::Basename
# File::Copy
# Sys::Hostname
# Data::Dumper
		perl \
		xz-utils \
		zstd \
	; \
	rm -rf /var/lib/apt/lists/*

RUN set -eux; \
# gpg: key 3A79BD29: public key "MySQL Release Engineering <mysql-build@oss.oracle.com>" imported
	key='859BE8D7C586F538430B19C2467B942D3A79BD29'; \
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key"; \
	mkdir -p /etc/apt/keyrings; \
	gpg --batch --export "$key" > /etc/apt/keyrings/mysql.gpg; \
	gpgconf --kill all; \
	rm -rf "$GNUPGHOME"

ENV MYSQL_MAJOR 8.0
ENV MYSQL_VERSION 8.0.31-1debian10

RUN echo 'deb [ signed-by=/etc/apt/keyrings/mysql.gpg ] http://repo.mysql.com/apt/debian/ buster mysql-8.0' > /etc/apt/sources.list.d/mysql.list
RUN { \
		echo mysql-community-server mysql-community-server/data-dir select ''; \
		echo mysql-community-server mysql-community-server/root-pass password ''; \
		echo mysql-community-server mysql-community-server/re-root-pass password ''; \
		echo mysql-community-server mysql-community-server/remove-test-db select false; \
	} | debconf-set-selections \
	&& apt-get update \
	&& apt-get install -y \
		mysql-community-client="${MYSQL_VERSION}" \
		mysql-community-server-core="${MYSQL_VERSION}" \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql /var/run/mysqld \
	&& chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
# ensure that /var/run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
	&& chmod 1777 /var/run/mysqld /var/lib/mysql

# COPY mysql_pubkey.asc mysql_pubkey.asc
VOLUME /var/lib/mysql

# Config files
COPY config/ /etc/mysql/
COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306 33060
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8C718D3B5072E1F5
#RUN apt-key adv --keyserver keys.gnupg.net --recv-keys 8C718D3B5072E1F5


#RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 467B942D3A79BD29
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 40976EAF437D05B5
#RUN  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
#RUN wget https://repo.mysql.com/mysql-apt-config_0.8.13-1_all.deb
#RUN  dpkg -i mysql-apt-config_0.8.13-1_all.deb
#RUN 
RUN uname -a
#RUN  wget https://dev.mysql.com/get/mysql-apt-config_0.8.22-1_all.deb
#RUN dpkg -i mysql-apt-config*
#ENV MYSQL_MAJOR=8.0
#ENV MYSQL_VERSION=8.0.30-1.el8
#RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 5072E1F5
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8C718D3B5072E1F5
#RUN  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 8C718D3B5072E1F5
#hkp://keyserver.ubuntu.com:80
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A4A9406876FCBD3C456770C88C718D3B5072E1F5
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 467B942D3A79BD29
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8C718D3B5072E1F5
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 467B942D3A79BD29
#RUN gpg --import mysql_pubkey.asc
#RUN gpg --fingerprint 5072E1F5
RUN lsb_release -a
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 467B942D3A79BD29
#RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 3A79BD29
#RUN echo "deb http://repo.mysql.com/apt/debian/ stretch mysql-${MYSQL_MAJOR}" > /etc/apt/sources.list.d/mysql.list
#RUN echo "deb https://repo.mysql.com/apt/ubuntu/ jammy mysql-8.0"  > /etc/apt/sources.list.d/mysql.list
#RUN wget -q -O - https://repo.mysql.com/RPM-GPG-KEY-mysql-2022 | apt-key add -
#RUN apt-get update && apt-get install -y mysql-server && rm -rf /var/lib/apt/lists/* 
#RUN apt-get update && apt-get install -y mysql-server="${MYSQL_VERSION}" && rm -rf /var/lib/apt/lists/*

# RUN { \
#         echo mysql-community-server mysql-community-server/data-dir select ''; \
#         echo mysql-community-server mysql-community-server/root-pass password '00110011'; \
#         echo mysql-community-server mysql-community-server/re-root-pass password '00110011'; \
#         echo mysql-community-server mysql-community-server/remove-test-db select false; \
#     } | debconf-set-selections \
#     && apt-get update && apt-get install -y mysql-server="${MYSQL_VERSION}" && rm -rf /var/lib/apt/lists/* \
#     && rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql /var/run/mysqld \
#     && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
# # ensure that /var/run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
#     && chmod 777 /var/run/mysqld \
# # comment out a few problematic configuration values
#     && find /etc/mysql/ -name '*.cnf' -print0 \
#         | xargs -0 grep -lZE '^(bind-address|log)' \
#         | xargs -rt -0 sed -Ei 's/^(bind-address|log)/#&/' \
# # dont reverse lookup hostnames, they are usually another container
#     && echo '[mysqld]\nskip-host-cache\nskip-name-resolve' > /etc/mysql/conf.d/docker.cnf



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
