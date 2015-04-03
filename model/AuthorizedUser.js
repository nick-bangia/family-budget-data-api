function AuthorizedUser() {
  // initialize properties
  this.username = '';
  this.password = '';
  this.isActive = false;
}

AuthorizedUser.prototype.getUsername = function() {
  return this.username;
}

AuthorizedUser.prototype.setUsername = function(value) {
  this.username = value;
}

AuthorizedUser.prototype.getPassword = function() {
  return this.password;
}

AuthorizedUser.prototype.setPassword = function(value) {
  this.password = value;
}

AuthorizedUser.prototype.getIsActive = function() {
  return this.isActive;
}

AuthorizedUser.prototype.setIsActive = function(value) {
  this.isActive = value;
}

module.exports = AuthorizedUser;
