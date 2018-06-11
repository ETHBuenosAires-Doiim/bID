var Users = artifacts.require("./Users.sol");
var Ownable = artifacts.require('./commom/Ownable.sol')
var Certifier = artifacts.require('./identity/Certifier.sol')
var SignUtils = artifacts.require('./commom/SignUtils.sol')
var ClaimableIdentity = artifacts.require('./identity/ClaimableIdentity.sol')
// var Identity = artifacts.require('./identity/Identity.sol')


module.exports = function(deployer) {
  deployer.deploy(Users);
  deployer.deploy(Ownable);
  deployer.deploy(SignUtils);
  deployer.deploy(Certifier);
  deployer.deploy(ClaimableIdentity);
  // deployer.deploy(SignUtils);
  // let keys = ['0x627306090abab3a6e1400e9345bc60c78a8bef57'];
  // let purposes = [1];
  // let types = [1];
  // deployer.deploy(Identity,keys,purposes,types,1,1,'0x627306090abab3a6e1400e9345bc60c78a8bef57');
};