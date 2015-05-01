var fs = require('fs');

function QueryUtils() { } 

QueryUtils.prototype.NormalizeQueries = function(queries, callback) {

	// loop through the queries object and test each entry for the string 'file://'
	// if exists, get the path from the value, and replace the entry with the file's contents
	for (queryKey in queries) {
		var querySet = queries[queryKey];
		for (key in querySet) {
			if (querySet[key].indexOf('file://') != -1) {
				var length = querySet[key].length;
				var queryPath = querySet[key].substring(7);
				var normalizedQuery = fs.readFileSync(queryPath, 'utf8');
				// replace the key's value with the query
				querySet[key] = normalizedQuery;
			}
		}
	}
	
	// once complete, pass the queries object to the callback
	callback(queries);
}

module.exports = QueryUtils;