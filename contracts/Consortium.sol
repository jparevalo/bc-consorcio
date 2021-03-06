pragma solidity ^0.4.18;
// written for Solidity version 0.4.18 and above that doesnt break functionality

contract Consortium {

    // This declares a new complex type which will
    // be used for variables later.
    // It will represent a single voter.
    struct Proposal {
      string name;
      string proposal_type;
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
      active_proposal = Proposal('FIRST','DESITION', false, now, ProposalStatus(0,0), 0);
    }

    function addMember(address member_address) public returns(bool){
      require(consortium_members[member_address].exists_flag != 1);
      consortium_members[member_address] = Member(member_address, false, 1);
      numMembers++;
      return true;
    }

    function removeMember(address member_address) public returns(bool){
      require(consortium_members[member_address].exists_flag == 1);
      delete consortium_members[member_address];
      numMembers--;
      return true;
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

    function newProposal(string name, string proposal_type, address associated_member) public returns(bool){
      require(!active_proposal.is_active);
      require(consortium_members[associated_member].exists_flag == 1);
      old_proposals[numProposals] = active_proposal;
      clearVotes();
      active_proposal = Proposal(name, proposal_type, true, now, ProposalStatus(0,0), 0);
      numProposals++;
      if(keccak256(proposal_type) == keccak256("REMOVE") || keccak256(proposal_type) == keccak256("ADD")){
        return setMemberEvaluationState(associated_member, true);
      }
      return true;
    }

    function removeProposal() public returns(bool){
      require(active_proposal.is_active);
      active_proposal.is_active = false;
      old_proposals[numProposals] = active_proposal;
      return true;
    }

    function vote(bool _vote, address voter_address) public returns(bool){
      require(_vote == true || _vote == false);
      require(active_proposal.is_active);
      require(!didMemberVote(voter_address));
      require(isMemberInConsortium(voter_address));
      require(!isMemberUnderEvaluation(voter_address));
      //address voter_address = msg.sender;
      //bool vote_exists = (_vote == true || _vote == false);
      //bool voter_hasnt_voted = !didMemberVote(voter_address);
      //bool voter_is_member = isMemberInConsortium(voter_address);
      //bool voter_is_not_under_evaluation = !isMemberUnderEvaluation(voter_address);
      votes.push(voter_address);
      if(_vote) active_proposal.votes.in_favor += 1;
      else active_proposal.votes.against += 1;
      return true;
    }

    function countVotedActiveProposal() public view returns (uint){
      uint consortium_votes = active_proposal.votes.in_favor + active_proposal.votes.against;
      return consortium_votes;
    }


    function isMemberUnderEvaluation(address member_address) public view returns(bool){
      return consortium_members[member_address].is_under_evaluation;
    }

    function setMemberEvaluationState(address member_address, bool evaluation) public returns(bool){
      require(isMemberInConsortium(member_address));
      consortium_members[member_address].is_under_evaluation = evaluation;
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
      //CAMBIAR
      return consortium_members[member_address].exists_flag == 1;
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

    function getActiveProposalName() public view returns(string){
      return active_proposal.name;
    }

    function getActiveProposalType() public view returns(string){
      return active_proposal.proposal_type;
    }

    function getActiveProposalActivity() public view returns(bool){
      return active_proposal.is_active;
    }

}
