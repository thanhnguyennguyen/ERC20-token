var NguyenToken =  artifacts.require("./NguyenToken.sol");

contract('NguyenToken', function(accounts) {
  var nguyenAccount = accounts[0],
      secondAccount = accounts[1],
      thirdAccount  = accounts[2],
      nguyenInstance;

  it("test NguyenToken", function() {
    return NguyenToken.deployed().then(function(instance) {
      nguyenInstance = instance;
      // test total supply
      return nguyenInstance.totalSupply.call();
      }).then(function(result) {
        // test initial total supply 
        assert.equal(1000, result);
        console.log('init ' + result + ' NguyenTokens');
        return nguyenInstance.balanceOf.call(nguyenAccount);
      }).then(function(result) {
        // test balance of owner
        assert.equal(1000, result);
        console.log('Account ' + nguyenAccount + ' has ' + result + ' NguyenTokens');
        return nguyenInstance.symbol.call();
      }).then(function(result) {
        // test token symbol
        assert.equal('NGUYENNGUYEN', result);
        console.log('Token symbol is ' + result);
        return nguyenInstance.transfer(secondAccount, 5, {from: nguyenAccount});
      }).then(function(result) {
        return nguyenInstance.balanceOf.call(nguyenAccount);
      }).then(function(result) {
        // test transfer from NguyenAccount to second account
        assert.equal(995, result);
        console.log('Account ' + nguyenAccount + ' has ' + result + ' NguyenTokens');
        return nguyenInstance.balanceOf.call(secondAccount);
      }).then(function(result) {
        // test transfer from NguyenAccount to second account
        assert.equal(5, result);
        console.log('Account ' + secondAccount + ' has ' + result + ' NguyenTokens');
        // test token burning
        return nguyenInstance.burn(10, {from: nguyenAccount});
      }).then(function(result) {
        return nguyenInstance.balanceOf.call(nguyenAccount);
      }).then(function(result) {
        // test balance after burning 10 tokens
        assert.equal(985, result);
        console.log('Account ' + nguyenAccount + ' now has ' + result + ' NguyenTokens after burning 10 tokens');
        return nguyenInstance.totalSupply.call();
      }).then(function(result) {
        // test total supply after burning 10 tokens
        assert.equal(990, result);
        console.log('Total supply now is ' + result + ' NguyenTokens after burning 10 tokens');
        // Nguyen approve secondAccount 20 tokens
        return nguyenInstance.approve(secondAccount, 20, {from: nguyenAccount});
      }).then(function() {
        // check remaining allowance
        return nguyenInstance.allowance.call(nguyenAccount, secondAccount);
      }).then(function(result) {
        // assert remaining allowance
        assert.equal(20, result);
        console.log('NguyenAccount approves for secondAccount spending upto 20 tokens');
        // secondAccount sent 8 tokens from NguyenAccount to thirdAccount
        return nguyenInstance.transferFrom(nguyenAccount, thirdAccount, 8, {from: secondAccount});
      }).then(function() {
        console.log('SecondAccount send 8 tokens from NguyenAccount to thirdAccount');
        // check remaining allowance
        return nguyenInstance.allowance.call(nguyenAccount, secondAccount);
      }).then(function(result) {
        assert.equal(12, result); // 20- 8 =12
        console.log('SecondAccount can send ' + result + ' tokens from NguyenAccount');
        // check balance of thirdAccount
        return nguyenInstance.balanceOf.call(thirdAccount);
      }).then(function(result) {
        assert.equal(8, result);
        console.log('ThirdAcccount now has ' + result + ' tokens ');
        // check balance of SecondAccount
        return nguyenInstance.balanceOf.call(secondAccount);
      }).then(function(result) {
        assert.equal(5, result);
        console.log('SecondAccount now has ' + result + ' tokens ');    
        // check balance of NguyenAccount
        return nguyenInstance.balanceOf.call(nguyenAccount);
    }).then(function(result) {
      assert.equal(977, result);
      console.log('NguyenAccount now has ' + result + ' tokens ');    
    })
  });
});
