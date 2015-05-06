var fs = require('fs');
var newLineItems = require('../data/lineItems/newLineItems');
var updatedLineItems = require('../data/lineItems/updatedLineItems');
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
          'quarter' in data &&
          'paymentMethodKey' in data &&
          'paymentMethodName' in data &&
          'accountName' in data &&
          'statusId' in data &&
          'isGoal' in data &&
          'lastUpdated' in data
         );
}

describe('Line Items', function() {
  
  before(function() {
    url = testUtils.GetRootURL();
  });
  
  describe('when a request is made to /lineItems/all', function() {
    
    before(function(done) {
      authorizedRequest.get( {url: url + '/lineItems/all' }, function (err, resp, body) {
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
      testUtils.TestStandardExpectationsForSuccessfulResult(results, 1);
      
      // list items are line items
      expect(IsALineItem(results.data[0])).to.be.true;
    });
  });
  
  describe('when a request is made to /lineItems/search', function() {
    
    before(function(done) {
      fs.createReadStream('./test/data/lineItems/searchCriteria.json').pipe(
        authorizedRequest.post( {url: url + '/lineItems/search' }, function (err, resp, body) {
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
      testUtils.TestStandardExpectationsForSuccessfulResult(results, 1);
      
      // list items are line items
      expect(IsALineItem(results.data[0])).to.be.true;
    });
    
    it ('should return the correct result for the given search criteria', function() {
      expect(results.data[0].amount).to.equal(-95.44);
      expect(results.data[0].description).to.equal('Test Line Item 178');
    });
  });
  
  describe('when a request is made to add line items (/lineItems/add)', function() {
    
    before(function(done) {
      fs.createReadStream('./test/data/lineItems/newLineItems.json').pipe(
        authorizedRequest.put( {url: url + '/lineItems/add' }, function (err, resp, body) {
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
      testUtils.TestStandardExpectationsForSuccessfulResult(results, 1);
      
      // test the standard expectations for a post result
      testUtils.TestStandardExpectationsForSuccessfulPutResult(results.data, newLineItems.data.length);      
    });
    
    it ('should have line item objects in the successful result', function() {
      expect(IsALineItem(results.data[0].data)).to.be.true;
    });
  });
  
  describe('when a request is made to update line items (/lineItems/update)', function() {
    
    before(function(done) {
      fs.createReadStream('./test/data/lineItems/updatedLineItems.json').pipe(
        authorizedRequest.put( {url: url + '/lineItems/update' }, function (err, resp, body) {
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
      testUtils.TestStandardExpectationsForSuccessfulResult(results, 1);
      
      // test the standard expectations for a post result
      testUtils.TestStandardExpectationsForSuccessfulPutResult(results.data, updatedLineItems.data.length);
             
      // test individual results for the update operation. We should expect 1 success and 1 failure due to no rows affected
      expect(results.data.filter( testUtils.TestSuccessfulResult ).length).to.be.above(0);
      
      expect(results.data.filter( testUtils.TestNoResultsResult ).length).to.be.above(0);
    });
    
    it ('should have line item objects in the successful result', function() {
      expect(IsALineItem(results.data[0].data)).to.be.true;
    });
  });
  
  describe('when a request is made to delete a line item', function() {
    
    before(function(done) {
      authorizedRequest.del( { url: url + '/lineItems/delete/47F4789B-E0F8-47EA-8CCB-983F2F06C88C' }, function(err, resp, body) {
        response = resp;
        results = JSON.parse(body);
        done(err);
      });
    });
    
    it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should return a success object with no items in the data array', function() {
      testUtils.TestStandardExpectationsForSuccessfulResult(results, 0);
    });
  });
  
  describe('when a request is made to add line items but has an invalid JSON body', function() {
    
    before(function(done) {
      fs.createReadStream('./test/data/invalidFormat.json').pipe(
        authorizedRequest.put( {url: url + '/lineItems/add' }, function (err, resp, body) {
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
  
  describe('when a request is made to update line items but has an invalid JSON body', function() {
    
    before(function(done) {
      fs.createReadStream('./test/data/invalidFormat.json').pipe(
        authorizedRequest.put( {url: url + '/lineItems/update' }, function (err, resp, body) {
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
	
	describe('when a request is made to search for line items but has an invalid JSON body', function() {
    
    before(function(done) {
      fs.createReadStream('./test/data/invalidFormat.json').pipe(
        authorizedRequest.post( {url: url + '/lineItems/search' }, function (err, resp, body) {
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
  
  describe('when a request is made to add a line item with incomplete data', function() {
    
    before(function(done) {
      fs.createReadStream('./test/data/lineItems/insufficientAddData.json').pipe(
        authorizedRequest.put( {url: url + '/lineItems/add' }, function (err, resp, body) {
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
  
  describe('when a request is made to update a line item with incomplete data', function() {
    
    before(function(done) {
      fs.createReadStream('./test/data/lineItems/insufficientUpdateData.json').pipe(
        authorizedRequest.put( {url: url + '/lineItems/update' }, function (err, resp, body) {
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

