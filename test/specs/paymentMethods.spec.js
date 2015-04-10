var fs = require('fs');
var newPaymentMethods = require('../test-data/newPaymentMethods');
var updatedPaymentMethods = require('../test-data/updatedPaymentMethods');
var PaymentMethod = require('../../model/PaymentMethod');
var url, response, results;
var authorizedRequest = testUtils.GetAuthorizedRequest();

var IsAPaymentMethod = function(data) {
  return ('paymentMethodKey' in data &&
          'paymentMethodName' in data &&
          'isActive' in data &&
          'lastUpdated' in data
         );
}

describe('PaymentMethods', function() {
  
  before(function() {
    url = testUtils.GetRootURL();
  });
  
  describe('when a request is made to /paymentMethods/all', function() {
    before(function(done) {
      authorizedRequest.get( {url: url + '/paymentMethods/all' }, function (err, resp, body) {
        response = resp;
        results = JSON.parse(body);
        done(err);
      });
    });
    
   it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should return a success object with a valid list of paymentMethods', function() {
      // test the standard expectations for a successful result
      testUtils.TestStandardExpectationsForSuccessfulResult(results);
      
      // list items are payment methods
      expect(IsAPaymentMethod(results.data[0])).to.be.true;
    });
  });
  
  describe('when a request is made to add payment methods (/paymentMethods/add)', function() {
    before(function(done) {
      fs.createReadStream('./test/test-data/newPaymentMethods.json').pipe(
        authorizedRequest.post( {url: url + '/paymentMethods/add' }, function (err, resp, body) {
          response = resp;
          results = JSON.parse(body);
          done(err);
        })
      );
    });
    
    it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should return a success object with a valid list of responses per payment method added', function() {
      // test the standard expectations for a successful result
      testUtils.TestStandardExpectationsForSuccessfulResult(results);
      
      // test the standard expectations for a post result
      testUtils.TestStandardExpectationsForSuccessfulPostResult(results.data, newPaymentMethods.data.length);      
    });
    
    it ('should have PaymentMethod objects in the successful result', function() {
      expect(IsAPaymentMethod(results.data[0].data)).to.be.true;
    });
  });
  
  describe('when a request is made to update payment methods (/paymentMethods/update)', function() {
    before(function(done) {
      fs.createReadStream('./test/test-data/updatedPaymentMethods.json').pipe(
        authorizedRequest.post( {url: url + '/paymentMethods/update' }, function (err, resp, body) {
          response = resp;
          results = JSON.parse(body);
          done(err);
        })
      );
    });
    
    it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should return a success object with a valid list of responses per payment method added', function() {
      // test the standard expectations for all results
      testUtils.TestStandardExpectationsForSuccessfulResult(results);
      
      // test the standard expectations for a post result
      testUtils.TestStandardExpectationsForSuccessfulPostResult(results.data, updatedPaymentMethods.data.length);
             
      // test individual results for the update operation. We should expect 1 success and 1 failure due to no rows affected
      expect(results.data.filter( testUtils.TestSuccessfulResult ).length).to.be.above(0);
      
      expect(results.data.filter( testUtils.TestNoResultsResult ).length).to.be.above(0);
    });
    
    it ('should have PaymentMethod objects in the successful result', function() {
      expect(IsAPaymentMethod(results.data[0].data)).to.be.true;
    });
  });
  
  describe('when a request is made to add payment methods but has invalid JSON post data', function() {
    
    before(function(done) {
      fs.createReadStream('./test/test-data/invalidFormat.json').pipe(
        authorizedRequest.post( {url: url + '/paymentMethods/add' }, function (err, resp, body) {
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
  
  describe('when a request is made to update payment methods but has invalid JSON post data', function() {
    
    before(function(done) {
      fs.createReadStream('./test/test-data/invalidFormat.json').pipe(
        authorizedRequest.post( {url: url + '/paymentMethods/update' }, function (err, resp, body) {
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