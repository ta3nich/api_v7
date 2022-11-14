FROM node:16

COPY my.cnf /etc/mysql/conf.d/my.cnf
COPY mysqld_charset.cnf /etc/mysql/conf.d/mysqld_charset.cnf


#RUN apt-get update && \
  #DEBIAN_FRONTEND=noninteractive apt-get -yq install mysql-server
#RUN apt-get update
#RUN apt-get install -y apt-transport-https
#RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN cat /etc/apt/sources.list
RUN uname -a
RUN apt-get update 
#&& apt-get install -y mariadb-server 

# MySQL
ENV MYSQL_PWD Pwd123
RUN echo "mysql-server mysql-server/root_password password $MYSQL_PWD" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password $MYSQL_PWD" | debconf-set-selections
RUN apt-get -y install mariadb-server  pwgen && \
    rm -rf /var/lib/apt/lists/* && \
    cp /etc/mysql/my.cnf /usr/share/mysql/my-default.cnf && \
    mysql_install_db > /dev/null 2>&1  && \
    touch /var/lib/mysql/.EMPTY_DB
    
    #&& \
    #if [ ! -f /usr/share/mysql/my-default.cnf ] ; then cp /etc/mysql/my.cnf /usr/share/mysql/my-default.cnf; fi && \
   # mysql_install_db > /dev/null 2>&1 && \
   # touch /var/lib/mysql/.EMPTY_DB
# MySQL

#ENV MYSQL_PWD Pwd123
#RUN echo "mysql-server mysql-server/root_password password $MYSQL_PWD" | debconf-set-selections
#RUN echo "mysql-server mysql-server/root_password_again password $MYSQL_PWD" | debconf-set-selections
#RUN apt-get -y install mysql-server
COPY import_sql.sh /import_sql.sh
COPY run.sh /run.sh

ENV MYSQL_USER=admin \
    MYSQL_PASS=Pwd123321 \
    ON_CREATE_DB=**False** \
    REPLICATION_MASTER=**False** \
    REPLICATION_SLAVE=**False** \
    REPLICATION_USER=replica \
    REPLICATION_PASS=replica \
    ON_CREATE_DB=**False**

# Add VOLUMEs to allow backup of config and databases
VOLUME  ["/etc/mysql", "/var/lib/mysql"]

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

EXPOSE 3000 3306
#EXPOSE 3306
#/usr/src/app
RUN find /usr/src/app/ -name '*.sh' -exec chmod a+x {} +
#RUN /usr/src/app/run.sh



CMD ["/run.sh"]
RUN update-rc.d mysql enable
RUN service mysql start

CMD [ "service","mysql","restart","&&","node", "server.js" ]


#CMD [  ]
