var Random = require('random-js');

function Goal() {
  // initialize properties
  this.goalKey = '';
  this.goalName = '';
  this.goalAmount = 0.0;
  this.estimatedCompletionDate = new Date();
  this.lastUpdated = new Date();
}

Goal.prototype.getNewKey = function() {
  return Random.uuid4(Random.engines.mt19937().autoSeed());
}

Goal.prototype.getGoalKey = function() {
  return this.goalKey;
}

Goal.prototype.setGoalKey = function(value) {
  this.goalKey = value;
}

Goal.prototype.getGoalName = function() {
  return this.goalName;
}

Goal.prototype.setGoalName = function(value) {
  this.goalName = value;
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

Goal.prototype.getLastUpdated = function() {
  return this.lastUpdated;
}

Goal.prototype.setLastUpdated = function(value) {
  this.lastUpdated = value;
}

module.exports = Goal;