// required configurations
var routesConfig = require('./config/routes');
var serverConfig = require('./config/server');
var dbCredentials = require('./config/dbCredentials');

// required classes
var ApiServer = require('apiserver');
var DBUtil = require('./framework/sql/DBUtil');
var PaymentMethodModule = require('./modules/PaymentMethodModule');

// instantiate the server
var server = new ApiServer({
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

  console.info('ApiServer listening at http://localhost:' + serverConfig.port + '\n')
});
