// requires
var Response = require('../framework/service/Response');
var DataUtils = require('../framework/service/utils/DataUtils');

// constructor
function AuthorizedUserModule(dbUtils, queries) {
  this.dbUtils = dbUtils;
	this.queries = queries;
  
  this.GetAuthorizedUserCredentials = function(row, callback) {
  // convert given row into username:password formatted string
    var credentials = row.Username + ':' + row.Password;
    
    // push the credentials string to the callback
    callback(credentials);
  }
}

// public methods
AuthorizedUserModule.prototype.GetAll = function(finished) {
	var self = this;
	
  this.dbUtils.SelectRows(self.queries.SelectAll, this.GetAuthorizedUserCredentials,
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

AuthorizedUserModule.prototype.Ping = function(request, response) {
  // simple method to allow for a "ping" check of whether user is authorized
  // if this code gets executed, then respond with a success response with the
  // isAuthorized object
  var successResponse = new Response();
  successResponse.data.push({ isAuthorized: true });
  response.serveJSON(successResponse);
}

// export the module
module.exports = AuthorizedUserModule;
