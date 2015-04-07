var mysql = require('mysql');
var Response = require('../service/Response');
var DataUtil = require('../service/DataUtil');

function DBUtil(credentials) {
  this.dbConnection = mysql.createConnection(credentials);
}

DBUtil.prototype.SelectRows = function(theQuery, rowProcessor, queryComplete) {

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
      var dataUtil = new DataUtil();
      dataUtil.TransformRowsToCallbacks(rows, rowProcessor, function(callbackArray) {
        dbResponse.setData(callbackArray);
		
		    // return to caller with response
		    queryComplete(dbResponse);
	    });
    }
  });
}

DBUtil.prototype.SingleRowQueryWithParams = function(theQuery, params, queryComplete) {
  
  // perform query with params
  this.dbConnection.query({
    sql: theQuery,
    values: params
  }, function (err, rows, fields) {
    var dbResponse = new Response();
    
    if (err) {
      dbResponse.setStatus("failure");
      dbResponse.setReason(err.code);
      dbResponse.setData([err, params]);
      
      // return the caller with error response
      queryComplete(dbResponse);
    } else {
      if (rows.affectedRows >= 1) {
        dbResponse.setData(params);
      } else {
        dbResponse.setStatus("failure");
        dbResponse.setReason("Query did not affect any rows");
        dbResponse.setData(params);
      }
      // return to the caller with the success response
      queryComplete(dbResponse);
    }
  });
}

module.exports = DBUtil;
