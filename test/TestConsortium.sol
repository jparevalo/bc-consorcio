pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Consortium.sol";

contract TestConsortium {

  function testInitialMemberAddressIsAddedInNewConsortium() public {
    // Arrange
    Consortium cons = Consortium(DeployedAddresses.Consortium());
    address initial_member_address = msg.sender;
    bool expected_response = true;

    // Act
    bool is_member_in_consortium = cons.isMemberInConsortium(initial_member_address);

    // Assert
    Assert.equal(expected_response, is_member_in_consortium, "Sender address should be a member of the consortium");
  }

  function testAddExistingMember() public {
    // Arrange
    Consortium cons = Consortium(DeployedAddresses.Consortium());
    address existing_member_address = msg.sender;
    bool expected_response = false;

    // Act
    bool could_add_same_member = cons.addMember(existing_member_address);

    // Assert
    Assert.equal(expected_response, could_add_same_member, "Sender address shouldnt be added twice to consortium" );
  }

  function testAddNonExistingMember() public {
    // Arrange
    Consortium cons = Consortium(DeployedAddresses.Consortium());
    address non_existing_member_address = 0x01;
    bool expected_response = true;

    // Act
    bool could_add_same_member = cons.addMember(non_existing_member_address);

    // Assert
    Assert.equal(expected_response, could_add_same_member, "New address 0x01 should be added to the consortium" );
  }

  function testRemoveExistingMember() public {
    // Arrange
    Consortium cons = Consortium(DeployedAddresses.Consortium());
    address existing_member_address = msg.sender;
    bool expected_response = true;

    // Act
    bool could_remove_member = cons.removeMember(existing_member_address);

    // Assert
    Assert.equal(expected_response, could_remove_member, "Sender address should be removed from the consortium" );
  }

  function testRemoveNonExistingMember() public {
    // Arrange
    Consortium cons = Consortium(DeployedAddresses.Consortium());
    address non_existing_member_address = 0xFFFF;
    bool expected_response = false;

    // Act
    bool could_remove_member = cons.removeMember(non_existing_member_address);

    // Assert
    Assert.equal(expected_response, could_remove_member, "0xFFFF shouldnt be removed from the consortium since its not a part of it yet" );
  }

  function testCheckExistingMemberIfUnderEvaluation() public {
    // Arrange
    Consortium cons = Consortium(DeployedAddresses.Consortium());
    address existing_member_address = msg.sender;
    bool expected_evaluation_state = false;
    bool expected_response = true;

    // Act
    bool under_evaluation_state = cons.isMemberUnderEvaluation(existing_member_address);
    bool could_get_member_under_evaluation_state = under_evaluation_state == expected_evaluation_state;

    //Assert
    Assert.equal(expected_response, could_get_member_under_evaluation_state, "Evaluation state of member should be retrieved since member exists");
  }

  function testCreateNewProposalWhenThereIsNoActiveProposal() public {
    // Arrange
    Consortium cons = Consortium(DeployedAddresses.Consortium());
    bytes32 new_proposal_name = "Kick member 0x01";
    bytes32 new_proposal_type = "REMOVE";
    bool expected_response = true;

    // Act
    bool proposal_created = cons.newProposal(new_proposal_name, new_proposal_type);

    // Assert
    Assert.equal(expected_response, proposal_created, "Proposal should be created since there is no active one");
  }

  function testCreateNewProposalWhenThereIsAnActiveProposal() public {
    // Arrange
    Consortium cons = Consortium(DeployedAddresses.Consortium());
    bytes32 new_proposal_name = "Kick member 0x01";
    bytes32 new_proposal_type = "REMOVE";
    bool expected_response = false;

    // Act
    bool proposal_created = cons.newProposal(new_proposal_name, new_proposal_type);

    // Assert
    Assert.equal(expected_response, proposal_created, "Proposal should not be created since there is an active one");
  }

  function testVotingOnActiveProposalWithExistingMember() public {
    // Arrange
    Consortium cons = Consortium(DeployedAddresses.Consortium());
    address existing_member_address = msg.sender;
    bytes32 new_proposal_name = "Kick member 0x01";
    bytes32 new_proposal_type = "REMOVE";
    bool new_vote = false;
    bool expected_response = true;

    // Act
    cons.addMember(existing_member_address);
    cons.newProposal(new_proposal_name, new_proposal_type);
    bool could_vote_with_existing_member = cons.vote(existing_member_address, new_vote);

    // Assert
    Assert.equal(expected_response, could_vote_with_existing_member, "A vote should be added to a proposal by a member since there is an active one and member exists");
  }

  function testVotingOnActiveProposalWithNonExistingMember() public {
    // Arrange
    Consortium cons = Consortium(DeployedAddresses.Consortium());
    address non_existing_member_address = 0xFFFF;
    bytes32 new_proposal_name = "Kick member 0x01";
    bytes32 new_proposal_type = "REMOVE";
    bool new_vote = false;
    bool expected_response = false;

    // Act
    //cons.addMember(non_existing_member_address);
    cons.newProposal(new_proposal_name, new_proposal_type);
    bool could_vote_with_existing_member = cons.vote(non_existing_member_address, new_vote);

    // Assert
    Assert.equal(expected_response, could_vote_with_existing_member, "A vote should not be added to a proposal by a member since member doesnt exist");
  }

  function testVotingOnActiveProposalWithExistingMemberThatAlreadyVoted() public {
    // Arrange
    Consortium cons = Consortium(DeployedAddresses.Consortium());
    address existing_member_address = msg.sender;
    bytes32 new_proposal_name = "Kick member 0x01";
    bytes32 new_proposal_type = "REMOVE";
    bool new_vote = false;
    bool expected_response = false;

    // Act
    cons.addMember(existing_member_address);
    cons.newProposal(new_proposal_name, new_proposal_type);
    cons.vote(existing_member_address, new_vote);
    bool could_vote_without_active_proposal = cons.vote(existing_member_address, new_vote);

    // Assert
    Assert.equal(expected_response, could_vote_without_active_proposal, "A vote should not be added since the member has already voted");
  }

  function testVotingOnActiveProposalWithExistingMemberThatIsUnderEvaluation() public {
    // Arrange
    Consortium cons = Consortium(DeployedAddresses.Consortium());
    address existing_member_address = msg.sender;
    bytes32 new_proposal_name = "Kick member 0x01";
    bytes32 new_proposal_type = "REMOVE";
    bool new_vote = false;
    bool is_under_evaluation_state = true;
    bool expected_response = false;

    // Act
    cons.addMember(existing_member_address);
    cons.newProposal(new_proposal_name, new_proposal_type);
    cons.setMemberEvaluationState(existing_member_address, is_under_evaluation_state);
    cons.vote(existing_member_address, new_vote);
    bool could_vote_while_under_evaluation = cons.vote(existing_member_address, new_vote);

    // Assert
    Assert.equal(expected_response, could_vote_while_under_evaluation, "A vote should not be added since the member is under evaluation");
  }

  function testGettingNameOfActiveProposal() public {
    //Arrange
    Consortium cons = Consortium(DeployedAddresses.Consortium());
    bytes32 new_proposal_name = "Kick member 0x01";
    bytes32 new_proposal_type = "REMOVE";
    bool expected_response = true;

    //active
    cons.newProposal(new_proposal_name, new_proposal_type);
    bytes32 name_of_proposal = cons.getActiveProposalName();
    bool found_name_of_proposal = (name_of_proposal == new_proposal_name);

    //Assert
    Assert.equal(expected_response, found_name_of_proposal,"A name should be found since an active proposal was created");
  }

  function testRemovingActiveProposal() public {
    //Arrange
    Consortium cons = Consortium(DeployedAddresses.Consortium());
    bytes32 new_proposal_name = "Kick member 0x01";
    bytes32 new_proposal_type = "REMOVE";
    bool expected_response = true;

    //active
    cons.newProposal(new_proposal_name, new_proposal_type);
    bool could_remove_proposal = cons.removeProposal();

    //Assert
    Assert.equal(expected_response, could_remove_proposal,"A proposal should be removed since an active proposal was created");
  }

}
