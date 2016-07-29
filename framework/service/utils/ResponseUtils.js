var Response = require('../Response');

function ResponseUtils() {
}

ResponseUtils.prototype.GenerateParseErrorResponse = function(error, callback) {
  var parseError = error;
  var errorResponse = new Response();
  
  // set the fields for this response accordingly for this parse error
  errorResponse.setStatus('failure');
  errorResponse.setReason('Request payload is incorrectly formatted - ' + parseError.message);
  
  // callback with this response
  callback(errorResponse);
}

ResponseUtils.prototype.Serve401 = function(response, authType, realm, error, description) {

  var www_authenticate_header = authType + ' realm="' + realm + '"';
    
  if (error !== undefined) {
    www_authenticate_header += ', error="' + error + '"';
  }
    
  if (description !== undefined) {
    www_authenticate_header += ', error_description="' + description + '"';
  }
    
  response.serveJSON(null, {
    httpStatusCode: 401,
    headers: { 'www-authenticate': www_authenticate_header }
  });
}

ResponseUtils.prototype.Serve500 = function(response, errorObject) {
  
  response.serveJSON(
      errorObject, 
      { httpStatusCode: 500 }
  );
}

module.exports = ResponseUtils;