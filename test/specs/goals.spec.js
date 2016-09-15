var fs = require('fs');
var newGoals = require('../data/goals/newGoals');
var updatedGoals = require('../data/goals/updatedGoals');
var url, response, results;
var authorizedRequest = testUtils.GetAuthorizedRequest();

var IsAGoal = function(data) {
  return ('goalKey' in data &&
          'goalAmount' in data &&
          'estimatedCompletionDate' in data &&
          'lastUpdated' in data
         );
}

describe('Goals', function() {
  
  before(function() {
    url = testUtils.GetRootURL();
  });
  
  describe('when a request is made to /goals/all', function() {
    before(function(done) {
      authorizedRequest.get( {url: url + '/goals/all' }, function (err, resp, body) {
        response = resp;
        results = JSON.parse(body);
        done(err);
      });
    });
    
   it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should return a success object with a valid list of goals', function() {
      // test the standard expectations for a successful result
      testUtils.TestStandardExpectationsForSuccessfulResult(results, 1);
      
      // list items are goals
      expect(IsAGoal(results.data[0])).to.be.true;
    });
  });
  
  describe('when a request is made to add goals (/goals/add)', function() {
    before(function(done) {
      fs.createReadStream('./test/data/goals/newGoals.json').pipe(
        authorizedRequest.put( {url: url + '/goals/add' }, function (err, resp, body) {
          response = resp;
          results = JSON.parse(body);
          done(err);
        })
      );
    });
    
    it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should return a success object with a valid list of responses per goal added', function() {
      // test the standard expectations for a successful result
      testUtils.TestStandardExpectationsForSuccessfulResult(results, 1);
      
      // test the standard expectations for a put result
      testUtils.TestStandardExpectationsForSuccessfulPutResult(results.data, newSubcategories.data.length);      
    });
    
    it ('should have goal objects in the successful result', function() {
      expect(IsAGoal(results.data[0].data)).to.be.true;
    });
  });
  
  describe('when a request is made to update goals (/goals/update)', function() {
    before(function(done) {
      fs.createReadStream('./test/data/goals/updatedGoals.json').pipe(
        authorizedRequest.put( {url: url + '/goals/update' }, function (err, resp, body) {
          response = resp;
          results = JSON.parse(body);
          done(err);
        })
      );
    });
    
    it ('should be authorized & OK', function() {
      expect(response.statusCode).to.equal(200);
    });
    
    it ('should return a success object with a valid list of responses per goal updated', function() {
      // test the standard expectations for all results
      testUtils.TestStandardExpectationsForSuccessfulResult(results, 1);
      
      // test the standard expectations for a put result
      testUtils.TestStandardExpectationsForSuccessfulPutResult(results.data, updatedGoals.data.length);
             
      // test individual results for the update operation. We should expect 1 success and 1 failure due to no rows affected
      expect(results.data.filter( testUtils.TestSuccessfulResult ).length).to.be.above(0);
      
      expect(results.data.filter( testUtils.TestNoResultsResult ).length).to.be.above(0);
    });
    
    it ('should have goal objects in the successful result', function() {
      expect(IsAGoal(results.data[0].data)).to.be.true;
    });
  });
  
  describe('when a request is made to add goal but has an invalid JSON body', function() {
    
    before(function(done) {
      fs.createReadStream('./test/data/invalidFormat.json').pipe(
        authorizedRequest.put( {url: url + '/goals/add' }, function (err, resp, body) {
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
  
  describe('when a request is made to update goals but has an invalid JSON body', function() {
    
    before(function(done) {
      fs.createReadStream('./test/data/invalidFormat.json').pipe(
        authorizedRequest.put( {url: url + '/goals/update' }, function (err, resp, body) {
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
  
  describe('when a request is made to add a goal with incomplete data', function() {
    
    before(function(done) {
      fs.createReadStream('./test/data/goals/insufficientAddData.json').pipe(
        authorizedRequest.put( {url: url + '/goals/add' }, function (err, resp, body) {
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
  
  describe('when a request is made to update a goals with incomplete data', function() {
    
    before(function(done) {
      fs.createReadStream('./test/data/goals/insufficientUpdateData.json').pipe(
        authorizedRequest.put( {url: url + '/goals/update' }, function (err, resp, body) {
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