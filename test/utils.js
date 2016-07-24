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

TestUtils.prototype.GetStaticAuthorizedAccessTokenForRefresh = function() {
    
    return authorizationConfig.StaticAuthorizedAccessTokenForRefresh;
}

TestUtils.prototype.GetStaticExpiredAccessToken = function() {
    
    return authorizationConfig.StaticExpiredAccessToken;
}

TestUtils.prototype.GetStaticExpiredAccessTokenForRefresh = function() {
    
    return authorizationConfig.StaticExpiredAccessTokenForRefresh;
}

TestUtils.prototype.GetStaticExpiredAccessTokenForExpiredRefresh = function() {
    
    return authorizationConfig.StaticExpiredAccessTokenForExpiredRefresh;
}

TestUtils.prototype.GetStaticExpiredAccessTokenForInvalidRefresh = function() {
    
    return authorizationConfig.StaticExpiredAccessTokenForInvalidRefresh;
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
    
  return 'Bearer realm="' + serverConfig.name + '", error="invalid_token", error_description="Access token expired. Please refresh your token or login again."';
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

TestUtils.prototype.GetAuthorizedRefreshRequest = function() {
    
    var staticAuthorizedAccessTokenForRefresh = this.GetStaticAuthorizedAccessTokenForRefresh();
    var staticValidRefreshTokenForValidAccessToken = this.GetStaticValidRefreshTokenForValidAccessToken();
    
    return this.GetRequestWithHeaders( {
        'x_access_token': staticAuthorizedAccessTokenForRefresh,
        'x_refresh_token': staticValidRefreshTokenForValidAccessToken
    });
}

TestUtils.prototype.GetRefreshForExpiredSessionRequest = function() {
    
    var staticExpiredAccessTokenForRefresh = this.GetStaticExpiredAccessTokenForRefresh();
    var staticValidRefreshTokenForExpiredAccessToken = this.GetStaticValidRefreshTokenForExpiredAccessToken();
    
    return this.GetRequestWithHeaders( {
        'x_access_token':  staticExpiredAccessTokenForRefresh,
        'x_refresh_token': staticValidRefreshTokenForExpiredAccessToken
    });
}

TestUtils.prototype.GetExpiredRefreshForExpiredSessionRequest = function() {
    
    var staticExpiredAccessTokenForExpiredRefresh = this.GetStaticExpiredAccessTokenForExpiredRefresh();
    var staticExpiredRefreshTokenForExpiredAccessToken = this.GetStaticExpiredRefreshTokenForExpiredAccessToken();
    
    return this.GetRequestWithHeaders( {
        'x_access_token': staticExpiredAccessTokenForExpiredRefresh,
        'x_refresh_token': staticExpiredRefreshTokenForExpiredAccessToken
    });
}

TestUtils.prototype.GetInvalidRefreshForExpiredSessionRequest = function() {
    
    var staticExpiredAccessTokenForInvalidRefresh = this.GetStaticExpiredAccessTokenForInvalidRefresh();
    var staticInvalidRefreshTokenForExpiredAccessToken = this.GetStaticInvalidRefreshTokenForExpiredAccessToken();
    
    return this.GetRequestWithHeaders( {
        'x_access_token':  staticExpiredAccessTokenForInvalidRefresh,
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