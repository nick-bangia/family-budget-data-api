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

## HTTPS Server Configuration
This API can be run in an encrypted state using TLS v1.2. Follow the steps below to generate the proper private key & certificate for the server.

### Generate server certificate & private key
	
1. Create a private key

	openssl genrsa -out family-budget-key.pem 2048

2. Create a Certificate Signing Request (CSR)
	
	openssl req -new -sha256 -key family-budget-key.pem -out family-budget-csr.pem

3. Use the CSR to create a self-signed certificate

	openssl x509 -req -in family-budget-csr.pem -signkey family-budget-key.pem -out family-budget-cert.pem
	
4. Copy family-budget-key.pem and family-budget.cert.pem to the /config/keys directory. Discard family-budget-csr.pem.

5. In /config/server.json, in the TLS section, identify both these files for the "serverCertFile" and "serverKeyFile" keys, and set the "enabled" key to true

## HTTPS Client Configuration 
This API can also require the client to possess a certificate in order to communicate with it. Follow the steps below to generate a client certificate and a server root CA
to use for its authentication on the server. These steps were derived from [Mike Tigas GitHub Gist](https://gist.github.com/mtigas/952344).

### Generate Server's Root Certificate Authority (CA)

1. Create a private key	for the Server Root Certficate Authority (CA)
	
	openssl genrsa -des3 -out family-budget-ca.key 2048

2. Create the root CA
    
	openssl req -new -x509 -days 365 -key family-budget-ca.key -out family-budget-ca.crt

3. Copy family-budget-ca.crt to the /config/keys directory.

4. In /config/server.json, in the TLS section, identify this file for the "clientCertFile" key, and set the "requestClientCert" key to true.

### Generate the client's certificate and private key

1. Create a private key
	
	openssl genrsa -des3 -out family-budget-client.key 4096
	
2. Create a Certificate Signing Request (CSR)
	
    openssl req -new -key client.key -out family-budget-client.csr

3. Use the CSR and the CA from above to generate the client certificate
    
	openssl x509 -req -days 365 -in family-budget-client.csr -CA family-budget-ca.crt -CAkey family-budget-ca.key -set_serial 01 -out family-budget-client.crt

4. Convert the client certificate & private key to PKCS (.p12), which can be imported by most OS's and browsers
	
	openssl pkcs12 -export -clcerts -in family-budget-client.crt -inkey family-budget-client.key -out family-budget-client.p12
	
5. Install the .p12 file into your OS and/or browser certificate store or use it programmatically