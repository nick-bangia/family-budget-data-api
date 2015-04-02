// required node vars
var fs = require('fs');
var https = require('https');

// required configurations
var routesConfig = require('./config/routes');
var serverConfig = require('./config/server');
var dbCredentials = require('./config/dbCredentials');

// required classes
var ApiServer = require('apiserver');
var DBUtil = require('./framework/sql/DBUtil');
var PaymentMethodModule = require('./modules/PaymentMethodModule');

// instantiate the https server
var httpsOptions = {
  key: fs.readFileSync('./config/keys/family-budget-key.pem'),
  cert: fs.readFileSync('./config/keys/family-budget-cert.pem')
};

// instantiate the apiServer
var server = new ApiServer({
  server: https.createServer(httpsOptions),
  timeout: serverConfig.timeout
});

// instantiate a class of DBUtil with the credentials from configuration
var dbUtility = new DBUtil(dbCredentials);

// add supported modules
server.addModule('v1', 'paymentMethods', new PaymentMethodModule(dbUtility));

// add supported routes
server.router.addRoutes(routesConfig);

// enable console logging on events
server.on('requestStart', function (pathname, time) {
  console.info('starting %s\n', pathname)
});

// begin listening for requests
server.listen(serverConfig.port, function() {

  console.info('ApiServer listening at https://localhost:' + serverConfig.port + '\n')
});
