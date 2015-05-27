var DataUtils = require('../framework/service/utils/DataUtils');

module.exports = function (dbUtils, checkAccess) {
  
  var getAccessResult = function(row, callback) {
    callback({ isAuthorized: row.IsAuthorized ? true : false });
  }
  
  return function (request, response, next) {
    // if no access token is provided, fail the authentication
    if (request.headers.x_access_token === undefined) {
      onAuthFailed(response, 'No token provided. Please provide a token to access this resource, or login to obtain a token.')
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
              if (accessResult[0].isAuthorized) {
                allowed = true;
              } else {
                onAuthFailed(response, 'Invalid token provided. Please login again to obtain a new token.');
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

function onAuthFailed(response, realm) {
  response.serveJSON(null, {
    httpStatusCode: 401,
    headers: { 'www-authenticate': 'Basic realm=\'' + realm + '\'' }
  });
}

function onError(response, reason) {
  response.serveJSON({ error: reason }, {
    httpStatusCode: 500
  });
}