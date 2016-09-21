var BaseModel = require('./BaseModel');
var Random = require('random-js');

function KeyedObject() {
  // initialize the key property
  this.key = '';

  BaseModel.apply(this, arguments);
}

KeyedObject.prototype = new BaseModel();

KeyedObject.prototype.getNewKey = function() {
  return Random.uuid4(Random.engines.mt19937().autoSeed());
}

module.exports = KeyedObject;