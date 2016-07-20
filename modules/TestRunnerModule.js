// constructor
function TestRunnerModule() {
    
}

// public methods
TestRunnerModule.prototype.RunTests = function() {
    
    // use this method to put custom logic to run tests using an external library
    
    // require the mocha binary to run tests using Mocha
    require('../node_modules/mocha/bin/_mocha');
}

// export the module
module.exports = TestRunnerModule;