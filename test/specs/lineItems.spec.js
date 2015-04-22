var fs = require('fs');
var newLineItems = require('../test-data/newLineItems');
var updatedLineItems = require('../test-data/updatedLineItems');
var url, response, results;
var authorizedRequest = testUtils.GetAuthorizedRequest();

var IsALineItem = function(data) {
  return ('uniqueKey' in data &&
          'year' in data &&
          'monthId' in data &&
          'month' in data &&
          'day' in data &&
          'dayOfWeekId' in data &&
          'dayOfWeek' in data &&
          'categoryKey' in data &&
          'categoryName' in data &&
          'subcategoryKey' in data &&
          'subcategoryName' in data &&
          'subcategoryPrefix' in data &&
          'description' in data &&
          'amount' in data &&
          'typeId' in data &&
          'subtypeId' in data &&
          'quarterId' in data &&
          'paymentMethodKey' in data &&
          'paymentMethodName' in data &&
          'accountName' in data &&
          'statusId' in data &&
          'isGoal' in data &&
          'lastUpdated' in data
         );
}

describe.skip('Line Items', function() {
  
  before(function() {
    url = testUtils.GetRootURL();
  });
  
  describe('when a request is made to /lineitems/all', function() {
    before(function(done) {
      authorizedRequest.get( {url: url + '/lineitems/all' }, function (err, resp, body) {
        response = resp;
        results = JSON.parse(body);
        done(err);
      });
    });
    
   it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should return a success object with a valid list of denormalized line items', function() {
      // test the standard expectations for a successful result
      testUtils.TestStandardExpectationsForSuccessfulResult(results);
      
      // list items are line items
      expect(IsALineItem(results.data[0])).to.be.true;
    });
  });
  
  describe('when a request is made to /lineitems/search', function() {
    before(function(done) {
      fs.createReadStream('./test/test-data/searchCriteria.json').pipe(
        authorizedRequest.get( {url: url + '/lineitems/search' }, function (err, resp, body) {
          response = resp;
          results = JSON.parse(body);
          done(err);
        })
      );
    });
    
   it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should return a success object with a valid list of denormalized line items', function() {
      // test the standard expectations for a successful result
      testUtils.TestStandardExpectationsForSuccessfulResult(results);
      
      // list items are line items
      expect(IsALineItem(results.data[0])).to.be.true;
    });
    
    it ('should return the correct result for the given search criteria', function() {
      expect(results.data[0].amount).to.equal(-95.44);
      expect(results.data[0].description).to.equal('Test Line Item 178');
    });
  });
  
  describe('when a request is made to add line items (/lineitems/add)', function() {
    before(function(done) {
      fs.createReadStream('./test/test-data/newLineItems.json').pipe(
        authorizedRequest.post( {url: url + '/lineitems/add' }, function (err, resp, body) {
          response = resp;
          results = JSON.parse(body);
          done(err);
        })
      );
    });
    
    it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should return a success object with a valid list of responses per line item added', function() {
      // test the standard expectations for a successful result
      testUtils.TestStandardExpectationsForSuccessfulResult(results);
      
      // test the standard expectations for a post result
      testUtils.TestStandardExpectationsForSuccessfulPostResult(results.data, newLineItems.data.length);      
    });
    
    it ('should have line item objects in the successful result', function() {
      expect(IsALineItem(results.data[0].data)).to.be.true;
    });
  });
  
  describe('when a request is made to update line items (/lineitems/update)', function() {
    before(function(done) {
      fs.createReadStream('./test/test-data/updatedLineItems.json').pipe(
        authorizedRequest.post( {url: url + '/lineitems/update' }, function (err, resp, body) {
          response = resp;
          results = JSON.parse(body);
          done(err);
        })
      );
    });
    
    it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should return a success object with a valid list of responses per line item updated', function() {
      // test the standard expectations for all results
      testUtils.TestStandardExpectationsForSuccessfulResult(results);
      
      // test the standard expectations for a post result
      testUtils.TestStandardExpectationsForSuccessfulPostResult(results.data, updatedLineItems.data.length);
             
      // test individual results for the update operation. We should expect 1 success and 1 failure due to no rows affected
      expect(results.data.filter( testUtils.TestSuccessfulResult ).length).to.be.above(0);
      
      expect(results.data.filter( testUtils.TestNoResultsResult ).length).to.be.above(0);
    });
    
    it ('should have line item objects in the successful result', function() {
      expect(IsALineItem(results.data[0].data)).to.be.true;
    });
  });
  
  describe('when a request is made to add line items but has invalid JSON post data', function() {
    
    before(function(done) {
      fs.createReadStream('./test/test-data/invalidFormat.json').pipe(
        authorizedRequest.post( {url: url + '/lineitems/add' }, function (err, resp, body) {
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
  
  describe('when a request is made to update line items but has invalid JSON post data', function() {
    
    before(function(done) {
      fs.createReadStream('./test/test-data/invalidFormat.json').pipe(
        authorizedRequest.post( {url: url + '/lineitems/update' }, function (err, resp, body) {
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