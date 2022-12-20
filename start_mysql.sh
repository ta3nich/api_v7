service mysql start
#echo "=> Creating MySQL user ${MYSQL_USER} with ${_word} password"
#mysql -uroot -pPwd123 mysql -e "source last_sql.sql" k
#echo "CREATE USER 'root'@'localhost'" | mysql -u root
# ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';.

#mysql -uroot -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '$PASS'"https://api-lrr9.onrender.com
#mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%' WITH GRANT OPTION"
mysql -uroot -e "create database b0t"
mysql -uroot -pPwd123 b0t < /usr/src/app/all.sql

mysql -uroot -e "CREATE USER 'rooti'@'%' IDENTIFIED WITH  BY 'Pwd123'"
mysql -uroot -e "GRANT ALL ON *.* TO 'rooti'@'%'"
#mysql -uroot -pPwd123 mysql -e "source last_sql.sql"
mysql -uroot -e "CREATE USER 'monty'@'127.0.0.1' IDENTIFIED BY 'Pwd123'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'monty'@'127.0.0.1' WITH GRANT OPTION "
mysql -uroot -e "GRANT ALL ON *.* TO root@'%' IDENTIFIED BY 'Pwd123' WITH GRANT OPTION; FLUSH PRIVILEGES"
#mysql -uroot -pPwd123 mysql -e "source last_sql.sql"
echo "=> Done!"
