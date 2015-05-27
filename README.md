#magento mysql docker

A basic image for docker+magento +mysql with sample data images such as [jackie/magento-mysql]
Usage
Basic Example

Git clone and cd into it

Please copy magento files and magento-sample-data-1.9.0.0 into this dir.

-magento/
-magento-sample-data-1.9.0.0/magento_sample_data_for_1.9.0.0.sql

```no-highlight
docker build -t=jackie/docker-magento-mysql .
```

Start your image binding host port 8080 to port 80 (Apache Web Server/HTTP) and 32815 to 3306 (MYSQL) in your container:

```no-highlight
docker run -d -p 8080:80 -p 32815:3306 jackie/docker-magento-mysql 
```
Get IP address by docker inspect container_id

Browse:IP address. eg: http://172.17.1.24


#Configuration

Complete the required information:

    Database Type: MySQL
    Host: localhost
    Database Name: magento
    User Name: magento
    User Password: the magento user password read from the logs (eg:ooVoh7aedael)
    Tables Prefix: (optional)

#Connecting to MySQL

The first time that you run your container, a new user admin with all privileges will be created in MySQL with a random password, a new user magento with sample data will also be created in MySQL with a random password. To get the password, check the logs of the container.

docker logs container_id

You will see some output like the following:

```no-highlight
========================================================================
You can now connect to this MySQL Server using:

    mysql -uadmin -p47nnf4FweaKu -h<host> -P<port>

Please remember to change the above password as soon as possible!
MySQL user 'root' has no password but only allows local connections
========================================================================
=> Waiting for confirmation of MySQL service startup
========================================================================

MySQL magento user password: ooVoh7aedael

========================================================================
```

In this case, 47nnf4FweaKu is the password allocated to the admin user.

Remember that the root user has no password but it's only accessible from within the container.

You can now test your deployment:

 mysql -u admin -p47nnf4FweaKu -h127.0.0.1 -P32815


