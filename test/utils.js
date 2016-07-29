var authorizationConfig = require('./config/authorization');
var serverConfig = require('./config/server');
var _ = require('underscore');

function TestUtils() {
}

TestUtils.prototype.GetRootURL = function() {
  var protocol = serverConfig.tls.enabled ? 'https' : 'http';
  var port = serverConfig.port;
  
  return protocol + '://localhost:' + port;
}

TestUtils.prototype.GetValidCredentials = function() {
  
    return { Username: authorizationConfig.Username, Password: authorizationConfig.ValidPassword };
}

TestUtils.prototype.GetInvalidCredentials = function() {
  
    return { Username: authorizationConfig.Username, Password: authorizationConfig.InvalidPassword };
}

TestUtils.prototype.GetStaticAuthorizedAccessToken = function() {
  
    return authorizationConfig.StaticAuthorizedAccessToken;
}

TestUtils.prototype.GetStaticAuthorizedAccessTokenForRenew = function() {
    
    return authorizationConfig.StaticAuthorizedAccessTokenForRenew;
}

TestUtils.prototype.GetStaticExpiredAccessToken = function() {
    
    return authorizationConfig.StaticExpiredAccessToken;
}

TestUtils.prototype.GetStaticExpiredAccessTokenForRenew = function() {
    
    return authorizationConfig.StaticExpiredAccessTokenForRenew;
}

TestUtils.prototype.GetStaticExpiredAccessTokenForExpiredRenew = function() {
    
    return authorizationConfig.StaticExpiredAccessTokenForExpiredRenew;
}

TestUtils.prototype.GetStaticExpiredAccessTokenForInvalidRenew = function() {
    
    return authorizationConfig.StaticExpiredAccessTokenForInvalidRenew;
}

TestUtils.prototype.GetStaticInvalidAccessToken = function() {
    
    return authorizationConfig.StaticInvalidAccessToken;
}

TestUtils.prototype.GetStaticValidRefreshTokenForValidAccessToken = function() {

    return authorizationConfig.StaticValidRefreshTokenForValidAccessToken;
}

TestUtils.prototype.GetStaticValidRefreshTokenForExpiredAccessToken = function() {
    
    return authorizationConfig.StaticValidRefreshTokenForExpiredAccessToken;
}

TestUtils.prototype.GetStaticExpiredRefreshTokenForExpiredAccessToken = function() {
    
    return authorizationConfig.StaticExpiredRefreshTokenForExpiredAccessToken;
}

TestUtils.prototype.GetStaticInvalidRefreshTokenForExpiredAccessToken = function() {
    
    return authorizationConfig.StaticInvalidRefreshTokenForExpiredAccessToken;
}

TestUtils.prototype.GetRequestWithHeaders = function(headers) {
    
    return request.defaults({
        'headers': headers
    });
}

TestUtils.prototype.GetExpectedNoAuthProvidedHeader = function() {
  
  return 'Basic realm="' + serverConfig.name + '"';
}

TestUtils.prototype.GetExpectedAuthFailedHeader = function() {
    
  return 'Basic realm="' + serverConfig.name + '", error="invalid_credentials", error_description="Invalid username and/or password provided."';
}

TestUtils.prototype.GetExpectedAuthTokenExpiredHeader = function() {
    
  return 'Bearer realm="' + serverConfig.name + '", error="invalid_token", error_description="Access token expired. Please renew your token or login again."';
}

TestUtils.prototype.GetExpectedAuthTokenInvalidHeader = function() {

  return 'Bearer realm="' + serverConfig.name + '", error="invalid_token", error_description="Invalid access token provided. Please login to obtain a valid access token."';
}

TestUtils.prototype.GetExpectedAuthRefreshTokenExpiredHeader = function() {
    
  return 'Bearer realm="' + serverConfig.name + '", error="invalid_token", error_description="Refresh token has expired. Please login again to obtain a new access token."';
}

TestUtils.prototype.GetExpectedAuthRefreshTokenInvalidHeader = function() {
    
  return 'Bearer realm="' + serverConfig.name + '", error="invalid_token", error_description="Invalid Refresh token provided. Please retry with a valid refresh token, or login again to obtain a new access token."';
}

TestUtils.prototype.GetExpectedTokenMissingHeader = function() {

  return 'Bearer realm="' + serverConfig.name + '", error="missing_token", error_description="Missing refresh or access token. Please retry with both a valid access and refresh token, or login again to obtain a new access token."';
}

