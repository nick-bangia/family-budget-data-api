// requires
var AuthorizedUserQueries = require('../queries/AuthorizedUserQueries');
var Response = require('../framework/service/Response');
var DataUtil = require('../framework/service/DataUtil');

// constructor
function AuthorizedUserModule(dbUtility) {
  this.dbUtility = dbUtility;
  
  this.GetAuthorizedUserCredentials = function(row, callback) {
  // convert given row into username:password formatted string
    var credentials = row.username + ':' + row.password;
    
    // push the credentials string to the callback
    callback(credentials);
  }
}

// public methods
AuthorizedUserModule.prototype.GetAll = function(finished) {

  this.dbUtility.SelectRows(AuthorizedUserQueries.SelectAll, this.GetAuthorizedUserCredentials,
    function(dbResponse) {
      // check if the query was successful
      if (dbResponse.getStatus() == "ok") {

        // if successful, get an array of AuthorizedUsers
        var dataUtility = new DataUtil();
        dataUtility.ProcessRowsInParallel(dbResponse.getData(), function(authorizedUsers) {
        
          // push authorizedUsers to the finished callback
          finished(authorizedUsers);
        });

      } else {
        // query failed, so return the failure Response
        console.error('Database error: ' + dbResponse.getReason() + '. This will disallow anybody from authenticating with the service!');
        finished([]);
      }
    }
  );
}

// export the module
module.exports = AuthorizedUserModule;
