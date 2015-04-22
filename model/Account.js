var Random = require('random-js');

function Account() {
  // initialize properties
  this.accountKey = '';
  this.accountName = '';
  this.isActive = true;
  this.lastUpdated = new Date();
}

Account.prototype.getNewKey = function() {
  return Random.uuid4(Random.engines.mt19937().autoSeed());
}

Account.prototype.getAccountKey = function() {
  return this.accountKey;
}

Account.prototype.setAccountKey = function(value) {
  this.accountKey = value;
}

Account.prototype.getAccountName = function() {
  return this.accountName;
}

Account.prototype.setAccountName = function(value) {
  this.accountName = value;
}

Account.prototype.getIsActive = function() {
  return this.isActive;
}

Account.prototype.setIsActive = function(value) {
  this.isActive = value;
}

Account.prototype.getLastUpdated = function() {
  return this.lastUpdated;
}

Account.prototype.setLastUpdated = function(value) {
  this.lastUpdated = value;
}

module.exports = Account;