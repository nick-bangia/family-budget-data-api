var KeyedObject = require('./KeyedObject');
var Random = require('random-js');

function Account() {
  // initialize properties
  this.accountName = '';
  this.isActive = true;
  this.lastUpdated = new Date();

  // subclass from KeyedObject
  KeyedObject.apply(this, arguments);
}

Account.prototype = new KeyedObject();

Account.prototype.getAccountKey = function() {
  return this.key;
}

Account.prototype.setAccountKey = function(value) {
  this.key = value;
}

Account.prototype.getAccountName = function() {
  return this.dataUtils.Escape(this.accountName);
}

Account.prototype.setAccountName = function(value) {
  this.accountName = value;
}

Account.prototype.getIsActive = function() {
  return this.isActive;
}

Account.prototype.setIsActive = function(value) {
  this.isActive = value ? true : false;
}

Account.prototype.getLastUpdated = function() {
  return this.lastUpdated;
}

Account.prototype.setLastUpdated = function(value) {
  this.lastUpdated = value;
}

module.exports = Account;