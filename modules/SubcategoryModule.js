// requires
var Subcategory = require('../model/Subcategory');
var Response = require('../framework/service/Response');
var DataUtils = require('../framework/service/utils/DataUtils');
var ResponseUtils = require('../framework/service/utils/ResponseUtils');

// constructor
function SubcategoryModule(dbUtility, queries) {
  this.dbUtility = dbUtility;
	this.queries = queries;
  var self = this;
  
  this.ConvertRowToSubcategory = function(row, callback) {
    // convert the given row into a Subcategory and push it to callback
    var sc = new Subcategory();

    sc.setSubcategoryKey(row.SubcategoryKey);
    sc.setCategoryKey(row.CategoryKey);
    sc.setCategoryName(row.CategoryName);
    sc.setAccountKey(row.AccountKey);
    sc.setAccountName(row.AccountName);
    sc.setSubcategoryName(row.SubcategoryName);
    sc.setSubcategoryPrefix(row.SubcategoryPrefix);
    sc.setIsActive(row.IsActive);
    sc.setIsGoal(row.IsGoal);
    sc.setLastUpdated(row.LastUpdatedDate);

    // push the Subcategory to callback
    callback(sc);
  }
  
  this.ReadSingleSubcategoryFromDatabase = function(subcategoryKey, callback) {
    // read a single category from the database given the key
    self.dbUtility.ReadSingleRowWithKey(self.queries.GetRowWithKey, [subcategoryKey], function(readResult) {
      if (readResult.status == 'ok') {
        self.ConvertRowToSubcategory(readResult.data, function(sc) {
          readResult.setData(sc);
          callback(readResult);
        });
      } else {
        callback(readResult);
      }
    });
  }
  
  this.UpdateSubcategoryInDatabase = function(subcategoryObject, callback) {
    // convert the given object to a Subcategory and update it in the DB
    subcategoryObject.__proto__ = Subcategory.prototype;
    var params = [subcategoryObject.getCategoryKey(), subcategoryObject.getAccountKey(), 
                  subcategoryObject.getSubcategoryName(), subcategoryObject.getSubcategoryPrefix(),
                  subcategoryObject.getIsActive(), subcategoryObject.getIsGoal(), subcategoryObject.getSubcategoryKey()];    
    
    self.dbUtility.SingleRowCUDQueryWithParams(self.queries.UpdateRow, params, function(updateResult) {
      // once the update query is complete, get the updated row, and return to callback
      if (updateResult.status == 'ok') {
        // get the updated row
        self.ReadSingleSubcategoryFromDatabase(subcategoryObject.getSubcategoryKey(), function(readResult) {
          callback(readResult);
        });
      } else {
        callback(updateResult);
      }
    });
  }
  
  this.InsertSubcategoryInDatabase = function(subcategoryObject, callback) {
    // convert the given object to a Subcategory and update it in the DB
    subcategoryObject.__proto__ = Subcategory.prototype;
    var newKey = subcategoryObject.getNewKey();
    var params = [newKey, subcategoryObject.getCategoryKey(), subcategoryObject.getAccountKey(),
                  subcategoryObject.getSubcategoryName(), subcategoryObject.getSubcategoryPrefix(),
                  subcategoryObject.getIsActive(), subcategoryObject.getIsGoal()];
    
    self.dbUtility.SingleRowCUDQueryWithParams(self.queries.InsertRow, params, function(insertResult) {
      // once the insert query is successful, get the newly inserted row, and return to callback
      if (insertResult.status == 'ok') {
        // get the new row
        self.ReadSingleSubcategoryFromDatabase(newKey, function(readResult) {
          callback(readResult);
        });
      } else {
        callback(insertResult);
      }      
    });
  }
}

// public methods
SubcategoryModule.prototype.GetAll = {
  get: function(request, response) {
    var self = this;
    
    this.dbUtility.SelectRows(self.queries.SelectAll, self.ConvertRowToSubcategory, 
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

SubcategoryModule.prototype.UpdateList = {
  
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
        dataUtils.ProcessList(request.body.data, self.UpdateSubcategoryInDatabase, 
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

SubcategoryModule.prototype.InsertList = {

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
        dataUtils.ProcessList(request.body.data, self.InsertSubcategoryInDatabase,
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
module.exports = SubcategoryModule;
