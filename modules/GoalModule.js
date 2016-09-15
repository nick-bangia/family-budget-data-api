// requires
var Goal = require('../model/Goal');
var Response = require('../framework/service/Response');
var DataUtils = require('../framework/service/utils/DataUtils');
var ResponseUtils = require('../framework/service/utils/ResponseUtils');

// constructor
function GoalModule(dbUtility, queries) {
  this.dbUtility = dbUtility;
  this.queries = queries;
  var self = this;
  
  this.ConvertRowToGoal = function(row, callback) {
    // convert the given row into a Goal and push it to callback
    var g = new Goal();

    g.setGoalKey(row.GoalKey);
    g.setGoalName(row.GoalName);
    g.setGoalAmount(row.GoalAmount);
    g.setEstimatedCompletionDate(row.EstimatedCompletionDate);
    g.setLastUpdated(row.LastUpdatedDate);

    // push the Goal to callback
    callback(g);
  }
  
  this.ReadSingleGoalFromDatabase = function(goalKey, callback) {
    // read a single category from the database given the key
    self.dbUtility.ReadSingleRowWithKey(self.queries.GetRowWithKey, [goalKey], function(readResult) {
      if (readResult.status == 'ok') {
        self.ConvertRowToGoal(readResult.data, function(sc) {
          readResult.setData(sc);
          callback(readResult);
        });
      } else {
        callback(readResult);
      }
    });
  }
  
  this.UpdateGoalInDatabase = function(goalObject, callback) {
    // convert the given object to a Goal and update it in the DB
    goalObject.__proto__ = Goal.prototype;
    var params = [goalObject.getGoalAmount(), 
                  goalObject.getEstimatedCompletionDate(),
                  goalObject.getGoalKey()];
    
    self.dbUtility.SingleRowCUDQueryWithParams(self.queries.UpdateRow, params, function(updateResult) {
      // once the update query is complete, get the updated row, and return to callback
      console.log(updateResult);
      if (updateResult.status == 'ok') {
        // get the updated row
        self.ReadSingleGoalFromDatabase(goalObject.getGoalKey(), function(readResult) {
          callback(readResult);
        });
      } else {
        callback(updateResult);
      }
    });
  }               
  
  this.InsertGoalInDatabase = function(goalObject, callback) {
    // convert the given object to a Goal and update it in the DB
    goalObject.__proto__ = Goal.prototype;
    var newKey = goalObject.getNewKey();
    var params = [newKey, 
                  goalObject.getGoalAmount(),
                  goalObject.getEstimatedCompletionDate()];
    
    self.dbUtility.SingleRowCUDQueryWithParams(self.queries.InsertRow, params, function(insertResult) {
      // once the insert query is successful, get the newly inserted row, and return to callback
      if (insertResult.status == 'ok') {
        // get the new row
        self.ReadSingleGoalFromDatabase(newKey, function(readResult) {
          callback(readResult);
        });
      } else {
        callback(insertResult);
      }      
    });
  }
}

// public methods
GoalModule.prototype.GetAll = {
  get: function(request, response) {
    var self = this;
    
    this.dbUtility.SelectRows(self.queries.SelectAll, self.ConvertRowToGoal, 
      function(dbResponse) {
        // check if the query was successful
        if (dbResponse.getStatus() == "ok") {

          // if successful, get an array of Subcategories
          var dataUtils = new DataUtils();
          dataUtils.ProcessRowsInParallel(dbResponse.getData(), function(subcategories) {

            //  wrap it in a response object
            var getAllResponse = new Response();
            getAllResponse.setData(subcategories);
                  
            // serve the categories as JSON
            response.serveJSON(getAllResponse);
          });

        } else {
          // query failed, so return the failure response
          response.serveJSON(dbResponse);
        }
      }
    );
  }
}

GoalModule.prototype.UpdateList = {
  
  put: function(request, response) {
    var self = this;
    // process the request when it reaches its end
    request.once('end', function () {
      // test for a parse error, and setup the response object appropriately
      if (request.parseError) {
        var responseUtils = new ResponseUtils();
        responseUtils.GenerateParseErrorResponse(request.parseError, function(errorResponse) {
          // serve the errorResponse as JSON
          response.serveJSON(errorResponse);
          
        });
      } else {
        // process data and serve response
        var dataUtils = new DataUtils();
        dataUtils.ProcessList(request.body.data, self.UpdateGoalInDatabase, 
          function(updateResponse) {
            // serve the response back to caller
            response.serveJSON(updateResponse);
        });
      }
    });
    
    // allow the request to continue processing
    request.resume();
  }
}

GoalModule.prototype.InsertList = {

  put: function(request, response) {
    var self = this;
    // process the request when it reaches its end
    request.once('end', function() {
      // test for a parse error, and setup the response object appropriately
      if (request.parseError) {
        var responseUtils = new ResponseUtils();
        responseUtils.GenerateParseErrorResponse(request.parseError, function(errorResponse) {
          // serve the errorResponse as JSON
          response.serveJSON(errorResponse);
        });
        
      } else {
        // process data and serve response
        var dataUtils = new DataUtils();
        dataUtils.ProcessList(request.body.data, self.InsertGoalInDatabase,
          function(insertResponse) {
            // serve the response back to the caller
            response.serveJSON(insertResponse);
        });
      }
    });
  
    // allow the request to continue processing
    request.resume();
  }
}

// export the module
module.exports = GoalModule;
