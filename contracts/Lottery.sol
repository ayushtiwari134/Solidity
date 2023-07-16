// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Contract
contract Lottery {
    address public owner;
    uint playerCount = 0;

    constructor() {
        owner = msg.sender;
    }

    struct Player {
        string name;
        address payable player;
    }

    Player[] public players;

    function getLength() public view returns (uint) {
        return players.length;
    }

    function createPlayer(string memory _name) public payable {
        require(msg.value >= 1 ether);
        Player memory p;
        p.name = _name;
        p.player = payable(msg.sender);
        players.push(p);
        playerCount++;
    }

    function createRandomNumber() public view returns (uint) {
        require(msg.sender == owner);
        return
            uint(
                keccak256(
                    abi.encodePacked(
                        msg.sender,
                        block.timestamp,
                        players.length
                    )
                )
            );
    }

    function selectWinner() public {
        require(msg.sender == owner);
        uint index = (createRandomNumber()) % (players.length);
        uint balance = address(this).balance;
        players[index].player.transfer(balance);
        playerCount = 0;
    }
}
