var Users = artifacts.require("./Users.sol");
var Ownable = artifacts.require('./commom/Ownable.sol')
var Certifier = artifacts.require('./identity/Certifier.sol')


module.exports = function(deployer) {
  deployer.deploy(Users);
  deployer.deploy(Ownable);
  deployer.deploy(Certifier);
};
