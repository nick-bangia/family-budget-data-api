var fs = require('fs');
var url, response, results;
var authorizedRequest = testUtils.GetAuthorizedRequest();

var IsABudgetAllowance = function(data) {
  return ('name' in data &&
          'reconciledAmount' in data &&
          'pendingAmount' in data &&
          'latestTransactionDate' in data &&
          'items' in data &&
          'accountName' in data.items[0] &&
          'name' in data.items[0] &&
          'reconciledAmount' in data.items[0] &&
          'pendingAmount' in data.items[0] &&
          'latestTransactionDate' in data.items[0] &&
          'items' in data.items[0] &&
          'name' in data.items[0].items[0] &&
          'reconciledAmount' in data.items[0].items[0] &&
          'pendingAmount' in data.items[0].items[0] &&
          'latestTransactionDate' in data.items[0].items[0]
         );
}

describe('Budget Allowances', function() {
  
  before(function() {
    url = testUtils.GetRootURL();
  });
  
  describe('when a request is made to /allowances', function() {
    before(function(done) {
      authorizedRequest.get( {url: url + '/allowances' }, function (err, resp, body) {
        response = resp;
        results = JSON.parse(body);
        done(err);
      });
    });
    
    it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should return a success object with a valid list of budget allowances', function() {
      // test the standard expectations for a successful result
      testUtils.TestStandardExpectationsForSuccessfulResult(results, 1);
      
      // list items are budget allowances
      expect(IsABudgetAllowance(results.data[0])).to.be.true;
    });
  });
  
  describe('when a request is made to /refreshAllowances', function() {
    before(function(done) {
      authorizedRequest.get( {url: url + '/refreshAllowances' }, function(err, resp, body) {
        response = resp;
        results = JSON.parse(body);
        done(err);
      });
    });
    
    it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    })
    
    it ('should return a success object with a valid list of budget allowances', function() {
      // test the standard expectations for a successful result
      testUtils.TestStandardExpectationsForSuccessfulResult(results, 0);
    });
  });
});