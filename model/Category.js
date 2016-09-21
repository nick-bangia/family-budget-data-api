var KeyedObject = require('./KeyedObject');
var Random = require('random-js');

function Category() {
  // initialize properties
  this.categoryName = '';
  this.isActive = true;

  // subclass from KeyedObject
  KeyedObject.apply(this, arguments);
}

Category.prototype = new KeyedObject();

Category.prototype.getCategoryKey = function() {
  return this.key;
}

Category.prototype.setCategoryKey = function(value) {
  this.key = value;
}

Category.prototype.getCategoryName = function() {
  return this.Escape(this.categoryName);
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

module.exports = Category;