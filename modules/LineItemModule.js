// requires
var LineItem = require('../model/LineItem');
var SearchCriteria = require('../model/SearchCriteria');
var Response = require('../framework/service/Response');
var DataUtils = require('../framework/service/utils/DataUtils');
var ResponseUtils = require('../framework/service/utils/ResponseUtils');

// constructor
function LineItemModule(dbUtility, queries) {
	this.dbUtility = dbUtility;
	this.queries = queries;
	var self = this;
	
	this.ConvertRowToLineItem = function(row, callback) {
    // convert the given row into a LineItem and push it to callback
    var item = new LineItem();
        
    item.setUniqueKey(row.UniqueKey);
    item.setYear(row.Year);
    item.setMonthId(row.MonthId);
    item.setMonth(row.MonthName);
		item.setDay(row.DayOfMonth);
		item.setDayOfWeekId(row.DayOfWeekId);
		item.setDayOfWeek(row.DayOfWeekName);
		item.setCategoryKey(row.CategoryKey);
		item.setCategoryName(row.CategoryName);
		item.setSubcategoryKey(row.SubcategoryKey);
		item.setSubcategoryName(row.SubcategoryName);
		item.setSubcategoryPrefix(row.SubcategoryPrefix);
		item.setDescription(row.Description);
		item.setAmount(row.Amount);
		item.setTypeId(row.TypeId);
		item.setSubtypeId(row.SubtypeId);
		item.setQuarter(row.Quarter);
		item.setPaymentMethodKey(row.PaymentMethodKey);
		item.setPaymentMethodName(row.PaymentMethodName);
		item.setAccountName(row.AccountName);
		item.setStatusId(row.StatusId);
		item.setIsGoal(row.IsGoal);
		item.setLastUpdated(row.LastUpdatedDate);

    // push the PaymentMethod to callback
    callback(item);
  }
  
  this.ReadSingleLineItemFromDatabase = function(uniqueKey, callback) {
    // read a single payment method from the database given the key
    self.dbUtility.ReadSingleRowWithKey(self.queries.GetRowWithKey, [uniqueKey], function(readResult) {
      if (readResult.status == 'ok') {
        self.ConvertRowToLineItem(readResult.data, function(item) {
          readResult.setData(item);
          callback(readResult);
        });
      } else {
        callback(readResult);
      }
    });
  }
  
  this.UpdateLineItemInDatabase = function(lineItemObject, callback) {
    // convert the given object to a LineItem and update it in the DB
    lineItemObject.__proto__ = LineItem.prototype;
    var params = [lineItemObject.getMonthId(), lineItemObject.getDay(), lineItemObject.getDayOfWeekId(), lineItemObject.getYear(),
									lineItemObject.getSubcategoryKey(), lineItemObject.getDescription(), lineItemObject.getAmount(), lineItemObject.getTypeId(),
									lineItemObject.getSubtypeId(), lineItemObject.getQuarter(), lineItemObject.getPaymentMethodKey(), lineItemObject.getStatusId(),
									lineItemObject.getUniqueKey()];
    
    self.dbUtility.SingleRowCUDQueryWithParams(self.queries.UpdateRow, params, function(updateResult) {
      // once the update query is complete, get the updated row, and return to callback
      if (updateResult.status == 'ok') {
        // get the updated row
        self.ReadSingleLineItemFromDatabase(lineItemObject.getUniqueKey(), function(readResult) {
          callback(readResult);
        });
      } else {
        callback(updateResult);
      }
    });
  }
  
  this.InsertLineItemInDatabase = function(lineItemObject, callback) {
    // convert the given object to a LineItem and insert into into the DB
    lineItemObject.__proto__ = LineItem.prototype;
    var newKey = lineItemObject.getNewKey();
    var params = [newKey, lineItemObject.getMonthId(), lineItemObject.getDay(), lineItemObject.getDayOfWeekId(), lineItemObject.getYear(),
									lineItemObject.getSubcategoryKey(), lineItemObject.getDescription(), lineItemObject.getAmount(), lineItemObject.getTypeId(),
									lineItemObject.getSubtypeId(), lineItemObject.getQuarter(), lineItemObject.getPaymentMethodKey(), lineItemObject.getStatusId()];
    
    self.dbUtility.SingleRowCUDQueryWithParams(self.queries.InsertRow, params, function(insertResult) {
      // once the insert query is successful, get the newly inserted row, and return to callback
      if (insertResult.status == 'ok') {
        // get the new row
        self.ReadSingleLineItemFromDatabase(newKey, function(readResult) {
          callback(readResult);
        });
      } else {
        callback(insertResult);
      }
    });
  }
  
  this.GetSearchParams = function(searchCriteria, callback) {
    // initialize the return params array
    var params = [];
    // get the searchCriteria object
    searchCriteria.__proto__ = SearchCriteria.prototype;
    
    // go through each search criteria, and check if it is the default value
    // if so, set the param to null, otherwise, set the param accordingly
    params[0]  = searchCriteria.getUniqueKey();
    params[1]  = searchCriteria.getDateCompareOperator();
    params[2]  = searchCriteria.getMinDate();
    params[3]  = searchCriteria.getMaxDate();
    params[4]  = searchCriteria.getYear();
    params[5]  = searchCriteria.getQuarter();
    params[6]  = searchCriteria.getMonth();
    params[7]  = searchCriteria.getDay();
    params[8]  = searchCriteria.getDayOfWeek();
    params[9]  = searchCriteria.getDescriptionContains() == undefined ? 
      null : '%' + searchCriteria.getDescriptionContains() + '%';
    params[10] = searchCriteria.getCategoryKey();
    params[11] = searchCriteria.getSubcategoryKey();
    params[12] = searchCriteria.getAmountCompareOperator();
    params[13] = searchCriteria.getMinAmount();
    params[14] = searchCriteria.getMaxAmount();
    params[15] = searchCriteria.getType();
    params[16] = searchCriteria.getSubtype();
    params[17] = searchCriteria.getPaymentMethodKey();
    params[18] = searchCriteria.getStatus();
    params[19] = searchCriteria.getUpdatedAfter();  
    
    callback(params);
  }
}

