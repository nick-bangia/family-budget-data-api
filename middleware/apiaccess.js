var DataUtils = require('../framework/service/utils/DataUtils');
var ResponseUtils = require('../framework/service/utils/ResponseUtils');

module.exports = function (realm, dbUtils, checkAccess) {
  
  var getAccessResult = function(row, callback) {
    callback({ authorizationState: row.AuthorizationState });
  }
  
  return function (request, response, next) {
    // if no access token is provided, fail the authentication
    if (request.headers.x_access_token === undefined) {
      onAuthFailed(response, realm);
      return next(null, true)
    }
    
    // otherwise, check the DB for whether the provided token is valid
    dbUtils.SelectRowsWithParams(checkAccess, [request.headers.x_access_token], getAccessResult, true,
      function(dbResponse) {
        var allowed = false;
        // as long as the dbResponse is ok, process the results
        if (dbResponse.getStatus() == "ok") {
          var dataUtils = new DataUtils();
          dataUtils.ProcessRowsInParallel(dbResponse.getData(), function(accessResult) {
            // if the accessResult array has at least 1 item, check that it's isAuthorized property is true
            if (accessResult.length > 0) {
              if (accessResult[0].authorizationState == 'AUTHORIZED') {
                allowed = true;
              } else if (accessResult[0].authorizationState == 'NOT AUTHORIZED') {
                onAuthFailed(response, realm, 'invalid_token', 'Invalid access token provided. Please login to obtain a valid access token.');     
              } else if (accessResult[0].authoriztionState == 'EXPIRED') {
                onAuthFailed(response, realm, 'invalid_token', 'Expired token provided. Please refresh your session, or login to obtain a valid token');
              }
                
              // call the next item in the chain, specifying whether to stop or continue execution
              next(null, !allowed);
            } else {
              onError(response, 'Error authenticating, no rows returned!');
              next(null, !allowed);
            }
          });
        } else {
          // if the status of the db response is not ok, then call next with an error
          onError(response, dbResponse.getReason());
          next(dbResponse.getData(), !allowed);
        }
      }
    );
  }
}

function onAuthFailed(response, realm, error, description) {
  
  var responseUtils = new ResponseUtils();
  
  responseUtils.Serve401(response, 'Bearer', realm, error, description);
  
  /*response.serveJSON(null, {
    httpStatusCode: 401,
    headers: { 
        'www-authenticate': 'Bearer realm="' + realm + '", error="' + error + '", error_description="' + description + '"'
    }
  });*/
}

function onError(response, reason) {
  
  var responseUtils = new ResponseUtils();
    
  responseUtils.Serve500(reason);
    
  /*response.serveJSON({ error: reason }, {
    httpStatusCode: 500
  });*/
}