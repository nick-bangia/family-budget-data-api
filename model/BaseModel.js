var DataUtils = require('../framework/service/utils/DataUtils');

function BaseModel() {
  // intialize the DataUtils
  this.dataUtils = new DataUtils();
}

module.exports = BaseModel;