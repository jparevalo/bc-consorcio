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
    let instance = await Consortium.new();
    let is_member_in_consortium = await instance.isMemberInConsortium.call(accounts[0]);
    assert.equal(is_member_in_consortium, true);
  });

  it("should add a non-existing member to the consortium", async () => {
    let instance = await Consortium.new();
    let could_add_member = await instance.addMember.call(accounts[1]);
    assert.equal(could_add_member, true);
  });

  it("should not add an existing member to the consortium", async () =>{
    let instance = await Consortium.new();
    let err = await tryCatch(instance.addMember.call(accounts[0]), errTypes.revert);
  });

  it("should remove an existing member from the consortium", async () => {
    let instance = await Consortium.new();
    let could_remove_member = await instance.removeMember.call(accounts[0]);
    assert.equal(could_remove_member, true);
  });

  it("should not remove a non-existing member from the consortium", async () =>{
    let instance = await Consortium.new();
    let err = await tryCatch(instance.removeMember.call(accounts[1]), errTypes.revert);
  });

  it("should create a new proposal when there is no active one", async () =>{
    let instance = await Consortium.new();
    let new_proposal_name = "Should we eat sushi tomorrow?";
    let new_proposal_type = "DESITION";
    let associated_member = accounts[0];
    let could_create_proposal = await instance.newProposal.call(new_proposal_name, new_proposal_type, associated_member);
    assert.equal(could_create_proposal, true);
  });

  it("should not create a new proposal when there is an active one", async () =>{
    let instance = await Consortium.new();
    let first_proposal_name = "Should we eat sushi tomorrow?";
    let first_proposal_type = "DESITION";
    let associated_member = accounts[0];
    await instance.newProposal(first_proposal_name, first_proposal_type, associated_member);
    let new_proposal_name = "Should we eat meat tomorrow?";
    let new_proposal_type = "DESITION";
    let err = await tryCatch(instance.newProposal(new_proposal_name, new_proposal_type, associated_member), errTypes.revert);
  });

  it("should remove an existing proposal when there is an active one", async () =>{
    let instance = await Consortium.new();
    let new_proposal_name = "Should we eat sushi tomorrow?";
    let new_proposal_type = "DESITION";
    let associated_member = accounts[0];
    await instance.newProposal(new_proposal_name, new_proposal_type, associated_member);
    let could_remove_proposal = await instance.removeProposal.call();
    assert.equal(could_remove_proposal, true);
  });

  it("should not remove an existing proposal when there is no active one", async () =>{
    let instance = await Consortium.new();
    let could_remove_proposal = await tryCatch(instance.removeProposal.call(), errTypes.revert);
  });

  it("should add a vote to an active proposal", async () =>{
      let instance = await Consortium.new();
      let proposal_name = "Should we eat sushi tomorrow?";
      let proposal_type = "DESITION";
      let associated_member = accounts[0];
      await instance.newProposal(proposal_name, proposal_type, associated_member);
      let could_vote_on_proposal = await instance.vote.call(true, associated_member);
      assert.equal(could_vote_on_proposal, true);
  });

  it("should not let a member who already voted vote on an active proposal", async () =>{
      let instance = await Consortium.new();
      let proposal_name = "Should we eat sushi tomorrow?";
      let proposal_type = "DESITION";
      let associated_member = accounts[0];
      await instance.newProposal(proposal_name, proposal_type, associated_member);
      await instance.vote(true, associated_member);
      let could_vote_on_proposal_again = await tryCatch(instance.vote.call(true, associated_member),errTypes.revert);
  });

  it("should not add a vote to an inactive proposal", async () =>{
      let instance = await Consortium.new();
      let associated_member = accounts[0];
      let could_vote_on_proposal = await tryCatch(instance.vote.call(true, associated_member),errTypes.revert);
  });

  it("should not let a non member vote on an active proposal", async () =>{
      let instance = await Consortium.new();
      let associated_member = accounts[2];
      let could_vote_on_proposal = await tryCatch(instance.vote.call(true, associated_member),errTypes.revert);
  });

  it("should not let a member who is under evaluation vote on an active proposal", async () =>{
      let instance = await Consortium.new();
      let proposal_name = "Should we eat sushi tomorrow?";
      let proposal_type = "DESITION";
      let member_under_evaluation = accounts[0];
      let set_member_under_evaluation = await instance.setMemberEvaluationState.call(member_under_evaluation, true);
      let could_create_proposal = await instance.newProposal.call(proposal_name, proposal_type, member_under_evaluation);
      let could_vote_on_proposal = await tryCatch(instance.vote.call(true, member_under_evaluation),errTypes.revert);
  });

  it("should be able to count all the votes on an active proposal", async () =>{
        let instance = await Consortium.new();
        let proposal_name = "Should we eat sushi tomorrow?";
        let proposal_type = "DESITION";
        let first_member = accounts[0];
        let second_member = accounts[1];
        await instance.newProposal(proposal_name, proposal_type, first_member);
        await instance.addMember(second_member);
        await instance.vote(true, first_member);
        await instance.vote(true, second_member);
        let vote_count = await instance.countVotedActiveProposal.call();
        assert.equal(vote_count, 2);
  });

});
