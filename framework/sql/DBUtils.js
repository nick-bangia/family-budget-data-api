var mysql = require('mysql');
var Response = require('../service/Response');
var DataUtils = require('../service/DataUtils');

function DBUtils(credentials) {
  this.dbConnection = mysql.createConnection(credentials);
}

DBUtils.prototype.SelectRows = function(theQuery, rowProcessor, queryComplete) {

  this.dbConnection.query(theQuery, function(err, rows, fields) {
    
    var dbResponse = new Response();

    if (err) {
      // if an error occurs, set up the response object accordingly
      dbResponse.setStatus("failure");
      dbResponse.setReason(err.code);
      dbResponse.setData(err);
	  
	    // return to caller with response
	    queryComplete(dbResponse);
    } else {
      // otherwise, if successful, put the rows into the data variable
      var dataUtils = new DataUtils();
      dataUtils.TransformRowsToCallbacks(rows, rowProcessor, function(callbackArray) {
        dbResponse.setData(callbackArray);
		
		    // return to caller with response
		    queryComplete(dbResponse);
	    });
    }
  });
}

DBUtils.prototype.ReadSingleRowWithKey = function(theQuery, key, queryComplete) {
  // perform the query and return the first row
  this.dbConnection.query({
    sql: theQuery,
    values: key
  }, function (err, rows, fields) {
    // initialize a successful response
    var dbResponse = new Response();
    
    if (err) {
      // set the error response fields if a query error occurred
      dbResponse.setStatus('failure');
      dbResponse.setReason(err.code);
      dbResponse.setData([err, key]);
      
      // return to caller with error response
      queryComplete(dbResponse);
    } else {
      if (rows.length >= 1) {
        dbResponse.setData(rows[0]);
      } else {
        dbResponse.setStatus('failure');
        dbResponse.setReason('Query did not return any rows');
        dbResponse.setData(key);
      }
      
      queryComplete(dbResponse);
    }
  });
}

DBUtils.prototype.SingleRowCUQueryWithParams = function(theQuery, params, queryComplete) {
  
  // perform query with params
  this.dbConnection.query({
    sql: theQuery,
    values: params
  }, function (err, rows, fields) {
    // initialize a successful response
    var dbResponse = new Response();
    
    if (err) {
      // set the error response fields if a query error occurred
      dbResponse.setStatus("failure");
      dbResponse.setReason(err.code);
      dbResponse.setData([err, params]);
      
      // return the caller with error response
      queryComplete(dbResponse);
    } else {
      if (rows.affectedRows == 0) {
        // set the error response fields if no rows were affected
        dbResponse.setStatus("failure");
        dbResponse.setReason("Query did not affect any rows");
        dbResponse.setData(params);
      }
      // return to the caller with the success response
      queryComplete(dbResponse);
    }
  });
}

module.exports = DBUtils;
