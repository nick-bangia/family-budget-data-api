var ResponseUtils = require('../framework/service/utils/ResponseUtils');

module.exports = function (options) {
  options = (options !== null && options !== undefined && options.constructor === Object) ? options : {}
  options.realm = options.realm || 'Please sign in.'
  options.credentials = options.credentials || []

  if (options.encode) {
    options.credentials.forEach(function (credential, i) {
      options.credentials[i] = 'Basic ' + new Buffer(credential, 'utf8').toString('base64')
    })
  }

  return function (request, response, next) {
    if (request.headers.authorization === undefined) {
      onAuthFailed(response, options.realm)
      return next(null, true)
    }
    var allowed = false
    for (var i = 0; i < options.credentials.length && allowed === false; i++) {
      allowed |= options.credentials[i] === request.headers.authorization
    }
    if (!allowed) {
      onAuthFailed(response, options.realm, 'invalid_credentials', 'Invalid username and/or password provided.');
    }
    next(null, !allowed)
  }
}

function onAuthFailed(response, realm, error, description) {

    var responseUtils = new ResponseUtils();
    
    responseUtils.Serve401(response, 'Basic', realm, error, description);
    /*
    response.serveJSON(null, {
      httpStatusCode: 401,
      headers: { 'www-authenticate': 'Basic realm=\'' + realm + '\'' }
    });*/
}