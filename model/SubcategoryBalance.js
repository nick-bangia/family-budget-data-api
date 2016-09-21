var BaseModel = require('./BaseModel');

function SubcategoryBalance() {
	// initialize properties
	this.subcategoryName = '';
	this.reconciledAmount = 0;
	this.pendingAmount = 0;
	this.latestTransactionDate = new Date();

	// subclass from BaseModel
	BaseModel.apply(this, arguments);
}

SubcategoryBalance.prototype = new BaseModel();

SubcategoryBalance.prototype.getSubcategoryName = function() {
	return this.subcategoryName;
}

SubcategoryBalance.prototype.setSubcategoryName = function(value) {
	this.subcategoryName = value;
}

SubcategoryBalance.prototype.getReconciledAmount = function() {
	return this.reconciledAmount;
}

SubcategoryBalance.prototype.setReconciledAmount = function(value) {
	this.reconciledAmount = value;
}

SubcategoryBalance.prototype.getPendingAmount = function() {
	return this.pendingAmount;
}

SubcategoryBalance.prototype.setPendingAmount = function(value) {
	this.pendingAmount = value;
}

SubcategoryBalance.prototype.getLatestTransactionDate = function() {
	return this.latestTransactionDate;
}

SubcategoryBalance.prototype.setLatestTransactionDate = function(value) {
	this.latestTransactionDate = value;
}

module.exports = SubcategoryBalance;