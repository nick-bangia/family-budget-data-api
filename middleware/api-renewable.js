var DataUtils = require('../framework/service/utils/DataUtils');
var ResponseUtils = require('../framework/service/utils/ResponseUtils');

module.exports = function (realm, dbUtils, checkRenewability) {
  
  var getRenewResult = function(row, callback) {
    callback({ renewableState: row.RenewableState });
  }
  
  return function (request, response, next) {
    // if no refresh token is provided, fail the request
    if (request.headers.x_refresh_token === undefined || request.headers.x_access_token == undefined) {
      onAuthFailed(response, realm, 'missing_token', 'Missing refresh or access token. Please retry with both a valid access and refresh token, or login again to obtain a new access token.');
      return next(null, true)
    }
    
    // otherwise, check the DB for whether the provided tokens are valid
    dbUtils.SelectRowsWithParams(checkRenewability, [request.headers.x_access_token, request.headers.x_refresh_token], getRenewResult, true,
      function(dbResponse) {
        var allowed = false;
        // as long as the dbResponse is ok, process the results
        if (dbResponse.getStatus() == "ok") {
          var dataUtils = new DataUtils();
          dataUtils.ProcessRowsInParallel(dbResponse.getData(), function(renewResult) {
            // if the renewResult array has at least 1 item, check that it's renewableState property is valid
            if (renewResult.length > 0) {
              if (renewResult[0].renewableState == 'AUTHORIZED') {
                allowed = true;
              } else if (renewResult[0].renewableState == 'NOT AUTHORIZED') {
                onAuthFailed(response, realm, 'invalid_token', 'Invalid Refresh token provided. Please retry with a valid refresh token, or login again to obtain a new access token.');     
              } else if (renewResult[0].renewableState == 'EXPIRED') {
                onAuthFailed(response, realm, 'invalid_token', 'Refresh token has expired. Please login again to obtain a new access token.');
              }
                
              // call the next item in the chain, specifying whether to stop or continue execution
              next(null, !allowed);
            } else {
              onError(response, 'Error renewing, no rows returned!');
              next(null, !allowed);
            }
          });
        } else {
          // if the status of the db response is not ok, then call next with an error
          onError(response, dbResponse);
          next(dbResponse.getData(), !allowed);
        }
      }
    );
  }
}

function onAuthFailed(response, realm, error, description) {
  
  var responseUtils = new ResponseUtils();
  
  responseUtils.Serve401(response, 'Bearer', realm, error, description);
}

function onError(response, errorObject) {
  
  var responseUtils = new ResponseUtils();
    
  responseUtils.Serve500(response, errorObject);
}