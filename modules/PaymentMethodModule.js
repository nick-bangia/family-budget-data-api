// requires
var PaymentMethod = require('../model/PaymentMethod');
var PaymentMethodQueries = require('../queries/PaymentMethodQueries');
var Response = require('../framework/service/Response');
var DataUtils = require('../framework/service/DataUtils');
var ResponseUtils = require('../framework/service/ResponseUtils');

// constructor
function PaymentMethodModule(dbUtility) {
  this.dbUtility = dbUtility;
  var self = this;
  
  this.ConvertRowToPaymentMethod = function(row, callback) {
    // convert the given row into a PaymentMethod and push it to callback
    var pm = new PaymentMethod();

    pm.setPaymentMethodKey(row.PaymentMethodKey);
    pm.setPaymentMethodName(row.PaymentMethodName);
    pm.setIsActive(row.IsActive);
    pm.setLastUpdated(row.LastUpdatedDate);

    // push the PaymentMethod to callback
    callback(pm);
  }
  
  this.ReadSinglePaymentMethodFromDatabase = function(paymentMethodKey, callback) {
    // read a single payment method from the database given the key
    self.dbUtility.ReadSingleRowWithKey(PaymentMethodQueries.GetNewRowWithKey, [paymentMethodKey], function(readResult) {
      if (readResult.status == 'ok') {
        self.ConvertRowToPaymentMethod(readResult.data, function(pm) {
          readResult.setData(pm);
          callback(readResult);
        });
      } else {
        callback(readResult);
      }
    });
  }
  
  this.UpdatePaymentMethodInDatabase = function(paymentMethodObject, callback) {
    // convert the given object to a PaymentMethod and update it in the DB
    paymentMethodObject.__proto__ = PaymentMethod.prototype;
    var params = [paymentMethodObject.getPaymentMethodName(), paymentMethodObject.getIsActive(), paymentMethodObject.getPaymentMethodKey()];    
    
    self.dbUtility.SingleRowCUQueryWithParams(PaymentMethodQueries.UpdateRow, params, function(updateResult) {
      // once the update query is complete, get the updated row, and return to callback
      if (updateResult.status == 'ok') {
        // get the updated row
        self.ReadSinglePaymentMethodFromDatabase(paymentMethodObject.getPaymentMethodKey(), function(readResult) {
          callback(readResult);
        });
      } else {
        callback(updateResult);
      }
    });
  }
  
  this.InsertPaymentMethodInDatabase = function(paymentMethodObject, callback) {
    // convert the given object to a PaymentMethod and update it in the DB
    paymentMethodObject.__proto__ = PaymentMethod.prototype;
    var newKey = paymentMethodObject.getNewKey();
    var params = [newKey, paymentMethodObject.getPaymentMethodName(), paymentMethodObject.getIsActive()];
    
    self.dbUtility.SingleRowCUQueryWithParams(PaymentMethodQueries.InsertRow, params, function(insertResult) {
      // once the insert query is successful, get the newly inserted row, and return to callback
      if (insertResult.status == 'ok') {
        // get the new row
        self.ReadSinglePaymentMethodFromDatabase(newKey, function(readResult) {
          callback(readResult);
        });
      } else {
        callback(insertResult);
      }      
    });
  }
}

// public methods
PaymentMethodModule.prototype.GetAll = {
  get: function(request, response) {
    var self = this;
    
    this.dbUtility.SelectRows(PaymentMethodQueries.SelectAll, self.ConvertRowToPaymentMethod, 
      function(dbResponse) {
        // check if the query was successful
        if (dbResponse.getStatus() == "ok") {

          // if successful, get an array of PaymentMethods
          var dataUtils = new DataUtils();
          dataUtils.ProcessRowsInParallel(dbResponse.getData(), function(paymentMethods) {

            //  wrap it in a response object
            var getAllResponse = new Response();
            getAllResponse.setData(paymentMethods);
                  
            // serve the paymentMethods as JSON
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

PaymentMethodModule.prototype.UpdateList = {
  
  post: function(request, response) {
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
        dataUtils.ProcessList(request.body.data, self.UpdatePaymentMethodInDatabase, 
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

PaymentMethodModule.prototype.InsertList = {

  post: function(request, response) {
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
        dataUtils.ProcessList(request.body.data, self.InsertPaymentMethodInDatabase,
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
module.exports = PaymentMethodModule;
