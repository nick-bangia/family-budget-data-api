var Random = require('random-js');

function PaymentMethod() {
  // initialize properties
  this.paymentMethodKey = '';
  this.paymentMethodName = '';
  this.isActive = false;
  this.lastUpdated = new Date();
}

PaymentMethod.prototype.getNewKey = function() {
  return Random.uuid4(Random.engines.mt19937().autoSeed());
}

PaymentMethod.prototype.getPaymentMethodKey = function() {
  return this.paymentMethodKey;
}

PaymentMethod.prototype.setPaymentMethodKey = function(value) {
  this.paymentMethodKey = value;
}

PaymentMethod.prototype.getPaymentMethodName = function() {
  return this.paymentMethodName;
}

PaymentMethod.prototype.setPaymentMethodName = function(value) {
  this.paymentMethodName = value;
}

PaymentMethod.prototype.getIsActive = function() {
  return this.isActive;
}

PaymentMethod.prototype.setIsActive = function(value) {
  this.isActive = value ? true : false;
}

PaymentMethod.prototype.getLastUpdated = function() {
  return this.lastUpdated;
}

PaymentMethod.prototype.setLastUpdated = function(value) {
  this.lastUpdated = value;
}

module.exports = PaymentMethod;
