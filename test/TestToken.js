var TestICOContract = artifacts.require("./TokenICO.sol");

contract('TestICOContract', function(accounts) {

  var TestICO;
  var object;

  it("should return 0", function() {
    return TestICOContract.deployed().then(function(instance) {
      return instance.balanceOf(accounts[0]);
    }).then(function(balance) {
      assert.equal(balance, 0, "0 isn't in the first account");
    });
  });

  it("should return 10000", function() {
    var value;
    return TestICOContract.deployed().then(function(instance) {
      TestICO = instance;
      return TestICO.totalSupply.call();
    }).then(function(balance) {
      value = balance;
      assert.equal(value, 10000, "Balance isn't 10000");
    });
  });

  //buy Tokens check
  it("should return 100", function(done) {
    var value;
    TestICOContract.deployed().then(function() {
      return TestICO.registerUser("user", "@user", "US");
    }).then(function() {
      return TestICO.sendTransaction({
        from: accounts[0],
        value: 200
      });
    }).then(function() {
      return TestICO.balanceOf.call(accounts[0]);
    }).then(function(balance) {
      value = balance.toNumber();
      assert.equal(value, 100, "100 isn't in the first account");
      done();
      console.log("Function 3 Done!");
    });
  });

  // transfer check
  it("should transfer tokens and return 50 as value of account 2", function(done) {
    TestICOContract.deployed().then(function() {
      return TestICO.sendTransaction({
        from: accounts[0],
        value: 100
      });
    }).then(function() {
      return TestICO.transfer(accounts[1], 50, {
        from: accounts[0]
      });
    }).then(function() {
      return TestICO.balanceOf.call(accounts[1]);
    }).then(function(balance) {
      var value = balance.toNumber();
      assert.equal(value, 50, "Value isn't 50");
      done();
      console.log("Function 4 Done!")
    });
  });

  //Allowance 1->2, 2 send ->1, 1 check balance
  it("Acc 3 allows Acc 4 to send 50 Tokens to Acc 5 -> Acc 5 balance should be 50", function(done) {
    TestICOContract.deployed().then(function(instance) {
      object = instance;
      return object.registerUser("user3", "@user3", "US", {
        from: accounts[2]
      });
    }).then(function() {
      return object.registerUser("user4", "@user4", "US", {
        from: accounts[3]
      });
    }).then(function() {
      return object.registerUser("user5", "@user5", "US", {
        from: accounts[4]
      });
    }).then(function() {
      return object.sendTransaction({
        from: accounts[2],
        value: 100
      });
    }).then(function() {
      return object.approve(accounts[3], 50, {
        from: accounts[2]
      });
    }).then(function() {
      return object.transferFrom(accounts[2], accounts[4], 50, {
        from: accounts[2]
      });
    }).then(function() {
      return object.balanceOf(accounts[4]);
    }).then(function(balance) {
      var amount = balance.toNumber();
      assert.equal(balance, 50, "Balance of Acc 5 isn't 50");
      done();
      console.log("Function 5 Done!")
    });
  });
});