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
      bytes32 member_address;
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

    function Consortium(uint minimum_quorum, uint minimum_agreement, uint spcial_command_hours) {
      addMember('admin');
      numProposals = 0;
      active_proposal = Proposal('0',false,now);
    }

    function addMember(bytes32 member_address){
      consortium_members[sender] = Member(member_name, false);
    }

    function removeMember(address member_address){
      delete consortium_members[member_address];
    }

    function newProposal(bytes32 name){
      require(!active_proposal.is_active);
      old_proposals[numProposals] = active_proposal
      active_proposal = Proposal(name, true, now, ProposalStatus(0,0));
      numProposals++;
    }

    function vote(bytes32 voter_id, bool _vote) {
      require(_vote == 'y' || _vote == 'n');
      require(!active_proposal.voted[sender]);
      active_proposal.voted[sender] = true;
      if(_vote) active_proposal.votes.in_favor += 1;
      else active_proposal.votes.against += 1;
    }

}
