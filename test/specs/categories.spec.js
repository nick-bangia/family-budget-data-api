var fs = require('fs');
var newCategories = require('../test-data/newCategories');
var updatedCategories = require('../test-data/updatedCategories');
var url, response, results;
var authorizedRequest = testUtils.GetAuthorizedRequest();

var IsACategory = function(data) {
  return ('categoryKey' in data &&
          'categoryName' in data &&
          'isActive' in data &&
          'lastUpdated' in data
         );
}

describe('Categories', function() {
  
  before(function() {
    url = testUtils.GetRootURL();
  });
  
  describe('when a request is made to /categories/all', function() {
    before(function(done) {
      authorizedRequest.get( {url: url + '/categories/all' }, function (err, resp, body) {
        response = resp;
        results = JSON.parse(body);
        done(err);
      });
    });
    
   it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should return a success object with a valid list of categories', function() {
      // test the standard expectations for a successful result
      testUtils.TestStandardExpectationsForSuccessfulResult(results, 1);
      
      // list items are categories
      expect(IsACategory(results.data[0])).to.be.true;
    });
  });
  
  describe('when a request is made to add categories (/categories/add)', function() {
    before(function(done) {
      fs.createReadStream('./test/test-data/newCategories.json').pipe(
        authorizedRequest.put( {url: url + '/categories/add' }, function (err, resp, body) {
          response = resp;
          results = JSON.parse(body);
          done(err);
        })
      );
    });
    
    it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should return a success object with a valid list of responses per category added', function() {
      // test the standard expectations for a successful result
      testUtils.TestStandardExpectationsForSuccessfulResult(results, 1);
      
      // test the standard expectations for a put result
      testUtils.TestStandardExpectationsForSuccessfulPutResult(results.data, newCategories.data.length);      
    });
    
    it ('should have category objects in the successful result', function() {
      expect(IsACategory(results.data[0].data)).to.be.true;
    });
  });
  
  describe('when a request is made to update categories (/categories/update)', function() {
    before(function(done) {
      fs.createReadStream('./test/test-data/updatedCategories.json').pipe(
        authorizedRequest.put( {url: url + '/categories/update' }, function (err, resp, body) {
          response = resp;
          results = JSON.parse(body);
          done(err);
        })
      );
    });
    
    it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should return a success object with a valid list of responses per category updated', function() {
      // test the standard expectations for all results
      testUtils.TestStandardExpectationsForSuccessfulResult(results, 1);
      
      // test the standard expectations for a put result
      testUtils.TestStandardExpectationsForSuccessfulPutResult(results.data, updatedCategories.data.length);
             
      // test individual results for the update operation. We should expect 1 success and 1 failure due to no rows affected
      expect(results.data.filter( testUtils.TestSuccessfulResult ).length).to.be.above(0);
      
      expect(results.data.filter( testUtils.TestNoResultsResult ).length).to.be.above(0);
    });
    
    it ('should have Category objects in the successful result', function() {
      expect(IsACategory(results.data[0].data)).to.be.true;
    });
  });
  
  describe('when a request is made to add categories but has an invalid JSON body', function() {
    
    before(function(done) {
      fs.createReadStream('./test/test-data/invalidFormat.json').pipe(
        authorizedRequest.put( {url: url + '/categories/add' }, function (err, resp, body) {
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
  
  describe('when a request is made to update categories but has an invalid JSON body', function() {
    
    before(function(done) {
      fs.createReadStream('./test/test-data/invalidFormat.json').pipe(
        authorizedRequest.put( {url: url + '/categories/update' }, function (err, resp, body) {
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