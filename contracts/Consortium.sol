pragma solidity ^0.4.18;
// written for Solidity version 0.4.18 and above that doesnt break functionality

contract Consortium {

    // This declares a new complex type which will
    // be used for variables later.
    // It will represent a single voter.
    struct Proposal {
      bytes32 proposal_name;
      bool is_active;
      uint started_on;
      ProposalStatus votes;
      mapping(address => bool) voted;
    }

    struct Member {
      bool is_under_evaluation;
    }

    struct ProposalStatus {
      uint in_favor;
      uint against;
    }

    Proposal active_proposal;
    mapping (uint => Proposal) old_proposals;
    mapping (address => Member) consortium_members;
    uint numProposals;

    constructor(/*uint minimum_quorum, uint minimum_agreement, uint special_command_hours*/) public{
      addMember(0x789CAfd6B0A6e60f6DE5E386a7C2Cb7a5F33cfe6);
      numProposals = 0;
      active_proposal = Proposal('0',false,now,ProposalStatus(0,0));
    }

    function addMember(address member_address) private{
      consortium_members[member_address] = Member(false);
    }

    function removeMember(address member_address) private{
      delete consortium_members[member_address];
    }

    function newProposal(bytes32 name) public{
      require(!active_proposal.is_active);
      old_proposals[numProposals] = active_proposal;
      active_proposal = Proposal(name, true, now, ProposalStatus(0,0));
      numProposals++;
    }

    function vote(address voter_address, bool _vote) public{
      require(_vote == true || _vote == false);
      require(!active_proposal.voted[voter_address]);
      active_proposal.voted[voter_address] = true;
      if(_vote) active_proposal.votes.in_favor += 1;
      else active_proposal.votes.against += 1;
    }

}
