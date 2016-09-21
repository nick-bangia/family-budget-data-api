var BaseModel = require('./BaseModel');

function DatedObject() {
    // initialize properties
    this.lastUpdated = new Date();

    // subclass from BaseModel
    BaseModel.apply(this, arguments);
}

DatedObject.prototype = new BaseModel();

DatedObject.prototype.getLastUpdated = function() {
    return this.lastUpdated;
}

DatedObject.prototype.setLastUpdated = function(value) {
    this.lastUpdated = value;
}

module.exports = DatedObject;