var DatedObject = require('./DatedObject');
var Random = require('random-js');

function KeyedObject() {
  // initialize the key property
  this.key = '';

  // subclass from DatedObject
  DatedObject.apply(this, arguments);
}

KeyedObject.prototype = new DatedObject();

KeyedObject.prototype.getNewKey = function() {
  return Random.uuid4(Random.engines.mt19937().autoSeed());
}

module.exports = KeyedObject;