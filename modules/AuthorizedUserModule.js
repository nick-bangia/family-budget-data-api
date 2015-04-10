// requires
var AuthorizedUserQueries = require('../queries/AuthorizedUserQueries');
var Response = require('../framework/service/Response');
var DataUtils = require('../framework/service/DataUtils');

// constructor
function AuthorizedUserModule(dbUtils) {
  this.dbUtils = dbUtils;
  
  this.GetAuthorizedUserCredentials = function(row, callback) {
  // convert given row into username:password formatted string
    var credentials = row.username + ':' + row.password;
    
    // push the credentials string to the callback
    callback(credentials);
  }
}

// public methods
AuthorizedUserModule.prototype.GetAll = function(finished) {

  this.dbUtils.SelectRows(AuthorizedUserQueries.SelectAll, this.GetAuthorizedUserCredentials,
    function(dbResponse) {
      // check if the query was successful
      if (dbResponse.getStatus() == "ok") {

        // if successful, get an array of AuthorizedUsers
        var dataUtils = new DataUtils();
        dataUtils.ProcessRowsInParallel(dbResponse.getData(), function(authorizedUsers) {
        
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

AuthorizedUserModule.prototype.CheckAuthorization = function(request, response) {
  // simple method to allow for a "ping" check of whether user is authorized
  // if this code gets executed, then the user is authorized, so return true
  var authorized = { isAuthorized: true };
  response.serveJSON(authorized);
}

// export the module
module.exports = AuthorizedUserModule;
