#!/bin/bash

VOLUME_HOME="/var/lib/mysql"
SAMPLE_DATA_FILE="/magento_sample_data_for_1.9.0.0.sql"

sed -ri -e "s/^upload_max_filesize.*/upload_max_filesize = ${PHP_UPLOAD_MAX_FILESIZE}/" \
    -e "s/^post_max_size.*/post_max_size = ${PHP_POST_MAX_SIZE}/" /etc/php5/apache2/php.ini
if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
    echo "=> Installing MySQL ..."
    mysql_install_db > /dev/null 2>&1
    echo "=> Done!"  
    /create_mysql_admin_user.sh
else
    echo "=> Using an existing volume of MySQL"
fi

# Create the magento database if it doesn't exist. 
if [[ ! -d $VOLUME_HOME/magento ]]; then

    # Start MySQL
    /usr/bin/mysqld_safe > /dev/null 2>&1 &

    RET=1
    while [[ RET -ne 0 ]]; do
        echo "=> Waiting for confirmation of MySQL service startup"
        sleep 5
        mysql -uroot -e "status" > /dev/null 2>&1
        RET=$?
    done

    # Generate a random password for the magento MySQL user.
    MAGENTO_PASSWORD=`pwgen -c -n -1 12`

    echo "========================================================================"
    echo
    echo "MySQL magento user password:" $MAGENTO_PASSWORD
    echo
    echo "========================================================================"

    # Create the database
    mysql -uroot -e \
        "CREATE DATABASE magento; \
         GRANT ALL PRIVILEGES ON magento.* TO 'magento'@'localhost' \
         IDENTIFIED BY '$MAGENTO_PASSWORD'; \
         FLUSH PRIVILEGES;"
    echo "Initializing the database with sample data"
    mysql -uroot -e \
         "use magento; \
          source /magento_sample_data_for_1.9.0.0.sql;"
	if [ $? -ne 0 ] ; then
		echo >&2 "Couldn't initialize the DB. Ensure proper permissions have been given"
		exit 1
	fi
    echo "database with sample data completed"
    mysqladmin -uroot shutdown
    sleep 5
fi

exec supervisord -n
