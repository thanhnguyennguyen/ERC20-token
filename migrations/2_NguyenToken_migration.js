var NguyenToken = artifacts.require("./NguyenToken.sol");
module.exports = function(deployer) {
  deployer.deploy(NguyenToken, 1000);
};
