const YourToken = artifacts.require("Token");

module.exports = function (deployer) {
    deployer.deploy(YourToken);
};