LineItemModule.prototype.GetAll = {
  get: function(request, response) {
    var self = this;
    
    this.dbUtility.SelectRows(self.queries.GetAllCondensed, self.ConvertRowToLineItem, 
      function(dbResponse) {
        // check if the query was successful
        if (dbResponse.getStatus() == "ok") {

          // if successful, get an array of LineItems
          var dataUtils = new DataUtils();
          dataUtils.ProcessRowsInParallel(dbResponse.getData(), function(lineItems) {

            //  wrap it in a response object
            var getAllResponse = new Response();
            getAllResponse.setData(lineItems);
                  
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

LineItemModule.prototype.UpdateList = {
  
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
        dataUtils.ProcessList(request.body.data, self.UpdateLineItemInDatabase, 
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

LineItemModule.prototype.InsertList = {

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
        dataUtils.ProcessList(request.body.data, self.InsertLineItemInDatabase,
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

LineItemModule.prototype.Search = {

  post: function(request, response) {
    var self = this;
    // process the request when it reaches the end
    request.once('end', function() {
      // test for a parse error, and setup the response object appropriately
      if (request.parseError) {
        var responseUtils = new ResponseUtils();
        responseUtils.GenerateParseErrorResponse(request.parseError, function(errorResponse) {
          // serve the error response as JSON
          response.serveJSON(errorResponse);
        });
      } else {
        // select the rows that qualify given the search criteria
        var searchCriteria = request.body.data[0];
        self.GetSearchParams(searchCriteria, function(params) {
          self.dbUtility.SelectRowsWithParams(self.queries.Search, params, self.ConvertRowToLineItem, 
            function(dbResponse) {
              // check if the query was successful
              if (dbResponse.getStatus() == "ok") {

                // if successful, get an array of LineItems
                var dataUtils = new DataUtils();
                dataUtils.ProcessRowsInParallel(dbResponse.getData(), function(lineItems) {

                  //  wrap it in a response object
                  var getAllResponse = new Response();
                  getAllResponse.setData(lineItems);
                        
                  // serve the categories as JSON
                  response.serveJSON(getAllResponse);
                });

              } else {
                // query failed, so return the failure response
                response.serveJSON(dbResponse);
              }
            }
          );
        });
      }
    });
    
    // allow the request to resume
    request.resume();
  }
}

LineItemModule.prototype.DeleteItem = {
  delete: function(request, response) {
    var self = this;
    
    this.dbUtility.SingleRowCUDQueryWithParams(self.queries.DeleteRow, [request.querystring.key], 
      function(deleteResult) {
        // simply serve the result back as JSON to the caller
        response.serveJSON(deleteResult);   
      }
    );
  }
}

module.exports = LineItemModule;  