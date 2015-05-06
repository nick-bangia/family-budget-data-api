var fs = require('fs');
var newAccounts = require('../data/accounts/newAccounts');
var updatedAccounts = require('../data/accounts/updatedAccounts');
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
      testUtils.TestStandardExpectationsForSuccessfulResult(results, 1);
      
      // list items are accounts
      expect(IsAnAccount(results.data[0])).to.be.true;
    });
  });
  
  describe('when a request is made to add accounts (/accounts/add)', function() {
    before(function(done) {
      fs.createReadStream('./test/data/accounts/newAccounts.json').pipe(
        authorizedRequest.put( {url: url + '/accounts/add' }, function (err, resp, body) {
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
      testUtils.TestStandardExpectationsForSuccessfulResult(results, 1);
      
      // test the standard expectations for a put result
      testUtils.TestStandardExpectationsForSuccessfulPutResult(results.data, newAccounts.data.length);      
    });
    
    it ('should have account objects in the successful result', function() {
      expect(IsAnAccount(results.data[0].data)).to.be.true;
    });
  });
  
  describe('when a request is made to update accounts (/accounts/update)', function() {
    before(function(done) {
      fs.createReadStream('./test/data/accounts/updatedAccounts.json').pipe(
        authorizedRequest.put( {url: url + '/accounts/update' }, function (err, resp, body) {
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
      testUtils.TestStandardExpectationsForSuccessfulResult(results, 1);
      
      // test the standard expectations for a put result
      testUtils.TestStandardExpectationsForSuccessfulPutResult(results.data, updatedAccounts.data.length);
             
      // test individual results for the update operation. We should expect 1 success and 1 failure due to no rows affected
      expect(results.data.filter( testUtils.TestSuccessfulResult ).length).to.be.above(0);
      
      expect(results.data.filter( testUtils.TestNoResultsResult ).length).to.be.above(0);
    });
    
    it ('should have Account objects in the successful result', function() {
      expect(IsAnAccount(results.data[0].data)).to.be.true;
    });
  });
  
  describe('when a request is made to add accounts but has an invalid JSON body', function() {
    
    before(function(done) {
      fs.createReadStream('./test/data/invalidFormat.json').pipe(
        authorizedRequest.put( {url: url + '/accounts/add' }, function (err, resp, body) {
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
  
  describe('when a request is made to update accounts but has an invalid JSON body', function() {
    
    before(function(done) {
      fs.createReadStream('./test/data/invalidFormat.json').pipe(
        authorizedRequest.put( {url: url + '/accounts/update' }, function (err, resp, body) {
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
  
  describe('when a request is made to add an account with incomplete data', function() {
    
    before(function(done) {
      fs.createReadStream('./test/data/accounts/insufficientAddData.json').pipe(
        authorizedRequest.put( {url: url + '/accounts/add' }, function (err, resp, body) {
          response = resp;
          results = JSON.parse(body);
          done(err);
        })
      );
    });
    
    it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should have a failure status with reason of "Bad Input - Missing Required Fields!"', function() {
      expect(results.data[0].status).to.equal('failure');
      expect(results.data[0].reason).to.have.string('Bad Input - Missing Required Fields!');
    });
  });
  
  describe('when a request is made to update an account with incomplete data', function() {
    
    before(function(done) {
      fs.createReadStream('./test/data/accounts/insufficientUpdateData.json').pipe(
        authorizedRequest.put( {url: url + '/accounts/update' }, function (err, resp, body) {
          response = resp;
          results = JSON.parse(body);
          done(err);
        })
      );
    });
    
    it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should have a failure status with reason of "Bad Input - Missing Required Fields!"', function() {
      expect(results.data[0].status).to.equal('failure');
      expect(results.data[0].reason).to.have.string('Bad Input - Missing Required Fields!');
    });
  });
});