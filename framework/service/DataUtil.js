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
  // initial call to processRow to kickstart the process, if callbacks has members
  if (callbacks.length == 0) {
    // if no callbacks (no rows), exit gracefully with empty results
    processingComplete(results);
  } else {
    // otherwise, begin the serial processing
    processRow();
  }
}

DataUtil.prototype.ProcessRowsInParallel = function(callbacks, processingComplete) {
  var results = [];
  var result_count = 0;
  
  // asynchronously iterate through all callbacks and process each one into the array using the index
  // when the count of results reaches the length of the array, call on processingComplete with the results
  if (callbacks.length == 0) {
    // if there are no callbacks (no rows to process), exit gracefully with the empty array
    processingComplete(results);
  } else {
    callbacks.forEach( function(callback, index) {
      callback( function() {
        results[index] = arguments[0];
        result_count++;
        
        // only when the results length equals the number of callbacks (rows), should we be done
        if (result_count == callbacks.length) {
          processingComplete(results);  
        }
      });
    });
  }
}

DataUtil.prototype.TransformRowsToCallbacks = function(rows, rowProcessor, transformComplete) {
  var callbackArray = [];
	
  // iterate over each row, and create a row processor function with it
  if (rows.length == 0) {
    // if no rows exist, return the empty array
    transformComplete(callbackArray);
  } else {
    rows.forEach(function(row, index) {
      callbackArray[index] = function(next) { rowProcessor(row, next) };
    
      // only when the callbackArray has been fully built should we be done
      if (rows.length == callbackArray.length) {
        // once the array has been built, call transformComplete
        transformComplete(callbackArray);
      }
    });
  }
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
