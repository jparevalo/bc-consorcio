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
    let could_add_member = await instance.addMember.call(accounts[1]);
    assert.equal(could_add_member, true);
  });

  it("should not add an existing member to the consortium", async () =>{
    let instance = await Consortium.deployed({from: accounts[0]});
    let err = await tryCatch(instance.addMember.call(accounts[0]), errTypes.revert);
  });

  it("should remove an existing member from the consortium", async () => {
    let instance = await Consortium.deployed({from: accounts[0]});
    let could_remove_member = await instance.removeMember.call(accounts[0]);
    assert.equal(could_remove_member, true);
  });

  it("should not remove a non-existing member from the consortium", async () =>{
    let instance = await Consortium.deployed({from: accounts[0]});
    let err = await tryCatch(instance.removeMember.call(accounts[1]), errTypes.revert);
  });

  it("should create a new proposal when there is no active one", async () =>{
    let instance = await Consortium.deployed({from: accounts[0]});
    let new_proposal_name = "Should we eat sushi tomorrow?";
    let new_proposal_type = "DESITION";
    let associated_member = 0;
    let could_create_proposal = await instance.newProposal.call(new_proposal_name, new_proposal_type, associated_member);
    assert.equal(could_create_proposal, true);
  });

  it("should not create a new proposal when there is no active one", async () =>{
    let instance = await Consortium.deployed({from: accounts[0]});
    let first_proposal_name = "Should we eat sushi tomorrow?";
    let first_proposal_type = "DESITION";
    let associated_member = 0;
    let could_create_proposal = await instance.newProposal.call(first_proposal_name, first_proposal_type, associated_member);
    let new_proposal_name = "Should we eat meat tomorrow?";
    let new_proposal_type = "DESITION";
    let err = await tryCatch(instance.newProposal.call(new_proposal_name, new_proposal_type, associated_member), errTypes.revert);
  });

});
