# magento mysql docker
A basic  image for docker magento mysql images such as [jackie/magento-mysql]

## Usage

### Basic Example
Git clone and cd into it

docker build -t=jackie/docker-magento-mysql .

Start your image binding host port 8080 to port 80 (Apache Web Server/HTTP) and 3306 to 3306 (MYSQL) in your container:

    sudo docker run -d -p 80 -p 3306 jackie/docker-magento-mysql 

## Administration

### Connecting to MySQL
The first time that you run your container, a new user admin with all privileges will be created in MySQL with a random password. To get the password, check the logs of the container. 

    sudo docker logs <container_id>
    
You will see some output like the following:

    ===================================================================
    You can now connect to this MySQL Server using:

        mysql -u admin -p47nnf4FweaKu -h<host> -P<port>

    Please remember to change the above password as soon as possible!
    MySQL user 'root' has no password but only allows local connections
    ===================================================================


In this case, `47nnf4FweaKu` is the password allocated to the `admin` user.

Remember that the `root` user has no password but it's only accessible from within the container.

You can now test your deployment:

     mysql -u admin -p47nnf4FweaKu -h127.0.0.1 -P3306