TestUtils.prototype.GetAuthorizedRequest = function() {

    var staticAuthorizedAccessToken = this.GetStaticAuthorizedAccessToken();

    return this.GetRequestWithHeaders( {
        'x_access_token' : staticAuthorizedAccessToken
    }); 
}

TestUtils.prototype.GetExpiredRequest = function() {
    
    var staticExpiredAccessToken = this.GetStaticExpiredAccessToken();

    return this.GetRequestWithHeaders( {
        'x_access_token': staticExpiredAccessToken    
    });
}

TestUtils.prototype.GetInvalidRequest = function() {
    
    var staticInvalidAccessToken = this.GetStaticInvalidAccessToken();

    return this.GetRequestWithHeaders( {
        'x_access_token': staticInvalidAccessToken  
    });
}

TestUtils.prototype.GetAuthorizedRenewRequest = function() {
    
    var staticAuthorizedAccessTokenForRenew = this.GetStaticAuthorizedAccessTokenForRenew();
    var staticValidRefreshTokenForValidAccessToken = this.GetStaticValidRefreshTokenForValidAccessToken();
    
    return this.GetRequestWithHeaders( {
        'x_access_token': staticAuthorizedAccessTokenForRenew,
        'x_refresh_token': staticValidRefreshTokenForValidAccessToken
    });
}

TestUtils.prototype.GetRenewForExpiredSessionRequest = function() {
    
    var staticExpiredAccessTokenForRenew = this.GetStaticExpiredAccessTokenForRenew();
    var staticValidRefreshTokenForExpiredAccessToken = this.GetStaticValidRefreshTokenForExpiredAccessToken();
    
    return this.GetRequestWithHeaders( {
        'x_access_token':  staticExpiredAccessTokenForRenew,
        'x_refresh_token': staticValidRefreshTokenForExpiredAccessToken
    });
}

TestUtils.prototype.GetExpiredRenewForExpiredSessionRequest = function() {
    
    var staticExpiredAccessTokenForExpiredRenew = this.GetStaticExpiredAccessTokenForExpiredRenew();
    var staticExpiredRefreshTokenForExpiredAccessToken = this.GetStaticExpiredRefreshTokenForExpiredAccessToken();
    
    return this.GetRequestWithHeaders( {
        'x_access_token': staticExpiredAccessTokenForExpiredRenew,
        'x_refresh_token': staticExpiredRefreshTokenForExpiredAccessToken
    });
}

TestUtils.prototype.GetInvalidRenewForExpiredSessionRequest = function() {
    
    var staticExpiredAccessTokenForInvalidRenew = this.GetStaticExpiredAccessTokenForInvalidRenew();
    var staticInvalidRefreshTokenForExpiredAccessToken = this.GetStaticInvalidRefreshTokenForExpiredAccessToken();
    
    return this.GetRequestWithHeaders( {
        'x_access_token':  staticExpiredAccessTokenForInvalidRenew,
        'x_refresh_token': staticInvalidRefreshTokenForExpiredAccessToken
    });
}

TestUtils.prototype.TestStandardExpectationsForSuccessfulResult = function(results, expectedListLength) {
  // success object
  expect(results).to.be.an('object');
  expect(results.status).to.equal('ok');
  expect(results.reason).to.equal('success');
  
  // data property is a list
  expect(_.isArray(results.data)).to.be.true;
  expect(results.data.length).to.be.at.least(expectedListLength);
}

TestUtils.prototype.TestStandardExpectationsForSuccessfulPutResult = function(resultData, expectedListLength) {
  // list item is a response object with a data array
  expect(resultData[0]).to.have.property('status');
  expect(resultData[0]).to.have.property('reason');
  expect(resultData[0]).to.have.property('data');
  
  // analyze the data array of the data property
  expect(resultData.length).to.be.at.least(expectedListLength);
  expect(resultData[0].data).to.be.an('object');
}

TestUtils.prototype.TestNoResultsResult = function(response) {
  return response.status == 'failure' && response.reason == 'Query did not affect any rows';
}

TestUtils.prototype.TestSuccessfulResult = function(response) {
  return response.status == 'ok' && response.reason == 'success';
}

TestUtils.prototype.TypeOf = function(object) {
  return Object.prototype.toString.call( object );
}
module.exports = TestUtils;