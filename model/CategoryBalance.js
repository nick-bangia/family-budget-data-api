var SubcategoryBalance = require('./SubcategoryBalance');

function CategoryBalance() {
	this.accountName = '';
  this.categoryName = '';
	this.reconciledAmount = 0;
	this.pendingAmount = 0;
	this.latestTransactionDate = new Date();
  this.subcategories = [new SubcategoryBalance()];
}

CategoryBalance.prototype.getAccountName = function() {
	return this.accountName;
}

CategoryBalance.prototype.setAccountName = function(value) {
	this.accountName = value;
}

CategoryBalance.prototype.getCategoryName = function() {
	return this.categoryName;
}

CategoryBalance.prototype.setCategoryName = function(value) {
	this.categoryName = value;
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