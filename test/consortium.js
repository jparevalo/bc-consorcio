var Consortium = artifacts.require("./Consortium.sol");

contract('Consortium', function(accounts) {
  it("should add the creator as the first member of the consortium", function() {
    return Consortium.deployed().then(function(instance) {
      return instance.isMemberInConsortium.call(instance.address);
    }).then(function(is_member_in_consortium) {
      assert.equal(is_member_in_consortium, true, "Sender address should be a member of the consortium");
    });
  });
});

// contract('Consortium 2', async (accounts) => {
//   let tryCatch = require("../exceptions.js").tryCatch;
//   let errTypes = require("../exceptions.js").errTypes;
//   it("should not add an existing member to the consortium", async () => {
//      let instance = await Consortium.deployed();
//      await tryCatch(instance.addMember.call(instance.address), errTypes.revert);
//   });
// });
