// requires
var PaymentMethod = require('../model/PaymentMethod');
var PaymentMethodQueries = require('../queries/PaymentMethodQueries');
var Response = require('../framework/service/Response');
var DataUtil = require('../framework/service/DataUtil');

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
  
  this.UpdatePaymentMethodInDatabase = function(paymentMethodObject, callback) {
    // convert the given object to a PaymentMethod and update it in the DB
    paymentMethodObject.__proto__ = PaymentMethod.prototype;
    var params = [paymentMethodObject.getPaymentMethodName(), paymentMethodObject.getIsActive(), paymentMethodObject.getLastUpdated(), paymentMethodObject.getPaymentMethodKey()];    
    
    self.dbUtility.SingleRowQueryWithParams(PaymentMethodQueries.UpdateRow, params, function(result) {
      // once the update query is complete, pass the result back to the processor
      callback(result);
    });
  }
  
  this.InsertPaymentMethodInDatabase = function(paymentMethodObject, callback) {
    // convert the given object to a PaymentMethod and update it in the DB
    paymentMethodObject.__proto__ = PaymentMethod.prototype;
    var params = [paymentMethodObject.getNewKey(), paymentMethodObject.getPaymentMethodName(), paymentMethodObject.getIsActive(), paymentMethodObject.getLastUpdated()];
    
    self.dbUtility.SingleRowQueryWithParams(PaymentMethodQueries.InsertRow, params, function(result) {
      // once the insert query is complete, pass the result back to the processor
      callback(result);
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
          var dataUtility = new DataUtil();
          dataUtility.ProcessRowsInParallel(dbResponse.getData(), function(paymentMethods) {

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
        var errorResponse = new Response();
        
        errorResponse.setStatus('failure');
        errorResponse.setReason('Request payload is incorrectly formatted - ' + request.parseError.message);
        errorResponse.setData(request.parseError);
        
        response.serveJSON(errorResponse);
      } else {
        // process data and serve response
        var dataUtil = new DataUtil();
        dataUtil.ProcessList(request.body.data, self.UpdatePaymentMethodInDatabase, 
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
        var errorResponse = new Response();
        
        errorResponse.setStatus('failure');
        errorResponse.setReason('Request payload is incorrectly formatted - ' + request.parseError.message);
        errorResponse.setData(request.parseError);
      
        response.serveJSON(updateResponse);
      } else {
        // process data and serve response
        var dataUtil = new DataUtil();
        dataUtil.ProcessList(request.body.data, self.InsertPaymentMethodInDatabase,
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
