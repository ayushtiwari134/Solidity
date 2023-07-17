// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Events{
    address public owner;
    address[] public attendees;

    constructor(){
        owner= msg.sender;
    }

    function payToContract() public payable{
        require(msg.value>=1 ether);
        attendees.push(msg.sender);
    }

    function displayBalance() public view returns(uint){
        return (address(this).balance);
    }
    function displayAttendees() public view returns(address[] memory){
        return attendees;
    }

}