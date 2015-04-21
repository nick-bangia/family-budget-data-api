var fs = require('fs');
var newAccounts = require('../test-data/newAccounts');
var updatedAccounts = require('../test-data/updatedAccounts');
var url, response, results;
var authorizedRequest = testUtils.GetAuthorizedRequest();

var IsAnAccount = function(data) {
  return ('accountKey' in data &&
          'accountName' in data &&
          'isActive' in data &&
          'lastUpdated' in data
         );
}

describe('Accounts', function() {
  
  before(function() {
    url = testUtils.GetRootURL();
  });
  
  describe('when a request is made to /accounts/all', function() {
    before(function(done) {
      authorizedRequest.get( {url: url + '/accounts/all' }, function (err, resp, body) {
        response = resp;
        results = JSON.parse(body);
        done(err);
      });
    });
    
   it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should return a success object with a valid list of accounts', function() {
      // test the standard expectations for a successful result
      testUtils.TestStandardExpectationsForSuccessfulResult(results);
      
      // list items are accounts
      expect(IsAnAccount(results.data[0])).to.be.true;
    });
  });
  
  describe('when a request is made to add accounts (/accounts/add)', function() {
    before(function(done) {
      fs.createReadStream('./test/test-data/newAccounts.json').pipe(
        authorizedRequest.post( {url: url + '/accounts/add' }, function (err, resp, body) {
          response = resp;
          results = JSON.parse(body);
          done(err);
        })
      );
    });
    
    it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should return a success object with a valid list of responses per account added', function() {
      // test the standard expectations for a successful result
      testUtils.TestStandardExpectationsForSuccessfulResult(results);
      
      // test the standard expectations for a post result
      testUtils.TestStandardExpectationsForSuccessfulPostResult(results.data, newAccounts.data.length);      
    });
    
    it ('should have account objects in the successful result', function() {
      expect(IsAnAccount(results.data[0].data)).to.be.true;
    });
  });
  
  describe('when a request is made to update accounts (/accounts/update)', function() {
    before(function(done) {
      fs.createReadStream('./test/test-data/updatedAccounts.json').pipe(
        authorizedRequest.post( {url: url + '/accounts/update' }, function (err, resp, body) {
          response = resp;
          results = JSON.parse(body);
          done(err);
        })
      );
    });
    
    it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should return a success object with a valid list of responses per account updated', function() {
      // test the standard expectations for all results
      testUtils.TestStandardExpectationsForSuccessfulResult(results);
      
      // test the standard expectations for a post result
      testUtils.TestStandardExpectationsForSuccessfulPostResult(results.data, updatedAccounts.data.length);
             
      // test individual results for the update operation. We should expect 1 success and 1 failure due to no rows affected
      expect(results.data.filter( testUtils.TestSuccessfulResult ).length).to.be.above(0);
      
      expect(results.data.filter( testUtils.TestNoResultsResult ).length).to.be.above(0);
    });
    
    it ('should have Account objects in the successful result', function() {
      expect(IsAnAccount(results.data[0].data)).to.be.true;
    });
  });
  
  describe('when a request is made to add accounts but has invalid JSON post data', function() {
    
    before(function(done) {
      fs.createReadStream('./test/test-data/invalidFormat.json').pipe(
        authorizedRequest.post( {url: url + '/accounts/add' }, function (err, resp, body) {
          response = resp;
          results = JSON.parse(body);
          done(err);
        })
      );
    });
    
    it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should have a failure status with reason of "Request payload is incorrectly formatted"', function() {
      expect(results.status).to.equal('failure');
      expect(results.reason).to.have.string('Request payload is incorrectly formatted');
    });
  });
  
  describe('when a request is made to update accounts but has invalid JSON post data', function() {
    
    before(function(done) {
      fs.createReadStream('./test/test-data/invalidFormat.json').pipe(
        authorizedRequest.post( {url: url + '/accounts/update' }, function (err, resp, body) {
          response = resp;
          results = JSON.parse(body);
          done(err);
        })
      );
    });
    
    it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should have a failure status with reason of "Request payload is incorrectly formatted"', function() {
      expect(results.status).to.equal('failure');
      expect(results.reason).to.have.string('Request payload is incorrectly formatted');
    });
  });
});