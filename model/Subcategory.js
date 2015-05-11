var Random = require('random-js');

function Subcategory() {
  // initialize properties
  this.subcategoryKey = '';
  this.categoryKey = '';
  this.categoryName = '';
  this.accountKey = '';
  this.accountName = '';
  this.subcategoryName = '';
  this.subcategoryPrefix = '';
  this.isActive = true;
  this.isGoal = false;
  this.lastUpdated = new Date();
}

Subcategory.prototype.getNewKey = function() {
  return Random.uuid4(Random.engines.mt19937().autoSeed());
}

Subcategory.prototype.getSubcategoryKey = function() {
  return this.subcategoryKey;
}

Subcategory.prototype.setSubcategoryKey = function(value) {
  this.subcategoryKey = value;
}

Subcategory.prototype.getCategoryKey = function() {
  return this.categoryKey;
}

Subcategory.prototype.setCategoryKey = function(value) {
  this.categoryKey = value;
}

Subcategory.prototype.getCategoryName = function() {
  return this.categoryName;
}

Subcategory.prototype.setCategoryName = function(value) {
  this.categoryName = value;
}

Subcategory.prototype.getAccountKey = function() {
  return this.accountKey;
}

Subcategory.prototype.setAccountKey = function(value) {
  this.accountKey = value;
}

Subcategory.prototype.getAccountName = function() {
  return this.accountName;
}

Subcategory.prototype.setAccountName = function(value) {
  this.accountName = value;
}

Subcategory.prototype.getSubcategoryName = function() {
  return this.subcategoryName;
}

Subcategory.prototype.setSubcategoryName = function(value) {
  this.subcategoryName = value;
}

Subcategory.prototype.getSubcategoryPrefix = function() {
  return this.subcategoryPrefix;
}

Subcategory.prototype.setSubcategoryPrefix = function(value) {
  this.subcategoryPrefix = value;
}

Subcategory.prototype.getIsActive = function() {
  return this.isActive;
}

Subcategory.prototype.setIsActive = function(value) {
  this.isActive = value ? true : false;
}

Subcategory.prototype.getIsGoal = function() {
  return this.isGoal;
}

Subcategory.prototype.setIsGoal = function(value) {
  this.isGoal = value ? true : false;
}

Subcategory.prototype.getLastUpdated = function() {
  return this.lastUpdated;
}

Subcategory.prototype.setLastUpdated = function(value) {
  this.lastUpdated = value;
}

module.exports = Subcategory;