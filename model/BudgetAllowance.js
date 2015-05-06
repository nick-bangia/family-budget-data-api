function BudgetAllowance() {
	this.categoryName = '';
	this.subcategoryName = '';
	this.reconciledAmount = 0;
	this.pendingAmount = 0;
	this.latestTransactionDate = '2015-01-01';
}

BudgetAllowance.prototype.getCategoryName = function() {
	return this.categoryName;
}

BudgetAllowance.prototype.setCategoryName = function(value) {
	this.categoryName = value;
}

BudgetAllowance.prototype.getSubcategoryName = function() {
	return this.subcategoryName;
}

BudgetAllowance.prototype.setSubcategoryName = function(value) {
	this.subcategoryName = value;
}

BudgetAllowance.prototype.getReconciledAmount = function() {
	return this.reconciledAmount;
}

BudgetAllowance.prototype.setReconciledAmount = function(value) {
	this.reconciledAmount = value;
}

BudgetAllowance.prototype.getPendingAmount = function() {
	return this.pendingAmount;
}

BudgetAllowance.prototype.setPendingAmount = function(value) {
	this.pendingAmount = value;
}

BudgetAllowance.prototype.getLatestTransactionDate = function() {
	return this.latestTransactionDate;
}

BudgetAllowance.prototype.setLatestTransactionDate = function(value) {
	this.latestTransactionDate = value;
}

module.exports = BudgetAllowance;