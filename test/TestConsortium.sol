pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Consortium.sol";

contract TestConsortium {

  function testInitialMemberAddressIsInNewConsortium() public {
    // Arrange
    Consortium cons = Consortium(DeployedAddresses.Consortium());
    address initial_member_address = 0x01;
    bool expected_response = true;

    // Act
    bool is_member_in_consortium = cons.isMemberInConsortium(initial_member_address);

    Assert.equal(expected_response, is_member_in_consortium, "Address 0x00 should be a member of the consortium");
  }

}
