// requires
var AuthorizedUserQueries = require('../queries/AuthorizedUserQueries');
var Response = require('../framework/service/Response');

// private shared functions
var GetArrayFrom = function(rows, finished) {

  // initialize an array of AuthorizedUsers
  var authorizedUsers = [];

  // loop throw rows and convert into username:password format
  rows.forEach(function(row) {
    authorizedUsers.push(row.username + ':' + row.password);
    
	// check if the authorizedUsers array is full
    if (authorizedUsers.length == rows.length) {
	  finished(authorizedUsers);
    }
  });
}

// constructor
function AuthorizedUserModule(dbUtility) {
  this._dbUtility = dbUtility;
}

// public methods
AuthorizedUserModule.prototype.GetAll = function(finished) {
  
  this._dbUtility.SelectRows(AuthorizedUserQueries.SelectAll, 
    function(dbResponse) {
      // check if the query was successful
      if (dbResponse.getStatus() == "ok") {

        // if successful, get an array of AuthorizedUsers
        GetArrayFrom(dbResponse.getData(), function(authorizedUsers) {
		  
		  // call the complete callback the array
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
