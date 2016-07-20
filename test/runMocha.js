// require mysql in order to precondition all tests
var fs = require('fs');
var mysql = require('mysql');
var dbCredentials = JSON.parse(fs.readFileSync('./test/config/db.json'));
var dbRefreshQueryScriptPath = './resources/FamilyBudgetSchema-TestDB.sql';

// set environment variables
process.env.NODE_ENV = process.env.NODE_ENV || 'test';
process.env.TEST_ENV = process.env.TEST_ENV || 'test';

// set exit variable
var exit = process.exit;
process.exit = function (code) {
  setTimeout(function () {
      exit();
  }, 200);
};



// prepare to refresh the DB before continuing
var connectionObj = {
  host: dbCredentials.host, 
  user: dbCredentials.user, 
  password: dbCredentials.password, 
  database: dbCredentials.database, 
  multipleStatements: true
};
var connection = mysql.createConnection(connectionObj);
var refreshDbQuery = fs.readFileSync(dbRefreshQueryScriptPath, 'utf8');

// execute the refresh script & begin testing
connection.query(refreshDbQuery, function(err, results) {
  if (err) throw err;
  
  // if successful query, continue to start the API server and run tests
  require('../server');
  
  // terminate the db connection gracefully
  connection.end();
});
