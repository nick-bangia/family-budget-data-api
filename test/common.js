global.chai = require('chai');
global.expect = global.chai.expect;
global.request = require('request');
global.TestUtility = require('./utils');
global.testUtils = new global.TestUtility();