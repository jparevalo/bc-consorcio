contract Consortium{
    // This declares a new complex type which will
    // be used for variables later.
    // It will represent a single voter.
    struct Proposal {
      string proposal_name;
      mapping (address => uint8) votes;
    }

    Proposal active_proposal;
    mapping (address => boproposalNameol) consortium_members;

    function Consortium() {
      members[message, sender] = true;
    }

    function vote(bool _vote) {
      require(_vote == 'yes' || _vote == 'no');
      require(!active_proposal.votes[message, sender]);
      active_proposal.votes[message, sender] = true;
      if(_vote) active_proposal.votes.in_favor += 1;
      else active_proposal.votes.against += 1;
    }
    
}
