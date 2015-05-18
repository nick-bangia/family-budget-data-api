// requires
var AccountBalance = require('../model/AccountBalance');
var CategoryBalance = require('../model/CategoryBalance');
var SubcategoryBalance = require('../model/SubcategoryBalance');
var Response = require('../framework/service/Response');
var DataUtils = require('../framework/service/utils/DataUtils');
var ResponseUtils = require('../framework/service/utils/ResponseUtils');

// constructor
function BudgetAllowanceModule(dbUtility, queries) {
  this.dbUtility = dbUtility;
	this.queries = queries;
  var self = this;
    
  this.GetAccountBalances = function(row, callback) {
    
    // initialize a AccountBalance with this Account's information
    var acctBalance = new AccountBalance();
    acctBalance.setAccountName(row.AccountName);
    acctBalance.setReconciledAmount(row.ReconciledAmount);
    acctBalance.setPendingAmount(row.PendingAmount);
    acctBalance.setLatestTransactionDate(row.LatestTransactionDate);
    
    // execute a second query to get the actual budget allowances for this given category
    self.dbUtility.SelectRowsWithParams(self.queries.SelectCategories, [acctBalance.getAccountName()], self.GetCategoryBalances, false,
      function(dbResponse) {
        // check if the query was successful
        if (dbResponse.getStatus() == "ok") {

          // if successful, get an array of CategoryBalances
          var dataUtils = new DataUtils();
          dataUtils.ProcessRowsInParallel(dbResponse.getData(), function(categoryBalances) {
            // assign the array of categoryBalances to acctBalance
            acctBalance.setCategories(categoryBalances);
            
            // send the categoryBalances to the callback
            callback(acctBalance);
          });
        } else {
            acctBalance.setCategories([]);
            // send the Account w/ allowances to the callback
            callback(acctBalance);
        }
      }
    );
  }   
  
  this.GetCategoryBalances = function(row, callback) {
    
    // initialize a CategoryBalance with this Category's information
    var catBalance = new CategoryBalance();
    catBalance.setAccountName(row.AccountName);
    catBalance.setCategoryName(row.CategoryName);
    catBalance.setReconciledAmount(row.ReconciledAmount);
    catBalance.setPendingAmount(row.PendingAmount);
    catBalance.setLatestTransactionDate(row.LatestTransactionDate);
    
    // execute a second query to get the actual budget allowances for this given category
    self.dbUtility.SelectRowsWithParams(
      self.queries.SelectSubcategories, 
      [catBalance.getAccountName(), catBalance.getCategoryName()], 
      self.ConvertRowToSubcategoryBalance,
      false,
      function(dbResponse) {
        // check if the query was successful
        if (dbResponse.getStatus() == "ok") {

          // if successful, get an array of SubcategoryBalances
          var dataUtils = new DataUtils();
          dataUtils.ProcessRowsInParallel(dbResponse.getData(), function(subcategoryBalances) {
            // assign the array of subcategoryBalances to catBalance
            catBalance.setSubcategories(subcategoryBalances);
            
            // send the Category w/ subcategory balances to the callback
            callback(catBalance);
          });
        } else {
            catBalance.setSubcategories([]);
            // send the Category balances w/ empty subcategory array to the callback
            callback(catBalance);
        }
      }
    );
  }
  
  this.ConvertRowToSubcategoryBalance = function(row, callback) {
    // populate a SubcategoryBalance with values from this row, and provide back to the callback
    var scBalance = new SubcategoryBalance();
    scBalance.setSubcategoryName(row.SubcategoryName);
    scBalance.setReconciledAmount(row.ReconciledAmount);
    scBalance.setPendingAmount(row.PendingAmount);
    scBalance.setLatestTransactionDate(row.LatestTransactionDate);
    
    // provide the scBalance back to callback
    callback(scBalance);
  }
}

// public methods
BudgetAllowanceModule.prototype.GetAll = {
  get: function(request, response) {
    var self = this;
    
    this.dbUtility.SelectRows(self.queries.SelectAccounts, self.GetAccountBalances, 
      function(dbResponse) {
        // check if the query was successful
        if (dbResponse.getStatus() == "ok") {

          // if successful, get an array of AccountBalances
          var dataUtils = new DataUtils();
          dataUtils.ProcessRowsInParallel(dbResponse.getData(), function(accountsWithAllowances) {

            //  wrap it in a response object
            var getAllResponse = new Response();
            getAllResponse.setData(accountsWithAllowances);
                  
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

BudgetAllowanceModule.prototype.Refresh = {
  get: function(request, response) {
    var self = this;
    
    this.dbUtility.ExecuteQuery(self.queries.Refresh, function(dbResponse) {
      // since this is just a simple DBQuery, just return the dbResponse directly
      response.serveJSON(dbResponse);
    });
  }
}

// export the module
module.exports = BudgetAllowanceModule;
