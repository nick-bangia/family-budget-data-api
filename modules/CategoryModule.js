// requires
var Category = require('../model/Category');
var Response = require('../framework/service/Response');
var DataUtils = require('../framework/service/utils/DataUtils');
var ResponseUtils = require('../framework/service/utils/ResponseUtils');

// constructor
function CategoryModule(dbUtility, queries) {
  this.dbUtility = dbUtility;
	this.queries = queries;
  var self = this;
  
  this.ConvertRowToCategory = function(row, callback) {
    // convert the given row into a Category and push it to callback
    var cat = new Category();

    cat.setCategoryKey(row.CategoryKey);
    cat.setCategoryName(row.CategoryName);
    cat.setIsActive(row.IsActive);
    cat.setLastUpdated(row.LastUpdatedDate);

    // push the Category to callback
    callback(cat);
  }
  
  this.ReadSingleCategoryFromDatabase = function(categoryKey, callback) {
    // read a single category from the database given the key
    self.dbUtility.ReadSingleRowWithKey(self.queries.GetRowWithKey, [categoryKey], function(readResult) {
      if (readResult.status == 'ok') {
        self.ConvertRowToCategory(readResult.data, function(cat) {
          readResult.setData(cat);
          callback(readResult);
        });
      } else {
        callback(readResult);
      }
    });
  }
  
  this.UpdateCategoryInDatabase = function(categoryObject, callback) {
    // convert the given object to a Category and update it in the DB
    categoryObject.__proto__ = Category.prototype;
    var params = [categoryObject.getCategoryName(), categoryObject.getIsActive(), categoryObject.getCategoryKey()];    
    
    self.dbUtility.SingleRowCUQueryWithParams(self.queries.UpdateRow, params, function(updateResult) {
      // once the update query is complete, get the updated row, and return to callback
      if (updateResult.status == 'ok') {
        // get the updated row
        self.ReadSingleCategoryFromDatabase(categoryObject.getCategoryKey(), function(readResult) {
          callback(readResult);
        });
      } else {
        callback(updateResult);
      }
    });
  }
  
  this.InsertCategoryInDatabase = function(categoryObject, callback) {
    // convert the given object to a Category and update it in the DB
    categoryObject.__proto__ = Category.prototype;
    var newKey = categoryObject.getNewKey();
    var params = [newKey, categoryObject.getCategoryName(), categoryObject.getIsActive()];
    
    self.dbUtility.SingleRowCUQueryWithParams(self.queries.InsertRow, params, function(insertResult) {
      // once the insert query is successful, get the newly inserted row, and return to callback
      if (insertResult.status == 'ok') {
        // get the new row
        self.ReadSingleCategoryFromDatabase(newKey, function(readResult) {
          callback(readResult);
        });
      } else {
        callback(insertResult);
      }      
    });
  }
}

// public methods
CategoryModule.prototype.GetAll = {
  get: function(request, response) {
    var self = this;
    
    this.dbUtility.SelectRows(self.queries.SelectAll, self.ConvertRowToCategory, 
      function(dbResponse) {
        // check if the query was successful
        if (dbResponse.getStatus() == "ok") {

          // if successful, get an array of Categoriess
          var dataUtils = new DataUtils();
          dataUtils.ProcessRowsInParallel(dbResponse.getData(), function(categories) {

            //  wrap it in a response object
            var getAllResponse = new Response();
            getAllResponse.setData(categories);
                  
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

CategoryModule.prototype.UpdateList = {
  
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
        dataUtils.ProcessList(request.body.data, self.UpdateCategoryInDatabase, 
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

CategoryModule.prototype.InsertList = {

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
        dataUtils.ProcessList(request.body.data, self.InsertCategoryInDatabase,
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
module.exports = CategoryModule;
