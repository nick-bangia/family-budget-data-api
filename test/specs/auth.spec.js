var url, response, results;
var invalidCredentials, validCredentials;

// pre-built request objects
var authorizedRequest = testUtils.GetAuthorizedRequest();
var expiredRequest = testUtils.GetExpiredRequest();
var invalidRequest = testUtils.GetInvalidRequest();
var authorizedRefreshRequest = testUtils.GetAuthorizedRefreshRequest();
var refreshForExpiredSessionRequest = testUtils.GetRefreshForExpiredSessionRequest();
var expiredRefreshForExpiredSessionRequest = testUtils.GetExpiredRefreshForExpiredSessionRequest();
var invalidRefreshForExpiredSessionRequest = testUtils.GetInvalidRefreshForExpiredSessionRequest();

// expected headers
var expectedNoAuthHeader = testUtils.GetExpectedNoAuthProvidedHeader();
var expectedAuthFailedHeader = testUtils.GetExpectedAuthFailedHeader();
var expectedAuthTokenExpiredHeader = testUtils.GetExpectedAuthTokenExpiredHeader();
var expectedAuthTokenInvalidHeader = testUtils.GetExpectedAuthTokenInvalidHeader();
var expectedAuthRefreshTokenExpiredHeader = testUtils.GetExpectedAuthRefreshTokenExpiredHeader();
var expectedAuthRefreshTokenInvalidHeader = testUtils.GetExpectedAuthRefreshTokenInvalidHeader();

// URLs for testing
loginUrl = testUtils.GetRootURL() + '/login';
refreshUrl = testUtils.GetRootURL() + '/login/refresh';
allAccountsUrl = testUtils.GetRootURL() + '/accounts/all';

// test credentials
invalidCredentials = testUtils.GetInvalidCredentials();
validCredentials = testUtils.GetValidCredentials();

