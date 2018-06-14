var Consortium = artifacts.require("./Consortium.sol");

// contract('Consortium', function(accounts) {
//   it("should add the creator as the first member of the consortium", function() {
//     return Consortium.deployed().then(function(instance) {
//       return instance.isMemberInConsortium.call(instance.address);
//     }).then(function(is_member_in_consortium) {
//       assert.equal(is_member_in_consortium, true, "Sender address should be a member of the consortium");
//     });
//   });
// });

contract("Consortium Async", async(accounts) => {

  let tryCatch = require("../exceptions.js").tryCatch;
  let errTypes = require("../exceptions.js").errTypes;

  it("should add the creator as the first member of the consortium", async () => {
    let instance = await Consortium.deployed({from: accounts[0]});
    let is_member_in_consortium = await instance.isMemberInConsortium.call(accounts[0]);
    assert.equal(is_member_in_consortium, true);
  });

  it("should add a non-existing member to the consortium", async () => {
    let instance = await Consortium.deployed({from: accounts[0]});
    let added_member = await instance.addMember.call(accounts[1]);
    assert.equal(added_member,true);
  });

  it("should not add an existing member to the consortium", async () =>{
    let instance = await Consortium.deployed({from: accounts[0]});
    let err = await tryCatch(instance.addMember.call(accounts[0]), errTypes.revert);
    //let could_add_member = await instance.addMember.call(instance.address);
    //assert.equal(could_add_member, false);
  });
});
