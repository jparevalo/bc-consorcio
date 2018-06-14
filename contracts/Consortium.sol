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
      address associated_member;
    }

    struct Member {
      address member_address;
      bool is_under_evaluation;
      uint8 exists_flag;
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
    address[] votes;

    constructor(/*uint minimum_quorum, uint minimum_agreement, uint special_command_hours*/) public{
      numProposals = 0;
      numMembers = 0;
      addMember(msg.sender);
      active_proposal = Proposal('0','DESITION',false,now,ProposalStatus(0,0), 0);
    }

    function addMember(address member_address) public returns(bool){
      //require (checkAddMemberToProposal(member_address));
      //assert(consortium_members[member_address].exists_flag != 1);
      if (consortium_members[member_address].exists_flag != 1){
        consortium_members[member_address] = Member(member_address, false, 1);
        numMembers++;
        return true;
      }
      return false;
    }

    function removeMember(address member_address) public returns(bool){
      //require (checkRemoveMemberFromProposal(member_address));
      if (consortium_members[member_address].exists_flag == 1){
        delete consortium_members[member_address];
        numMembers--;
        return true;
      }
      return false;
    }

    function didMemberVote(address member_address) public view returns(bool){
      for(uint i = 0; i < votes.length; i++){
        if(votes[i] == member_address){
          return true;
        }
      }
      return false;
    }

    function clearVotes() public {
      for(uint i = 0; i < votes.length; i++){
        delete votes[i];
      }
    }

    function newProposal(bytes32 name, bytes32 proposal_type, address associated_member) public returns(bool){
      //require(!active_proposal.is_active);
      bool voter_is_member = isMemberInConsortium(msg.sender);
      if(voter_is_member && !active_proposal.is_active){
        old_proposals[numProposals] = active_proposal;
        clearVotes();
        active_proposal = Proposal(name, proposal_type, true, now, ProposalStatus(0,0), 0);
        numProposals++;
        if(proposal_type == "REMOVE" || proposal_type == "ADD"){
          return setMemberEvaluationState(associated_member, true);
        }
        return true;
      }
      else{
        return false;
      }
    }

    function removeProposal() public returns(bool){
      if(active_proposal.is_active){
        active_proposal.is_active = false;
        old_proposals[numProposals] = active_proposal;
        return true;
      }
      else{
        return false;
      }
    }

    function vote(bool _vote) public returns(bool){
      //require(_vote == true || _vote == false);
      //require(!active_proposal.voted[voter_address]);
      //require(isMemberInConsortium(voter_address));
      address voter_address = msg.sender;
      bool vote_exists = (_vote == true || _vote == false);
      bool voter_hasnt_voted = !didMemberVote(voter_address);
      bool voter_is_member = isMemberInConsortium(voter_address);
      bool voter_is_not_under_evaluation = !isMemberUnderEvaluation(voter_address);
      if(vote_exists && voter_hasnt_voted && voter_is_member && voter_is_not_under_evaluation){
        votes.push(voter_address);
        if(_vote) active_proposal.votes.in_favor += 1;
        else active_proposal.votes.against += 1;
        return true;
      }
      else{
        return false;
      }
    }

    function countVotedActiveProposal() public view returns (uint){
      uint consortium_votes = active_proposal.votes.in_favor + active_proposal.votes.against;
      return consortium_votes;
    }


    function isMemberUnderEvaluation(address member_address) public view returns(bool){
      return consortium_members[member_address].is_under_evaluation;
    }

    function setMemberEvaluationState(address member_address, bool evaluation) public returns(bool){
      if(isMemberInConsortium(member_address)){
        consortium_members[member_address].is_under_evaluation = evaluation;
        return true;
      }
      return false;
    }


    function checkMinPercentConsortiumQuorum(uint decision) public view returns (bool){
      if (decision == 65){
        uint minNumMembers = 65*numMembers;
      }
      else if (decision == 50){
        minNumMembers = 50*numMembers;
      }
      if (uint(countVotedActiveProposal()*100) > minNumMembers){
        return true;
      }
      return false;
    }

    function checkMinPercentConsortiumQuorumVotesInFavor(uint decision)public view returns (bool){
      uint consortium_votes_in_favor = active_proposal.votes.in_favor;
      if (decision == 80){
        uint count_voted_active_proposal =  countVotedActiveProposal()*80;
      }
      else if (decision == 50){
        count_voted_active_proposal =  countVotedActiveProposal()*50;
      }
      if (consortium_votes_in_favor*100 > count_voted_active_proposal){
        return true;
      }
      return false;
    }

    function checkFinishProposal() public{
      if (checkMinPercentConsortiumQuorum(65) && checkMinPercentConsortiumQuorumVotesInFavor(80)){
        active_proposal.is_active = false;
      }
    }

    function isMemberInConsortium(address member_address) public view returns(bool){
      //CAMBIAR ESTO
      //return true;
      if (consortium_members[member_address].exists_flag == 1){
        return true;
      }
      return false;
    }

    function checkAddMemberToProposal(address member_address) public view returns(bool){
      if (checkMinPercentConsortiumQuorum(50) && checkMinPercentConsortiumQuorumVotesInFavor(50) && !consortium_members[member_address].is_under_evaluation){
        return true;
      }
      return false;
    }

    function checkRemoveMemberFromProposal(address member_address) public view returns(bool){
      if (checkMinPercentConsortiumQuorum(50) && checkMinPercentConsortiumQuorumVotesInFavor(50) && consortium_members[member_address].is_under_evaluation){
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
