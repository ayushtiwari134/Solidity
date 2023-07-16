// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Practice {
    // Creating a struct which basically defines a person.
    struct Person {
        string name;
        address payable receiver;
    }

    // Creating a mapping to categorise each person and call them with a specific id.
    mapping(uint256 => Person) id;

    // Function to create a mapping using an id, name and address of the person.
    function createPersonMapping(
        uint _id,
        string memory _name,
        address payable _receiver
    ) public {
        id[_id] = Person(_name, _receiver); // id[index]=>Person() struct.
    }

    // Function to view a particular person on the basis of an id that is taken as input.
    function getPerson(
        uint _id
    ) public view returns (string memory _name, address _receiver) {
        Person storage p1 = id[_id]; // stores the person with the id that is taken as input into variable p1.
        return (p1.name, p1.receiver); // returns the name and address of the person.
    }

    // Function to transfer ethereum into the contract and can be left as an empty function (for Remix ide)
    function payEthToContract() public payable {}

    // Function to display the balance of the contract that has been transferred using the above function
    function getBalance() public view returns (uint balance) {
        return address(this).balance;
    }

    // Function to transfer the ethers which have been imported into the contract to an address that has been stored in the Person struct
    function payEthToAddress(uint _id) public {
        Person storage p1 = id[_id];
        p1.receiver.transfer(1 ether);
    }
}
