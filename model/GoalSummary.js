var DatedObject = require('./DatedObject');

function GoalSummary() {
   // initialize properties
   this.goalName = '';
   this.goalAmount = 0.0;
   this.totalSaved = 0.0;
   this.targetCompletionDate = new Date();

   // subclass from DatedObject
   DatedObject.apply(this, arguments);
}

GoalSummary.prototype = new DatedObject();

GoalSummary.prototype.getGoalName = function() {
    return this.Escape(this.goalName);
}

GoalSummary.prototype.setGoalName = function(value) {
    this.goalName = value;
}

GoalSummary.prototype.getGoalAmount = function() {
    return this.goalAmount;
}

GoalSummary.prototype.setGoalAmount = function(value) {
    this.goalAmount = value;
}

GoalSummary.prototype.getTotalSaved = function() {
    return this.totalSaved;
}

GoalSummary.prototype.setTotalSaved = function(value) {
    this.totalSaved = value;
}

GoalSummary.prototype.getTargetCompletionDate = function() {
    return this.targetCompletionDate;
}

GoalSummary.prototype.setTargetCompletionDate = function(value) {
    this.targetCompletionDate = value;
}

module.exports = GoalSummary;
