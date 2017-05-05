var BaseModel = require('./BaseModel');
var CategoryBalance = require('./CategoryBalance');

function AccountBalance() {
	// initialize properties
  this.name = '';
  this.reconciledAmount = 0;
  this.pendingAmount = 0;
  this.latestTransactionDate = new Date();
  this.categories = [new CategoryBalance()];

  // subclass from BaseModel
  BaseModel.apply(this, arguments)
}

AccountBalance.prototype = new BaseModel();

AccountBalance.prototype.getName = function() {
  return this.Escape(this.name);
}

AccountBalance.prototype.setName = function(value) {
  this.name = value;
}

AccountBalance.prototype.getReconciledAmount = function() {
	return this.reconciledAmount;
}

AccountBalance.prototype.setReconciledAmount = function(value) {
	this.reconciledAmount = value;
}

AccountBalance.prototype.getPendingAmount = function() {
	return this.pendingAmount;
}

AccountBalance.prototype.setPendingAmount = function(value) {
	this.pendingAmount = value;
}

AccountBalance.prototype.getLatestTransactionDate = function() {
	return this.latestTransactionDate;
}

AccountBalance.prototype.setLatestTransactionDate = function(value) {
	this.latestTransactionDate = value;
}

AccountBalance.prototype.getCategories = function() {
  return this.categories;
}

AccountBalance.prototype.setCategories = function(value) {
  this.categories = value;
}

module.exports = AccountBalance;