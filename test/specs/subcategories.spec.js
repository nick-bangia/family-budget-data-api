var fs = require('fs');
var newSubcategories = require('../test-data/newSubcategories');
var updatedSubcategories = require('../test-data/updatedSubcategories');
var url, response, results;
var authorizedRequest = testUtils.GetAuthorizedRequest();

var IsASubcategory = function(data) {
  return ('subcategoryKey' in data &&
          'categoryKey' in data &&
          'accountKey' in data &&
          'subcategoryName' in data &&
          'subcategoryPrefix' in data &&
          'isActive' in data &&
          'isGoal' in data &&
          'lastUpdated' in data
         );
}

describe.skip('Subcategories', function() {
  
  before(function() {
    url = testUtils.GetRootURL();
  });
  
  describe('when a request is made to /subcategories/all', function() {
    before(function(done) {
      authorizedRequest.get( {url: url + '/subcategories/all' }, function (err, resp, body) {
        response = resp;
        results = JSON.parse(body);
        done(err);
      });
    });
    
   it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should return a success object with a valid list of subcategories', function() {
      // test the standard expectations for a successful result
      testUtils.TestStandardExpectationsForSuccessfulResult(results);
      
      // list items are subcategories
      expect(IsASubcategory(results.data[0])).to.be.true;
    });
  });
  
  describe('when a request is made to add subcategories (/subcategories/add)', function() {
    before(function(done) {
      fs.createReadStream('./test/test-data/newSubcategories.json').pipe(
        authorizedRequest.post( {url: url + '/subcategories/add' }, function (err, resp, body) {
          response = resp;
          results = JSON.parse(body);
          done(err);
        })
      );
    });
    
    it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should return a success object with a valid list of responses per subcategory added', function() {
      // test the standard expectations for a successful result
      testUtils.TestStandardExpectationsForSuccessfulResult(results);
      
      // test the standard expectations for a post result
      testUtils.TestStandardExpectationsForSuccessfulPostResult(results.data, newSubcategories.data.length);      
    });
    
    it ('should have subcategory objects in the successful result', function() {
      expect(IsASubcategory(results.data[0].data)).to.be.true;
    });
  });
  
  describe('when a request is made to update subcategories (/subcategories/update)', function() {
    before(function(done) {
      fs.createReadStream('./test/test-data/updatedSubcategories.json').pipe(
        authorizedRequest.post( {url: url + '/subcategories/update' }, function (err, resp, body) {
          response = resp;
          results = JSON.parse(body);
          done(err);
        })
      );
    });
    
    it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should return a success object with a valid list of responses per subcategory updated', function() {
      // test the standard expectations for all results
      testUtils.TestStandardExpectationsForSuccessfulResult(results);
      
      // test the standard expectations for a post result
      testUtils.TestStandardExpectationsForSuccessfulPostResult(results.data, updatedSubcategories.data.length);
             
      // test individual results for the update operation. We should expect 1 success and 1 failure due to no rows affected
      expect(results.data.filter( testUtils.TestSuccessfulResult ).length).to.be.above(0);
      
      expect(results.data.filter( testUtils.TestNoResultsResult ).length).to.be.above(0);
    });
    
    it ('should have subcategory objects in the successful result', function() {
      expect(IsASubcategory(results.data[0].data)).to.be.true;
    });
  });
  
  describe('when a request is made to add subcategories but has invalid JSON post data', function() {
    
    before(function(done) {
      fs.createReadStream('./test/test-data/invalidFormat.json').pipe(
        authorizedRequest.post( {url: url + '/subcategories/add' }, function (err, resp, body) {
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
  
  describe('when a request is made to update subcategories but has invalid JSON post data', function() {
    
    before(function(done) {
      fs.createReadStream('./test/test-data/invalidFormat.json').pipe(
        authorizedRequest.post( {url: url + '/subcategories/update' }, function (err, resp, body) {
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