var CategoryBalance = require('./CategoryBalance');

function AccountBalance() {
	this.accountName = '';
  this.reconciledAmount = 0;
  this.pendingAmount = 0;
  this.latestTransactionDate = new Date();
  this.categories = [new CategoryBalance()];
}

AccountBalance.prototype.getAccountName = function() {
  return this.accountName;
}

AccountBalance.prototype.setAccountName = function(value) {
  this.accountName = value;
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