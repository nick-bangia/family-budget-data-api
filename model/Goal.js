var Subcategory = require('./Subcategory');

function Goal() {
  // initialize properties
  this.goalAmount = 0.0;
  this.estimatedCompletionDate = new Date();

  // subclass from Subcategory
  Subcategory.apply(this, arguments);
}

Goal.prototype = new Subcategory();

Goal.prototype.getGoalKey = function() {
  return this.key;
}

Goal.prototype.setGoalKey = function(value) {
  this.key = value;
}

Goal.prototype.getGoalName = function() {
  return this.Escape(this.name);
}

Goal.prototype.setGoalName = function(value) {
  this.name = value;
}

Goal.prototype.getGoalPrefix = function() {
  return this.Escape(this.prefix);
}

Goal.prototype.setGoalPrefix = function(value) {
  this.prefix = value;
}

Goal.prototype.getGoalAmount = function() {
  return this.goalAmount;
}

Goal.prototype.setGoalAmount = function(value) {
  this.goalAmount = value;
}

Goal.prototype.getEstimatedCompletionDate = function() {
  return this.estimatedCompletionDate;
}

Goal.prototype.setEstimatedCompletionDate = function(value) {
  this.estimatedCompletionDate = value;
}

module.exports = Goal;