var ApiServer = require('apiserver');
var routes = require('./config/routes');
var dbCredentials = require('./config/dbCredentials');
var DBUtil = require('./framework/sql/DBUtil');
var PaymentMethodModule = require('./modules/PaymentMethodModule');

// instantiate the server
var server = new ApiServer({
  timeout: 2000
});

// instantiate a class of DBUtil with the credentials from configuration
var dbUtility = new DBUtil(dbCredentials);

// add supported modules
server.addModule('v1', 'paymentMethods', new PaymentMethodModule(dbUtility));

// add supported routes
server.router.addRoutes(routes);

// enable console logging on events
server.on('requestStart', function (pathname, time) {
  console.info('starting %s\n', pathname)
});

// begin listening for requests
server.listen(8888, function() {

  console.info('ApiServer listening at http://localhost:8888\n')
});
