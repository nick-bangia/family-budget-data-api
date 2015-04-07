// required node vars
var fs = require('fs');
var https = require('https');

// required configurations. If this server is running in a test context, use differnt configurations
var routesConfig = require('./config/routes');
var serverConfigPath = './config/server';
var dbCredentialsPath = './config/dbCredentials';

if (process.argv[2] == 'testing') {
  serverConfigPath = './test/config/server';
  dbCredentialsPath = './test/config/dbCredentials';
}

var serverConfig = require(serverConfigPath);
var dbCredentials = require(dbCredentialsPath);

// required classes
var ApiServer = require('apiserver');
var DBUtil = require('./framework/sql/DBUtil');
var AuthorizedUserModule = require('./modules/AuthorizedUserModule');
var PaymentMethodModule = require('./modules/PaymentMethodModule');

// initialize the server variable
var server = null;
// instantiate a class of DBUtil with the credentials from configuration
var dbUtility = new DBUtil(dbCredentials);

// instantiate an http(s) server, depending on whether tls is enabled
if (serverConfig.tls.enabled) {
  var httpsOptions = {
    cert: fs.readFileSync(serverConfig.tls.serverCertFile),
    key: fs.readFileSync(serverConfig.tls.serverKeyFile),
    requestCert: serverConfig.tls.requestClientCert
  };

  if (httpsOptions.requestCert) {
    // only add the certificate authority in if a client certificate is being requested
    httpsOptions.ca = [ fs.readFileSync(serverConfig.tls.clientCertFile) ];
  }
  
  // instantiate the https apiServer
  server = new ApiServer({
    server: https.createServer(httpsOptions),
    timeout: serverConfig.timeout
  });
} else {
  // instantiate the http apiServer
  server = new ApiServer({
    timeout: serverConfig.timeout
  });
}

// instantiate the authorizedUserModule to get a list of authorized users of this API
var authorizedUserModule = new AuthorizedUserModule(dbUtility);

if (serverConfig.authEnabled) {
  authorizedUserModule.GetAll(function(authorizedUsers) {
	
    // set up the httpAuth middleware
    server.use(/.+/, ApiServer.httpAuth({
      realm: serverConfig.name,
      credentials: authorizedUsers,
      encode: true
    }));
	
    // continue configuring server
    ConfigureServer(server);	
  });   
} else {
  // continue configuring server
  ConfigureServer(server);
}

function ConfigureServer(server) {  
  // configure the payload parser middleware to parse the payload for any route that adds or updates a list
  server.use(/^.+\/(update|add)$/, ApiServer.payloadParser());
  
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
    var protocol = serverConfig.tls.enabled ? "https" : "http";
    console.info('ApiServer listening at ' + protocol + '://localhost:' + serverConfig.port + '\n');
  });
}
