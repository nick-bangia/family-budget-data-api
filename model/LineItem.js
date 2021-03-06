var KeyedObject = require('./KeyedObject');
var Random = require('random-js');

function LineItem() {
  // initialize properties
  this.year = 2015;
  this.monthId = 1
  this.month = 'January';
  this.day = 1;
  this.dayOfWeekId = 1;
  this.dayOfWeek = 'Sunday';
  this.categoryKey = '';
  this.categoryName = '';
  this.subcategoryKey = '';
  this.subcategoryName = '';
  this.subcategoryPrefix = '';
  this.description = '';
  this.amount = 0.0;
  this.typeId = 0;
  this.subtypeId = 0;
  this.quarter = 1;
  this.paymentMethodKey = '';
  this.paymentMethodName = '';
  this.accountName = '';
  this.goalAmount = '';
  this.statusId = 0;
  this.isTaxDeductible = false;

  // subclass from KeyedObject
  KeyedObject.apply(this, arguments);
}

LineItem.prototype = new KeyedObject();

LineItem.prototype.getUniqueKey = function() {
  return this.key;
}

LineItem.prototype.setUniqueKey = function(value) {
  this.key = value;
}

LineItem.prototype.getYear = function() {
  return this.year;
}

LineItem.prototype.setYear = function(value) {
  this.year = value;
}

LineItem.prototype.getMonthId = function() {
  return this.monthId;
}

LineItem.prototype.setMonthId = function(value) {
  this.monthId = value;
}

LineItem.prototype.getMonth = function() {
  return this.month;
}

LineItem.prototype.setMonth = function(value) {
  this.month = value;
}

LineItem.prototype.getDay = function() {
  return this.day;
}

LineItem.prototype.setDay = function(value) {
  this.day = value;
}

LineItem.prototype.getDayOfWeekId = function() {
  return this.dayOfWeekId;
}

LineItem.prototype.setDayOfWeekId = function(value) {
  this.dayOfWeekId = value;
}

LineItem.prototype.getDayOfWeek = function() {
  return this.dayOfWeek;
}

LineItem.prototype.setDayOfWeek = function(value) {
  this.dayOfWeek = value;
}

LineItem.prototype.getCategoryKey = function() {
  return this.Escape(this.categoryKey);
}

LineItem.prototype.setCategoryKey = function(value) {
  this.categoryKey = value;
}

LineItem.prototype.getCategoryName = function() {
  return this.categoryName;
}

LineItem.prototype.setCategoryName = function(value) {
  this.categoryName = value;
}

LineItem.prototype.getSubcategoryKey = function() {
  return this.Escape(this.subcategoryKey);
}

LineItem.prototype.setSubcategoryKey = function(value) {
  this.subcategoryKey = value;
}

LineItem.prototype.getSubcategoryName = function() {
  return this.subcategoryName;
}

LineItem.prototype.setSubcategoryName = function(value) {
  this.subcategoryName = value;
}

LineItem.prototype.getSubcategoryPrefix = function() {
  return this.subcategoryPrefix;
}

LineItem.prototype.setSubcategoryPrefix = function(value) {
  this.subcategoryPrefix = value;
}

LineItem.prototype.getDescription = function() {
  return this.Escape(this.description);
}

LineItem.prototype.setDescription = function(value) {
  this.description = value;
}

LineItem.prototype.getAmount = function() {
  return this.amount;
}

LineItem.prototype.setAmount = function(value) {
  this.amount = value;
}

LineItem.prototype.getTypeId = function() {
  return this.typeId;
}

LineItem.prototype.setTypeId = function(value) {
  this.typeId = value;
}

LineItem.prototype.getSubtypeId = function() {
  return this.subtypeId;
}

LineItem.prototype.setSubtypeId = function(value) {
  this.subtypeId = value;
}

LineItem.prototype.getQuarter = function() {
  return this.quarter;
}

LineItem.prototype.setQuarter = function(value) {
  this.quarter = value;
}

LineItem.prototype.getPaymentMethodKey = function() {
  return this.Escape(this.paymentMethodKey);
}

LineItem.prototype.setPaymentMethodKey = function(value) {
  this.paymentMethodKey = value;
}

LineItem.prototype.getPaymentMethodName = function() {
  return this.paymentMethodName;
}

LineItem.prototype.setPaymentMethodName = function(value) {
  this.paymentMethodName = value;
}

LineItem.prototype.getAccountName = function() {
  return this.accountName;
}

LineItem.prototype.setAccountName = function(value) {
  this.accountName = value;
}

LineItem.prototype.getGoalAmount = function() {
  return this.goalAmount;
}

LineItem.prototype.setGoalAmount = function(value) {
  this.goalAmount = value;
}

LineItem.prototype.getStatusId = function() {
  return this.statusId;
}

LineItem.prototype.setStatusId = function(value) {
  this.statusId = value;
}

LineItem.prototype.getIsTaxDeductible = function() {
  return this.isTaxDeductible;
}

LineItem.prototype.setIsTaxDeductible = function(value) {
  this.isTaxDeductible = value ? true : false;
}

module.exports = LineItem;
