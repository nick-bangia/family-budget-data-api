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

module.exports = ResponseUtils;