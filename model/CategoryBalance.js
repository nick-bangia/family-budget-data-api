var BaseModel = require('./BaseModel');
var SubcategoryBalance = require('./SubcategoryBalance');

function CategoryBalance() {
  // initialize properties
  this.accountName = '';
  this.categoryName = '';
  this.reconciledAmount = 0;
  this.pendingAmount = 0;
  this.latestTransactionDate = new Date();
  this.subcategories = [new SubcategoryBalance()];

  // subclass from BaseModel
  BaseModel.apply(this, arguments);
}

CategoryBalance.prototype = new BaseModel();

CategoryBalance.prototype.getAccountName = function() {
	return this.Escape(this.accountName);
}

CategoryBalance.prototype.setAccountName = function(value) {
	this.accountName = value;
}

CategoryBalance.prototype.getName = function() {
	return this.Escape(this.name);
}

CategoryBalance.prototype.setName = function(value) {
	this.name = value;
}

CategoryBalance.prototype.getReconciledAmount = function() {
	return this.reconciledAmount;
}

CategoryBalance.prototype.setReconciledAmount = function(value) {
	this.reconciledAmount = value;
}

CategoryBalance.prototype.getPendingAmount = function() {
	return this.pendingAmount;
}

CategoryBalance.prototype.setPendingAmount = function(value) {
	this.pendingAmount = value;
}

CategoryBalance.prototype.getLatestTransactionDate = function() {
	return this.latestTransactionDate;
}

CategoryBalance.prototype.setLatestTransactionDate = function(value) {
	this.latestTransactionDate = value;
}

CategoryBalance.prototype.getSubcategories = function() {
	return this.subcategories;
}

CategoryBalance.prototype.setSubcategories = function(value) {
	this.subcategories = value;
}

module.exports = CategoryBalance;