// requires
var Account = require('../model/Account');
var Response = require('../framework/service/Response');
var DataUtils = require('../framework/service/utils/DataUtils');
var ResponseUtils = require('../framework/service/utils/ResponseUtils');

// constructor
function AccountModule(dbUtility, queries) {
  this.dbUtility = dbUtility;
	this.queries = queries;
  var self = this;
  
  this.ConvertRowToAccount = function(row, callback) {
    // convert the given row into a Account and push it to callback
    var acc = new Account();

    acc.setAccountKey(row.AccountKey);
    acc.setAccountName(row.AccountName);
    acc.setIsActive(row.IsActive);
    acc.setLastUpdated(row.LastUpdatedDate);

    // push the Account to callback
    callback(acc);
  }
  
  this.ReadSingleAccountFromDatabase = function(accountKey, callback) {
    // read a single account from the database given the key
    self.dbUtility.ReadSingleRowWithKey(self.queries.GetRowWithKey, [accountKey], function(readResult) {
      if (readResult.status == 'ok') {
        self.ConvertRowToAccount(readResult.data, function(acc) {
          readResult.setData(acc);
          callback(readResult);
        });
      } else {
        callback(readResult);
      }
    });
  }
  
  this.UpdateAccountInDatabase = function(accountObject, callback) {
    // convert the given object to a Account and update it in the DB
    accountObject.__proto__ = Account.prototype;
    var params = [accountObject.getAccountName(), accountObject.getIsActive(), accountObject.getAccountKey()];    
    
    self.dbUtility.SingleRowCUQueryWithParams(self.queries.UpdateRow, params, function(updateResult) {
      // once the update query is complete, get the updated row, and return to callback
      if (updateResult.status == 'ok') {
        // get the updated row
        self.ReadSingleAccountFromDatabase(accountObject.getAccountKey(), function(readResult) {
          callback(readResult);
        });
      } else {
        callback(updateResult);
      }
    });
  }
  
  this.InsertAccountInDatabase = function(accountObject, callback) {
    // convert the given object to a Account and update it in the DB
    accountObject.__proto__ = Account.prototype;
    var newKey = accountObject.getNewKey();
    var params = [newKey, accountObject.getAccountName(), accountObject.getIsActive()];
    
    self.dbUtility.SingleRowCUQueryWithParams(self.queries.InsertRow, params, function(insertResult) {
      // once the insert query is successful, get the newly inserted row, and return to callback
      if (insertResult.status == 'ok') {
        // get the new row
        self.ReadSingleAccountFromDatabase(newKey, function(readResult) {
          callback(readResult);
        });
      } else {
        callback(insertResult);
      }      
    });
  }
}

// public methods
AccountModule.prototype.GetAll = {
  get: function(request, response) {
    var self = this;
    
    this.dbUtility.SelectRows(self.queries.SelectAll, self.ConvertRowToAccount, 
      function(dbResponse) {
        // check if the query was successful
        if (dbResponse.getStatus() == "ok") {

          // if successful, get an array of Accounts
          var dataUtils = new DataUtils();
          dataUtils.ProcessRowsInParallel(dbResponse.getData(), function(accounts) {

            //  wrap it in a response object
            var getAllResponse = new Response();
            getAllResponse.setData(accounts);
                  
            // serve the accounts as JSON
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

AccountModule.prototype.UpdateList = {
  
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
        dataUtils.ProcessList(request.body.data, self.UpdateAccountInDatabase, 
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

AccountModule.prototype.InsertList = {

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
        dataUtils.ProcessList(request.body.data, self.InsertAccountInDatabase,
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
module.exports = AccountModule;
