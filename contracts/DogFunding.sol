// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DogFund{

    // owner address 
    address public owner;

    // struct to store the problems of a dog signed up
    struct DogProblems{
        address receiver;
        uint id;
        string name;
        string disease;
        uint target;
    }
    
    // struct to store the donations that have been donated.
    struct Donations{
        address sender;
        uint amount;
    }

    // constructor function
    constructor(){
        owner = msg.sender;
    }

    // modifier to check if the person calling is only owner
    modifier onlyOwner(){
        require (msg.sender==owner);
       _; 
    }

    // mapping to map dogs that have been registered
    mapping (uint=>DogProblems) dogProblem;
    // mapping to map donations with address of sender as key and struct as value
    mapping (address=>mapping(uint=>Donations)) donations;

    function createRequest(uint _id, string memory _name, string memory _disease, uint _target) public {
        DogProblems memory dog1 = DogProblems(msg.sender,_id,_name,_disease,_target);
        dogProblem[_id]= dog1;
    }

    function getDogDetails(uint _id) public view returns(DogProblems memory){
        return dogProblem[_id];
    }

    function donate(uint _id, uint _amount) public payable{
        require(msg.value>0 ether);
        address _receiver = dogProblem[_id].receiver;
        Donations memory donation1= Donations(msg.sender, _amount);
        donations[msg.sender][_id]= donation1;
        (bool success, )= _receiver.call{value:address(this).balance}("");
        require(success);
    }

    function getDonations(address _sender,uint _id) public view returns(Donations memory){
        return(donations[_sender][_id]);
    }
}