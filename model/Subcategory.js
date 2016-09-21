var KeyedObject = require('./KeyedObject');
var Random = require('random-js');

function Subcategory() {
  // initialize properties
  this.categoryKey = '';
  this.categoryName = '';
  this.accountKey = '';
  this.accountName = '';
  this.name = '';
  this.prefix = '';
  this.isActive = true;
  this.isAllocatable = false;

  // subclass from BaseModel
  KeyedObject.apply(this, arguments);
}

Subcategory.prototype = new KeyedObject();

Subcategory.prototype.getNewKey = function() {
  return Random.uuid4(Random.engines.mt19937().autoSeed());
}

Subcategory.prototype.getSubcategoryKey = function() {
  return this.key;
}

Subcategory.prototype.setSubcategoryKey = function(value) {
  this.key = value;
}

Subcategory.prototype.getCategoryKey = function() {
  return this.Escape(this.categoryKey);
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
  return this.Escape(this.accountKey);
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
  return this.Escape(this.name);
}

Subcategory.prototype.setSubcategoryName = function(value) {
  this.name = value;
}

Subcategory.prototype.getSubcategoryPrefix = function() {
  return this.Escape(this.prefix);
}

Subcategory.prototype.setSubcategoryPrefix = function(value) {
  this.prefix = value;
}

Subcategory.prototype.getIsActive = function() {
  return this.isActive;
}

Subcategory.prototype.setIsActive = function(value) {
  this.isActive = value ? true : false;
}

Subcategory.prototype.getIsAllocatable = function() {
  return this.isAllocatable;
}

Subcategory.prototype.setIsAllocatable = function(value) {
  this.isAllocatable = value ? true : false;
}

module.exports = Subcategory;