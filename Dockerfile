FROM node:16


# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r mysql && useradd -r -g mysql mysql

RUN apt-get update && apt-get install -y --no-install-recommends lsb-release  debian-keyring debian-archive-keyring gnupg dirmngr && rm -rf /var/lib/apt/lists/*
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y supervisor default-mysql-server
ADD ./etc/ /etc/
RUN mkdir /docker-entrypoint-initdb.d

RUN apt-get update && apt-get install -y --no-install-recommends \
        pwgen \
        openssl \
        perl \
    && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		bzip2 \
		openssl \
		perl \
		xz-utils \
		zstd \
	; \
	rm -rf /var/lib/apt/lists/*


ENV MYSQL_MAJOR 8.0
ENV MYSQL_VERSION 8.0.31-1debian10

RUN echo 'deb [ signed-by=/etc/apt/keyrings/mysql.gpg ] http://repo.mysql.com/apt/debian/ buster mysql-8.0' > /etc/apt/sources.list.d/mysql.list
# RUN { \
# 		echo mysql-community-server mysql-community-server/data-dir select ''; \
# 		echo mysql-community-server mysql-community-server/root-pass password ''; \
# 		echo mysql-community-server mysql-community-server/re-root-pass password ''; \
# 		echo mysql-community-server mysql-community-server/remove-test-db select false; \
# 	} | debconf-set-selections \
# 	&& apt-get update \
# 	&& apt-get install -y \
# 		mysql-community-client="${MYSQL_VERSION}" \
# 		mysql-community-server-core="${MYSQL_VERSION}" \
# 	&& rm -rf /var/lib/apt/lists/* \
# 	&& rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql /var/run/mysqld \
# 	&& chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
# 	&& chmod 1777 /var/run/mysqld /var/lib/mysql  \
#     && find /etc/mysql/ -name '*.cnf' -print0 \
#         | xargs -0 grep -lZE '^(bind-address|log)' \
#         | xargs -rt -0 sed -Ei 's/^(bind-address|log)/#&/' \
#     && echo '[mysqld]\nskip-host-cache\nskip-name-resolve' > /etc/mysql/conf.d/docker.cnf

# COPY mysql_pubkey.asc mysql_pubkey.asc
VOLUME /var/lib/mysql

# Config files
#COPY config/ /etc/mysql/
COPY my.cnf /etc/mysql/conf.d/my.cnf

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat

EXPOSE 3306 33060

RUN uname -a

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
RUN find /usr/src/app/ -name '*.sh' -exec chmod a+x {} +


EXPOSE 3000 3306 10000
ENTRYPOINT ["docker-entrypoint.sh"]

CMD [ "/usr/bin/supervisord", "-n" ]

#CMD [ "node", "server.js" ]
