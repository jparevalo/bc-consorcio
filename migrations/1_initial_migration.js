var Migrations = artifacts.require("./Migrations.sol");
var Consortium = artifacts.require("./Consortium.sol")

module.exports = function(deployer) {
  //deployer.deploy(Migrations);
  deployer.deploy(Consortium);
};
