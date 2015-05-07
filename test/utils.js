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

TestUtils.prototype.GetExpectedWWWAuthenticateHeader = function() {
  
  return "Basic realm='" + serverConfig.name + "'";
}

TestUtils.prototype.GetAuthorizedRequest = function() {

  var authorizedCredentials = this.GetValidCredentials();

  var authorizedRequest = request.defaults({
    'auth': {
      'user': authorizedCredentials.Username,
      'pass': authorizedCredentials.Password
    }
  });
  
  return authorizedRequest;
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