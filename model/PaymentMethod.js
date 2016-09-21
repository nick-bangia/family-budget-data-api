var KeyedObject = require('./KeyedObject');
var Random = require('random-js');

function PaymentMethod() {
  // initialize properties
  this.paymentMethodName = '';
  this.isActive = false;

  // subclass from KeyedObject
  KeyedObject.apply(this, arguments);
}

PaymentMethod.prototype = new KeyedObject();

PaymentMethod.prototype.getPaymentMethodKey = function() {
  return this.key;
}

PaymentMethod.prototype.setPaymentMethodKey = function(value) {
  this.key = value;
}

PaymentMethod.prototype.getPaymentMethodName = function() {
  return this.Escape(this.paymentMethodName);
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

module.exports = PaymentMethod;
