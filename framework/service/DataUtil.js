var Response = require('./Response');

function DataUtil() {
}

DataUtil.prototype.ProcessRowsInSeries = function(callbacks, processingComplete) {
  var results = [];
  
  // Process each row one at a time using recursion on the processRow function
  // once complete (callback is no longer defined because the array is empty), call
  // processingComplete with results
  function processRow() {
    var callback = callbacks.shift();
    if(callback) {
      callback(function() {
        results.push(arguments[0]);
        processRow();
      });
    } else {
      // only executed when the callbacks array is empty
      processingComplete(results);
    }
  }
  // initial call to processRow to kickstart the process
  processRow();
}

DataUtil.prototype.ProcessRowsInParallel = function(callbacks, processingComplete) {
  var results = [];
  var result_count = 0;
  
  // asynchronously iterate through all callbacks and process each one into the array using the index
  // when the count of results reaches the length of the array, call on processingComplete with the results
  callbacks.forEach( function(callback, index) {
    callback( function() {
      results[index] = arguments[0];
      result_count++;
	  
      if (result_count == callbacks.length) {
        processingComplete(results);  
      }
    });
  });
}

DataUtil.prototype.TransformRowsToCallbacks = function(rows, rowProcessor, transformComplete) {
  var callbackArray = [];
	
  // iterate over each row, and create a row processor function with it
  rows.forEach(function(row, index) {
    callbackArray[index] = function(next) { rowProcessor(row, next) };
	
  if (rows.length == callbackArray.length) {
    // once the array has been built, call transformComplete
    transformComplete(callbackArray);
  }
  });
}

DataUtil.prototype.ProcessList = function(dataArray, rowProcessor, processingComplete) {
  var self = this;
  
  // iterate over each row, and process it with the rowProcessor
  self.TransformRowsToCallbacks(dataArray, rowProcessor, function(callbacks) {
    self.ProcessRowsInParallel(callbacks, function(processResults) {
      var processResponse = new Response();
      processResponse.setData(processResults);
      
      // since processing the list has completed, call processingComplete w/ results
      processingComplete(processResponse);
    });
  });
}

module.exports = DataUtil;
