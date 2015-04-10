function Response() {
  this.status = "ok";
  this.reason = "success";
  this.data = null;
}

Response.prototype.getStatus = function() {
  return this.status;
}

Response.prototype.setStatus = function(value) {
  this.status = value;
}

Response.prototype.getReason = function() {
  return this.reason;
}

Response.prototype.setReason = function(value) {
  this.reason = value;
}

Response.prototype.getData = function() {
  return this.data;
}

Response.prototype.setData = function(value) {
  this.data = value;
}

module.exports = Response;
