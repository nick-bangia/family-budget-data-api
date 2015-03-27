// requires
var PaymentMethod = require('../model/PaymentMethod');
var PaymentMethodQueries = require('../queries/PaymentMethodQueries');
var Response = require('../framework/service/Response');

// private shared functions
var ConvertRowToPaymentMethod = function(row, callback) {
  // convert the given row into a PaymentMethod and push it to callback
  var pm = new PaymentMethod();

  pm.setPaymentMethodKey(row.PaymentMethodKey);
  pm.setPaymentMethodName(row.PaymentMethodName);
  pm.setIsActive(row.IsActive);
  pm.setLastUpdated(row.LastUpdatedDate);

  // push the PaymentMethod to callback
  callback(pm);
}

var GetArrayFrom = function(rows, finished) {

  // initialize an array of PaymentMethods
  var paymentMethods = [];

  // loop throw rows and convert into PaymentMethod model
  rows.forEach(function(row) {
    ConvertRowToPaymentMethod(row, function(paymentMethod) {
      paymentMethods.push(paymentMethod);

      // check if the paymentMethods array is full
      if (paymentMethods.length == rows.length) {
        finished(paymentMethods);
      }
    });
  });
}

// constructor
function PaymentMethodModule(dbUtility) {
  this._dbUtility = dbUtility;
}

// public methods
PaymentMethodModule.prototype.GetAll = function(request, response) {
  
  this._dbUtility.SelectRows(PaymentMethodQueries.SelectAll, 
    function(dbResponse) {
      // check if the query was successful
      if (dbResponse.getStatus() == "ok") {

        // if successful, get an array of PaymentMethods
        GetArrayFrom(dbResponse.getData(), function(paymentMethods) {

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

// export the module
module.exports = PaymentMethodModule;
