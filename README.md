___
# ICC006 - Blockchain y Criptomonedas
Juan Pablo Arévalo, Sebastián Durán, Jaime Echeverría

___
## Description
This Project consists of designing a smart contract in order to manage destitions of any kind amongst a consortium.

This consortium will consist of a non-limited ammount of people, who will be able to propose the addition or removal of another members to/from the consortium.

The members will also be able to propose different ideas or actions, which will be approved or rejected based on the results of the voting made by the consortium members.

The smart contract will receive commands sent by the current consortium members and it will be in charge of managing them and registering the corresponding votes. The results will be accesible by all consortium members via a special command.

## Use Cases

1. New Proposal (Add/Remove members, idea or action)
2. Voting on a Proposal
3. Ending a Proposal as APPROVED
4. Ending a Proposal as REJECTED
5. Requesting for a RE-Vote
6. Requesting for the Deletion of a Proposal.
7. Requesting a direct elimination of a member

## Rules
1. Every consortium member will be able to vote on a proposal.
2. Any vote from a member out of the consortium will be invalid.
3. There must be a minimum quorum of 65% to end a proposal.
4. There must be a minimum agreement rate of 80% to consider a proposal as APPROVED or REJECTED.
5. There can only be one active proposal, the contract will not accept new proposals unless rules 3 and 4 are met for the current proposal.
6. In order to remove a member from the consortium, there must be a minimum quorum of 50% and a positive vote count of at least half the current consortium members.
7. To add members, the same conditions establihed in 6 must be met.
8. In the case where more than 50% of the members are inactive members, an active member can send a special command in order to remove another consortium member directly. The member will be removed only if there is an active removal proposal more than 72 hours old.
9. If a member of future member is being consider for removal/addition, they will not be able to vote and will not be considered in the quorum/vote count conditions.
10. No member can vote more than once on the same proposal.
11. Any member can send a special command to request a RE-Vote. If there is an active proposal which is older than 72 hours, and rules 3 and 4 aren't met for that proposal, this proposal will be reset.
