var url, invalidCredentials, validCredentials, expectedWWWAuthenticateHeader, response, results;

describe('Authorization Testing', function() {
  before(function () {
    url = testUtils.GetRootURL() + '/ping';
    invalidCredentials = testUtils.GetInvalidCredentials();
    validCredentials = testUtils.GetValidCredentials();
    expectedWWWAuthenticateHeader = testUtils.GetExpectedWWWAuthenticateHeader();
  });

  describe('when no authorization header is present', function() {
    before(function(done) {
      request.get( {url: url }, function(err, resp, body) {
        response = resp;
        done(err);        
      });
    });
    
    it ('should not be authorized', function() {
      expect(response.statusCode).to.equal(401);
    });
    
    it ('should challenge the user with a www-authenticate header', function() {
      expect(response.headers['www-authenticate']).to.be.ok;
    });
  });
  
  describe('when an invalid authorization credentials are used', function() {
    before(function(done) {
      request.get( {url: url}, function(err, resp, body) {
        response = resp;
        done(err);
      }).auth(invalidCredentials.Username, invalidCredentials.Password);
    });
    
    it ('should not be authorized', function() {
      expect(response.statusCode).to.equal(401);
    });
    
    it ('should challenge the user with a www-authenticate header', function() {
      expect(response.headers['www-authenticate']).to.equal(expectedWWWAuthenticateHeader);
    });
  });
  
  describe('when a valid authorization header is present', function() {
    before(function(done) {
      request.get( {url: url}, function(err, resp, body) {
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
      testUtils.TestStandardExpectationsForSuccessfulResult(results);
    });
    
    it ('should have an entry in the data property of "isAuthorized: true"', function () {
      expect(results.data[0].isAuthorized).to.be.true;
    });
  });
});