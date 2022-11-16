service mysql start
#echo "=> Creating MySQL user ${MYSQL_USER} with ${_word} password"
#mysql -uroot -pPwd123 mysql -e "source last_sql.sql"
#echo "CREATE USER 'root'@'localhost'" | mysql -u root


#mysql -uroot -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '$PASS'"
#mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%' WITH GRANT OPTION"
mysql -uroot -e "CREATE USER 'root'@'%' IDENTIFIED BY 'Pwd123'"
mysql -uroot -e "GRANT ALL ON *.* TO 'root'@'%'"
mysql -uroot -pPwd123 mysql -e "source last_sql.sql"
mysql -uroot -e "CREATE USER 'monty'@'127.0.0.1' IDENTIFIED BY 'Pwd123'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'monty'@'127.0.0.1' WITH GRANT OPTION "
mysql -uroot -e "GRANT ALL ON *.* TO root@'%' IDENTIFIED BY 'Pwd123' WITH GRANT OPTION; FLUSH PRIVILEGES"
#mysql -uroot -pPwd123 mysql -e "source last_sql.sql"
echo "=> Done!"
