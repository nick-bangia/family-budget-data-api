var DataUtils = require('../framework/service/utils/DataUtils');

function BaseModel() {

}

BaseModel.prototype.Escape = function(toBeEscaped) {
  var dataUtils = new DataUtils();
  return dataUtils.Escape(toBeEscaped);
}

module.exports = BaseModel;