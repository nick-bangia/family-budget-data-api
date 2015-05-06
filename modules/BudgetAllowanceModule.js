// requires
var BudgetAllowance = require('../model/BudgetAllowance');
var Response = require('../framework/service/Response');
var DataUtils = require('../framework/service/utils/DataUtils');
var ResponseUtils = require('../framework/service/utils/ResponseUtils');

// constructor
function BudgetAllowanceModule(dbUtility, queries) {
  this.dbUtility = dbUtility;
	this.queries = queries;
  var self = this;
  
  this.ConvertRowToBudgetAllowance = function(row, callback) {
    // convert the given row into a BudgetAllowance and push it to callback
    var ba = new BudgetAllowance();

    ba.setCategoryName(row.CategoryName);
    ba.setSubcategoryName(row.SubcategoryName);
    ba.setReconciledAmount(row.ReconciledAmount);
    ba.setPendingAmount(row.PendingAmount);
    ba.setLatestTransactionDate(row.LatestTransactionDate);

    // push the Account to callback
    callback(ba);
  }
}

// public methods
BudgetAllowanceModule.prototype.GetAll = {
  get: function(request, response) {
    var self = this;
    
    this.dbUtility.SelectRows(self.queries.SelectAll, self.ConvertRowToBudgetAllowance, 
      function(dbResponse) {
        // check if the query was successful
        if (dbResponse.getStatus() == "ok") {

          // if successful, get an array of BudgetAllowances
          var dataUtils = new DataUtils();
          dataUtils.ProcessRowsInParallel(dbResponse.getData(), function(allowances) {

            //  wrap it in a response object
            var getAllResponse = new Response();
            getAllResponse.setData(allowances);
                  
            // serve the allowances as JSON
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

// export the module
module.exports = BudgetAllowanceModule;
