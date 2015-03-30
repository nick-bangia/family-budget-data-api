# Family Budget Data API
RESTful API to expose family budgeting data services for consumption

## Dependencies
This API required the following dependencies:
* APIServer ( npm install apiserver )
* MySQL ( npm install mysql )
* Forever ( npm install forever -g )

## Installation
You can install this web API by following the steps below:
1. Copy source files to /var/www/family-budget-api
2. Install MySQL and run the SQL script in resources/ as root to create the database
3. Update the Credentials SQL script in resources/ to change your username and password. Also change $host to your server's hostname
4. Run the Credentials SQL script to create the user & apply necessary grants
5. Log in to MySQL using new credentials and verify that you can make a SELECT statement
6. Update the dbCredentials.json file in /config to use the newly created user & password
7. Copy the family-budget-api init.d script in /resources to /etc/init.d/
8. Reboot by executing sudo reboot
9. Verify that the service is up and running on the port you selected in /config/server.json

