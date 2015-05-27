// requires
var Response = require('../framework/service/Response');
var DataUtils = require('../framework/service/utils/DataUtils');
var Random = require('random-js');

// constructor
function AuthorizedUserModule(dbUtils, queries, authInterval) {
  this.dbUtils = dbUtils;
	this.queries = queries;
  this.authInterval = authInterval;
  
  this.GetAuthorizedUserCredentials = function(row, callback) {
    // convert given row into username:password formatted string
    var credentials = row.Username + ':' + row.Password;
    
    // push the credentials string to the callback
    callback(credentials);
  }
  
  this.GetAccessToken = function(row, callback) {
    // convert given row into an access token object
    var accessToken = { access_token: row.Token, expires_on: row.Expires };
    
    // push the token to the calllback
    callback(accessToken);
  }
}

// public methods
AuthorizedUserModule.prototype.GetAll = function(finished) {
	var self = this;
	
  this.dbUtils.SelectRows(self.queries.SelectAll, self.GetAuthorizedUserCredentials,
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

AuthorizedUserModule.prototype.Login = {

  get: function(request, response) {
    var self = this;
    
    // Logs in a user by invalidating any current access tokens & generating a new one
    var authorizedUser = request.headers.authorization;
    var newToken = Random.uuid4(Random.engines.mt19937().autoSeed());
    this.dbUtils.SelectRowsWithParams(self.queries.Login, [authorizedUser, newToken, self.authInterval], self.GetAccessToken, true,
      function(dbResponse) {
        // check if the query was successful
        if (dbResponse.getStatus() == "ok") {
          // if successful, get an array of tokens (should only ever be 1 row returned)
          var dataUtils = new DataUtils();
          dataUtils.ProcessRowsInParallel(dbResponse.getData(), function(tokenData) {
            // construct the successful response with token data and serve as JSON
            var tokenResponse = new Response();
            tokenResponse.setData(tokenData);
            
            // serve the response
            response.serveJSON(tokenResponse);
          });
        }
      }
    );
  }
}

// export the module
module.exports = AuthorizedUserModule;
