function SearchCriteria() {
  this.uniqueKey = 'nil';
  this.dateCompareOperator = 'nil';
  this.minDate = 'nil';
  this.maxDate = 'nil';
  this.year = 0;
  this.quarter = 0;
  this.month = 0;
  this.day = 0;
  this.dayOfWeek = 0;
  this.descriptionContains = 'nil';
  this.categoryKey = 'nil';
  this.subcategoryKey = 'nil';
  this.amountCompareOperator = 'nil';
  this.minAmount = -999999;
  this.maxAmount = 999999;
  this.type = -1;
  this.subtype = -1;
  this.paymentMethodKey = 'nil';
  this.status = -1;
  this.isTaxDeductible = false;
  this.updatedAfter = 'nil';
}

SearchCriteria.prototype.getUniqueKey = function() {
  return this.uniqueKey;
}

SearchCriteria.prototype.setUniqueKey = function(value) {
  this.uniqueKey = value;
}

SearchCriteria.prototype.getDateCompareOperator = function() {
  return this.dateCompareOperator;
}

SearchCriteria.prototype.setDateCompareOperator = function(value) {
  this.dateCompareOperator = value;
}

SearchCriteria.prototype.getMinDate = function() {
  return this.minDate;
}

SearchCriteria.prototype.setMinDate = function(value) {
  this.minDate = value;
}

SearchCriteria.prototype.getMaxDate = function() {
  return this.maxDate;
}

SearchCriteria.prototype.setMaxDate = function(value) {
  this.maxDate = value;
}

SearchCriteria.prototype.getYear = function() {
  return this.year;
}

SearchCriteria.prototype.setYear = function(value) {
  this.year = value;
}

SearchCriteria.prototype.getQuarter = function() {
  return this.quarter;
}

SearchCriteria.prototype.setQuarter = function(value) {
  this.quarter = value;
}

SearchCriteria.prototype.getMonth = function() {
  return this.month;
}

SearchCriteria.prototype.setMonth = function(value) {
  this.month = value;
}

SearchCriteria.prototype.getDay = function() {
  return this.day;
}

SearchCriteria.prototype.setDay = function(value) {
  this.day = value;
}

SearchCriteria.prototype.getDayOfWeek = function() {
  return this.dayOfWeek;
}

SearchCriteria.prototype.setDayOfWeek = function(value) {
  this.dayOfWeek = value;
}

SearchCriteria.prototype.getDescriptionContains = function() {
  return this.descriptionContains;
}

SearchCriteria.prototype.setDescriptionContains = function(value) {
  this.descriptionContains = value;
}

SearchCriteria.prototype.getCategoryKey = function() {
  return this.categoryKey;
}

SearchCriteria.prototype.setCategoryKey = function(value) {
  this.categoryKey = value;
}

SearchCriteria.prototype.getSubcategoryKey = function() {
  return this.subcategoryKey;
}

SearchCriteria.prototype.setSubcategoryKey = function(value) {
  this.subcategoryKey = value;
}

SearchCriteria.prototype.getAmountCompareOperator = function() {
  return this.amountCompareOperator;
}

SearchCriteria.prototype.setAmountCompareOperator = function(value) {
  this.amountCompareOperator = value;
}

SearchCriteria.prototype.getMinAmount = function() {
  return this.minAmount;
}

SearchCriteria.prototype.setMinAmount = function(value) {
  this.minAmount = value;
}

SearchCriteria.prototype.getMaxAmount = function() {
  return this.maxAmount;
}

SearchCriteria.prototype.setMaxAmount = function(value) {
  this.maxAmount = value;
}

SearchCriteria.prototype.getType = function() {
  return this.type;
}

SearchCriteria.prototype.setType = function(value) {
  this.type = value;
}

SearchCriteria.prototype.getSubtype = function() {
  return this.subtype;
}

SearchCriteria.prototype.setSubtype = function(value) {
  this.subtype = value;
}

SearchCriteria.prototype.getPaymentMethodKey = function() {
  return this.paymentMethodKey;
}

SearchCriteria.prototype.setPaymentMethodKey = function(value) {
  this.paymentMethodKey = value;
}

SearchCriteria.prototype.getStatus = function() {
  return this.status;
}

SearchCriteria.prototype.setStatus = function(value) {
  this.status = value;
}

SearchCriteria.prototype.getIsTaxDeductible = function() {
  return this.isTaxDeductible;
}

SearchCriteria.prototype.setIsTaxDeductible = function(value) {
  this.isTaxDeductible = value ? true : false;
}

SearchCriteria.prototype.getUpdatedAfter = function() {
  return this.updatedAfter;
}

SearchCriteria.prototype.setUpdatedAfter = function(value) {
  this.updatedAfter = value;
}

module.exports = SearchCriteria;