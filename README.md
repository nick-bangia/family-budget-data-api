# Family Budget Data API
RESTful API to expose family budgeting data services for consumption

## Dependencies
This API requires the following dependencies:
* APIServer ( `npm install apiserver` )
* MySQL ( `npm install mysql` )
* Forever ( Global Install in order to run it on a server *forever*. Install with `npm install forever -g` )
* random-js ( `npm install random-js` )
* underscore ( `npm install underscore` )

## Dev-Dependencies
If developing and/or testing, the following dependencies are required:
* Mocha ( `npm install mocha` )
* Chai ( `npm install chai` )
* Request ( `npm install request` )

## Installation
You can install this web API by following the steps below:

1. Get the URL for the g-zipped tarball version that you are interested in (located at `./releases/` in the GitHub repository)

2. Run `npm install [url]` for the URL above in the directory of your choice (`/var/www`) is good for production use. 
  * If interested in only production use, use the `--production` flag

3. Install MySQL server somewhere, and run the SQL script in `./resources/` to create the schema

4. Update the Credentials SQL script in `./resources/` to change your username and password. Also change $host to your server's hostname

5. Run the Credentials SQL script to create the user & apply necessary grants

6. Log in to MySQL using new credentials and verify that you can make a SELECT statement

7. Update the dbCredentials.json file in `./config` to use the newly created user & password

8. Copy the family-budget-api init.d script in `./resources` to `/etc/init.d/`

9. Reboot by executing `sudo reboot`

10. Verify that the service is up and running on the port you selected in `./config/server.json`

11. Run the bash script `./resources/CreateCrontabFile.sh [DB_USER] [DB_PWD] [Interval]` to establish a random password for the `cronjob` MySQL user and generate a file called `crontab.txt` that runs a cronjob to refresh the budget allowances at a regular interval. The parameters for the script are the MySQL Username/Password and the Interval at which you want the cronjob to run.

12. Create the cronjob by executing `crontab crontab.txt`. If all is well, no errors should be reported. To see a list of active cronjobs use `crontab -l` and to remove a cronjob use `crontab -r`

## HTTPS Server Configuration
This API can be run in an encrypted state using TLS v1.2. Follow the steps below in a terminal to generate the proper private key & certificate for the server. Openssl is required.

#### Generate server certificate & private key

*Generate a private key*

```   
	openssl genrsa -out family-budget-key.pem 2048
```

*Create a Certificate Signing Request (CSR)*

```
	openssl req -new -sha256 -key family-budget-key.pem -out family-budget-csr.pem
```

*Use the CSR to create a self-signed certificate*

```
	openssl x509 -req -in family-budget-csr.pem -signkey family-budget-key.pem -out family-budget-cert.pem
```

*Copy family-budget-key.pem and family-budget.cert.pem to the /config/keys directory. Discard family-budget-csr.pem*

*In /config/server.json, in the TLS section, identify both these files for the "serverCertFile" and "serverKeyFile" keys, and set the "enabled" key to true*

## HTTPS Client Configuration 
This API can also require the client to possess a certificate in order to communicate with it. Follow the steps below in a terminal to generate a client certificate and a server root CA to use for its authentication on the server. **OpenSSL is required.** These steps were derived from [Mike Tigas GitHub Gist](https://gist.github.com/mtigas/952344).

#### Generate Server's Root Certificate Authority (CA)

*Create a private key for the Server Root Certficate Authority (CA)*

```	
	openssl genrsa -des3 -out family-budget-ca.key 2048
```

*Create the root CA*

```    
	openssl req -new -x509 -days 365 -key family-budget-ca.key -out family-budget-ca.crt
```

*Copy family-budget-ca.crt to the /config/keys directory.*

*In /config/server.json, in the TLS section, identify this file for the "clientCertFile" key, and set the "requestClientCert" key to true.*

#### Generate the Client's Certificate and Private Key

*Create a private key*
	
```
	openssl genrsa -des3 -out family-budget-client.key 4096
```
	
*Create a Certificate Signing Request (CSR)*

```	
	openssl req -new -key client.key -out family-budget-client.csr
```

*Use the CSR and the CA from above to generate the client certificate*

```
	openssl x509 -req -days 365 -in family-budget-client.csr -CA family-budget-ca.crt -CAkey family-budget-ca.key -set_serial 01 -out family-budget-client.crt
```

*Convert the client certificate & private key to PKCS (.p12), which can be imported by most OS's and browsers*

```
	openssl pkcs12 -export -clcerts -in family-budget-client.crt -inkey family-budget-client.key -out family-budget-client.p12
```
	
*Install the .p12 file into your OS and/or browser certificate store or use it programmatically*
