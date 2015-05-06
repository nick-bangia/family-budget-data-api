/* CONFIGURE THE APPLICATION */
// --------------------------//

// required node vars
var fs = require('fs');
var https = require('https');

// required configurations. If this server is running in a test context, use differnt configurations
var routesConfig = require('./config/routes');
var serverConfigPath = './config/server';
var dbConfigPath = './config/db';

// get the options (if any) into a variable
var options = ((typeof process.argv[2]) === 'undefined') ? '' : process.argv[2];

// if the TEST_ENV environment variable is set, then we are running in a test mode
// so configure the server & db appropriately
if (process.env.TEST_ENV || options.indexOf('t') > -1) {
  serverConfigPath = './test/config/server';
  dbConfigPath = './test/config/db';
}

var serverConfig = require(serverConfigPath);
var dbConfig = require(dbConfigPath);

/* BEGIN SETTING UP THE API SERVER */
//---------------------------------//
// required classes
var ApiServer = require('apiserver');
var DBUtils = require('./framework/sql/DBUtils');
var QueryUtils = require('./framework/service/utils/QueryUtils');
var AuthorizedUserModule = require('./modules/AuthorizedUserModule');
var PaymentMethodModule = require('./modules/PaymentMethodModule');
var AccountModule = require('./modules/AccountModule');
var CategoryModule = require('./modules/CategoryModule');
var SubcategoryModule = require('./modules/SubcategoryModule');
var LineItemModule = require('./modules/LineItemModule');
var BudgetAllowanceModule = require('./modules/BudgetAllowanceModule');

// initialize the server variable
var server = null;
// instantiate a class of DBUtil with the db config values
var dbUtils = new DBUtils(dbConfig);
// instantiate a QueryUtils class
var queryUtils = new QueryUtils();

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

// load & normalize DB queries
var AccountQueries = require('./queries/AccountQueries');
var AuthorizedUserQueries = require('./queries/AuthorizedUserQueries');
var CategoryQueries = require('./queries/CategoryQueries');
var LineItemQueries = require('./queries/LineItemQueries');
var PaymentMethodQueries = require('./queries/PaymentMethodQueries');
var SubcategoryQueries = require('./queries/SubcategoryQueries');
var BudgetAllowanceQueries = require('./queries/BudgetAllowanceQueries');

// normalize all queries
var allQueries = { account: AccountQueries, auth: AuthorizedUserQueries, cat: CategoryQueries, item: LineItemQueries, pm: PaymentMethodQueries, subcat: SubcategoryQueries, allowances: BudgetAllowanceQueries };
var queryUtils = new QueryUtils();
queryUtils.NormalizeQueries(allQueries, function(normalizedQueries) {
	// instantiate the authorizedUserModule to get a list of authorized users of this API
	var authorizedUserModule = new AuthorizedUserModule(dbUtils, normalizedQueries.auth);

	if (serverConfig.authEnabled) {
		authorizedUserModule.GetAll(function(authorizedUsers) {
		
			// set up the httpAuth middleware
			server.use(/.+/, ApiServer.httpAuth({
				realm: serverConfig.name,
				credentials: authorizedUsers,
				encode: true
			}));
		
			// continue configuring server
			ConfigureServer(server, normalizedQueries);	
		});   
	} else {
		// continue configuring server
		ConfigureServer(server, normalizedQueries);
	}
});

function ConfigureServer(server, normalizedQueries) {  
  // configure the payload parser middleware to parse the payload for any route that adds or updates a list
	server.use(/^.+\/(update|add|search)$/, ApiServer.payloadParser());

	// add supported modules
	server.addModule('v1', 'authorization', new AuthorizedUserModule(dbUtils, normalizedQueries.auth));
	server.addModule('v1', 'paymentMethods', new PaymentMethodModule(dbUtils, normalizedQueries.pm));
	server.addModule('v1', 'accounts', new AccountModule(dbUtils, normalizedQueries.account));
	server.addModule('v1', 'categories', new CategoryModule(dbUtils, normalizedQueries.cat));
	server.addModule('v1', 'subcategories', new SubcategoryModule(dbUtils, normalizedQueries.subcat));
  server.addModule('v1', 'lineItems', new LineItemModule(dbUtils, normalizedQueries.item));
  server.addModule('v1', 'budgetAllowances', new BudgetAllowanceModule(dbUtils, normalizedQueries.allowances));
	
	// add supported routes
	server.router.addRoutes(routesConfig);

	// enable console logging on events if in debug mode (-d flag)
	if (options.indexOf('d') > -1) {
		server.on('requestStart', function (pathname, time) {
			console.info('starting %s\n', pathname)
		});
	}

	// begin listening for requests
	server.listen(serverConfig.port, function() {
		if (options.indexOf('d') > -1) {
			var protocol = serverConfig.tls.enabled ? "https" : "http";
			console.info('ApiServer listening at ' + protocol + '://localhost:' + serverConfig.port + '\n');
		}
	});
}
