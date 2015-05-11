var Random = require('random-js');

function Category() {
  // initialize properties
  this.categoryKey = '';
  this.categoryName = '';
  this.isActive = true;
  this.lastUpdated = new Date();
}

Category.prototype.getNewKey = function() {
  return Random.uuid4(Random.engines.mt19937().autoSeed());
}

Category.prototype.getCategoryKey = function() {
  return this.categoryKey;
}

Category.prototype.setCategoryKey = function(value) {
  this.categoryKey = value;
}

Category.prototype.getCategoryName = function() {
  return this.categoryName;
}

Category.prototype.setCategoryName = function(value) {
  this.categoryName = value;
}

Category.prototype.getIsActive = function() {
  return this.isActive;
}

Category.prototype.setIsActive = function(value) {
  this.isActive = value ? true : false;
}

Category.prototype.getLastUpdated = function() {
  return this.lastUpdated;
}

Category.prototype.setLastUpdated = function(value) {
  this.lastUpdated = value;
}

module.exports = Category;