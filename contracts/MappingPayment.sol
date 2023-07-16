// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Practice {
    struct Person {
        string name;
        address payable receiver;
    }

    mapping(uint256 => Person) id;

    function createPersonMapping(
        uint _id,
        string memory _name,
        address payable _receiver
    ) public {
        id[_id] = Person(_name, _receiver);
    }

    function getPerson(
        uint _id
    ) public view returns (string memory _name, address _receiver) {
        Person storage p1 = id[_id];
        return (p1.name, p1.receiver);
    }

    function payEthToContract() public payable {}

    function getBalance() public view returns (uint balance) {
        return address(this).balance;
    }

    function payEthToAddress() public {
        Person storage p1 = id[0];
        p1.receiver.transfer(1 ether);
    }
}
