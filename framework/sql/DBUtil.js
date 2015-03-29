var mysql = require('mysql');
var Response = require('../service/Response');

function DBUtil(credentials) {
  this.dbConnection = mysql.createConnection(credentials);
}

DBUtil.prototype.SelectRows = function(theQuery, processRows) {

  this.dbConnection.query(theQuery, function(err, rows, fields) {
    
    var dbResponse = new Response();

    if (err) {
      // if an error occurs, set up the response object accordingly
      dbResponse.setStatus("failure");
      dbResponse.setReason(err.code);
      dbResponse.setData(err);
    } else {
      // otherwise, if successful, put the rows into the data variable
      dbResponse.setData(rows);
    }

    processRows(dbResponse);
  });
}

module.exports = DBUtil;
