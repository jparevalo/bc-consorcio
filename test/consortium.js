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
    let instance = await Consortium.deployed();
    let is_member_in_consortium = await instance.isMemberInConsortium.call(instance.address);
    assert.equal(is_member_in_consortium, true);
  });

  it("should add a non-existing member to the consortium", async () => {
    let instance = await Consortium.deployed();
    let added_member = await instance.addMember.call(0x01dfafa);
    assert.equal(added_member,true);
  });

  it("should not add an existing member to the consortium", async () =>{
    let instance = await Consortium.deployed();
    //let err = await tryCatch(instance.addMember.call(instance.address), errTypes.revert);
    let could_add_member = await instance.addMember.call(instance.address);
    assert.equal(could_add_member, false);
  });
});