describe('Authorization Testing', function() {

  describe('when no username and password is present', function() {
    before(function(done) {
      request.get( {url: loginUrl }, function(err, resp, body) {
        response = resp;
        done(err);
      });
    });
    
    it ('should not be authorized', function() {
      expect(response.statusCode).to.equal(401);
    });
    
    it ('should challenge the user with the proper www-authenticate header', function() {
      expect(response.headers['www-authenticate']).to.equal(expectedNoAuthHeader);
    });
  });
  
  describe('when an invalid username nad password are present', function() {
    before(function(done) {
      request.get( {url: loginUrl}, function(err, resp, body) {
        response = resp;
        done(err);
      }).auth(invalidCredentials.Username, invalidCredentials.Password);
    });
    
    it ('should not be authorized', function() {
      expect(response.statusCode).to.equal(401);
    });
    
    it ('should challenge the user with the proper www-authenticate header', function() {
      expect(response.headers['www-authenticate']).to.equal(expectedAuthFailedHeader);
    });
  });
  
  describe('when a valid username and password are present', function() {
    before(function(done) {
      request.get( { url: loginUrl }, function(err, resp, body) {
        response = resp;
        results = JSON.parse(body);
        done(err);
      }).auth(validCredentials.Username, validCredentials.Password);
    });
    
    it ('should be authorized and return a status of 200', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should not challenge the user with a www-authenticate header', function() {
      expect(response.headers['www-authenticate']).to.not.be.ok;
    });
    
    it ('should return a success object with a valid list for the data property', function () {
      testUtils.TestStandardExpectationsForSuccessfulResult(results, 1);
    });
    
    it ('should return an auth token object to be used in future requests.', function() {
      expect('access_token' in results.data[0]).to.be.true;
      expect('refresh_token' in results.data[0]).to.be.true;
      expect('expires_on' in results.data[0]).to.be.true;
    });
  });
    
  describe('when a valid access token is used to make a request to accounts/all', function() {
    before(function(done) {
      authorizedRequest.get( {url: allAccountsUrl}, function(err, resp, body) {
        response = resp;
        results = JSON.parse(body);
        done(err);
      });
    });
      
    it ('should be authorized and return a status of 200', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should not challenge the user with a www-authenticate header', function() {
      expect(response.headers['www-authenticate']).to.not.be.ok;
    });    
  });
    
  describe('when a valid, expired access token is used to make a request to /accounts/all', function() {
    before(function(done) {
      expiredRequest.get( {url: allAccountsUrl}, function(err, resp, body) {
        response = resp;
        results = JSON.parse(body);
        done(err);
      });
    });
      
    it ('should not be authorized', function() {
      expect(response.statusCode).to.equal(401);
    });
    
    it ('should challenge the user with the proper www-authenticate', function() {
      expect(response.headers['www-authenticate']).to.equal(expectedAuthTokenExpiredHeader);
    });
  });
    
  describe('when an invalid access token is used to make a request to /accounts/all', function() {
    before(function(done) {
      invalidRequest.get( {url: allAccountsUrl}, function(err, resp, body) {
        response = resp;
        results = JSON.parse(body);
        done(err);
      });
    });
      
    it ('should not be authorized', function() {
      expect(response.statusCode).to.equal(401);      
    });
      
    it ('should challenge the user with the proper www-authenticate header', function() {
      expect(response.headers['www-authenticate']).to.equal(expectedAuthTokenInvalidHeader);
    });
  });
  
  describe('when a valid refresh request is made with a valid, non-expired access token', function() {
    before(function(done) {
      authorizedRefreshRequest.get( { url: refreshUrl }, function(err, resp, body) {
        response = resp;
        results = JSON.parse(body);
        done(err);
      });
    });
      
    it ('should be authorized and return a status of OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should not challenge the user with a www-authenticate header', function() {
      expect(response.headers['www-authenticate']).to.not.be.ok;
    });
    
    it ('should return a success object with a valid list for the data property', function () {
      testUtils.TestStandardExpectationsForSuccessfulResult(results, 1);
    });
    
    it ('should return an auth token object to be used in future requests.', function() {
      expect('access_token' in results.data[0]).to.be.true;
      expect('refresh_token' in results.data[0]).to.be.true;
      expect('expires_on' in results.data[0]).to.be.true;
    });
  });
    
  describe('when a valid refresh request is made with a valid, expired access token', function() {
    before(function(done) {
      refreshForExpiredSessionRequest.get( { url: refreshUrl }, function(err, resp, body) {
        response = resp;
        results = JSON.parse(body);
        done(err);
      });
    });
      
    it ('should be authorized and return a status of OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should not challenge the user with a www-authenticate header', function() {
      expect(response.headers['www-authenticate']).to.not.be.ok;
    });
    
    it ('should return a success object with a valid list for the data property', function () {
      testUtils.TestStandardExpectationsForSuccessfulResult(results, 1);
    });
    
    it ('should return an auth token object to be used in future requests.', function() {
      expect('access_token' in results.data[0]).to.be.true;
      expect('refresh_token' in results.data[0]).to.be.true;
      expect('expires_on' in results.data[0]).to.be.true;
    });
      
    describe('A following request should be allowed to be made with the new access token', function() {
      before(function(done) {
        var authorizedRequest = testUtils.GetRequestWithHeaders({
            'x_access_token': results.data[0].access_token
        });
      
        authorizedRequest.get( { url: allAccountsUrl }, function(err, resp, body) {    
          response = resp;
          results = JSON.parse(body);
          done(err);
        });
      });
      
      it ('should be authorized and return a status of OK', function() {
        expect(response.statusCode).to.equal(200);
      });
    
      it ('should not challenge the user with a www-authenticate header', function() {
        expect(response.headers['www-authenticate']).to.not.be.ok;  
      })
    });
  });
    
  describe('when a valid, expired access token and an expired refresh token are used to refresh the session', function() {
    before(function(done) {
      expiredRefreshForExpiredSessionRequest.get( {url: refreshUrl}, function(err, resp, body) {
        response = resp;
        results = JSON.parse(body);
        done(err);
      });
    });

    it ('should not be authorized', function() {
      expect(response.statusCode).to.equal(401);
    });
    
    it ('should challenge the user with the proper www-authenticate header', function() {
      expect(response.headers['www-authenticate']).to.equal(expectedAuthRefreshTokenExpiredHeader);
    });
  });
    
  describe('when a valid, expired access token and an invalid refresh token are used to refresh the session', function() {
    before(function(done) {
      invalidRefreshForExpiredSessionRequest.get( { url: refreshUrl }, function(err, resp, body) {
        response = resp;
        results = JSON.parse(body);
        done(err);
      });
    });
      
    it ('should not be authorized', function() {
      expect(response.statusCode).to.equal(401);    
    });
      
    it ('should challenge the user with the proper www-authenticate header', function() {
      expect(response.headers['www-authenticate']).to.equal(expectedAuthRefreshTokenInvalidHeader);
    });
  });
});