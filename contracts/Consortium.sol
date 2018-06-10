pragma solidity ^0.4.18;
// written for Solidity version 0.4.18 and above that doesnt break functionality

contract Consortium {

    // This declares a new complex type which will
    // be used for variables later.
    // It will represent a single voter.
    struct Proposal {
      bytes32 name;
      bytes32 proposal_type;
      bool is_active;
      uint started_on;
      ProposalStatus votes;
      mapping(address => bool) voted;
    }

    struct Member {
      address member_address;
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
    uint numMembers;

    constructor(/*uint minimum_quorum, uint minimum_agreement, uint special_command_hours*/) public{
      numProposals = 0;
      numMembers = 0;
      addMember(msg.sender);
      active_proposal = Proposal('0','DESITION',false,now,ProposalStatus(0,0));
    }

    function addMember(address member_address) public returns(bool){
      require (checkAddMemberToProposal(member_address));
      if (consortium_members[member_address].member_address == 0){
        consortium_members[member_address] = Member(member_address, false);
        numMembers++;
        return true;
      }
      return false;
    }

    function removeMember(address member_address) public returns(bool){
      require (checkRemoveMemberFromProposal(member_address));
      if (consortium_members[member_address].member_address != 0){
        delete consortium_members[member_address];
        numMembers--;
        return true;
      }
      return false;
    }

    function newProposal(bytes32 name, bytes32 proposal_type) public returns(bool){
      require(!active_proposal.is_active);
      old_proposals[numProposals] = active_proposal;
      active_proposal = Proposal(name, proposal_type, true, now, ProposalStatus(0,0));
      numProposals++;
      return true;
    }

    function vote(address voter_address, bool _vote) public{
      require(_vote == true || _vote == false);
      require(!active_proposal.voted[voter_address]);
      require(isMemberInConsortium(voter_address));
      active_proposal.voted[voter_address] = true;
      if(_vote) active_proposal.votes.in_favor += 1;
      else active_proposal.votes.against += 1;
    }

    function countVotedActiveProposal() public returns (uint){
      uint consortium_votes = active_proposal.votes.in_favor + active_proposal.votes.against;
      return consortium_votes;
    }

    function checkMin65PercentConsortiumQuorum() public returns (bool){
      uint minNumMembers = 65*numMembers;
      if (uint(countVotedActiveProposal()*100) > minNumMembers){
        return true;
      }
      return false;
    }

    function checkMin50PercentConsortiumQuorum() public returns (bool){
      uint minNumMembers = 50*numMembers;
      if (uint(countVotedActiveProposal()*100) > minNumMembers){
        return true;
      }
      return false;
    }

    function checkMin80PercentConsortiumQuorumVotesInFavor()public returns (bool){
      uint consortium_votes_in_favor = active_proposal.votes.in_favor;
      if (consortium_votes_in_favor*100 > countVotedActiveProposal()*80){
        return true;
      }
      return false;
    }

    function checkMin50PercentConsortiumQuorumVotesInFavor() public returns (bool){
      uint consortium_votes_in_favor = active_proposal.votes.in_favor;
      if (consortium_votes_in_favor*100 > countVotedActiveProposal()*50){
        return true;
      }
      return false;
    }

    function checkFinishProposal() public{
      if (checkMin65PercentConsortiumQuorum() && checkMin80PercentConsortiumQuorumVotesInFavor()){
        active_proposal.is_active = false;
      }
    }

    function checkAddMemberToProposal(address member_address) public returns(bool){
      if (checkMin50PercentConsortiumQuorum() && checkMin50PercentConsortiumQuorumVotesInFavor()){
        return true;
      }
      return false;
    }

    function checkRemoveMemberFromProposal(address member_address) public returns(bool){
      if (checkMin50PercentConsortiumQuorum() && checkMin50PercentConsortiumQuorumVotesInFavor() && consortium_members[member_address].is_under_evaluation){
        return true;
      }
      return false;
    }

    function isMemberInConsortium(address member_address) public view returns(bool){
      if (consortium_members[member_address].member_address != 0){
        return true;
      }
      return false;
    }

    function getActiveProposalName() public view returns(bytes32){
      return active_proposal.name;
    }

    function getActiveProposalType() public view returns(bytes32){
      return active_proposal.proposal_type;
    }

    function getActiveProposalActivity() public view returns(bool){
      return active_proposal.is_active;
    }

}
